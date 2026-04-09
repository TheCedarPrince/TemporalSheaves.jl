"""

    op(p::Presentation)

Compute the opposite of the schema associated to a `Presentation`.

# Arguments

- `p::Presentation` - a presentation of a ZigZag schema 

# Returns 

- A copy of `p` that reverses the `Hom`'s of the presentation

# Examples

```julia-repl
julia> op_of_p = op(p);
```
"""
function op(p::Presentation)
    op_p = Presentation(p.syntax)
    add_generators!(op_p, generators(p, :Ob))
    add_generators!(op_p, [Hom(nameof(h), codom(h), dom(h)) for h in generators(p, :Hom)])
    if !isempty(generators(p, :Attr)) || !isempty(generators(p, :AttrType))
        printstyled(Base.stdout, "This operation does not preserve attribute data.\n", color = :light_red, bold = true)
        printstyled(Base.stdout, "Destroying detected attribute data; returning presentation without attribute information.\n", color = :light_red, bold = true)
    end
    return op_p
end

export op
