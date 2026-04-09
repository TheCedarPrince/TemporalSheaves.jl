"""
    zigzag(time_points::Int; opposite::Bool = true)

Generates a discrete representation of the discrete subunit interval category (referred to as the ZigZag category) for `n` time points.

# Arguments

- `time_points::Int` - how many time points to represent 

# Keyword Arguments

- `opposite::Bool` - if `true` make the underlying schema associated to the ZigZag category opposite; if `false`, the schema remains unchanged (default: `true`)

# Returns

- `sch::Presentation` - a `Presentation` representing the schema for `n` number of `time_points`

- `cons::DataType` - an ACSet `DataType` that represents the constructor built by `@acset_type`

# Examples

Create a ZigZag with 2 time points:

```julia-repl
julia> s, c = zigzag(2);
```
"""
function zigzag(time_points::Int; opposite::Bool = true)

    if opposite
        schema_name = Symbol("SchZop$(time_points)")
        cons_name = Symbol("Zop$(time_points)")
    else
        schema_name = Symbol("SchZ$(time_points)")
        cons_name = Symbol("Z$(time_points)")
    end

    sch = eval(
        quote
            @present $(schema_name) <: SchZigZag begin
            end
        end
    )

    for tp in 0:(time_points - 2)
        ob_l1 = Ob(SchZigZag.syntax, Symbol("t$(tp)"))
        ob_apex = Ob(SchZigZag.syntax, Symbol("t$(tp)_to_t$(tp + 1)"))
        ob_l2 = Ob(SchZigZag.syntax, Symbol("t$(tp + 1)"))

        if tp == 0
            add_generators!(sch, [ob_l1, ob_apex, ob_l2])
        else
            add_generators!(sch, [ob_apex, ob_l2])
        end

        h_S = Hom(Symbol("t$(tp)_inclS"), ob_l1, ob_apex)
        h_F = Hom(Symbol("t$(tp + 1)_inclF"), ob_l2, ob_apex)

        add_generators!(sch, [h_S, h_F])
    end

    sch = opposite ? TemporalSheaves.op(sch) : sch

    cons = eval(
        quote
            if $opposite
                @acset_type $(cons_name)(TemporalSheaves.op($(schema_name))) <: AbstractZigZag
            else
                @acset_type $(cons_name)($(schema_name)) <: AbstractZigZag
            end
        end
    )

    return sch, cons
end


"""
    zigzag!(time_points::Int; opposite::Bool = true)

Generates a discrete representation of the discrete subunit interval category (referred to as the ZigZag category) for `n` time points prepared for combinatorial data.

# Arguments

- `time_points::Int` - how many time points to represent 

# Keyword Arguments

- `opposite::Bool` - if `true` make the underlying schema associated to the ZigZag category opposite; if `false`, the schema remains unchanged (default: `true`)

# Returns

- `sch::Presentation` - a `Presentation` representing the schema for `n` number of `time_points`

- `cons::DataType` - an ACSet `DataType` that represents the constructor built by `@acset_type`

# Examples

Create a ZigZag with 2 time points:

```julia-repl
julia> s, c = zigzag!(2);
```

"""
function zigzag!(time_points::Int; opposite::Bool = true)

    if opposite
        schema_name = Symbol("SchZop$(time_points)!")
        cons_name = Symbol("Zop$(time_points)!")
    else
        schema_name = Symbol("SchZ$(time_points)!")
        cons_name = Symbol("Z$(time_points)!")
    end

    sch = eval(
        quote
            @present $(schema_name) <: SchZigZag begin
            end
        end
    )

    for tp in 0:(time_points - 2)
        sym_l1 = Symbol("t$(tp)")
        sym_apex = Symbol("t$(tp)_to_t$(tp + 1)")
        sym_l2 = Symbol("t$(tp + 1)")

        ob_l1 = Ob(SchZigZag.syntax, sym_l1)
        ob_apex = Ob(SchZigZag.syntax, sym_apex)
        ob_l2 = Ob(SchZigZag.syntax, sym_l2)

        if tp == 0
            add_generators!(sch, [ob_l1, ob_apex, ob_l2])
        else
            add_generators!(sch, [ob_apex, ob_l2])
        end

        h_S = Hom(Symbol("t$(tp)_inclS"), ob_l1, ob_apex)
        h_F = Hom(Symbol("t$(tp + 1)_inclF"), ob_l2, ob_apex)

        add_generators!(sch, [h_S, h_F])
    end

    sch = opposite ? TemporalSheaves.op(sch) : sch

    state_ob = Ob(SchZigZag.syntax, :state)
    add_generator!(sch, state_ob)

    tset_attrtype = AttrType(SchZigZag.syntax.AttrType, :temporal_set)
    label_attrtype = AttrType(SchZigZag.syntax.AttrType, :label)
    state_labels_attrtype = Attr(:state_labels, state_ob, label_attrtype)

    add_generator!(sch, tset_attrtype)
    add_generator!(sch, label_attrtype)
    add_generator!(sch, state_labels_attrtype)

    for tp in 0:(time_points - 2)
        sym_l1 = Symbol("t$(tp)")
        sym_apex = Symbol("t$(tp)_to_t$(tp + 1)")
        sym_l2 = Symbol("t$(tp + 1)")

        ob_l1 = Ob(SchZigZag.syntax, sym_l1)
        ob_apex = Ob(SchZigZag.syntax, sym_apex)
        ob_l2 = Ob(SchZigZag.syntax, sym_l2)

        state_l2 = Hom(Symbol("$(String(sym_l2))_state"), ob_l2, state_ob)

        tset_apex = Attr(Symbol("$(String(sym_apex))_temporal_set"), ob_apex, tset_attrtype)
        tset_l2 = Attr(Symbol("$(String(sym_l2))_temporal_set"), ob_l2, tset_attrtype)

        if tp == 0
            state_l1 = Hom(Symbol("$(String(sym_l1))_state"), ob_l1, state_ob)

            tset_l1 = Attr(Symbol("$(String(sym_l1))_temporal_set"), ob_l1, tset_attrtype)

            add_generators!(sch, [state_l1, state_l2])
            add_generators!(sch, [tset_l1, tset_apex, tset_l2])
        else
            add_generators!(sch, [state_l2])
            add_generators!(sch, [tset_apex, tset_l2])
        end
    end

    cons = eval(
        quote
            if $opposite
                @acset_type $(cons_name)($(sch)) <: AbstractZigZag
            else
                @acset_type $(cons_name)($(sch)) <: AbstractZigZag
            end
        end
    )

    return sch, cons

end

"""
    get_timepoints(s::Presentation; type::Symbol = :discrete)

Get time points associated to a given ZigZag schema.

# Arguments

- `s::Presentation` - a schema associated to a ZigZag schema 

# Keyword Arguments

- `type` - what time points to return (default: `:discrete`); options include:

  - `:discrete` - the discrete time points associated to a schema 

  - `:cumulative` - the cumulative time points associated to a schema 

  - Anything else (like an empty string) returns all time points associated to a schema 

# Returns

- Vector of `Ob{:generator}` objects 

# Examples 

```julia-repl
julia> s, c = zigzag(2);

julia> get_timepoints(s)
2-element Vector{Catlab.Theories.FreeSchema.Ob{:generator}}:
 t0
 t1

julia> get_timepoints(s, type = :cumulative)
1-element Vector{Catlab.Theories.FreeSchema.Ob{:generator}}:
 t0_to_t1
```

"""
function get_timepoints(s::Presentation; type = :discrete)

    if type == :discrete
        return filter(s -> occursin(r"^t\d+$", string(s)), generators(s, :Ob))
    elseif type == :cumulative
        return filter(x -> contains(String(x.args[1]), "to"), generators(s, :Ob))
    else
        return generators(s, :Ob)
    end

end


"""
    subobject_graph_embedding(cons)

Computes the subobjects associated to a ZigZag and interprets them as graph embeddings associated to the underlying graph of the constructor's schema.

> **Note:** If you want raw subobjects, please see the `subobject_classifier` function.

# Arguments 

- `cons::DataType` - an ACSet `DataType` that represents the constructor built by `@acset_type`

# Returns 

- Vector of subobjects as graph embeddings (specifically, `NamedGraph`'s).

# Examples 

Compute the subobjects on the ZigZag schema

```julia-repl
julia> s, c = zigzag(c);

julia> subobs = subobject_graph_embedding(c);
```

"""
function subobject_graph_embedding(cons)
    #=

    TODO: Update this function to work only on schemas -- using the combinatorial nature of the zigzag, there is a general pattern we can exploit to simplify preparing the embeddings. We don't need to actually run subobject_classifier repeatedly. Furthermore, all we are using schema for is to get the objects and the mapping pattern. Good for a first draft, but could be significantly improved.

    =#
    if !(cons <: AbstractZigZag)
        printstyled(Base.stdout, "\nConstructor is not an $(AbstractZigZag).\n", color = :light_red, bold = true)
        println(Base.stdout, "You can make one by: \n")

        printstyled(Base.stdout, "@present YourSchema <: SchZigZag begin\n", color = :light_blue, bold = true)
        printstyled(Base.stdout, "# Other Code\n", color = :light_blue, bold = true)
        printstyled(Base.stdout, "end", color = :light_blue, bold = true)

        println(Base.stdout, "\n\nin your REPL or code.\n")
        @error "$(cons) is not an $(AbstractZigZag)!\n"
    end

    G = NamedGraph{Symbol, Symbol}()

    obs = acset_schema(cons()).obs

    n = length(filter(x -> !contains(String(x), "to"), obs))
    add_vertices!(G, n, vname = [Symbol("t$(i - 1)") for i in 1:n])

    for i in 1:(n - 1)
        add_edges!(
            G,
            [i],
            [i + 1],
            ename = Symbol("t$(i - 1)_to_t$(i)")
        )
    end

    _, cons_dict = subobject_classifier(cons)

    tuples = []
    for (k, v) in cons_dict
        for sub in v
            f = sub |> components
            t = NamedTuple(
                key => collect(val)
                    for (key, val) in pairs(f)
            )
            push!(tuples, t)
        end
    end

    return subs = map(tuples |> unique) do t
        V = vcat(
            [
                isempty(getfield(t, v)) ? Int[] : incident(G, v, :vname)
                    for v in G[:vname]
            ]...
        )
        E = vcat(
            [
                isempty(getfield(t, e)) ? Int[] : incident(G, e, :ename)
                    for e in G[:ename]
            ]...
        )

        Subobject(G, V = V, E = E)
    end
end

export get_timepoints
export subobject_graph_embedding
export zigzag
export zigzag!
