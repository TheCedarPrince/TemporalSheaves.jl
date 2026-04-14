using Documenter
using DocumenterCitations
using DocumenterVitepress

using TemporalSheaves
using Sixel
using ImageIO
using HypertextLiteral

bib = CitationBibliography(joinpath(@__DIR__, "src", "refs.bib"))

ext1 = Base.get_extension(TemporalSheaves, :TemporalSheavesHypertextExt)
ext2 = Base.get_extension(TemporalSheaves, :TemporalSheavesTerminalViewExt)

DocMeta.setdocmeta!(TemporalSheaves, :DocTestSetup, :(using TemporalSheaves); recursive = true)

makedocs(;
    modules = [TemporalSheaves, ext1, ext2],
    authors = "TheCedarPrince <jacobszelko@gmail.com> and contributors",
    sitename = "TemporalSheaves.jl",
    format = DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/TheCedarPrince/TemporalSheaves.jl",
        devbranch = "main",
        devurl = "dev",
    ),
    pages = [
        "Home" => "index.md",
        "Tutorials" => "tutorials.md",
        "Goals" =>
            [
            "temporal_paths.md",
        ],
        "API" => "api.md",
        "References" => "references.md"
    ],
    plugins = [bib]
)

DocumenterVitepress.deploydocs(;
    # ← CHANGE: was deploydocs(...)
    repo = "github.com/TheCedarPrince/TemporalSheaves.jl",
    target = joinpath(@__DIR__, "build"),  # ← ADD: required by DVP
    branch = "gh-pages",
    devbranch = "main",
    push_preview = true,
)
