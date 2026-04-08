module TemporalSheavesTerminalViewExt

    using Catlab.Graphics: to_graphviz
    using Catlab.Graphics.Graphviz: Graph, run_graphviz
    using FileIO: FileIO, load
    using Sixel: Sixel, sixel_encode
    using TemporalSheaves

    __init__() = @info "Terminal image preview for TemporalSheaves loaded!"

    function TemporalSheaves.display_in_repl(g::Graph; image_gap = true)
        tmp = tempname() * ".png"
        open(tmp, "w") do io
            run_graphviz(io, g, format="png")
        end
        image_gap ? println("") : nothing
        sixel_encode(stdout, load(tmp))
    end

end
