using Documenter, CompAir

makedocs(
    sitename="CompAir.jl",
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://seawhanlee.github.io/CompAir.jl",
        assets=String[],
        sidebar_sitename=false
    ),
    modules=[CompAir],
    authors="Seawhan Lee",
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "Installation" => "manual/installation.md",
            "Quick Start" => "manual/quickstart.md",
            "Examples" => "manual/examples.md"
        ],
        "Development" => [
            "Contributing" => "dev/contributing.md",
            "Changelog" => "dev/changelog.md"
        ]
    ],
    warnonly=true
)

deploydocs(
    repo="github.com/seawhanlee/CompAir.jl.git",
    devbranch="main",
    push_preview=true
)
