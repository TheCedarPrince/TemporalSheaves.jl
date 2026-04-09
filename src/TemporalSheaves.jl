"""
Package to work with temporal sheaves and associate them to data sources for computational applications of temporal sheaf theory.
"""
module TemporalSheaves

using Base: get_extension
using Base.Experimental: register_error_hint
using Catlab

function __init__()
    return register_error_hint(MethodError) do io, exc, argtypes, kwargs
        if exc.f == display_in_repl
            if isnothing(get_extension(TemporalSheaves, :TemporalSheavesTerminalViewExt))
                _extension_message("FileIO", display_in_repl, io)
                _extension_message("Sixel", display_in_repl, io)
            end
        end
    end
end

include("utilities.jl")
include("structs.jl")
include("presentations.jl")
include("zigzag.jl")
include("show.jl")
end
