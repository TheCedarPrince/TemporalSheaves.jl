function zigzag(time_points; opposite = true)

    if opposite
        schema_name = Symbol("SchZop$(time_points)")
    else
        schema_name = Symbol("SchZ$(time_points)")
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

    if opposite
        cons_name = Symbol("Zop$(time_points)")
    else
        cons_name = Symbol("Z$(time_points)")
    end

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


function subobject_graph_embedding(cons)
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

export zigzag
export subobject_graph_embedding
