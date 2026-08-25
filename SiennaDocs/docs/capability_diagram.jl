# Maintainer-only: landing-page capability diagram generator (HTML/CSS grid).
#
# Edit CAPABILITY_APPS / CROSS_APP_CAPABILITIES below; toggle INCLUDE_INVEST for diagram + nav.
#
# Per-app capabilities: edit that app's `capabilities` vector only.
# Cross-app capabilities: append to CROSS_APP_CAPABILITIES (do not duplicate in app lists).
#   Set enabled = false to hide; set after_app + after_cap_index for vertical placement;
#   span_from / span_to must be adjacent enabled columns.

module CapabilityDiagram

const INCLUDE_INVEST = false

struct AppColumn
    id::Symbol
    header::String
    capabilities::Vector{String}
    gs_page::String          # page stem, e.g. "getting_started/net" (matches make.jl pages)
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
    block_id::String        # HTML data-block-id (unique, short)
    node_id::String         # HTML element id (unique; e.g. "X_PF")
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
        "Net",
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
        "getting_started/net",
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
#      With INCLUDE_INVEST = false, column order is Data, Ops, Net, Dyn — re-check spans.
#   4. Choose unique block_id and node_id strings (not used elsewhere in the diagram).
#   5. Set enabled = false to draft without deleting the entry.
#   6. Run test/test_capability_diagram.jl; a span must cover adjacent enabled columns.
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

function _html_escape(text::AbstractString)
    return replace(text, "&" => "&amp;", "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;")
end

# Format a capability label for HTML. Use `|` in source strings for manual line breaks.
function wrap_label(text::String)
    return join(_html_escape.(split(text, '|')), "<br/>")
end

# Match Documenter.HTML(prettyurls=...) link shape from the hub index page.
function _gs_link_target(page::String, prettyurls::Bool)
    return prettyurls ? "$(page)/" : "$(page).html"
end

function _enabled_apps(apps::Vector{AppColumn}, include_invest::Bool)
    return [
        app for app in apps if (app.id == :invest ? include_invest : app.enabled)
    ]
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

function _html_row(cells::Vector{String})
    return """  <div class="sienna-cap-row">\n    $(join(cells, "\n    "))\n  </div>"""
end

function _space_cell()
    return """<div class="sienna-cap-space" aria-hidden="true"></div>"""
end

function _html_div_cell(
    class::String,
    id::String,
    content::String;
    span::Int = 1,
    extra::String = "",
)
    span_attr = span > 1 ? " style=\"grid-column: span $span\"" : ""
    extra_attr = extra == "" ? "" : " $extra"
    return """<div class="$class" id="$id"$span_attr$extra_attr>$content</div>"""
end

function _cross_app_row_cells(
    entry::CrossAppCapability,
    apps::Vector{AppColumn},
    col_index::Dict{Symbol, Int},
)::Vector{String}
    ncol = length(apps)
    haskey(col_index, entry.span_from) && haskey(col_index, entry.span_to) ||
        error(
            "cross-app $(entry.node_id): span columns must be enabled apps, " *
            "got $(entry.span_from) → $(entry.span_to)",
        )
    from_col = col_index[entry.span_from]
    to_col = col_index[entry.span_to]
    to_col == from_col + 1 ||
        error(
            "cross-app $(entry.node_id): span must cover adjacent columns, " *
            "got $(entry.span_from) (col $from_col) → $(entry.span_to) (col $to_col)",
        )
    cells = String[]
    for _ in 1:(from_col - 1)
        push!(cells, _space_cell())
    end
    push!(
        cells,
        _html_div_cell(
            "sienna-cap-cell sienna-cap-inter",
            entry.node_id,
            wrap_label(entry.label);
            span = 2,
            extra = "data-block-id=\"$(entry.block_id)\"",
        ),
    )
    for _ in 1:(ncol - from_col - 1)
        push!(cells, _space_cell())
    end
    return cells
end

function _row_slot_count(cells::Vector{String})
    slots = 0
    for cell in cells
        slots += occursin("grid-column: span 2", cell) ? 2 : 1
    end
    return slots
end

# Build the HTML/CSS-grid diagram (no client-side Mermaid).
function generate_html_diagram(;
    include_invest::Bool = INCLUDE_INVEST,
    apps::Vector{AppColumn} = CAPABILITY_APPS,
    cross_app::Vector{CrossAppCapability} = CROSS_APP_CAPABILITIES,
    prettyurls::Bool = false,
)
    enabled_apps = _enabled_apps(apps, include_invest)
    enabled_cross = _enabled_cross_app(cross_app)
    ncol = length(enabled_apps)
    col_index = _app_col_index(enabled_apps)
    max_caps = maximum(length(app.capabilities) for app in enabled_apps; init = 0)

    rows = String[]

    header_cells = [
        _html_div_cell(
            "sienna-cap-cell sienna-cap-hdr",
            _header_node_id(app),
            _html_escape("Sienna\\$(app.header)"),
        ) for app in enabled_apps
    ]
    @assert _row_slot_count(header_cells) == ncol
    push!(rows, _html_row(header_cells))

    for cap_idx in 1:max_caps
        row_cells = String[]
        for app in enabled_apps
            if cap_idx <= length(app.capabilities)
                push!(
                    row_cells,
                    _html_div_cell(
                        "sienna-cap-cell sienna-cap-core",
                        _cap_node_id(app, cap_idx),
                        wrap_label(app.capabilities[cap_idx]),
                    ),
                )
            else
                push!(row_cells, _space_cell())
            end
        end
        @assert _row_slot_count(row_cells) == ncol
        push!(rows, _html_row(row_cells))

        for entry in enabled_cross
            entry.after_cap_index == cap_idx || continue
            anchor_idx = findfirst(app -> app.id == entry.after_app, enabled_apps)
            anchor_idx === nothing && continue
            cap_idx <= length(enabled_apps[anchor_idx].capabilities) || continue
            cross_cells = _cross_app_row_cells(entry, enabled_apps, col_index)
            @assert _row_slot_count(cross_cells) == ncol
            push!(rows, _html_row(cross_cells))
        end
    end

    gs_cells = [
        let href = _gs_link_target(app.gs_page, prettyurls)
            title = _html_escape("Sienna\\$(app.header)")
            """<a class="sienna-cap-cell sienna-cap-gs" id="$(_gs_node_id(app))" href="$(_html_escape(href))">Learn $title</a>"""
        end for app in enabled_apps
    ]
    @assert _row_slot_count(gs_cells) == ncol
    push!(rows, _html_row(gs_cells))

    return """
<div class="sienna-cap-diagram" style="--sienna-cap-cols: $ncol" role="group" aria-label="Sienna applications and capabilities">
$(join(rows, "\n"))
</div>
"""
end

function diagram_css()
    return """
<style>
.sienna-cap-diagram {
  display: flex;
  flex-direction: column;
  gap: 0.65em;
  margin: 1.25em 0;
  font-size: 1.05rem;
}
.sienna-cap-diagram .sienna-cap-row {
  display: grid;
  grid-template-columns: repeat(var(--sienna-cap-cols), minmax(0, 1fr));
  gap: 0.65em 0.75em;
}
.sienna-cap-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 0.55em 0.5em;
  line-height: 1.3;
  box-sizing: border-box;
}
.sienna-cap-hdr {
  border: 2px solid #f59e31;
  border-radius: 999px;
}
.sienna-cap-core,
.sienna-cap-inter {
  border: 2px solid #7eb6e0;
  border-radius: 6px;
}
.sienna-cap-gs {
  background: #1a5f4a;
  color: #ffffff !important;
  border: 2px solid #0d3d2e;
  border-radius: 999px;
  text-decoration: none;
  min-height: 48px;
  padding: 6px 4px;
}
.sienna-cap-gs:hover,
.sienna-cap-gs:focus {
  color: #ffffff !important;
  filter: brightness(1.12);
}
article .sienna-cap-diagram .sienna-cap-cell:not(.sienna-cap-gs) {
  color: #222;
}
html.theme--documenter-dark article .sienna-cap-diagram .sienna-cap-cell:not(.sienna-cap-gs),
html.theme--catppuccin-frappe article .sienna-cap-diagram .sienna-cap-cell:not(.sienna-cap-gs),
html.theme--catppuccin-macchiato article .sienna-cap-diagram .sienna-cap-cell:not(.sienna-cap-gs),
html.theme--catppuccin-mocha article .sienna-cap-diagram .sienna-cap-cell:not(.sienna-cap-gs) {
  color: #ffffff;
}
</style>
"""
end

# Markdown fragment for the landing-page capability diagram (written by make.jl).
function capability_diagram_markdown(; prettyurls::Bool = false)
    html = generate_html_diagram(; prettyurls = prettyurls)
    return """
```@raw html
$html
$(diagram_css())
```
"""
end

end # module
