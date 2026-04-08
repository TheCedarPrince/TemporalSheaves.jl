```@meta
ShareDefaultModule = true
```

```@setup
using Catlab
using HypertextLiteral
using TemporalSheaves
```

# Tutorials 

## The Category of Discrete Sub-Unit Intervals, $\mathbf{Z}$

**Definition:** Let $(\mathbf{Z},\subseteq)$ be the induced subposet of $(\mathbf{I}_{\mathbb{Z}},\subseteq)$ spanned by intervals of length at most one.
More concretely, $\mathbf{Z}$ is the posetal category consisting of:

- Objects $[t]:=[t,t]$ and $[t,t+1]$ for $t\in\mathbb{Z}$;
- Non-identity morphisms $[t]\to [t,t+1]$ and $[t+1]\to[t,t+1]$ for $t\in\mathbb{Z}$.

We call $\mathbf{Z}$ the **category of discrete subunit-intervals**.

---

While the precise name of this category is the category of discrete subunit-intervals, letter $\mathbf{Z}$ was chose to be reminiscent of $\mathbb{Z}$ as well as to evoke the zigzag shape of this category.
For that reason, in `TemporalSheaves.jl` and across the literature here, this category is also affectionately referred to as the $\mathbf{ZigZag}$ category as a shorthand and to emphasize how we are using the shape of this category for our computational applications.

## Examples Using the $\mathbf{ZigZag}$ Category, $\mathbf{Z}$

### Computing $\mathbf{Z}$ and $\mathbf{Z^{op}}$ on $2$ Time Points

Underlying `TemporalSheaves.jl` is the `SchZigZag` Presentation based on `Catlab.jl`'s `FreeSchema` and the abstract acset type, `AbstractZigZag`.
These foundational abstractions allow flexibility in defining methods based on a zigzag schema category with finite number of time points.
Using this basis, `TemporalSheaves.jl` provides the following functionality to produce a zigzag schema and constructor for $n$ number of time points one wants:

```@docs
zigzag
```

Using this function, we can define a zigzag schema on $2$ time points as follows:

```@example
schema, constructor = zigzag(2; opposite = false);
nothing # hide
```

This produces a `schema` and `constructor` object.
We can look at the schema produced:

```@example
to_graphviz(schema, graph_attrs=Dict(:dpi => "70"), prog = "circo")
```

Through this schema, we see two time points: `t0` and `t1`.
Additionally, the apex of this span, `t0_to_t1`, is an object in this category that relates information over these two time points via the homomorphisms, `t0_inclS` and `t1_inclF`.

However, for our purposes, we want to work with $\mathbf{Z^{op}}$, the opposite category of $\mathbf{Z}$.
`TemporalSheaves.jl` provides `op` functionality to compute $\mathbf{Z^{op}}$ on $2$ time points with the following approach:

```@example
schema, constructor = zigzag(2; opposite = true);
nothing # hide
```

Which yields, reversed homomorphisms for this category:

```@example
to_graphviz(schema, graph_attrs=Dict(:dpi => "70"), prog = "circo")
```

### Working with Subobjects of $\mathbf{Z^{op}}$

To view the subobjects of this category, one can use `Catlab.jl`'s `subobject_classifier` method on the `constructor` object.
However, the resulting subobjects are not immediately convenient to visualize or read so `TemporalSheaves.jl` provides the following method:

```@docs
subobject_graph_embedding
```

Calling this function, we can obtain all subobjects as graph embeddings into the graph of the zigzag category:

```@example
subobs = subobject_graph_embedding(constructor)
nothing # hide
```

Furthermore, we can view these subobjects with the following method:

```@example
to_graphviz_htl(subobs, style = "", node_labels = true, edge_labels = true)
```

> Note: for visualization convenience beyond `Catlab.jl`'s `to_graphviz` method, `TemporalSheaves.jl` provides the following methods:
> 
> ``````@docs
> to_graphviz_htl
> display_in_repl
> ``````

Furthermore, using these subobject embeddings, one can readily perform propositional logic operations with them such as follows:

```@example
A = subobs[4]
B = subobs[1]

C = @withmodel ACSetCategory(constructor()) (⟹) begin
    B ⟹ A
end

to_graphviz_htl([B, A, C], node_labels = true, edge_labels = true)
```

You can read the output as $B \implies A$ giving $C$.

## Adding Data To $\mathbf{Z}$ Finite Structures

### Preparing $\mathbf{Z^{op}}$ across $2$ Time Points

To add data to the objects of a zigzag schema category we construct, we proceed in a very similar way with the non-attributed case.
However, this time, we start with the following method:

```@docs
zigzag!
```

Applying the same approach as before, we can generate a `schema` and `constructor` object:

```@example
schema, constructor = zigzag!(2);
nothing # hide
```

### Attributed $\mathbf{Z^{op}}$-$\mathbf{Set}$ on $2$ Time Points

Before continuing, let's examine the new graph of this schema:

```@example
to_graphviz(schema, graph_attrs=Dict(:dpi => "70"), prog = "circo")
```

While this schema looks radically different than the previous schema, it is not as different as one may think.
For complete clarity, let's look at the definition of this schema:

```julia
@present SchZop2! <: SchZigZag begin
  (t0, t1, t0_to_t1)::Ob
  state::Ob

  t0_inclS::Hom(t0, t0_to_t1)
  t1_inclF::Hom(t1, t0_to_t1)

  t0_state::Hom(t0, state)
  t1_state::Hom(t1, state)

  temporal_set::AttrType
  label::AttrType

  t0_temporal_set::Attr(t0, temporal_set)
  t1_temporal_set::Attr(t1, temporal_set)
  t0_to_t1_temporal_set::Attr(t0_to_t1, temporal_set)
  state_label::Attr(state, label)
end
```

Between the last two schemas, the time point objects and inclusion homomorphsisms are the same.
What has been added to this `Presentation` is attribute information to attach _temporal sets_ to each time point.
These are the `Attr`'s denoted as `t0_temporal_set`, `t1_temporal_set`, and `t0_to_t1_temporal_set`.
Moreover, the `state` object has been added so as to record the potential states associated to each element of a temporal set.
The `state_label` `Attr` associates a given state to labels provided at an instance of this `Presentation`.
The addition of these features to this schema is motivated by applications (see section on applications) and allow full exploitation of the categorical machinery provided by `Catlab.jl` on such zigzag categories.

## Computational Applications of $\mathbf{Z^{op}}$-$\mathbf{Set}$

To better understand how to use these features, we provide a few examples 

### Example: Temporal Paths of Flu Transmission

Here, we use the zigzag schema associated to $2$ time points to define flu cases.

```@example
flu_transmission = @acset constructor{String, String} begin
    state   = 4
    state_labels = ["S", "I", "R", "D"]

    t0      = 2
    t1      = 3
    t0_to_t1 = 2

    t0_inclS = [1, 2]
    t1_inclF = [1, 2]

    t0_state = [1, 2]
    t1_state = [2, 3, 1]

    t0_temporal_set          = ["Jacob", "Sanna"]
    t1_temporal_set          = ["Jacob", "Sanna", "Tino"]
    t0_to_t1_temporal_set    = ["Jacob", "Sanna"]
end;
```

We define temporal sets with $3$ people named "Jacob", "Sanna", and "Tino".
Using this acset, let's interrogate it:

```@example
function temporal_path(acs, sch, name::String)
    s = acset_schema(acs)

    t_obs = get_timepoints(sch, type = :discrete)
    span_obs = get_timepoints(sch, type = :cumulative)
    
    function get_state(ob)
        ob_sym = nameof(ob)

        temporal_attr = only(
            attr for (attr, dom, codom) in attrs(s; from=ob_sym)
            if occursin("temporal_set", string(attr))
        )
        rows = incident(acs, name, temporal_attr)
        isempty(rows) && return nothing

        state_hom = findfirst(
            ((hom, dom, codom),) -> occursin("state", string(hom)),
            collect(homs(s; from=ob_sym))
        )
        isnothing(state_hom) && return nothing
        hom_name = homs(s; from=ob_sym)[state_hom][1]

        subpart(acs, subpart(acs, only(rows), hom_name), :state_labels)
    end

    tps = []
    states = []
    for ob in t_obs
        state = get_state(ob)
        push!(tps, nameof(ob))
        push!(states, state)
    end

    return hcat(tps, states)
end
```

Using this function, we can find across the temporal path 

```@example
temporal_path(flu_transmission, schema, "Jacob")
```

We can also do this across more time points; for example:

```@example

schema, constructor = zigzag!(4; opposite = true);

longer_flu_transmission = @acset constructor{String, String} begin
    state        = 4
    state_labels = ["S", "I", "R", "D"]

    # --- t0 ---
    t0              = 3
    t0_state        = [1, 1, 1]                    # S, S, S
    t0_temporal_set = ["Jacob", "Sanna", "Tino"]

    # --- t1 ---
    t1              = 3
    t1_state        = [2, 1, 1]                    # I, S, S
    t1_temporal_set = ["Jacob", "Sanna", "Tino"]

    # --- t2 ---
    t2              = 3
    t2_state        = [3, 2, 1]                    # R, I, S
    t2_temporal_set = ["Jacob", "Sanna", "Tino"]

    # --- t3 ---
    t3              = 3
    t3_state        = [3, 3, 2]                    # R, R, I
    t3_temporal_set = ["Jacob", "Sanna", "Tino"]

    # --- t0_to_t1 span ---
    t0_to_t1              = 3
    t0_to_t1_temporal_set = ["Jacob", "Sanna", "Tino"]
    t0_inclS              = [1, 2, 3]              # all of t0 persists
    t1_inclF              = [1, 2, 3]              # all of t1 persists

    # --- t1_to_t2 span ---
    t1_to_t2              = 3
    t1_to_t2_temporal_set = ["Jacob", "Sanna", "Tino"]
    t1_inclS              = [1, 2, 3]              # all of t1 persists
    t2_inclF              = [1, 2, 3]              # all of t2 persists

    # --- t2_to_t3 span ---
    t2_to_t3              = 3
    t2_to_t3_temporal_set = ["Jacob", "Sanna", "Tino"]
    t2_inclS              = [1, 2, 3]              # all of t2 persists
    t3_inclF              = [1, 2, 3]              # all of t3 persists
end

temporal_path(longer_flu_transmission, schema, "Sanna")
```
