using Documenter, PowerSystems
import DataStructures: OrderedDict
using Literate
const PSYPATH = dirname(pathof(PowerSystems))

# This is commented out because the output is not user-friendly. Deliberation on how to best
# communicate this information to users is ongoing.
#include(joinpath(@__DIR__, "src", "generate_validation_table.jl"))

pages = OrderedDict(
        "Welcome Page" => "index.md",
        "User Guide" => Any[
            "user_guide/installation.md",
            "user_guide/quick_start_guide.md",
            "user_guide/system.md"
        ],
        "Modeler" => Any[
            "modeler/parsing.md",
            "modeler/data.md",
        ],
        "Model Developer" => Any[
            "Extending Parsing" => "model_developer/extending_parsing.md",
            "Adding Types" => "model_developer/adding_types.md",
        ],
        "Developer" => Any[
            "Style Guide" => "developer/style.md",
            "Testing" => "developer/testing.md",
            "Logging" => "developer/logging.md",
        ],
        "API" => Any[
            "Structs" => "api/structs.md",
            "DynamicStructs" => "api/dynamicsAPI.md",
            "Exported" => "api/exported.md",
            "Internal" => "api/internal.md"
        ]
)

## This code performs the automated addition of Literate - Generated Markdowns
julia_file_filter = x -> occursin(".jl", x)
folders = Dict(
    "User Guide" => filter(julia_file_filter, readdir("docs/src/user_guide")),
    "Modeler" => filter(julia_file_filter, readdir("docs/src/modeler")),
    "Model Developer" => filter(julia_file_filter, readdir("docs/src/model_developer")),
    "Developer" => filter(julia_file_filter, readdir("docs/src/developer")),
)

for (section, folder) in folders
    for file in folder
        section_folder_name = lowercase(replace(section, " " => "_"))
        outputdir = joinpath(pwd(), "docs", "src", "$section_folder_name")
        inputfile = "$section_folder_name/$file"
        Literate.markdown(joinpath(pwd(), "docs", "src", inputfile), outputdir)
        subsection = titlecase(replace(split(file, ".")[1], "_" => " "))
        push!(pages[section], ("$subsection" => replace("$inputfile", ".jl" => ".md")))
    end
end

makedocs(
    modules = [PowerSystems],
    format = Documenter.HTML(),
    sitename = "PowerSystems.jl",
    authors = "Jose Daniel Lara, Daniel Thom and Clayton Barrows",
    pages = Any[p for p in pages]
)

deploydocs(
    repo = "github.com/NREL-SIIP/PowerSystems.jl.git",
    target = "build",
    branch = "gh-pages",
    devbranch = "master",
    devurl = "dev",
    versions = ["stable" => "v^", "v#.#"],
)
