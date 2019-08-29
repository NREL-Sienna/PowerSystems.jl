using Documenter, PowerSystems

script_name = joinpath(@__DIR__, "../bin", "generate_valid_config_file.py")		
config_name = joinpath(@__DIR__, "../src", "descriptors", "validation_config.json")		
descriptor_name = joinpath(@__DIR__, "../src", "descriptors", "power_system_structs.json")		
read(`python3 $script_name $config_name $descriptor_name`)		
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
