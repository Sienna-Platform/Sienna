# Production Cost Modeling Tutorial

In this tutorial, we will conduct a two stage production cost modeling (PCM) simulation
in Sienna\Ops, including customizing the inputs and analyzing and visualizing the results.

This will take us on an introductory tour through each of the five core packages in
Sienna\Ops: [`PowerSystems.jl`](https://nrel-sienna.github.io/PowerSystems.jl/stable/),
[`PowerSystemCaseBuilder.jl`](https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl),
[`PowerSimulations.jl`](https://nrel-sienna.github.io/PowerSimulations.jl/stable/),
[`PowerAnalytics.jl`](https://nrel-sienna.github.io/PowerAnalytics.jl/stable/), and
[`PowerGraphics.jl`](https://nrel-sienna.github.io/PowerGraphics.jl/stable/).

## Tutorial Overview

### TODO Add summary graphic and description

## Getting Set Up

Before getting started, follow the [Sienna installation instructions](@ref install).

In a Julia REPL, load the Sienna\Ops packages:

```@example pcm
using PowerSystems
using PowerSystemCaseBuilder
using PowerSimulations
using PowerAnalytics
# TODO update
# using PowerGraphics
```

We will also need an optimization problem solver -- we'll install and use
[`HiGHS.jl`](https://ergo-code.github.io/HiGHS/dev/interfaces/julia/), which is open-source:

```@example pcm
using Pkg
Pkg.add(["HiGHS"])
using HiGHS
```

## Checking Package Versions

Sienna is under active development, so new breaking changes can cause errors.
We ensure that this tutorial is reproducible using these Sienna\Ops package versions,
which you can check using [`Pkg.status`](@extref) from Julia's package manager:

```@example pcm
Pkg.status()
```

You'll see there are some additional documentation packages listed which you can ignore for
purposes of running the tutorial. If you run into errors with the tutorial, first
verify your Sienna package versions match those shown. Specify versions with
[`Pkg.add`](@extref) if needed.
