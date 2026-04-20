# A Single Unit Commitment Problem

```@setup pcm2
using PowerSystems
using PowerSystemCaseBuilder
using PowerSimulations
using PowerAnalytics

system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys");
```

Next, we will define, run, and analyze a single unit commitment problem, optimizing the
commitment decisions over a 24-hour window, with a 24-hour look ahead. This is a single
building block of a production cost model, our starting place on the way to solving a
full, multi-stage production cost model on the next page.

## to do: should this be followed by an analysis and visualization page? So it's not so similar to what already in PSI?
