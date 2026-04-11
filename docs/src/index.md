```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: TemporalSheaves
  text:
  tagline: Sheaves for Discrete and Cumulative Time Points
  image:
    src: logo.svg
    alt: TemporalSheaves
  actions:
    - theme: brand
      text: Tutorials
      link: /tutorials
    - theme: alt
      text: View on Github
      link: https://github.com/TheCedarPrince/TemporalSheaves.jl
    - theme: alt
      text: API Reference
      link: /api
---
```

`TemporalSheaves.jl` is a Julia package to consider sheaf theory through the lens of changes over time.
In particular, `TemporalSheaves.jl` is designed to support working with temporal sheaves, track information across time points, and supports discrete and cumulative changes over time.

To install (while in development), execute the following in your Julia REPL:

```julia-repl
julia> using Pkg

julia> Pkg.add("https://github.com/TheCedarPrince/TemporalSheaves.jl")
```

Then to start using `TemporalSheaves.jl`, you can do the following:

```julia-repl
julia> using TemporalSheaves
```


If you want to use the terminal viewer extension, also add and use the following packages from your environment:

```julia-repl
julia> Pkg.add(["Sixel", "ImageIO"])

julia> using Sixel, ImageIO
```

and then you can use the function `display_in_repl`

```@docs; canonical=false
display_in_repl
```
