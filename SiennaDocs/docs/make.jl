using Documenter
import DataStructures: OrderedDict
using SiennaDocs
using DocumenterInterLinks
using MultiDocumenter

# These will all be post-processed to point to the aggregate MultiDocumenter site
links = InterLinks(
    "Pkg" => "https://pkgdocs.julialang.org/v1/",
    "PowerSystems" => "https://nrel-sienna.github.io/PowerSystems.jl/stable/",
    "PowerSimulations" => "https://nrel-sienna.github.io/PowerSimulations.jl/stable/",
    "PowerAnalytics" => "https://nrel-sienna.github.io/PowerAnalytics.jl/stable/",
    "PowerGraphics" => "https://nrel-sienna.github.io/PowerGraphics.jl/stable/",
    "PowerSystemCaseBuilder" => "https://nrel-sienna.github.io/PowerSystemCaseBuilder.jl/stable/",
)

pages = OrderedDict(
    "Sienna Documentation Hub" => "index.md",
    "How-to" => Any[
        "Install Sienna" => "how-to/install.md",
        "Use Sienna in VSCode" => "how-to/use_vscode.md",
    ],
    "Reference" => Any[
        "Citation" => "reference/citing.md",
        "Developers" => ["Developer Guidelines" => "reference/developer_guidelines.md"],
    ],
)

# First, build the SiennaDocs hub itself with Documenter.jl into docs/build.
# When SIENNA_DOCS_ROOTPATH is set (e.g. PR preview), use it so redirects/canonicals point to the preview URL.
const _docs_rootpath = get(ENV, "SIENNA_DOCS_ROOTPATH", "/Sienna/SiennaDocs/docs/build")
const _docs_rootpath_normalized = endswith(_docs_rootpath, "/") ? _docs_rootpath : _docs_rootpath * "/"
# Hub is at path "index", so its canonical base is .../build/index
hub_canonical = "https://nrel-sienna.github.io" * rstrip(_docs_rootpath, '/') * "/index"
makedocs(
    modules = [SiennaDocs],
    format = Documenter.HTML(
        sidebar_sitename = false,
        prettyurls = haskey(ENV, "GITHUB_ACTIONS"),
        size_threshold = nothing,
        canonical = hub_canonical,
        footer = "Return to the [Sienna homepage](https://nrel-sienna.github.io/Sienna/). Docs powered by [Documenter.jl] (https://github.com/JuliaDocs/Documenter.jl) and the [Julia Programming Language](https://julialang.org/).",
    ),
    sitename = "Sienna Documentation",
    authors = "Kate Doubleday",
    pages = Any[p for p in pages],
    plugins = [links],
)

# MultiDocumenter's canonical update expects versions.js + version dirs; the hub is single-version
# and already has canonical set in makedocs, so we pass fix_canonical_url = false for the hub.
# Where to clone upstream package documentation from gh-pages
clonedir = joinpath(@__DIR__, "clones")
isdir(clonedir) || mkpath(clonedir)

# Build aggregate into a temp dir, then copy to build/. We cannot use build/ as outpath
# because the hub's MultiDocRef has upstream = build/, so MultiDocumenter would read from
# and write to the same directory and overwrite files while reading them.
outpath = mktempdir()

@info """
Cloning package documentation into: $(clonedir)
Building aggregate Sienna documentation site into: $(outpath)
"""

# One MultiDocRef per package; same ref reused in multiple dropdowns.
# include_versions limits copied version dirs to reduce site size; "All versions" link points to package gh-pages.
const _INCLUDE_VERSIONS = ["stable", "dev"]
psy = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerSystems.jl"),
    path = "PowerSystems",
    name = "PowerSystems.jl",
    giturl = "https://github.com/NREL-Sienna/PowerSystems.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
pscb = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerSystemCaseBuilder.jl"),
    path = "PowerSystemCaseBuilder",
    name = "PowerSystemCaseBuilder.jl",
    giturl = "https://github.com/NREL-Sienna/PowerSystemCaseBuilder.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
pg = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerGraphics.jl"),
    path = "PowerGraphics",
    name = "PowerGraphics.jl",
    giturl = "https://github.com/NREL-Sienna/PowerGraphics.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
pnm = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerNetworkMatrices.jl"),
    path = "PowerNetworkMatrices",
    name = "PowerNetworkMatrices.jl",
    giturl = "https://github.com/NREL-Sienna/PowerNetworkMatrices.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
psi = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerSimulations.jl"),
    path = "PowerSimulations",
    name = "PowerSimulations.jl",
    giturl = "https://github.com/NREL-Sienna/PowerSimulations.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
sss = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "StorageSystemsSimulations.jl"),
    path = "StorageSystemsSimulations",
    name = "StorageSystemsSimulations.jl",
    giturl = "https://github.com/NREL-Sienna/StorageSystemsSimulations.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
hps = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "HydroPowerSimulations.jl"),
    path = "HydroPowerSimulations",
    name = "HydroPowerSimulations.jl",
    giturl = "https://github.com/NREL-Sienna/HydroPowerSimulations.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
pf = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerFlows.jl"),
    path = "PowerFlows",
    name = "PowerFlows.jl",
    giturl = "https://github.com/NREL-Sienna/PowerFlows.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
pa = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerAnalytics.jl"),
    path = "PowerAnalytics",
    name = "PowerAnalytics.jl",
    giturl = "https://github.com/NREL-Sienna/PowerAnalytics.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)
psid = MultiDocumenter.MultiDocRef(
    upstream = joinpath(clonedir, "PowerSimulationsDynamics.jl"),
    path = "PowerSimulationsDynamics",
    name = "PowerSimulationsDynamics.jl",
    giturl = "https://github.com/NREL-Sienna/PowerSimulationsDynamics.jl.git",
    include_versions = _INCLUDE_VERSIONS,
)

# Hub at path "index" so root index.html redirects to ./index/ (one redirect, no loop)
# and the hub page at .../build/index/ has the MultiDocumenter nav bar.
docs = Any[
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(@__DIR__, "build"),
        path = "index",
        name = "Sienna Documentation",
        fix_canonical_url = false,
    ),

    MultiDocumenter.DropdownNav("Sienna\\Data", [psy, pscb, pg, pnm]),
    MultiDocumenter.DropdownNav("Sienna\\Ops", [psy, psi, sss, hps, pf, pa, pg]),
    MultiDocumenter.DropdownNav("Sienna\\Dyn", [psy, psid, pg]),
]

# Docs are served at https://nrel-sienna.github.io/Sienna/SiennaDocs/docs/build/
# (Sienna repo = Jekyll site at /Sienna/ with SiennaDocs in subfolder)
# Run docs/patch_multidocumenter.jl once if you see UndefVarError: indexhtml_path or many "Canonical URL missing" warnings.
MultiDocumenter.make(
    outpath,
    docs;
    search_engine = MultiDocumenter.SearchConfig(
        index_versions = ["stable"],
        engine = MultiDocumenter.PageFind,
    ),
    rootpath = _docs_rootpath_normalized,
    canonical_domain = "https://nrel-sienna.github.io",
    sitemap = true,
)

# DocumenterInterLinks resolves @extref at build time into absolute URLs (e.g. nrel-sienna.github.io/PowerSystems.jl/...).
# MultiDocumenter copies pre-built HTML, so those links would leave the aggregate. Rewrite them to point under the aggregate base.
const _AGGREGATE_BASE = rstrip(_docs_rootpath, '/')
const _EXTERNAL_TO_AGGREGATE = [
    "https://nrel-sienna.github.io/PowerSystems.jl/" => "$_AGGREGATE_BASE/PowerSystems/",
    "https://nrel-sienna.github.io/PowerSystemCaseBuilder.jl/" => "$_AGGREGATE_BASE/PowerSystemCaseBuilder/",
    "https://nrel-sienna.github.io/PowerGraphics.jl/" => "$_AGGREGATE_BASE/PowerGraphics/",
    "https://nrel-sienna.github.io/PowerNetworkMatrices.jl/" => "$_AGGREGATE_BASE/PowerNetworkMatrices/",
    "https://nrel-sienna.github.io/PowerSimulations.jl/" => "$_AGGREGATE_BASE/PowerSimulations/",
    "https://nrel-sienna.github.io/StorageSystemsSimulations.jl/" => "$_AGGREGATE_BASE/StorageSystemsSimulations/",
    "https://nrel-sienna.github.io/HydroPowerSimulations.jl/" => "$_AGGREGATE_BASE/HydroPowerSimulations/",
    "https://nrel-sienna.github.io/PowerFlows.jl/" => "$_AGGREGATE_BASE/PowerFlows/",
    "https://nrel-sienna.github.io/PowerAnalytics.jl/" => "$_AGGREGATE_BASE/PowerAnalytics/",
    "https://nrel-sienna.github.io/PowerSimulationsDynamics.jl/" => "$_AGGREGATE_BASE/PowerSimulationsDynamics/",
]
const _HOMEPAGE_LINK = """<a href="https://nrel-sienna.github.io/Sienna/" class="nav-link nav-item">Homepage</a>"""
const _NAV_ITEMS_OPEN = """<div id="nav-items" class="hidden-on-mobile">"""

@info "Rewriting @extref links and injecting Homepage link in nav"
for (root, dirs, files) in walkdir(outpath)
    for f in files
        endswith(f, ".html") || continue
        path = joinpath(root, f)
        isfile(path) || continue
        content = read(path, String)
        modified = false
        for (from, to) in _EXTERNAL_TO_AGGREGATE
            if occursin(from, content)
                content = replace(content, from => to)
                modified = true
            end
        end
        # "See All Versions" script must link to package gh-pages; restore it after rewriting package URLs to aggregate
        if occursin("documenter-see-all-versions-option", content)
            for (pkg_url, agg_path) in _EXTERNAL_TO_AGGREGATE
                needle = "var url=\"" * agg_path * "\""
                if occursin(needle, content)
                    content = replace(content, needle => "var url=\"" * pkg_url * "\""; count = 1)
                    modified = true
                    break
                end
            end
        end
        # Inject "Homepage" as first item in the top bar (MultiDocumenter requires first doc to have path for redirect)
        if occursin(_NAV_ITEMS_OPEN, content) && !occursin(">Homepage</a>", content)
            content = replace(content, _NAV_ITEMS_OPEN => _NAV_ITEMS_OPEN * _HOMEPAGE_LINK)
            modified = true
        end
        if modified
            write(path, content)
        end
    end
end

@info "Copying aggregated documentation into docs/build for deployment"
cp(outpath, joinpath(@__DIR__, "build"); force = true)
