# Multi-Stage Production Cost Modeling

```@setup pcm4
using PowerSystems
using PowerSystemCaseBuilder
using PowerSimulations
using PowerAnalytics
using HiGHS

system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys");

for g in get_components(RenewableDispatch, system)
           set_available!(g, false)
end
```

Now, we are ready to put pieces together. We will define, solve, analyze, and
visualize a multi-stage production cost model over the course of a year with two decision
stages: a day ahead, hourly resolution unit commitment, followed by an hourly resolution
economic dispatch.

11. Set up a default unit commitment model

```@example pcm4
template = template_unit_commitment()
```

```@example pcm4
solver = optimizer_with_attributes(HiGHS.Optimizer, "mip_rel_gap" => 0.5)
```

12. Apply that template to our data to make a complete model, with both data and equations:

```@example pcm4
models = SimulationModels(;
    decision_models = [
        DecisionModel(template, system; optimizer = solver, name = "UC"),
    ],
)
```

We just have one model -- the unit commitment model.

13. In addition to defining the formulation template, sequential simulations require
    definitions for how information flows between problems to set the initial conditions
    of the next problem:

```@example pcm4
DA_sequence = SimulationSequence(;
    models = models,
    ini_cond_chronology = InterProblemChronology(),
)
```

14. Finally, put together the models and the flow of information between them to simulate
    3 days of a unit commitment:

```@example pcm4
sim = Simulation(;
    name = "default_UC",
    steps = 3,
    models = models,
    sequence = DA_sequence,
    simulation_folder = mktempdir(; cleanup = true),
)
```

15. Build the simulation, which does all the equation preparation before executing:

```@example pcm4
build!(sim; recorders = [:simulation])
```

16. Simulate!

```@example pcm4
execute!(sim)
```

17. Now, load in the simulation results from the output files:

```@example pcm4
results = SimulationResults(sim)
uc_results = get_decision_problem_results(results, "UC")
```

18. Let's visualize the results

<!-- ```@example pcm4 # plot_fuel(uc_results); ```-->
19. We can also look at how much it cost to operate the thermal generators at each time step:

```@example pcm4
costs =
    read_realized_expressions(uc_results, list_expression_names(uc_results))["ProductionCostExpression__ThermalStandard"]
```

Wind, solar, and hydro have 0 operating cost and do not contribute to total cost in this model

20. We can sum over the set of generators and time-steps to get total production cost for this window

```@example pcm4
sum(sum(eachcol(costs[!, 2:end])))
```

## Now, let's change some things in the system:

21. Now, let's change how the thermal generators behave by adding in ramping and minimum up
    and down time constraints:

```@example pcm4
set_device_model!(template, ThermalStandard, ThermalStandardUnitCommitment)
```

You can see the formulations options in the documentation:
https://nrel-sienna.github.io/PowerSimulations.jl/stable/formulation_library/ThermalGen/

22. We've changed our template, so we need to re-build the DecisionModels within our simulation, which
    includes a copy of the template:

```@example pcm4
models = SimulationModels(;
    decision_models = [
        DecisionModel(template, system; optimizer = solver, name = "UC"),
    ],
)
DA_sequence = SimulationSequence(;
    models = models,
    ini_cond_chronology = InterProblemChronology(),
)
sim = Simulation(;
    name = "default_UC",
    steps = 3,
    models = models,
    sequence = DA_sequence,
    simulation_folder = mktempdir(; cleanup = true),
)
```

22. Now, let's re-build, and execute our simulation:

```@example pcm4
build!(sim; recorders = [:simulation]);
execute!(sim)
```

23. Let's re-extract the results and take a look at the impact on the dispatch stack:

```@example pcm4
results = SimulationResults(sim)
uc_results = get_decision_problem_results(results, "UC")
# plot_fuel(uc_results);
```

24. Finally, let's extract the operating costs again and see the impact on total cost:

```@example pcm4
costs =
    read_realized_expressions(uc_results, list_expression_names(uc_results))["ProductionCostExpression__ThermalStandard"]
sum(sum(eachcol(costs[!, 2:end])))
```

## Adding in renewables

25. Now, let's add in those large-scale wind and solar plants by making them
    available again:

```@example pcm4
for g in get_components(RenewableDispatch, system)
    set_available!(g, true)
end
```

26. We've changed the data, not the template formulations, so this time we just need to re-build and simulate:

```@example pcm4
build!(sim; recorders = [:simulation]);
execute!(sim)
```

27. Let's re-extract the results and take a look at the impact on the dispatch stack:

```@example pcm4
results = SimulationResults(sim)
uc_results = get_decision_problem_results(results, "UC")
# plot_fuel(uc_results);
```

28. Finally, let's extract the operating costs again and see the impact on total cost:

```@example pcm4
costs =
    read_realized_expressions(uc_results, list_expression_names(uc_results))["ProductionCostExpression__ThermalStandard"]
sum(sum(eachcol(costs[!, 2:end])))
```
