using Documenter, CompAir

makedocs(
    sitename="CompAir.jl",
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true",
        canonical="https://seawhanlee.github.io/CompAir.jl",
        assets=String[],
        sidebar_sitename=true
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
        "API Reference" => [
            "Isentropic Relations" => "api/isentropic.md",
            "Normal Shock Waves" => "api/normal_shock.md",
            "Oblique Shock Waves" => "api/oblique_shock.md",
            "Prandtl-Meyer Expansion" => "api/prandtl_expand.md",
            "Cone Shock Analysis" => "api/cone_shock.md",
            "Nozzle Analysis" => "api/nozzle.md",
            "Atmospheric Model" => "api/atmos1976.md"
        ],
        "Development" => [
            "Contributing" => "dev/contributing.md",
            "Changelog" => "dev/changelog.md"
        ]
    ],
    checkdocs=:exports,
    warnonly=true,
)

deploydocs(
    repo="github.com/seawhanlee/CompAir.jl.git",
    devbranch="main",
    push_preview=true,
    versions=["stable" => "v^", "v#.#.", "dev" => "main"],
)
