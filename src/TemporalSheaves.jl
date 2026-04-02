module TemporalSheaves

    using Catlab
        import Catlab.CategoricalAlgebra:
          @acset_type,
          @present,
          FreeSchema,
          codom,
          dom,
          elements,
          representable,
          subobject_classifier,
          yoneda
        import Catlab.Graphics:
          to_graphviz
        import Catlab.Graphics.Graphviz:
          Graph
        import Catlab.Models:
          Presentation,
          add_generators!,
          generators
        import Catlab.Subobjects:
          Subobject,
          ⟹
        import Catlab.Theories:
          Hom,
          Ob

    include("show.jl")

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

end
