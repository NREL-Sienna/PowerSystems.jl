using Documenter, PowerSystems
using InfrastructureSystems
const PSYPATH = dirname(pathof(PowerSystems))

include(joinpath(@__DIR__, "src", "generate_validation_table.jl"))

makedocs(
    modules = [PowerSystems],
    format = Documenter.HTML(),
    sitename = "PowerSystems.jl",
    pages = Any[ # Compat: `Any` for 0.4 compat
        "Home" => "index.md",
        # "User Guide" => "man/guide.md",
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
