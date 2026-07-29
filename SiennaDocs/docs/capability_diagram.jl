# Maintainer-only: landing-page capability diagram generator (block-beta Mermaid).
#
# Edit CAPABILITY_APPS / CROSS_APP_CAPABILITIES below; toggle INCLUDE_INVEST for diagram + nav.
#
# Per-app capabilities: edit that app's `capabilities` vector only.
# Cross-app capabilities: append to CROSS_APP_CAPABILITIES (do not duplicate in app lists).
#   Set enabled = false to hide; set after_app + after_cap_index for vertical placement;
#   span_from / span_to must be adjacent enabled columns.
# Do not add `-->` edges in block-beta; they break column alignment.

module CapabilityDiagram

const INCLUDE_INVEST = false

struct AppColumn
    id::Symbol
    header::String
    capabilities::Vector{String}
    gs_page::String          # page stem, e.g. "getting_started/network" (matches make.jl pages)
    enabled::Bool
end

struct CrossAppCapability
    id::Symbol              # internal name only (not shown in diagram)
    label::String           # display text; use `|` for a line break (see wrap_label)
    enabled::Bool           # false = keep config but hide from diagram
    after_app::Symbol       # which column's cap rows set the vertical anchor
    after_cap_index::Int    # insert after this 1-based cap row of after_app (must be ≤ that app's cap count)
    span_from::Symbol       # left column app id (must be adjacent to span_to in enabled column order)
    span_to::Symbol         # right column app id
    block_id::String        # Mermaid block id (unique, short; used in `block:id:2` and `style id ...`)
    node_id::String         # Mermaid node id (unique; e.g. "X_PF"; gets interCap class)
end

const CAPABILITY_APPS = AppColumn[
    AppColumn(
        :data,
        "Data",
        [
            "Data assembly, parsing|and archiving",
            "Common data ontology|across applications",
            "Publicly available data sets",
        ],
        "getting_started/data",
        true,
    ),
    AppColumn(
        :invest,
        "Invest",
        [
            "Generation investment|planning",
            "Transmission investment|planning",
        ],
        "getting_started/invest",
        INCLUDE_INVEST,
    ),
    AppColumn(
        :ops,
        "Ops",
        [
            "Production cost|modeling",
            "Market analysis",
            "Resource adequacy|assessment",
            "Integrated resource|planning",
            # "Reserve adequacy",
            # "Price forecasting",
            # "Capacity|deliverability",
            # "Medium-term hydro planning",
            # "AGC modeling",
        ],
        "getting_started/ops",
        true,
    ),
    AppColumn(
        :network,
        "Network",
        [
            "AC and DC|power flow",
            "Network reduction",
            "Reactive power|planning",
            # "Geographic reduction",
            # "Robust power flow",
            # "Virtual PTDF",
            # "Multi-period|power flows",
            "Contingency analysis",
        ],
        "getting_started/network",
        true,
    ),
    AppColumn(
        :dyn,
        "Dyn",
        [
            "Transient stability",
            "Electromagnetic|transient modeling",
            "Small signal|stability",
            # "Dynamic contingency|analysis",
            "Inertia monitoring",
        ],
        "getting_started/dyn",
        true,
    ),
]

# Cross-app capability blocks (spanning nodes between two adjacent columns).
#
# Do NOT add the label to any app's `capabilities` vector — only append here.
#
# How to add one:
#   1. Append a CrossAppCapability(...) below.
#   2. Pick after_app + after_cap_index for vertical placement: the block is inserted
#      immediately after that app's cap row N (e.g. after_cap_index = 4 → below O4).
#      If you add/remove caps in that app, update after_cap_index to match.
#   3. Set span_from / span_to to two neighboring enabled columns (e.g. :ops → :network).
#      With INCLUDE_INVEST = false, column order is Data, Ops, Network, Dyn — re-check spans.
#   4. Choose unique block_id and node_id strings (not used elsewhere in the diagram).
#   5. Set enabled = false to draft without deleting the entry.
#   6. Run test/test_capability_diagram.jl; orphan `style block_id` without a row causes Mermaid errors.
#
# Multiple blocks at the same after_cap_index stack in declaration order (one row each).
const CROSS_APP_CAPABILITIES = CrossAppCapability[
    # id, label, enabled, after_app, after_cap_index, span_from, span_to, block_id, node_id
    CrossAppCapability(
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
]

const _APP_NODE_PREFIX = Dict(
    :data => "D",
    :invest => "I",
    :ops => "O",
    :network => "N",
    :dyn => "Y",
)

# Format a capability label for Mermaid. Use `|` in source strings for manual line breaks.
function wrap_label(text::String)
    return replace(text, "|" => "<br/>")
end

# Match Documenter.HTML(prettyurls=...) link shape from the hub index page.
function _gs_link_target(page::String, prettyurls::Bool)
    return prettyurls ? "$(page)/" : "$(page).html"
end

function _enabled_apps(apps::Vector{AppColumn}, include_invest::Bool)
    return [app for app in apps if app.enabled && (app.id != :invest || include_invest)]
end

function _enabled_cross_app(cross_app::Vector{CrossAppCapability})
    return [entry for entry in cross_app if entry.enabled]
end

function _app_col_index(apps::Vector{AppColumn})
    return Dict(app.id => i for (i, app) in enumerate(apps))
end

function _cap_node_id(app::AppColumn, cap_index::Int)
    prefix = _APP_NODE_PREFIX[app.id]
    return "$(prefix)$(cap_index)"
end

function _header_node_id(app::AppColumn)
    title = uppercasefirst(string(app.id))
    return "$(title)Hdr"
end

function _gs_node_id(app::AppColumn)
    title = uppercasefirst(string(app.id))
    return "GS$(title)"
end

function _mermaid_cap_cell(app::AppColumn, cap_index::Int)
    label = wrap_label(app.capabilities[cap_index])
    return "$(_cap_node_id(app, cap_index))[\"$label\"]"
end

function _cross_app_row(
    entry::CrossAppCapability,
    apps::Vector{AppColumn},
    col_index::Dict{Symbol, Int},
)::String
    ncol = length(apps)
    from_col = col_index[entry.span_from]
    to_col = col_index[entry.span_to]
    @assert to_col == from_col + 1 "cross-app span must cover adjacent columns"
    leading = fill("space", from_col - 1)
    trailing = fill("space", ncol - from_col - 1)
    label = wrap_label(entry.label)
    block_lines = [
        "  $(join(leading, " ")) block:$(entry.block_id):2",
        "    $(entry.node_id)[\"$label\"]",
        "  end $(join(trailing, " "))",
    ]
    return join(block_lines, "\n")
end

function _cross_app_styles(entries::Vector{CrossAppCapability})
    return [
        "  style $(entry.block_id) fill:none,stroke:none,color:transparent" for
        entry in entries
    ]
end

# Build the Mermaid `block-beta` source. Do not add `-->` edges; they break column alignment.
function generate_block_beta_diagram(;
    include_invest::Bool = INCLUDE_INVEST,
    apps::Vector{AppColumn} = CAPABILITY_APPS,
    cross_app::Vector{CrossAppCapability} = CROSS_APP_CAPABILITIES,
    prettyurls::Bool = false,
)
    enabled_apps = _enabled_apps(apps, include_invest)
    enabled_cross = _enabled_cross_app(cross_app)
    ncol = length(enabled_apps)
    col_index = _app_col_index(enabled_apps)
    max_caps = maximum(length(app.capabilities) for app in enabled_apps; init=0)

    header_cells = [
        "$(_header_node_id(app))(\"Sienna\\$(app.header)\")" for app in enabled_apps
    ]
    gs_cells = [
        let title = app.header
            node = _gs_node_id(app)
            href = _gs_link_target(app.gs_page, prettyurls)
            """$node(["<a href='$href' style='color:#ffffff;text-decoration:none'>Learn Sienna\\$title</a>"])"""
        end for app in enabled_apps
    ]

    cap_node_ids = String[]
    cross_node_ids = String[]
    inserted_cross = CrossAppCapability[]
    header_ids = String[]
    gs_ids = String[]

    for app in enabled_apps
        push!(header_ids, _header_node_id(app))
        push!(gs_ids, _gs_node_id(app))
    end

    body_lines = String[]
    for cap_idx in 1:max_caps
        row_cells = String[]
        for app in enabled_apps
            if cap_idx <= length(app.capabilities)
                cell = _mermaid_cap_cell(app, cap_idx)
                push!(cap_node_ids, _cap_node_id(app, cap_idx))
                push!(row_cells, cell)
            else
                push!(row_cells, "space")
            end
        end
        push!(body_lines, "  $(join(row_cells, " "))")

        for entry in enabled_cross
            entry.after_cap_index == cap_idx || continue
            anchor_idx = findfirst(app -> app.id == entry.after_app, enabled_apps)
            anchor_idx === nothing && continue
            cap_idx <= length(enabled_apps[anchor_idx].capabilities) || continue
            push!(body_lines, _cross_app_row(entry, enabled_apps, col_index))
            push!(cross_node_ids, entry.node_id)
            push!(inserted_cross, entry)
        end
    end

    gs_row = "  $(join(gs_cells, " "))"
    cross_styles = _cross_app_styles(inserted_cross)

    lines = String[
        "%%{init: {'theme': 'base', 'themeVariables': {'fontSize': '18px', 'lineColor': '#9ec5e8', 'arrowheadColor': '#9ec5e8'}}}%%",
        "block-beta",
        "  columns $ncol",
        "",
        "  $(join(header_cells, " "))",
        "",
        body_lines...,
        "",
        gs_row,
        "",
        "  classDef appHdr fill:none,stroke:#f59e31,stroke-width:2px",
        "  classDef coreCap fill:none,stroke:#7eb6e0,stroke-width:2px",
        "  classDef interCap fill:none,stroke:#7eb6e0,stroke-width:2px",
        "  classDef gsBtn fill:#1a5f4a,color:#ffffff,stroke:#0d3d2e,stroke-width:2px",
        "",
        "  class $(join(header_ids, ",")) appHdr",
        isempty(cap_node_ids) ? "" : "  class $(join(cap_node_ids, ",")) coreCap",
        isempty(cross_node_ids) ? "" : "  class $(join(cross_node_ids, ",")) interCap",
        "  class $(join(gs_ids, ",")) gsBtn",
        cross_styles...,
    ]
    return join(filter(!isempty, lines), "\n")
end

function diagram_css()
    # Explicit colors: Mermaid bakes dark label colors into the SVG tree, so
    # `inherit` does not pick up Documenter body text under dark themes.
    return """
<style>
article .mermaid svg g.node:not(.gsBtn) .nodeLabel p,
article .mermaid svg g.node:not(.gsBtn) .nodeLabel span,
article .mermaid svg g.node:not(.gsBtn) .nodeLabel div,
article .mermaid svg g.node:not(.gsBtn) .nodeLabel a,
article .mermaid svg g.node:not(.gsBtn) .label text,
article .mermaid svg g.node:not(.gsBtn) .label span,
article .mermaid svg g.node:not(.gsBtn) foreignObject div {
  color: #222 !important;
}
article .mermaid svg g.node:not(.gsBtn) .label text,
article .mermaid svg g.node:not(.gsBtn) text {
  fill: #222 !important;
}
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .nodeLabel p,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .nodeLabel span,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .nodeLabel div,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .nodeLabel a,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .label span,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) foreignObject div,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .nodeLabel p,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .nodeLabel span,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .nodeLabel div,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .nodeLabel a,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .label span,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) foreignObject div,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .nodeLabel p,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .nodeLabel span,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .nodeLabel div,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .nodeLabel a,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .label span,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) foreignObject div,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .nodeLabel p,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .nodeLabel span,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .nodeLabel div,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .nodeLabel a,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .label span,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) foreignObject div {
  color: #ffffff !important;
}
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--documenter-dark article .mermaid svg g.node:not(.gsBtn) text,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--catppuccin-frappe article .mermaid svg g.node:not(.gsBtn) text,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--catppuccin-macchiato article .mermaid svg g.node:not(.gsBtn) text,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) .label text,
html.theme--catppuccin-mocha article .mermaid svg g.node:not(.gsBtn) text {
  fill: #ffffff !important;
}
article .mermaid svg g.node.gsBtn .nodeLabel p,
article .mermaid svg g.node.gsBtn .nodeLabel span,
article .mermaid svg g.node.gsBtn .nodeLabel div,
article .mermaid svg g.node.gsBtn .nodeLabel a,
article .mermaid svg g.node.gsBtn .label text,
article .mermaid svg g.node.gsBtn .label span,
article .mermaid svg g.node.gsBtn foreignObject div,
article .mermaid svg g.node.gsBtn a {
  color: #ffffff !important;
}
article .mermaid svg g.node.gsBtn .label text,
article .mermaid svg g.node.gsBtn text {
  fill: #ffffff !important;
}
article .mermaid svg .edgePath .path,
article .mermaid svg .flowchart-link {
  stroke: #9ec5e8 !important;
}
article .mermaid svg .marker,
article .mermaid svg .arrowheadPath {
  fill: #9ec5e8 !important;
  stroke: #9ec5e8 !important;
}
article .mermaid svg g.node.gsBtn .label-container,
article .mermaid svg g.node.gsBtn path {
  min-height: 48px;
}
article .mermaid svg g.node.gsBtn foreignObject div {
  padding: 6px 4px;
}
</style>
"""
end

# Markdown fragment for the landing-page capability diagram (written by make.jl).
function capability_diagram_markdown(; prettyurls::Bool = false)
    mermaid = generate_block_beta_diagram(prettyurls=prettyurls)
    return """
```mermaid
$mermaid
```

```@raw html
$(diagram_css())
```
"""
end

end # module
