function display_in_repl(g::Graph)
    print(Base.stdout, "Please install ImageInTerminal.jl and PNGFiles.jl:\n\n")

    printstyled(Base.stdout, "using Pkg\n", color = :light_blue, bold = true)
    printstyled(Base.stdout, "Pkg.add([\"ImageInTerminal\", \"PNGFiles\"])\n", color = :light_blue, bold = true)

    println(Base.stdout, "\nThen TemporalSheavesTerminalViewExt will load and display_in_repl will work.\n")

end

export display_in_repl
