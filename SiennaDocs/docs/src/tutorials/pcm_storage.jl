# # [Production Cost Modeling](@id showcase_pcm_storage)
#
# Production cost modeling (PCM) simulates how a power system is operated over time at
# least cost. In this showcase, you will run a short unit commitment (UC) day-ahead (DA)
# model on the Reliability Test System from the Grid Modernization Laboratory Consortium
# (RTS-GMLC), which includes a battery.

# You will use key packages in the Sienna\Data and Sienna\Ops applications: you will load the system data set with
# [`PowerSystemCaseBuilder.jl`](@extref PowerSystemCaseBuilder :doc:`index`), and
# simulate the UC with [`PowerSimulations.jl`](@extref PowerSimulations :doc:`index`), including the battery with
# [`StorageSystemsSimulations.jl`](@extref StorageSystemsSimulations :doc:`index`). Then, you will
# add a second storage plant to see what changes, and use [`PowerAnalytics.jl`](@extref PowerAnalytics :doc:`index`) and [`PowerGraphics.jl`](@extref PowerGraphics :doc:`index`) to compare the two scenarios.
#
# !!! note "Analysis questions"
#     - What is the production cost of a one-day unit commitment run on this system?
#     - How do thermal constraints, renewables, and storage shape cost and the generation stack?
#     - How does adding another storage plant change renewable curtailment and production cost compared with the base case?

# ## Environment
#
# [Install Sienna\Data and Sienna\Ops](@ref install) and the supporting packages used below, including [`HiGHS`](https://ergo-code.github.io/HiGHS/dev/), an open-source solver. Then, load the packages in Julia with:

using Pkg
using PowerSystems
using PowerSystemCaseBuilder
using PowerSimulations
using StorageSystemsSimulations
using HydroPowerSimulations
using PowerAnalytics
using PowerAnalytics.Metrics
using PowerGraphics
using DataFrames
using HiGHS
using Dates
using Logging

# If you have any issues with reproducibility, print the active package versions with
# [`Pkg.status`](@extref) and try again with these exact versions:

Pkg.status()

# Configure the solver through
# [`PowerSimulations.optimizer_with_attributes`](@extref):
# stop at a 5% optimality gap or 120 seconds.

solver = optimizer_with_attributes(
    HiGHS.Optimizer,
    "mip_rel_gap" => 0.05,
    "time_limit" => 120.0,
)

# ## Load the day-ahead system
#
# First, we need to load a data set, which is formatted as a [`PowerSystems.System`](@extref) object.
# [`PowerSystemCaseBuilder.build_system`](@extref) loads `RTS_GMLC_DA_sys`
# from the [`PowerSystemCaseBuilder.PSISystems`](@extref) category of pre-defined data sets.

sys_base = build_system(PSISystems, "RTS_GMLC_DA_sys"; skip_serialization = true)

# See that this returns a summary of the data set, including that it currently contains 1 [`PowerSystems.EnergyReservoirStorage`](@extref) component (a battery).

# ## Build a unit-commitment template
#
# A [`PowerSimulations.ProblemTemplate`](@extref) is like a recipe for an optimization problem: it maps each [`PowerSystems.jl`](@extref PowerSystems :doc:`index`) Type to a [`PowerSimulations.jl`](@extref PowerSimulations :doc:`index`) formulation that specifies how that type of component behaves. Start an empty template:

template_uc = ProblemTemplate()

# Now, use [`PowerSimulations.set_device_model!`](@extref) to populate the template
# and pair each component type with a formulation.
# Network branches use [`PowerSimulations.StaticBranch`](@extref):

set_device_model!(template_uc, Line, StaticBranch)
set_device_model!(template_uc, TapTransformer, StaticBranch)

# Thermal units are committed on/off with
# [`PowerSimulations.ThermalBasicUnitCommitment`](@extref).
# Dispatchable renewables use [`PowerSimulations.RenewableFullDispatch`](@extref)
# (curtailable); non-dispatchable renewables use
# [`PowerSimulations.FixedOutput`](@extref). Loads use
# [`PowerSimulations.StaticPowerLoad`](@extref).

set_device_model!(template_uc, ThermalStandard, ThermalBasicUnitCommitment)
set_device_model!(template_uc, RenewableDispatch, RenewableFullDispatch)
set_device_model!(template_uc, RenewableNonDispatch, FixedOutput)
set_device_model!(template_uc, PowerLoad, StaticPowerLoad)

# Hydro units use
# [`HydroPowerSimulations.HydroDispatchRunOfRiver`](@extref) from
# [`HydroPowerSimulations.jl`](@extref HydroPowerSimulations :doc:`index`):

set_device_model!(template_uc, HydroDispatch, HydroDispatchRunOfRiver)
set_device_model!(template_uc, HydroTurbine, HydroDispatchRunOfRiver)

# Storage uses a [`PowerSimulations.DeviceModel`](@extref) with
# [`StorageSystemsSimulations.StorageDispatchWithReserves`](@extref).
# The attributes below turn off the optional storage features so the model stays small.

set_device_model!(
    template_uc,
    DeviceModel(
        EnergyReservoirStorage,
        StorageDispatchWithReserves;
        attributes = Dict{String, Any}(
            "reservation" => false,
            "cycling_limits" => false,
            "energy_target" => false,
            "complete_coverage" => false,
            "regularization" => false,
        ),
    ),
)

# We'll ignore transmission limits for now, using a
# [`PowerSimulations.CopperPlatePowerModel`](@extref) network model that treats the whole
# system as one bus. Set it with
# [`PowerSimulations.set_network_model!`](@extref).

set_network_model!(template_uc, NetworkModel(CopperPlatePowerModel; use_slacks = true))

# Finally, print the template again to see our final recipe:

template_uc

# ## Scenario A — base case
#
# Now, combine the data set and the behavior template into a [`PowerSimulations.DecisionModel`](@extref) to define the full UC problem:

uc_model_a = DecisionModel(
    template_uc,
    sys_base;
    name = "UC",
    optimizer = solver,
    initialize_model = false,
    optimizer_solve_log_print = false,
    check_numerical_bounds = false,
    warm_start = true,
    store_variable_names = true,
)

# Next, define a [`PowerSimulations.SimulationSequence`](@extref), which defines how decision problems are connected over time, with the [`PowerSimulations.InterProblemChronology`](@extref) defining how initial conditions pass from one step to the next:

# !!! details "Details"
#     `PowerSimulations.jl` can be used to run multi-stage simulations,
#     such as a UC stage feeding into an economic dispatch stage.
#     For this example, we are only running a single UC stage, so we
#     only have a single input to `SimulationModels`.
#     This framework is available to connect any number of stages together.
#     See [Multi-stage production cost simulation](@extref PowerSimulations :doc:`tutorials/generated_pcm_simulation`)
#     for an example.

models_a = SimulationModels(;
    decision_models = [uc_model_a],
)
sequence_a = SimulationSequence(;
    models = models_a,
    ini_cond_chronology = InterProblemChronology(),
)

# Create a one-step (one day) [`PowerSimulations.Simulation`](@extref) starting on
# 2020-01-01.

sim_a = Simulation(;
    name = "base_case",
    steps = 1,
    models = models_a,
    sequence = sequence_a,
    initial_time = DateTime("2020-01-01T00:00:00"),
    simulation_folder = mktempdir(),
)

# [`PowerSimulations.build!`](@extref) assembles the optimization problem and
# [`PowerSimulations.execute!`](@extref) solves it.

build!(sim_a; console_level = Logging.Warn, file_level = Logging.Error)
execute!(sim_a; enable_progress_bar = false)

# Read results with [`PowerSimulations.SimulationResults`](@extref) and
# [`PowerSimulations.get_decision_problem_results`](@extref), which also prints the
# listing of output data available: 

results_a = get_decision_problem_results(SimulationResults(sim_a), "UC")

# Now, before we analyze the results, let's run our second scenario.

# ## Scenario B — add a new storage plant
#
# Our second scenario requires modifying the data set, so we will start by adding a new storage plant component to our [`PowerSystems.System`](@extref). Load a fresh copy of the
# system so Scenario A stays untouched, and prepare it the same way.

sys_plus = build_system(PSISystems, "RTS_GMLC_DA_sys"; skip_serialization = true)

# Pick a bus for the new plant with [`PowerSystems.get_component`](@extref).
# The existing battery sits on bus `Cecil`; use bus `Barton` instead by retrieving
# a reference to it:

bus_barton = get_component(ACBus, sys_plus, "Barton")

# Build a new [`PowerSystems.EnergyReservoirStorage`](@extref). The technology fields use
# [`PowerSystems.PrimeMovers`](@extref) and
# [`PowerSystems.StorageTech`](@extref).

new_storage = EnergyReservoirStorage(;
    name = "new_storage_plant",
    available = true,
    bus = bus_barton,                              # Link to the bus we retrieved above
    prime_mover_type = PrimeMovers.BA,             # battery
    storage_technology_type = StorageTech.LIB,     # lithium-ion battery
    storage_capacity = 4.0,                        # 2 GWh (4.0 × 500), per-unit on base_power
    storage_level_limits = (min = 0.0, max = 1.0),
    initial_storage_capacity_level = 0.0,
    rating = 1.0,                                  # 500 MW (1.0 × 500), per-unit on base_power
    active_power = 0.0,
    input_active_power_limits = (min = 0.0, max = 1.0),
    output_active_power_limits = (min = 0.0, max = 1.0),
    efficiency = (in = 0.92, out = 0.92),          # charges/discharges at 92% efficiency
    reactive_power = 0.0,
    reactive_power_limits = nothing,
    base_power = 500.0,                             # all per-unit fields referenced to this (MW)
)

# Attach it to the system with [`PowerSystems.add_component!`](@extref):

add_component!(sys_plus, new_storage)

# Confirm the system now has two storage plants with
# [`PowerSystems.get_components`](@extref), using Julia's broadcasting dot syntax:

get_name.(get_components(EnergyReservoirStorage, sys_plus))

# Re-run the same UC pipeline on the new system, under a new simulation name.

models_b = SimulationModels(;
    decision_models = [
        DecisionModel(
            template_uc,
            sys_plus;
            name = "UC",
            optimizer = solver,
            initialize_model = false,
            optimizer_solve_log_print = false,
            check_numerical_bounds = false,
            warm_start = true,
            store_variable_names = true,
        ),
    ],
)

sequence_b = SimulationSequence(;
    models = models_b,
    ini_cond_chronology = InterProblemChronology(),
)

sim_b = Simulation(;
    name = "new_storage_scenario",
    steps = 1,
    models = models_b,
    sequence = sequence_b,
    initial_time = DateTime("2020-01-01T00:00:00"),
    simulation_folder = mktempdir(),
)

build!(sim_b; console_level = Logging.Warn, file_level = Logging.Error)
execute!(sim_b; enable_progress_bar = false)

results_b = get_decision_problem_results(SimulationResults(sim_b), "UC")

# ## Fuel Stack Comparison
#
# Now, compare the fuel stacks for base case and added storage plant, made with
# [`PowerGraphics.plot_fuel`](@extref):
#
# ```julia
# plot_fuel(results_a, sys_base)
# ```
#
#md # ![Figure 1 — base case fuel stack](assets/A1_baseline_fuel.png)
#
# ```julia
# plot_fuel(results_b, sys_plus)
# ```
#
#md # ![Figure 2 — added storage plant fuel stack](assets/A2_storage_x10_fuel.png)

#
# We see that for this system, the new storage plant in Scenario B charges when
# overnight wind and midday PV are abundant, then serves the morning and evening
# load ramps, eliminating renewable curtailment and reducing natural gas use in
# the evening.

# ## Compare scenarios

# Finally, we'll use [`PowerAnalytics.jl`](@extref PowerAnalytics :doc:`index`) to compare the two scenarios. 
# [`PowerAnalytics.make_selector`](@extref) picks components to analyze;
# `groupby = :all` sums them into one column. Select dispatchable renewables and all storage:

renewable_sel = make_selector(RenewableDispatch; groupby = :all)
storage_sel = make_selector(EnergyReservoirStorage; groupby = :all)
thermal_sel = make_selector(ThermalStandard; groupby = :all)

# Timed metrics return a `DataFrame` with a
# `DateTime` column and one data column per selector group. For example,
# [`PowerAnalytics.calc_curtailment`](@extref) is unused renewable energy at each hour:

curt_hourly_a = calc_curtailment(renewable_sel, results_a)

# [`PowerAnalytics.aggregate_time`](@extref) collapses that series over the horizon
# (default aggregation is `sum`), yielding one row:

aggregate_time(curt_hourly_a)

# Rather than repeating that for every metric, list all time-varying metrics so we can
# compute them all at once. [`PowerAnalytics.calc_total_cost`](@extref) is thermal
# production cost;
# [`PowerAnalytics.calc_active_power_in`](@extref) is storage charging and
# [`PowerAnalytics.calc_active_power_out`](@extref) is storage discharging:

time_computations = [
    (calc_total_cost, thermal_sel, "total_cost"),
    (calc_curtailment, renewable_sel, "renewable_curtailment"),
    (calc_active_power_in, storage_sel, "storage_charge"),
    (calc_active_power_out, storage_sel, "storage_discharge"),
]

# Collect key metrics in one `DataFrame` by running [`PowerAnalytics.compute_all`](@extref)
# on our selected list of metrics for each scenario and aggregating over the horizon:

timed_agg_a = aggregate_time(compute_all(results_a, time_computations...))
timed_agg_b = aggregate_time(compute_all(results_b, time_computations...))

timed_comparison = vcat(
    hcat(DataFrame("scenario" => "base_case"), timed_agg_a),
    hcat(DataFrame("scenario" => "new_storage_scenario"), timed_agg_b),
)

# `PowerAnalytics` also has metrics without a time dimension, such as solver statistics,
# which we can compute through the same framework without the time aggregation step. 
# Compare optimizer stats [`PowerAnalytics.calc_sum_objective_value`](@extref),
# [`PowerAnalytics.calc_sum_solve_time`](@extref), and
# [`PowerAnalytics.calc_sum_bytes_alloc`](@extref):

timeless_computations =
    [calc_sum_objective_value, calc_sum_solve_time, calc_sum_bytes_alloc]
timeless_names = ["objective_value", "solve_time", "bytes_alloc"]

timeless_a = compute_all(results_a, timeless_computations, nothing, timeless_names)
timeless_b = compute_all(results_b, timeless_computations, nothing, timeless_names)

timeless_comparison = vcat(
    hcat(DataFrame("scenario" => "base_case"), timeless_a),
    hcat(DataFrame("scenario" => "new_storage_scenario"), timeless_b),
)

# We see that the added storage plant reduces renewable curtailment and increases storage charge and discharge, decreasing thermal production cost and removing renewable curtailment. The objective value
# can be higher than thermal production costs due to slack and other costs.

# ## Takeaways and Next Steps
#
# - Sienna\Data and Sienna\Ops offer a flexible framework for building and running production cost modeling simulations, either with your own data or with pre-defined data sets.
# - The Julia packages in Sienna\Data and Sienna\Ops are modular so you only need to load what you need, but they also work together to provide a start-to-finish workflow for production cost modeling.
# - This showcase demonstrates the types of analyses you can perform with Sienna\Ops, but there are many ways to customize the analysis to fit your needs.
# - Each package has its own tutorials that go more in depth on the functionality introduced here.
