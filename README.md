# Sienna Website

This repo builds the main [Sienna website](https://sienna-platform.github.io/Sienna/).
Refer to this repository and readme if you are making edits to the public website
and need to view your draft edits; otherwise please refer to the
[website itself](https://sienna-platform.github.io/Sienna/).

It is a website built in 2 parts:
1. Main landing pages, built using [Jekyll](https://jekyllrb.com/) in Ruby.
1. Technical documentation pages written and compiled by 
[`Documenter.jl`](https://documenter.juliadocs.org/stable/) and aggregated with 
[`MultiDocumenter.jl`](https://github.com/JuliaComputing/MultiDocumenter.jl), which are then
linked from the main website. These files are located in the `SiennaDocs/` subfolder.
The documentation site is published at
[https://sienna-platform.github.io/Sienna/SiennaDocs/docs/build/](https://sienna-platform.github.io/Sienna/SiennaDocs/docs/build/).

## Production deploy (two workflows)

Both write to the `gh-pages` branch with `clean: false` / `force: false`, and share
concurrency group `gh-pages` (`cancel-in-progress: false`, `queue: max`) so marketing,
docs, and PR previews serialize and multiple pending runs wait in line instead of
canceling each other.

| Workflow | Triggers | Deploys |
| --- | --- | --- |
| `.github/workflows/jekyll.yml` | `push` to `main`, `workflow_dispatch` | Jekyll `_site` (marketing only; `_site/SiennaDocs` removed before deploy) |
| `.github/workflows/sienna-docs-aggregate.yml` | `push` to `main`, daily cron `0 7 * * *` (UTC), `workflow_dispatch`, `repository_dispatch` type `sienna-docs-refresh` | `SiennaDocs/docs/build` → `gh-pages` path `SiennaDocs/docs/build` |

If the docs aggregate job fails, JamesIves never runs, so the previous
`SiennaDocs/docs/build` tree on `gh-pages` stays live (last-good docs). Marketing
never ships a `SiennaDocs/` tree, so a marketing-only rebuild cannot wipe docs.

PR previews (`.github/workflows/jekyll-preview.yml`) still run combined `make.jl` +
Jekyll into `pr-preview/pr-N/`. Before Jekyll, CI removes `SiennaDocs/docs/clones`.
`_config.yml` `exclude` keeps clones, sources, manifests, tests, scripts, and similar
build inputs out of the Jekyll publish surface (while leaving `SiennaDocs/docs/build`
available for the combined preview assemble).

After a successful non-PR docs deploy, each website-aggregated package may send
`repository_dispatch` / `sienna-docs-refresh` to this repo.

## Serving the main website with Jekyll

Install Ruby and Jekyll according to the
[Jekyll installation guide](https://jekyllrb.com/docs/installation/).

Serve the website from the root of the repository:
```
bundle exec jekyll serve --livereload
```

The website can be then viewed in a browser by navigating to:

[localhost:4000/Sienna/](http://localhost:4000/Sienna/)

When developing locally, run
```
jekyll clean
```
and clear your browser cache regularly to ensure .css changes are visible. 

## Updating the `SiennaDocs` technical documentation

If you are making changes to the technical documentation pages in `SiennaDocs`, compile the
markdown into .html files by running from the `SiennaDocs` subfolder:

```julia
julia --project=docs docs/make.jl 
```

This step is necessary to make any changes to `SiennaDocs` visible when serving the website
using Jekyll. Built docs use directory URLs (for example
`…/SiennaDocs/docs/build/index/how-to/install/`), matching production and PR preview.

**Debugging the aggregated docs (MultiDocumenter) in a browser:** Prefer serving over opening `file://` URLs, because Documenter’s version selector and `rootpath` assume a real HTTP path. After `julia --project=docs docs/make.jl`, run `bundle exec jekyll serve` from the repository root and open `http://localhost:4000/Sienna/SiennaDocs/docs/build/` (redirects to `…/build/index/`). To verify the “See All Versions” control, open a package page such as `…/PowerSystems/stable/…`, choose **See All Versions** in the version dropdown, and confirm only a new tab navigates to the package’s GitHub Pages site while the original tab stays on the aggregate docs and the dropdown still shows the current version (not blank).

For more information, see
[How to Compile and View Documentation Locally](https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/compile/)
in Sienna's `InfrastructureSystems.jl` package.
