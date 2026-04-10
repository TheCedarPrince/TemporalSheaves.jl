# docs/watch.jl
# Run from repo root: julia --project=docs docs/watch.jl

using Pkg
Pkg.develop(PackageSpec(path = pwd()))
Pkg.instantiate()

using LiveServer
using FileWatching

const DOCS_SRC  = joinpath(@__DIR__, "src")
const BUILD_DIR = joinpath(@__DIR__, "build", "1")
const MAKE_JL   = joinpath(@__DIR__, "make.jl")

function build()
    @info "Building docs..."
    try
        include(MAKE_JL)
        @info "Build complete."
    catch e
        @error "Build failed" exception = (e, catch_backtrace())
    end
end

server = Ref{Any}(nothing)
start_server() = (server[] = LiveServer.serve(dir = BUILD_DIR); @info "Serving at http://localhost:8000")
stop_server()  = (isnothing(server[]) || close(server[]); server[] = nothing)

build()
start_server()

@info "Watching $DOCS_SRC for changes. Press Ctrl+C to stop."
try
    while true
        FileWatching.watch_folder(DOCS_SRC)   # blocks until any change in the folder
        @info "Change detected, rebuilding..."
        stop_server()
        build()
        start_server()
    end
catch e
    e isa InterruptException ? @info("Shutting down.") : rethrow(e)
finally
    stop_server()
end
