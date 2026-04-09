module TemporalSheavesTerminalViewExt

using Catlab.Graphics: to_graphviz
using Catlab.Graphics.Graphviz: Graph, run_graphviz
using FileIO: FileIO, load
using Sixel: Sixel, sixel_encode
using TemporalSheaves

__init__() = @info "Terminal image preview for TemporalSheaves loaded!"


"""
    display_in_repl(g::Graph; image_gap=true)

Render a Graphviz `Graph` as a PNG and display it inline in the terminal using Sixel encoding.

# Arguments

- `g::Graph` - a Graphviz graph to render
- `image_gap::Bool` - if `true`, prints a blank line above the image for visual spacing

# Returns

- `nothing` (displays the image to `stdout` as a side effect)

# Examples

```julia-repl
julia> display_in_repl(my_graph)
julia> display_in_repl(my_graph; image_gap=false)
```
"""
function TemporalSheaves.display_in_repl(g::Graph; image_gap = true)
    tmp = tempname() * ".png"
    open(tmp, "w") do io
        run_graphviz(io, g, format = "png")
    end
    image_gap ? println("") : nothing
    return sixel_encode(stdout, load(tmp))
end

end
