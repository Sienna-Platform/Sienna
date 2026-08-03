using Test

include(joinpath(@__DIR__, "..", "docs", "capability_diagram.jl"))
using .CapabilityDiagram

function _diagram_grid_rows(diagram::String)
    rows = String[]
    for line in split(diagram, '\n')
        startswith(line, "  ") || continue
        startswith(line, "    ") && continue
        stripped = strip(line)
        isempty(stripped) && continue
        startswith(stripped, "classDef") && continue
        startswith(stripped, "class ") && continue
        startswith(stripped, "style ") && continue
        startswith(stripped, "end") && continue
        push!(rows, stripped)
    end
    return rows
end

function _row_slot_count(row::String)
    count = 0
    i = 1
    n = length(row)
    while i <= n
        rest = @view row[i:end]
        if startswith(rest, "space")
            count += 1
            i += 5
            while i <= n && row[i] == ' '
                i += 1
            end
        elseif startswith(rest, "block:")
            m = match(r"^block:[^:]+:2", rest)
            m === nothing && break
            count += 2
            i += length(m.match)
            while i <= n && row[i] == ' '
                i += 1
            end
        else
            m = match(r"^[\w]+(?:\([^)]*\)|\[[^\]]*\])", rest)
            m === nothing && break
            count += 1
            i += length(m.match)
            while i <= n && row[i] == ' '
                i += 1
            end
        end
    end
    return count
end

@testset "capability diagram generator" begin
    diagram_invest = CapabilityDiagram.generate_block_beta_diagram(; include_invest = true)
    diagram_no_invest =
        CapabilityDiagram.generate_block_beta_diagram(; include_invest = false)
    diagram_no_cross = CapabilityDiagram.generate_block_beta_diagram(;
        cross_app = CapabilityDiagram.CrossAppCapability[],
    )

    @test occursin("columns 5", diagram_invest)
    @test occursin("columns 4", diagram_no_invest)
    @test occursin("InvestHdr", diagram_invest)
    @test !occursin("InvestHdr", diagram_no_invest)
    @test !occursin("GSInvest", diagram_no_invest)
    @test occursin("X_PF", diagram_invest)
    @test !occursin("X_PF", diagram_no_cross)
    @test occursin("O4", diagram_invest)
    @test occursin("N4", diagram_invest)
    @test occursin("Learn Sienna\\Ops", diagram_invest)
    @test occursin(
        "getting_started/ops.html",
        CapabilityDiagram.generate_block_beta_diagram(; prettyurls = false),
    )
    @test occursin(
        "getting_started/ops/",
        CapabilityDiagram.generate_block_beta_diagram(; prettyurls = true),
    )
    @test !occursin("space space space space space", diagram_invest)
    @test occursin("block:pf:2", diagram_invest)

    ncol = 5
    for row in _diagram_grid_rows(diagram_invest)
        startswith(row, "columns") && continue
        occursin("block:", row) && continue
        startswith(row, "end") && continue
        startswith(row, "GS") && continue
        occursin("Hdr(", row) && continue
        @test _row_slot_count(row) == ncol
    end

    extra_cap_apps = [
        CapabilityDiagram.AppColumn(
            :data,
            "Data",
            ["Only cap"],
            "getting_started/data",
            true,
        ),
        CapabilityDiagram.AppColumn(
            :ops,
            "Ops",
            ["Op A", "Op B", "Op C"],
            "getting_started/ops",
            true,
        ),
    ]
    padded = CapabilityDiagram.generate_block_beta_diagram(;
        include_invest = false,
        apps = extra_cap_apps,
        cross_app = CapabilityDiagram.CrossAppCapability[],
    )
    @test occursin("columns 2", padded)
    @test occursin("space", padded)

    disabled_cross = CapabilityDiagram.CrossAppCapability[
        CapabilityDiagram.CrossAppCapability(
            :power_flow_in_loop,
            "Power flow|in the loop",
            true,
            :ops,
            4,
            :ops,
            :network,
            "pf",
            "X_PF",
        ),
        CapabilityDiagram.CrossAppCapability(
            :draft_feature,
            "Draft|feature",
            false,
            :ops,
            4,
            :ops,
            :network,
            "draft",
            "X_DRAFT",
        ),
    ]
    with_disabled =
        CapabilityDiagram.generate_block_beta_diagram(; cross_app = disabled_cross)
    @test !occursin("X_DRAFT", with_disabled)
    @test occursin("block:pf:2", with_disabled)

    enabled_draft = CapabilityDiagram.CrossAppCapability[
        disabled_cross[1],
        CapabilityDiagram.CrossAppCapability(
            :draft_feature,
            "Draft|feature",
            true,
            :ops,
            4,
            :ops,
            :network,
            "draft",
            "X_DRAFT",
        ),
    ]
    with_draft = CapabilityDiagram.generate_block_beta_diagram(; cross_app = enabled_draft)
    @test occursin("X_DRAFT", with_draft)
    @test occursin("block:draft:2", with_draft)

    @test occursin(
        "classDef appHdr fill:none,stroke:#f59e31,stroke-width:2px",
        diagram_no_invest,
    )
    @test occursin(
        "classDef coreCap fill:none,stroke:#7eb6e0,stroke-width:2px",
        diagram_no_invest,
    )
    @test occursin(
        "classDef interCap fill:none,stroke:#7eb6e0,stroke-width:2px",
        diagram_no_invest,
    )
    @test !occursin("primaryTextColor", diagram_no_invest)
    @test !occursin("secondaryTextColor", diagram_no_invest)
    @test occursin(
        "classDef gsBtn fill:#1a5f4a,color:#ffffff,stroke:#0d3d2e,stroke-width:2px",
        diagram_no_invest,
    )

    css = CapabilityDiagram.diagram_css()
    @test occursin("g.node:not(.gsBtn)", css)
    @test occursin("color: #222 !important;", css)
    @test occursin("fill: #222 !important;", css)
    @test occursin("html.theme--documenter-dark", css)
    @test occursin("html.theme--catppuccin-frappe", css)
    @test occursin("html.theme--catppuccin-macchiato", css)
    @test occursin("html.theme--catppuccin-mocha", css)
    @test occursin("g.node.gsBtn", css)
    @test occursin("color: #ffffff !important;", css)
    @test occursin("fill: #ffffff !important;", css)
    @test !occursin("color: inherit", css)
    @test !occursin("currentColor", css)
    # White/light text for unfilled nodes must be theme-scoped, not global.
    @test !occursin(
        r"article \.mermaid svg \.nodeLabel p,\narticle \.mermaid svg \.nodeLabel span",
        css,
    )
end
