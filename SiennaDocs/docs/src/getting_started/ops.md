# [Getting Started with Sienna\Ops](@id getting_started_ops)

## Prerequisite

Visit to [Julia programming language page](https://julialang.org/) to install Julia
and walk through some of their extensive learning resources.
**Our tutorials assume users have some familiarity with Julia already.**

## Install Sienna

Add packages as described in [Install Sienna — Sienna\Ops](@ref install_ops).

## Learn Sienna\Ops

Work through these resources:

| Description                  | Resource                                                                                                                                          | Package(s)                                                         |
|:---------------------------- |:------------------------------------------------------------------------------------------------------------------------------------------------- |:------------------------------------------------------------------ |
| Data setup                   | [Learn Sienna\Data](@ref learn_sienna_data)                                                                                                       | Sienna\Data                                                        |
| Production cost model 101    | [Single-step Problem](@extref PowerSimulations :doc:`tutorials/generated_decision_problem`)                                                       | [PowerSimulations.jl](@extref PowerSimulations :doc:`index`)       |
| Production cost model 102    | [Multi-stage Production Cost Simulation](@extref PowerSimulations :doc:`tutorials/generated_pcm_simulation`)                                      | [PowerSimulations.jl](@extref PowerSimulations :doc:`index`)       |
| Results processing           | [Simulation Scenarios Analysis](@extref PowerAnalytics :doc:`tutorials/generated_PA_workflow_tutorial`)                                           | [PowerAnalytics.jl](@extref PowerAnalytics :doc:`index`)           |
| Resource adequacy simulation | [Resource adequacy workflow](https://Sienna-Platform.github.io/SiennaPRASInterface.jl/stable/tutorials/generated_resource_adequacy_workflow.html) | [SiennaPRASInterface.jl](@extref SiennaPRASInterface :doc:`index`) |

Scheduling models may call network power flow through Sienna\Net packages; see:

| Description                  | Resource                                                                                     | Package(s)                                                   |
|:---------------------------- |:-------------------------------------------------------------------------------------------- |:------------------------------------------------------------ |
| Standalone network analysis  | [Learn Sienna\Net](@ref learn_sienna_network)                                            | Sienna\Net                                               |
| Sienna\Ops -> Sienna\Net | [Running Power Flow In The Loop with Unit Commitment](@extref PowerSimulations uc-inloop-pf) | [PowerSimulations.jl](@extref PowerSimulations :doc:`index`) |

From there, explore the rest of each package's API, how-to guides, and explanation for more
package-specific information, such as [Chronologies](@extref PowerSimulations :doc:`explanation/chronologies`), [Sequencing](@extref PowerSimulations :doc:`explanation/sequencing`), and the full [Formulation Library](@extref PowerSimulations :doc:`formulation_library/Introduction`).

## Community resources

Visit the [Sienna resources page](https://Sienna-Platform.github.io/Sienna/pages/resources.html) for
Slack, YouTube, GitHub, and discussion forums.
