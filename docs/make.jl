using Documenter, PowerSchema

makedocs(
    modules = [PowerSchema],
    format = :html,
    sitename = "PowerSchema.jl",
    pages = Any[ # Compat: `Any` for 0.4 compat
        "Home" => "index.md",
        # "User Guide" => "man/guide.md",
        "API" => Any[
            "PowerSchema" => "api/PowerSchema.md"
        ],
        "Contributing" => "man/contributing.md"
    ]
)

deploydocs(
    repo = "github.com/NREL/PowerSchema.jl.git",
    branch = "gh-pages",
    target = "build",
    julia  = "0.6",
    deps = Deps.pip("pygments", "mkdocs", "python-markdown-math"),
    make = nothing,
)