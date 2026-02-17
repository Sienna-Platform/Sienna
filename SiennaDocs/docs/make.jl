using Documenter
import DataStructures: OrderedDict
using SiennaDocs
using DocumenterInterLinks

links = InterLinks(
    "Pkg" => "https://pkgdocs.julialang.org/v1/",
    "PowerSystems" => "https://nrel-sienna.github.io/PowerSystems.jl/stable/",
    "PowerSimulations" => "https://nrel-sienna.github.io/PowerSimulations.jl/stable/",
    "PowerAnalytics" => "https://nrel-sienna.github.io/PowerAnalytics.jl/stable/",
    "PowerGraphics" => "https://nrel-sienna.github.io/PowerGraphics.jl/stable/",
    # "PowerSystemCaseBuilder" => "https://nrel-sienna.github.io/PowerSystemCaseBuilder.jl/stable/",
)


pages = OrderedDict(
    "Sienna Documentation Hub" => "index.md",
    "How-to" => Any["Install Sienna" => "how-to/install.md",
        "Use Sienna in VSCode" => "how-to/use_vscode.md"],
    # "Tutorials" => Any[
    #     "Sienna\\Ops" => Any[
    #         "Production Cost Modeling" => Any[
    #             "Getting Started" => "tutorials/pcm_1.md",
    #             "Loading and Manipulating Data" => "tutorials/pcm_2.md",
    #             "A Single Unit Commitment Problem" => "tutorials/pcm_3.md",
    #             "Multi-Stage Production Cost Modeling" => "tutorials/pcm_4.md"
    #         ],],
    # ],
    "Reference" => Any[ 
        "Citation" => "reference/citing.md",
        "Developers" => ["Developer Guidelines" => "reference/developer_guidelines.md",]
    ],
)

makedocs(
    modules = [SiennaDocs],
    format = Documenter.HTML(
        sidebar_sitename = false,
        prettyurls = haskey(ENV, "GITHUB_ACTIONS"),
        size_threshold = nothing,
        footer = "Return to the [Sienna homepage](https://nrel-sienna.github.io/Sienna/). Docs powered by [Documenter.jl]       (https://github.com/JuliaDocs/Documenter.jl) and the [Julia Programming Language](https://julialang.org/).",),
    sitename = "Sienna Documentation Hub",
    authors = "Kate Doubleday",
    pages = Any[p for p in pages],
    plugins = [links],
)
