using Documenter
import DataStructures: OrderedDict
using SiennaDocs
using DocumenterInterLinks
using MultiDocumenter

# These will all be post-processed to point to the aggregate MultiDocumenter site
links = InterLinks(
    "Pkg" => "https://pkgdocs.julialang.org/v1/",
    "PowerSystems" => "https://Sienna-Platform.github.io/PowerSystems.jl/stable/",
    "PowerSimulations" => "https://Sienna-Platform.github.io/PowerSimulations.jl/stable/",
    "PowerAnalytics" => "https://Sienna-Platform.github.io/PowerAnalytics.jl/stable/",
    "PowerGraphics" => "https://Sienna-Platform.github.io/PowerGraphics.jl/stable/",
    "PowerSystemCaseBuilder" => "https://Sienna-Platform.github.io/PowerSystemCaseBuilder.jl/stable/",
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
hub_canonical = "https://Sienna-Platform.github.io" * rstrip(_docs_rootpath, '/') * "/index"
makedocs(
    modules = [SiennaDocs],
    format = Documenter.HTML(
        sidebar_sitename = false,
        prettyurls = haskey(ENV, "GITHUB_ACTIONS"),
        size_threshold = nothing,
        canonical = hub_canonical,
        footer = "Return to the [Sienna homepage](https://Sienna-Platform.github.io/Sienna/). Docs powered by [Documenter.jl] (https://github.com/JuliaDocs/Documenter.jl) and the [Julia Programming Language](https://julialang.org/).",
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
const _AGGREGATED_PACKAGES = [
    (id = :psy, repo = "PowerSystems.jl", path = "PowerSystems"),
    (id = :pscb, repo = "PowerSystemCaseBuilder.jl", path = "PowerSystemCaseBuilder"),
    (id = :pg, repo = "PowerGraphics.jl", path = "PowerGraphics"),
    (id = :pnm, repo = "PowerNetworkMatrices.jl", path = "PowerNetworkMatrices"),
    (id = :psi, repo = "PowerSimulations.jl", path = "PowerSimulations"),
    (id = :sss, repo = "StorageSystemsSimulations.jl", path = "StorageSystemsSimulations"),
    (id = :hps, repo = "HydroPowerSimulations.jl", path = "HydroPowerSimulations"),
    (id = :pf, repo = "PowerFlows.jl", path = "PowerFlows"),
    (id = :pa, repo = "PowerAnalytics.jl", path = "PowerAnalytics"),
    (id = :psid, repo = "PowerSimulationsDynamics.jl", path = "PowerSimulationsDynamics"),
    (id = :pras, repo = "SiennaPRASInterface.jl", path = "SiennaPRASInterface"),
    # (id = :psinv, repo = "PowerSystemsInvestments.jl", path = "PowerSystemsInvestments"),
    # (id = :psip, repo = "PowerSystemsInvestmentsPortfolios.jl", path = "PowerSystemsInvestmentsPortfolios"),
]
const _PACKAGE_REF_BY_ID = Dict(
    pkg.id => MultiDocumenter.MultiDocRef(
        upstream = joinpath(clonedir, pkg.repo),
        path = pkg.path,
        name = pkg.repo,
        giturl = "https://github.com/Sienna-Platform/$(pkg.repo).git",
        include_versions = _INCLUDE_VERSIONS,
    ) for pkg in _AGGREGATED_PACKAGES
)
_refs(ids) = [_PACKAGE_REF_BY_ID[id] for id in ids]

# Hub at path "index" so root index.html redirects to ./index/ (one redirect, no loop)
# and the hub page at .../build/index/ has the MultiDocumenter nav bar.
docs = Any[
    MultiDocumenter.MultiDocRef(
        upstream = joinpath(@__DIR__, "build"),
        path = "index",
        name = "Sienna Documentation",
        fix_canonical_url = false,
    ),

    # Dropdown composition keeps explicit unique identifiers while refs are built from one source list.
    MultiDocumenter.DropdownNav("Sienna\\Data", _refs([:psy, :pscb])),
    MultiDocumenter.DropdownNav("Sienna\\Ops", _refs([:psi, :sss, :hps, :pras, :pa, :pg, :psy])),
    MultiDocumenter.DropdownNav("Sienna\\Dyn", _refs([:psid, :psy])),
    MultiDocumenter.DropdownNav("Sienna\\Network", _refs([:pf, :pnm, :psy])),
    # MultiDocumenter.DropdownNav("Sienna\\Invest", _refs([:psip, :psinv, :psy])),
]

function _validate_aggregated_package_docs(packages, clonedir, required_versions)
    missing = String[]
    for pkg in packages
        for ver in required_versions
            verdir = joinpath(clonedir, pkg.repo, ver)
            isdir(verdir) || push!(missing, "$(pkg.repo)/$(ver) (expected at $(verdir))")
        end
    end
    isempty(missing) && return
    error("""
    Missing aggregated package documentation before MultiDocumenter.make:
    $(join(missing, "\n"))

    Each clone under $(clonedir) must contain gh-pages version directories listed in include_versions.
    Confirm the package has published docs on GitHub Pages (branch gh-pages) with stable/ and dev/.
    """)
end

_package_refs = collect(values(_PACKAGE_REF_BY_ID))
MultiDocumenter.maybe_clone(_package_refs)
_validate_aggregated_package_docs(_AGGREGATED_PACKAGES, clonedir, _INCLUDE_VERSIONS)

# Docs are served at https://Sienna-Platform.github.io/Sienna/SiennaDocs/docs/build/
# (Sienna repo = Jekyll site at /Sienna/ with SiennaDocs in subfolder)
MultiDocumenter.make(
    outpath,
    docs;
    search_engine = MultiDocumenter.SearchConfig(
        index_versions = ["stable"],
        engine = MultiDocumenter.PageFind,
    ),
    rootpath = _docs_rootpath_normalized,
    canonical_domain = "https://Sienna-Platform.github.io",
    sitemap = true,
)

# DocumenterInterLinks resolves @extref at build time into absolute URLs (e.g. Sienna-Platform.github.io/PowerSystems.jl/...).
# MultiDocumenter copies pre-built HTML, so those links would leave the aggregate. Rewrite them to point under the aggregate base.
const _AGGREGATE_BASE = rstrip(_docs_rootpath, '/')
const _EXTERNAL_TO_AGGREGATE = [
    "https://Sienna-Platform.github.io/$(pkg.repo)/" => "$_AGGREGATE_BASE/$(pkg.path)/" for
    pkg in _AGGREGATED_PACKAGES
]
const _HOMEPAGE_LINK = """<a href="https://Sienna-Platform.github.io/Sienna/" class="nav-link nav-item">Homepage</a>"""
# MultiDocumenter/Gumbo serializes with attribute order class then id; support both for robustness.
const _NAV_ITEMS_OPEN_ID_FIRST = """<div id="nav-items" class="hidden-on-mobile">"""
const _NAV_ITEMS_OPEN_CLASS_FIRST = """<div class="hidden-on-mobile" id="nav-items">"""
# Restore MultiDocumenter nav when page is restored from bfcache (back/forward); headroom classes can leave nav at top:-100vh
const _PAGESHOW_NAV_FIX = """
<script>
(function(){
  window.addEventListener('pageshow', function(ev) {
    if (!ev.persisted) return;
    var nav = document.getElementById('multi-page-nav');
    if (nav) {
      nav.classList.remove('headroom--unpinned', 'headroom--not-top', 'headroom--not-bottom');
      nav.style.top = '';
      nav.style.display = 'flex';
    }
  });
})();
</script>
</body>"""

# Unique placeholder; must not appear in real HTML. MultiDocumenter's "See All Versions" script contains
# package gh-pages URLs that must not be rewritten to aggregate paths (would break window.open and
# desync option value vs Documenter). Shield the script block, run extref rewrites, then restore.
const _SEE_ALL_VERSIONS_SCRIPT_PLACEHOLDER = "__SIENNA_MD_SEE_ALL_VERSIONS_SCRIPT_PLACEHOLDER__"
function _shield_see_all_versions_script(content::String)
    rgx = r"(<script>\(function\(\)\{/\* documenter-see-all-versions-option \*/[\s\S]*?\}\)\(\);\</script\>|<script id=\"multidoc-see-all-versions-config\" type=\"application/json\">\{[\s\S]*?\}</script>)"
    m = match(rgx, content)
    m === nothing && return content, nothing
    return replace(content, m.match => _SEE_ALL_VERSIONS_SCRIPT_PLACEHOLDER; count = 1), m.match
end

@info "Rewriting @extref links and injecting Homepage link in nav"
for (root, dirs, files) in walkdir(outpath)
    for f in files
        endswith(f, ".html") || continue
        path = joinpath(root, f)
        isfile(path) || continue
        content = read(path, String)
        modified = false
        content, see_all_block = _shield_see_all_versions_script(content)
        for (from, to) in _EXTERNAL_TO_AGGREGATE
            if occursin(from, content)
                content = replace(content, from => to)
                modified = true
            end
        end
        if see_all_block !== nothing
            content = replace(content, _SEE_ALL_VERSIONS_SCRIPT_PLACEHOLDER => see_all_block; count = 1)
        end
        # Inject "Homepage" as first item in the top bar (MultiDocumenter requires first doc to have path for redirect)
        if !occursin(">Homepage</a>", content)
            if occursin(_NAV_ITEMS_OPEN_CLASS_FIRST, content)
                content = replace(content, _NAV_ITEMS_OPEN_CLASS_FIRST => _NAV_ITEMS_OPEN_CLASS_FIRST * _HOMEPAGE_LINK)
                modified = true
            elseif occursin(_NAV_ITEMS_OPEN_ID_FIRST, content)
                content = replace(content, _NAV_ITEMS_OPEN_ID_FIRST => _NAV_ITEMS_OPEN_ID_FIRST * _HOMEPAGE_LINK)
                modified = true
            end
        end
        # Ensure nav is visible when page is restored from back-forward cache (headroom can leave it at top:-100vh)
        if occursin("id=\"multi-page-nav\"", content) && !occursin("pageshow", content)
            content = replace(content, "</body>" => _PAGESHOW_NAV_FIX; count = 1)
            modified = true
        end
        if modified
            write(path, content)
        end
    end
end

@info "Copying aggregated documentation into docs/build for deployment"
cp(outpath, joinpath(@__DIR__, "build"); force = true)
