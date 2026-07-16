using Test

const _SIENNA_ROOT = normpath(joinpath(@__DIR__, "..", ".."))
const _DOCS_BUILD = joinpath(_SIENNA_ROOT, "SiennaDocs", "docs", "build")
const _DOCS_PREFIX = "/SiennaDocs/docs/build/"
const _HUB_SEGMENTS = ("how-to", "getting_started", "reference")
const _JEKYLL_SCAN_DIRS = (
    joinpath(_SIENNA_ROOT, "_layouts"),
    joinpath(_SIENNA_ROOT, "_data"),
    joinpath(_SIENNA_ROOT, "pages"),
)
const _HREF_PATTERN = r"/SiennaDocs/docs/build/[^\"'\s#*)]+"
const _MISSING_HUB_INDEX_PATTERN =
    r"/SiennaDocs/docs/build/(how-to|getting_started|reference)(/|$)"

function _jekyll_source_files(; include_drafts::Bool = true)
    files = String[]
    for dir in _JEKYLL_SCAN_DIRS
        isdir(dir) || continue
        for (root, _, names) in walkdir(dir)
            for name in names
                endswith(name, ".html") || endswith(name, ".md") ||
                    endswith(name, ".yml") ||
                    continue
                !include_drafts && startswith(name, "_") && continue
                push!(files, joinpath(root, name))
            end
        end
    end
    return sort!(unique!(files))
end

function _extract_docs_hrefs(content::String)
    hrefs = String[]
    for m in eachmatch(_HREF_PATTERN, content)
        href = String(m.match)
        endswith(href, "/") || (href *= "/")
        push!(hrefs, href)
    end
    return unique!(hrefs)
end

function _collect_jekyll_docs_hrefs(; include_drafts::Bool = true)
    hrefs = String[]
    for path in _jekyll_source_files(; include_drafts)
        append!(hrefs, _extract_docs_hrefs(read(path, String)))
    end
    return sort!(unique!(hrefs))
end

function _hub_href_missing_index(href::String)
    return !occursin("/SiennaDocs/docs/build/index/", href) &&
           occursin(_MISSING_HUB_INDEX_PATTERN, href)
end

function _href_to_build_file(href::String)
    startswith(href, _DOCS_PREFIX) || return nothing
    rel = strip(href[(length(_DOCS_PREFIX) + 1):end], '/')
    if isempty(rel)
        return joinpath(_DOCS_BUILD, "index.html")
    end
    return joinpath(_DOCS_BUILD, rel, "index.html")
end

function _load_sienna_docs_data()
    path = joinpath(_SIENNA_ROOT, "_data", "sienna_docs.yml")
    isfile(path) || return nothing
    hub = nothing
    pages = Dict{String, String}()
    for line in split(read(path, String), '\n')
        stripped = strip(line)
        startswith(stripped, "hub:") &&
            (hub = strip(split(stripped, ":"; limit = 2)[2], [' ', '"', '\'']))
        m = match(r"^(\w+):\s*(.+)$", stripped)
        m === nothing && continue
        m.captures[1] == "hub" && continue
        pages[m.captures[1]] = strip(m.captures[2], [' ', '"', '\''])
    end
    return (; hub, pages)
end

@testset "Jekyll → SiennaDocs links" begin
    hrefs = _collect_jekyll_docs_hrefs()
    @test !isempty(hrefs)

    bad_hub = filter(_hub_href_missing_index, hrefs)
    @test isempty(bad_hub)  # hub pages must live under .../build/index/

    data = _load_sienna_docs_data()
    if data !== nothing
        @test data.hub == "/SiennaDocs/docs/build/index/"
        install_href = data.hub * data.pages["install"]
        citing_href = data.hub * data.pages["citing"]

        home_layout = read(joinpath(_SIENNA_ROOT, "_layouts", "home-sienna.html"), String)
        @test occursin("site.data.sienna_docs.hub", home_layout)
        @test occursin("site.data.sienna_docs.pages.install", home_layout)

        nav_content = read(
            joinpath(_SIENNA_ROOT, "_data", "navigation-menu", "secondary.yml"),
            String,
        )
        @test occursin(citing_href, nav_content)

        if isdir(_DOCS_BUILD)
            for expected in (install_href, citing_href)
                build_file = _href_to_build_file(expected)
                @test build_file !== nothing
                @test isfile(build_file)
            end
        end
    end

    if isdir(_DOCS_BUILD)
        published_hrefs = _collect_jekyll_docs_hrefs(; include_drafts = false)
        missing_files = String[]
        for href in published_hrefs
            build_file = _href_to_build_file(href)
            build_file === nothing && continue
            isfile(build_file) || push!(missing_files, "$href -> $build_file")
        end
        @test isempty(missing_files)
    else
        @info "Skipping build artifact check; run docs/make.jl first" build_dir =
            _DOCS_BUILD
    end
end
