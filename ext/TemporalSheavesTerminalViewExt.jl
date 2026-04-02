module TemporalSheavesTerminalViewExt

    using TemporalSheaves
    using ImageInTerminal
    using PNGFiles

    import Catlab.Graphics.Graphviz:
        Graph,
        run_graphviz

    function display_in_repl(g::Graph)
        buf = IOBuffer()
        run_graphviz(buf, g, format="png")
        seekstart(buf)
        display(PNGFiles.load(buf))
    end

end
