# [Getting Started with Sienna Ops](@id getting_started_ops)

## Install

Add packages as described in [Install Sienna — Sienna\Ops](@ref install_ops).

## Learn

Work through these resources:

| Package | Tutorial | Description |
|:--------|:---------|:------------|
| [PowerSystems.jl](@extref PowerSystems :doc:`index`) | [Create and Explore a Power `System`](@extref PowerSystems :doc:`tutorials/generated_creating_system`) | Start here: shared foundation with Sienna\Data; needed before any Ops simulation |
| [PowerSystems.jl](@extref PowerSystems :doc:`index`) | [Working with Time Series](@extref PowerSystems :doc:`tutorials/generated_working_with_time_series`) | Before multi-period studies: attach load, price, and renewable profiles to a system |
| [PowerSimulations.jl](@extref PowerSimulations :doc:`index`) | [Single-step Problem](@extref PowerSimulations :doc:`tutorials/generated_decision_problem`) | First optimization run: one period, minimal model complexity |
| [PowerSimulations.jl](@extref PowerSimulations :doc:`index`) | [Multi-stage Production Cost Simulation](@extref PowerSimulations :doc:`tutorials/generated_pcm_simulation`) | After the single-step tutorial: commitment and dispatch across many time stages |
| [PowerAnalytics.jl](@extref PowerAnalytics :doc:`index`) | [Simulation Scenarios Analysis](@extref PowerAnalytics :doc:`tutorials/generated_PA_workflow_tutorial`) | After running simulations: compare cases and extract insights from results |
| [SiennaPRASInterface.jl](@extref SiennaPRASInterface :doc:`index`) | [Resource adequacy workflow](https://Sienna-Platform.github.io/SiennaPRASInterface.jl/stable/tutorials/generated_resource_adequacy_workflow.html) | When the question is long-horizon reliability, not hourly dispatch |

Scheduling models may call network power flow through Sienna\Network packages; see
[Getting Started with Sienna Network](@ref getting_started_network) for standalone network analysis.

## Community resources

Visit the [Sienna resources page](https://Sienna-Platform.github.io/Sienna/pages/resources.html) for
Slack, YouTube, GitHub, and discussion forums.
