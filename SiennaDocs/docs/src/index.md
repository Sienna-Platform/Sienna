# [Sienna Documentation](@id documentation)

```@meta
CurrentModule = SiennaDocs
```

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

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'fontSize': '18px', 'lineColor': '#9ec5e8', 'arrowheadColor': '#9ec5e8', 'primaryTextColor': '#ffffff', 'secondaryTextColor': '#ffffff'}}}%%
block-beta
  columns 5

  DataHdr("Sienna\Data") InvestHdr("Sienna\Invest") OpsHdr("Sienna\Ops") NetHdr("Sienna\Network") DynHdr("Sienna\Dyn")

  D1["Data assembly<br/>and parsing"] I1["Generation investment<br/>planning"] O1["Market analysis"] N1["AC and DC<br/>power flow"] Y1["Transient stability"]
  D2["Data archiving"] I2["Transmission investment<br/>planning"] O2["Resource adequacy"] N2["Network reduction"] Y2["Electromagnetic<br/>transient modeling"]
  D3["Common data ontology<br/>across applications"] space O3["Reserve adequacy"] N3["Reactive power<br/>planning"] Y3["Small signal<br/>stability"]
  D4["Publicly available<br/>data sets"] space O4["Integrated resource<br/>planning"] N4["Geographic reduction"] Y4["Dynamic contingency<br/>analysis"]
  space space O5["Price forecasting"] N5["Robust power flow"] Y5["Inertia monitoring"]
  space space block:pf:2
    X_PF["Power flow<br/>in the loop"]
  end space
  space space O6["Production cost<br/>modeling"] N6["Virtual PTDF"] space
  space space O7["Capacity<br/>deliverability"] N7["Multi-period<br/>power flows"] space
  space space O8["Medium-term hydro<br/>planning"] N8["Contingency analysis"] space
  space space O9["AGC modeling"] space space
  space space space space space
  GSData(["<a href='getting_started/data/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Data</a>"]) GSInvest(["<a href='getting_started/invest/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Invest</a>"]) GSOps(["<a href='getting_started/ops/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Ops</a>"]) GSNet(["<a href='getting_started/network/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Network</a>"]) GSDyn(["<a href='getting_started/dyn/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Dyn</a>"])

  classDef appHdr fill:none,stroke:#f59e31,color:#ffffff,stroke-width:2px
  classDef coreCap fill:none,stroke:#7eb6e0,color:#ffffff,stroke-width:2px
  classDef interCap fill:none,stroke:#7eb6e0,color:#ffffff,stroke-width:2px
  classDef gsBtn fill:#1a5f4a,color:#ffffff,stroke:#0d3d2e,stroke-width:2px

  class DataHdr,InvestHdr,OpsHdr,NetHdr,DynHdr appHdr
  class D1,D2,D3,D4,I1,I2,O1,O2,O3,O4,O5,O6,O7,O8,O9,N1,N2,N3,N4,N5,N6,N7,N8,Y1,Y2,Y3,Y4,Y5 coreCap
  class X_PF interCap
  class GSData,GSInvest,GSOps,GSNet,GSDyn gsBtn
  style pf fill:none,stroke:none,color:transparent
```

```@raw html
<style>
article .mermaid svg .nodeLabel p,
article .mermaid svg .nodeLabel span,
article .mermaid svg .nodeLabel div,
article .mermaid svg .nodeLabel a,
article .mermaid svg .label text,
article .mermaid svg .label span,
article .mermaid svg foreignObject div {
  color: #ffffff !important;
}
article .mermaid svg .label text,
article .mermaid svg text {
  fill: #ffffff !important;
}
article .mermaid svg .edgePath .path,
article .mermaid svg .flowchart-link {
  stroke: #9ec5e8 !important;
}
article .mermaid svg .marker,
article .mermaid svg .arrowheadPath {
  fill: #9ec5e8 !important;
  stroke: #9ec5e8 !important;
}
</style>
```

- **Orange outline** — Sienna application name (white text)
- **Blue outline** — capability within an application (cross-app node uses the same styling)
- **Green fill** — Learn link to the getting-started path for that application

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
