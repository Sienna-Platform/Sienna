# [Getting Started with Sienna\Net](@id getting_started_network)

## Prerequisite

Visit the [Julia programming language page](https://julialang.org/) to install Julia and explore their extensive learning resources.
**Our tutorials assume users have some familiarity with Julia already.**

## Install Sienna

Add packages as described in [Install Sienna — Sienna\Net](@ref install_network).

## [Learn Sienna\Net](@id learn_sienna_network)

Work through these resources:

| Description                    | Resource                                                                                       | Package(s)                                                           |
|:------------------------------ |:---------------------------------------------------------------------------------------------- |:-------------------------------------------------------------------- |
| Data setup                     | [Learn Sienna\Data](@ref learn_sienna_data)                                                    | Sienna\Data                                                          |
| AC/DC power flow               | [Solving a Power Flow](@extref PowerFlows :doc:`tutorials/generated_solving_a_power_flow`)     | [PowerFlows.jl](@extref PowerFlows :doc:`index`)                     |
| Network matrices 101           | [Introduction](@extref PowerNetworkMatrices :doc:`tutorials/generated_introduction`)           | [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) |
| Contingency screening at scale | [Analysis at Scale](@extref PowerNetworkMatrices :doc:`tutorials/generated_analysis_at_scale`) | [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) |

Next steps by study type, especially for accelerating solve times on large systems
without changing core electrical behavior:

| Description                | Resource                                                                                                       | Package(s)                                                           |
|:-------------------------- |:-------------------------------------------------------------------------------------------------------------- |:-------------------------------------------------------------------- |
| Network topology reduction | [Network Reduction Theory](@extref PowerNetworkMatrices :doc:`explanation/network_reduction_theory`)           | [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) |
| Efficient matrix builds    | [Build Multiple Matrices](@extref PowerNetworkMatrices :doc:`how_to_guides/generated_build_multiple_matrices`) | [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) |
| Linear solver choice       | [Choose a Linear Solver](@extref PowerNetworkMatrices :doc:`how_to_guides/generated_choose_linear_solver`)     | [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) |
| AC convergence tuning      | [How to choose an AC formulation and solver](@extref PowerFlows choose-ac-formulation-and-solver)              | [PowerFlows.jl](@extref PowerFlows :doc:`index`)                     |

Sienna\Ops scheduling workflows may integrate power flow from these packages; see
[Getting Started with Sienna\Ops](@ref getting_started_ops).

From there, explore the rest of each package's API, how-to guides, and explanation for more
package-specific information (e.g.
[DC Power Flow Approximation](@extref PowerNetworkMatrices :doc:`explanation/dc_power_flow_approximation`),
[Computational Considerations](@extref PowerNetworkMatrices :doc:`explanation/computational_considerations`),
[Evaluation Models vs. Solver Algorithms](@extref PowerFlows :doc:`explanation/models-and-solvers`)).

## Community resources

Visit the [Sienna resources page](https://Sienna-Platform.github.io/Sienna/pages/resources.html) for
Slack, YouTube, GitHub, and discussion forums.
