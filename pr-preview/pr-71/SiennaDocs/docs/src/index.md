# [Sienna Documentation](@id documentation)

## Welcome to Sienna

The National Laboratory of the Rockies' [Sienna platform](https://sienna-
platform.github.io/Sienna/)
is an open-source framework for power systems planning, operations, and reliability modeling.

Sienna is a modular, extensible platform built in the [Julia](https://julialang.org/) programming
language.
Sienna is comprised of many Julia packages, organized
into applications:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'fontSize': '18px', 'lineColor': '#9ec5e8', 'arrowheadColor': '#9ec5e8', 'primaryTextColor': '#ffffff', 'secondaryTextColor': '#ffffff'}}}%%
block-beta
  columns 4
  DataHdr("Sienna\Data") OpsHdr("Sienna\Ops") NetworkHdr("Sienna\Network") DynHdr("Sienna\Dyn")
  D1["Data assembly, parsing<br/>and archiving"] O1["Production cost<br/>modeling"] N1["AC and DC<br/>power flow"] Y1["Transient stability"]
  D2["Common data ontology<br/>across applications"] O2["Market analysis"] N2["Network reduction"] Y2["Electromagnetic<br/>transient modeling"]
  D3["Publicly available data sets"] O3["Resource adequacy<br/>assessment"] N3["Reactive power<br/>planning"] Y3["Small signal<br/>stability"]
  space O4["Integrated resource<br/>planning"] N4["Contingency analysis"] Y4["Inertia monitoring"]
  space block:pf:2
    X_PF["Power flow<br/>in the loop"]
  end space
  GSData(["<a href='getting_started/data/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Data</a>"]) GSOps(["<a href='getting_started/ops/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Ops</a>"]) GSNetwork(["<a href='getting_started/network/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Network</a>"]) GSDyn(["<a href='getting_started/dyn/' style='color:#ffffff;text-decoration:none'>Learn Sienna\Dyn</a>"])
  classDef appHdr fill:none,stroke:#f59e31,color:#ffffff,stroke-width:2px
  classDef coreCap fill:none,stroke:#7eb6e0,color:#ffffff,stroke-width:2px
  classDef interCap fill:none,stroke:#7eb6e0,color:#ffffff,stroke-width:2px
  classDef gsBtn fill:#1a5f4a,color:#ffffff,stroke:#0d3d2e,stroke-width:2px
  class DataHdr,OpsHdr,NetworkHdr,DynHdr appHdr
  class D1,O1,N1,Y1,D2,O2,N2,Y2,D3,O3,N3,Y3,O4,N4,Y4 coreCap
  class X_PF interCap
  class GSData,GSOps,GSNetwork,GSDyn gsBtn
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
article .mermaid svg g.node.gsBtn .label-container,
article .mermaid svg g.node.gsBtn path {
  min-height: 48px;
}
article .mermaid svg g.node.gsBtn foreignObject div {
  padding: 6px 4px;
}
</style>

```

Click the links above to get started with each application's package install instructions and
recommended learning pathway.

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
