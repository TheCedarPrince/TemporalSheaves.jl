using TemporalSheaves
using Documenter

DocMeta.setdocmeta!(TemporalSheaves, :DocTestSetup, :(using TemporalSheaves); recursive=true)

makedocs(;
    modules=[TemporalSheaves],
    authors="TheCedarPrince <jacobszelko@gmail.com> and contributors",
    sitename="TemporalSheaves.jl",
    format=Documenter.HTML(;
        canonical="https://TheCedarPrince.github.io/TemporalSheaves.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/TheCedarPrince/TemporalSheaves.jl",
    devbranch="main",
)
