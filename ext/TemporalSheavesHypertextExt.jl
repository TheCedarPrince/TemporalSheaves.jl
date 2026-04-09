module TemporalSheavesHypertextExt

using Catlab.Graphics
using HypertextLiteral
using TemporalSheaves

__init__() = @info "Hypertext literal functions for TemporalSheaves loaded!"

"""
    to_graphviz_htl(graphs; style="display: flex; flex-wrap: wrap;",
                    graph_attrs=Dict(:splines=>"false", :rankdir=>"LR", :dpi=>"70"),
                    kwargs...)

Render a collection of Graphviz graphs as a single HypertextLiteral HTML object, suitable for display in Documenter.jl `@example` blocks.

Each graph is converted to an SVG string and embedded as a raw HTML `<div>`, laid out according to `style`.

# Arguments

- `graphs` - a collection of Graphviz-renderable graph objects
- `style::String` - CSS style string applied to the outer wrapper `<div>`
- `graph_attrs` - dictionary of Graphviz graph-level attributes passed to `to_graphviz`
- `kwargs...` - additional keyword arguments forwarded to `to_graphviz`

# Returns

- A `HypertextLiteral` HTML object containing all graphs as embedded SVGs

# Examples

```julia-repl
julia> subobs = subobject_graph_embedding(constructor);
julia> to_graphviz_htl(subobs)
```
"""
function TemporalSheaves.to_graphviz_htl(
        graphs;
        style::String = "display: flex; flex-wrap: wrap;",
        graph_attrs = Dict(:splines => "false", :rankdir => "LR", :dpi => "70"),
        kwargs...
    )

    #= 

Disclaimer: This code was inspired by the solution given here:
https://github.com/JuliaPluto/Pluto.jl/discussions/2197#discussioncomment-3069437
Many thanks!

=#

    plots = []
    for g in graphs
        g = to_graphviz(
            g;
            graph_attrs = graph_attrs,
            kwargs...
        )

        svg = sprint(show, "image/svg+xml", g)
        push!(plots, htl"<div>$(HTML(svg))</div>")
    end

    return htl"<div style=$style>$plots</div>"
end

end
