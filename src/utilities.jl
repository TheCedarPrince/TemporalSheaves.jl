"""
    _extension_message(pkg, fn, io)

Prints a styled message to `io` instructing the user to install and load a required package.

# Arguments

- `pkg` - name of the package that needs to be loaded
- `fn` - name of the function that requires `pkg`
- `io` - the `IO` stream to print the message to

# Returns

- `nothing` (prints to `io` as a side effect)

# Examples

```julia-repl
julia> _extension_message("Graphs", "my_function", stdout)
```
"""
function _extension_message(pkg, fn, io)
    print(io, "\n\nPlease load the ")
    printstyled(io, "$pkg", color = :green, bold = true)
    print(io, " package to use the ")
    printstyled(io, "$fn", color = :magenta)
    print(io, " function. ")

    println(io, "You can do this by running: \n")

    printstyled(io, "using Pkg\n", color = :light_blue, bold = true)
    printstyled(io, "Pkg.add(\"$pkg\")\n", color = :light_blue, bold = true)
    printstyled(io, "using $pkg\n", color = :light_blue, bold = true)

    return println(io, "\n\nin your REPL or code.")
end
