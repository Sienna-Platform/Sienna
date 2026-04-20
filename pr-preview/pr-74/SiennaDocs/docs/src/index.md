# [Sienna Documentation Hub](@id hub)

```@meta
CurrentModule = SiennaDocs
```

## About Sienna

The National Laboratory of the Rockies' [Sienna platform](https://nrel-sienna.github.io/Sienna/)
is a open source framework for scheduling problems and dynamic simulations for power systems.
Sienna is a modular, extensible platform with five core applications enabled by multiple
packages in the [`Julia`](http://www.julialang.org) programming language:

  - [Sienna\Data](https://nrel-sienna.github.io/Sienna/pages/applications/sienna_data.html) enables
    efficient data input, analysis, and transformation.
  - [Sienna\Ops](https://nrel-sienna.github.io/Sienna/pages/applications/sienna_ops.html)
    enables system scheduling simulations by formulating and solving optimization problems.
  - [Sienna\Dyn](https://nrel-sienna.github.io/Sienna/pages/applications/sienna_dyn.html) enables
    system transient analysis including small signal stability and full system dynamic
    simulations.
  - [Sienna\Network]()
  - [Sienna\Invest]()

Each core application has many ways it can be applied, separately or together. Here are some top use cases for each application:

  - [Sienna\Data](https://nrel-sienna.github.io/Sienna/pages/applications/sienna_data.html) Data assembly, data archiving (case builder), and commonly available datasets.
  - [Sienna\Ops](https://nrel-sienna.github.io/Sienna/pages/applications/sienna_ops.html) Market analysis, resource adequacy, and reserve adequacy.
  - [Sienna\Dyn](https://nrel-sienna.github.io/Sienna/pages/applications/sienna_dyn.html) Transient stability, EMT, and small signal stability.
  - [Sienna\Network]() AC and DC power flow, network reduction, and reactive power planning.
  - [Sienna\Invest]() Generation and transmission investment planning

## Quick Links

| Sienna\Data                                                                              | Sienna\Ops                                                                                        | Sienna\Dyn                                                                                       |
|:---------------------------------------------------------------------------------------- |:------------------------------------------------------------------------------------------------- |:------------------------------------------------------------------------------------------------ |
| [PowerSystems.jl](https://nrel-sienna.github.io/PowerSystems.jl/stable/)                 | [PowerSystems.jl](https://nrel-sienna.github.io/PowerSystems.jl/stable/)                          | [PowerSystems.jl](https://nrel-sienna.github.io/PowerSystems.jl/stable/)                         |
| [PowerSystemCaseBuilder.jl](https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl)    | [PowerSimulations.jl](https://nrel-sienna.github.io/PowerSimulations.jl/stable/)                  | [PowerSimulationsDynamics.jl](https://nrel-sienna.github.io/PowerSimulationsDynamics.jl/stable/) |
| [PowerGraphics.jl](https://nrel-sienna.github.io/PowerGraphics.jl/stable/)               | [StorageSystemSimulations.jl](https://nrel-sienna.github.io/StorageSystemsSimulations.jl/stable/) | [PowerGraphics.jl](https://nrel-sienna.github.io/PowerGraphics.jl/stable/)                       |
| [PowerNetworkMatrices.jl](https://nrel-sienna.github.io/PowerNetworkMatrices.jl/stable/) | [HydroPowerSimulations.jl](https://github.com/NREL-Sienna/HydroPowerSimulations.jl)               |                                                                                                  |
|                                                                                          | [PowerFlows.jl](https://nrel-sienna.github.io/PowerFlows.jl/stable/)                              |                                                                                                  |
|                                                                                          | [PowerAnalytics.jl](https://nrel-sienna.github.io/PowerAnalytics.jl/stable/)                      |                                                                                                  |
|                                                                                          | [PowerGraphics.jl](https://nrel-sienna.github.io/PowerGraphics.jl/stable/)                        |                                                                                                  |

## How To Use The Sienna Documentation

Sienna is a modular modeling platform, so each Sienna package has its own documentation.
Click the links above to access the documentation for each core Sienna package.

This central site links these packages and provides information that is common across Sienna,
as well as tutorials for new users to learn capabilities across the Sienna applications.

There are four main sections containing different information:

  - **Tutorials** - Detailed walk-throughs to help you *learn* how to use Sienna
  - **How to...** - Directions to help *guide* your work for a particular task
  - **Explanation** - Additional details and background information to help you *understand*
    Sienna, its structure, and how it works behind the scenes
  - **Reference** - Technical references and API for a quick *look-up* during your work

## Resources

| Resource                                                                                     | Description                                                                                                                     |
|:-------------------------------------------------------------------------------------------- |:------------------------------------------------------------------------------------------------------------------------------- |
| **[Learn Julia](https://julialang.org/)** *— Prerequisite*                                   | Before diving into Sienna, get some familiarity with the Julia programming language through their extensive learning resources. |
| **[Watch Tutorials](https://www.youtube.com/@nrel-sienna)** *— YouTube*                      | See our YouTube channel for quick tutorial videos, webinars, and presentations showcasing Sienna at work.                       |
| **[Ask Questions](https://nrel-sienna.slack.com)** *— Slack*                                 | Join our active community on Slack to ask our developers questions and share your experience with other users.                  |
| **[Contribute Code](https://github.com/NREL-Sienna)** *— Sienna Codebase*                    | Visit the Sienna project on Github to access and contribute to all the open-source software packages in the Sienna ecosystem.   |
| **[Propose Features](https://github.com/orgs/NREL-Sienna/discussions)** *— Discussion Board* | Have an idea of where you'd like Sienna to go? Propose and discuss new features on Sienna's Github Discussions page.            |
| **[Work with Us](mailto:sienna@nrel.gov)** *— Collaborate*                                   | Email us if you're interested in working with the Sienna team to build a new capability or apply Sienna to your own use case.   |
