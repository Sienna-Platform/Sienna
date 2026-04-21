# Sienna Website

This repo builds the main [Sienna website](https://nrel-sienna.github.io/Sienna/).
Refer to this repository and readme if you are making edits to the public website
and need to view your draft edits; otherwise please refer to the
[website itself](https://nrel-sienna.github.io/Sienna/).

It is a website built in 2 parts:
1. Main landing pages, built using [Jekyll](https://jekyllrb.com/) in Ruby.
1. Technical documentation pages written and compiled by 
[`Documenter.jl`](https://documenter.juliadocs.org/stable/) and aggregated with 
[`MultiDocumenter.jl`](https://github.com/JuliaComputing/MultiDocumenter.jl), which are then
linked from the main website. These files are located in the `SiennaDocs/` subfolder.
The documentation site is published at
[https://nrel-sienna.github.io/Sienna/SiennaDocs/docs/build/](https://nrel-sienna.github.io/Sienna/SiennaDocs/docs/build/).

## Serving the main website with Jekyll

Install Ruby and Jekyll according to the
[Jekyll installation guide](https://jekyllrb.com/docs/installation/).

Serve the website from the root of the repository:
```
bundle exec jekyll serve --livereload
```

The website can be then viewed in a browser by navigating to:

[localhost:4000/Sienna/](http://localhost:4000/Sienna/)


## Updating the `SiennaDocs` technical documentation

If you are making changes to the technical documentation pages in `SiennaDocs`, compile the
markdown into .html files by running from the `SiennaDocs` subfolder:

```julia
julia --project=docs docs/make.jl 
```

This step is necessary to make any changes to `SiennaDocs` visible when serving the website
using Jekyll. The updated technical documentation will also be viewable on its own by opening the
`SiennaDocs\docs\build\index.html` file (double-click to open in a browser).

**Debugging the aggregated docs (MultiDocumenter) in a browser:** Prefer serving over opening `file://` URLs, because Documenter’s version selector and `rootpath` assume a real HTTP path. After `julia --project=docs docs/make.jl`, run `bundle exec jekyll serve` from the repository root and open `http://localhost:4000/Sienna/SiennaDocs/docs/build/` (see above). To verify the “See All Versions” control, open a package page such as `…/PowerSystems/stable/…`, choose **See All Versions** in the version dropdown, and confirm only a new tab navigates to the package’s GitHub Pages site while the original tab stays on the aggregate docs and the dropdown still shows the current version (not blank).

For more information, see
[How to Compile and View Documentation Locally](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/compile/)
in Sienna's `InfrastructureSystems.jl` package.


