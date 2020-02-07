using Documenter, PowerSystems
using InfrastructureSystems
const PSYPATH = dirname(pathof(PowerSystems))

# This is commented out because the output is not user-friendly. Deliberation on how to best
# communicate this information to users is ongoing.
#include(joinpath(@__DIR__, "src", "generate_validation_table.jl"))

makedocs(
    modules = [PowerSystems],
    format = Documenter.HTML(mathengine = Documenter.MathJax()),
    sitename = "PowerSystems.jl",
    authors = "Jose Daniel Lara, Daniel Thom and Clayton Barrows",
    pages = Any[ # Compat: `Any` for 0.4 compat
        "Introduction" => "index.md",
        "User Guide" => Any[
            "man/parsing.md",
            "man/data.md",
        ],
        "Developer" => Any[
            "Tests" => "developer/tests.md",
            "Logging" => "developer/logging.md",
            "Style Guide" => "developer/style.md",
            "Extending Parsing" => "developer/extending_parsing.md",
        ],
        "API" => Any[
            "PowerSystems" => "api/PowerSystems.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/NREL/PowerSystems.jl.git",
    branch = "gh-pages",
    target = "build",
    make = nothing,
)
