using Documenter, PowerSystems
using InfrastructureSystems
const PSYPATH = dirname(pathof(PowerSystems))

include(joinpath(@__DIR__, "src", "generate_validation_table.jl"))

makedocs(
    modules = [PowerSystems],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
    assets = [
        "assets/logo.png"
    ]),
    sitename = "PowerSystems.jl",
    authors = "Jose Daniel Lara, Daniel Thom and Clayton Barrows",
    pages = Any[ # Compat: `Any` for 0.4 compat
        "Introduction" => "index.md",
        "User Guide" => Any["man/data.md"],
        "Developer" => Any["Tests"=>"developer/tests.md",
                           "Logging"=>"developer/logging.md",
                           "Style Guide" => "developer/style.md"],
        "API" => Any[
                        "PowerSystems" => "api/PowerSystems.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/NREL/PowerSystems.jl.git",
    branch = "gh-pages",
    target = "build",
    deps = Deps.pip("pygments", "mkdocs", "python-markdown-math"),
    make = nothing,
)
