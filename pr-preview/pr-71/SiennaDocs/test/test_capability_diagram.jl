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
end
