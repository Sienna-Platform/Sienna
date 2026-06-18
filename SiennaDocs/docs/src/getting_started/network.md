# [Getting Started with Sienna Network](@id getting_started_network)

## Install

Add packages as described in [Install Sienna — Sienna\Network](@ref install_network).

## Learn

Work through these resources:

| Package | Tutorial | Description |
|:--------|:---------|:------------|
| [PowerFlows.jl](@extref PowerFlows :doc:`index`) | [Solving a Power Flow](@extref PowerFlows :doc:`tutorials/generated_solving_a_power_flow`) | Start here: obtain a converged solution |
| [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) | [`PowerNetworkMatrices.jl` Getting Started](@extref PowerNetworkMatrices :doc:`tutorials/getting_started`) | After a solved case: build and use incidence and sensitivity matrices |
| [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) | [PTDF matrix](@extref PowerNetworkMatrices :doc:`tutorials/tutorial_PTDF_matrix`) | When market or planning workflows need injection-to-flow sensitivities |
| [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) | [Radial Reduction](@extref PowerNetworkMatrices :doc:`tutorials/tutorial_RadialReduction`) | For handling radial networks that you want to shrink for faster downstream work |
| [PowerNetworkMatrices.jl](@extref PowerNetworkMatrices :doc:`index`) | [Degree Two Reduction](@extref PowerNetworkMatrices :doc:`tutorials/tutorial_DegreeTwoReduction`) | For large transmission models where equivalencing speeds later studies |
| [PowerFlows.jl](@extref PowerFlows :doc:`index`) | [How to choose an AC formulation and solver](@extref PowerFlows choose-ac-formulation-and-solver) | Consult when flows fail to converge or you need to trade accuracy for speed |

Sienna\Ops scheduling workflows may integrate power flow from these packages; see
[Getting Started with Sienna Ops](@ref getting_started_ops) for operations simulations.

## Community resources

Visit the [Sienna resources page](https://Sienna-Platform.github.io/Sienna/pages/resources.html) for
Slack, YouTube, GitHub, and discussion forums.
