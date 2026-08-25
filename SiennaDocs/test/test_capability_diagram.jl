using Test

include(joinpath(@__DIR__, "..", "docs", "capability_diagram.jl"))
using .CapabilityDiagram

function _html_grid_rows(diagram::String)
    return [
        String(m[1]) for
        m in eachmatch(r"<div class=\"sienna-cap-row\">\n(.*?)\n  </div>"s, diagram)
    ]
end

function _row_slot_count(row::String)
    span2 = count("grid-column: span 2", row)
    units = count(r"class=\"sienna-cap-(?:cell|space)", row)
    return units + span2
end

@testset "capability diagram generator" begin
    diagram_invest = CapabilityDiagram.generate_html_diagram(; include_invest = true)
    diagram_no_invest =
        CapabilityDiagram.generate_html_diagram(; include_invest = false)
    diagram_no_cross = CapabilityDiagram.generate_html_diagram(;
        cross_app = CapabilityDiagram.CrossAppCapability[],
    )

    @test occursin("--sienna-cap-cols: 5", diagram_invest)
    @test occursin("--sienna-cap-cols: 4", diagram_no_invest)
    @test occursin("id=\"InvestHdr\"", diagram_invest)
    @test !occursin("id=\"InvestHdr\"", diagram_no_invest)
    @test !occursin("id=\"GSInvest\"", diagram_no_invest)
    @test occursin("id=\"X_PF\"", diagram_invest)
    @test occursin("data-block-id=\"pf\"", diagram_invest)
    @test !occursin("id=\"X_PF\"", diagram_no_cross)
    @test occursin("id=\"O4\"", diagram_invest)
    @test occursin("id=\"N4\"", diagram_invest)
    @test occursin("Learn Sienna\\Ops", diagram_invest)
    @test occursin(
        "getting_started/ops.html",
        CapabilityDiagram.generate_html_diagram(; prettyurls = false),
    )
    @test occursin(
        "getting_started/ops/",
        CapabilityDiagram.generate_html_diagram(; prettyurls = true),
    )
    @test occursin("sienna-cap-inter", diagram_invest)
    @test occursin("grid-column: span 2", diagram_invest)

    for row in _html_grid_rows(diagram_invest)
        @test _row_slot_count(row) == 5
    end
    for row in _html_grid_rows(diagram_no_invest)
        @test _row_slot_count(row) == 4
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
    padded = CapabilityDiagram.generate_html_diagram(;
        include_invest = false,
        apps = extra_cap_apps,
        cross_app = CapabilityDiagram.CrossAppCapability[],
    )
    @test occursin("--sienna-cap-cols: 2", padded)
    @test occursin("sienna-cap-space", padded)
    for row in _html_grid_rows(padded)
        @test _row_slot_count(row) == 2
    end

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
        CapabilityDiagram.generate_html_diagram(; cross_app = disabled_cross)
    @test !occursin("X_DRAFT", with_disabled)
    @test occursin("id=\"X_PF\"", with_disabled)
    @test occursin("data-block-id=\"pf\"", with_disabled)

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
    with_draft = CapabilityDiagram.generate_html_diagram(; cross_app = enabled_draft)
    @test occursin("id=\"X_DRAFT\"", with_draft)
    @test occursin("data-block-id=\"draft\"", with_draft)

    css = CapabilityDiagram.diagram_css()
    @test occursin("sienna-cap-hdr", diagram_no_invest)
    @test occursin("sienna-cap-core", diagram_no_invest)
    @test occursin("#f59e31", css)
    @test occursin("#7eb6e0", css)
    @test occursin("#1a5f4a", css)
    @test !occursin("primaryTextColor", diagram_no_invest)
    @test !occursin("block-beta", diagram_no_invest)
    @test !occursin("mermaid", diagram_no_invest)

    @test occursin("sienna-cap-cell:not(.sienna-cap-gs)", css)
    @test occursin("color: #222;", css)
    @test occursin("html.theme--documenter-dark", css)
    @test occursin("html.theme--catppuccin-frappe", css)
    @test occursin("html.theme--catppuccin-macchiato", css)
    @test occursin("html.theme--catppuccin-mocha", css)
    @test occursin("sienna-cap-gs", css)
    @test occursin("color: #ffffff !important;", css)
    @test !occursin("color: inherit", css)
    @test !occursin("currentColor", css)
    @test !occursin(".mermaid", css)

    md = CapabilityDiagram.capability_diagram_markdown(; prettyurls = true)
    @test occursin("```@raw html", md)
    @test occursin("sienna-cap-diagram", md)
    @test occursin("getting_started/ops/", md)
    @test !occursin("```mermaid", md)
    @test !occursin("block-beta", md)
    @test !occursin("cdn.jsdelivr.net", md)
end
