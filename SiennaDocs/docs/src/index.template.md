# [Sienna Documentation](@id documentation)

## Welcome to Sienna

The National Laboratory of the Rockies' [Sienna platform](https://sienna-
platform.github.io/Sienna/)
is an open-source framework for power systems planning, operations, and reliability modeling.

Sienna is a modular, extensible platform built in the [Julia](https://julialang.org/) programming
language.
Sienna is comprised of many Julia packages, organized
into applications:

  - [Sienna\Data](https://Sienna-Platform.github.io/Sienna/pages/applications/sienna_data.html) —
    efficient data input, analysis, and transformation
  - [Sienna\Ops](https://Sienna-Platform.github.io/Sienna/pages/applications/sienna_ops.html) —
    system scheduling simulations and resource adequacy
  - [Sienna\Dyn](https://Sienna-Platform.github.io/Sienna/pages/applications/sienna_dyn.html) —
    transient analysis including small-signal stability and dynamic simulations
  - [Sienna\Network](https://Sienna-Platform.github.io/Sienna/pages/applications/sienna_network.html) —
    power flow, network reductions, and reactive power planning

[Visit the Sienna homepage to learn more.](https://Sienna-Platform.github.io/Sienna/)

## Sienna applications and capabilities

<!--CAPABILITY_DIAGRAM--> <!-- replaced by capability_diagram.jl output in make.jl -->

## How to Use This Documentation

This site is the central Sienna Documentation, including Sienna-wide how-tos (install, VS Code) plus
the documentation pages for the core Sienna packages, available via the top navigation dropdowns.

Throughout the Sienna documentation, we strive to follow
the [Diataxis](https://diataxis.fr/)
documentation framework. Within each package's documentation, there are four main sections
containing different information:
  - **Tutorials** - Detailed walk-throughs to help you *learn* how to use Sienna
  - **How to...** - Directions to help *guide* your work for a particular task
  - **Explanation** - Additional details and background information to help you *understand*
    Sienna, its structure, and how it works behind the scenes
  - **Reference** - Technical references and API for a quick *look-up* during your work

The package documentation pages from the dropdowns include the `stable` and `dev` versions. Use **See All Versions** on a package page for
full version history on GitHub Pages.
