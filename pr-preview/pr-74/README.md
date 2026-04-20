# Sienna Website

This repo builds the main [Sienna website](https://nrel-sienna.github.io/Sienna/).
Refer to this repository and readme if you are making edits to the public website
and need to view your draft edits; otherwise please refer to the
[website itself](https://nrel-sienna.github.io/Sienna/).

It is a website built in 2 parts:
1. Main landing pages, built using [Jekyll](https://jekyllrb.com/) in Ruby.
1. Technical documentation pages written and compiled by 
[`Documenter.jl`](https://documenter.juliadocs.org/stable/), which are then
linked from the main website. These files are located in the `SiennaDocs/` subfolder.

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

For more information, see
[How to Compile and View Documentation Locally](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/compile/)
in Sienna's `InfrastructureSystems.jl` package.


