using Documenter, PowerSystems
import DataStructures: OrderedDict
using Literate

# This is commented out because the output is not user-friendly. Deliberation on how to best
# communicate this information to users is ongoing.
#include(joinpath(@__DIR__, "src", "generate_validation_table.jl"))
include(joinpath(@__DIR__, "make_model_library.jl"))

pages = OrderedDict(
        "Welcome Page" => "index.md",
        "Tutorials" =>  "tutorials/intro_page.md",
        "User Guide Reference" => Any[
            "user_guide_reference/system.md",
            "user_guide_reference/type_structure.md",
        ],
        "Modeler Reference" => Any[
            "modeler_reference/time_series.md",
            "modeler_reference/parsing.md",
            "modeler_reference/data.md",
            "modeler_reference/example_dynamic_data.md"
        ],
        "Model Developer Reference" => Any[
            "Extending Parsing" => "model_developer_reference/extending_parsing.md",
            "Adding Types" => "model_developer_reference/adding_custom_types.md",
        ],
        "Code Base Developer Reference" => Any[
            "Developer Guide" => "code_base_developer_reference/developer.md",
            "Developer Guide" => "code_base_developer_reference/adding_new_types.md",
        ],
        "Model Library" => Any[],
        "Internal API" => "api/internal.md"
)

pages["Model Library"] = make_model_library(
     categories = [
        Topology,
        StaticInjection,
        Service,
        Branch,
        PSY.DeviceParameter,
    ],
    exceptions = [PSY.DynamicComponent,
                  PSY.ActivePowerControl,
                  PSY.ReactivePowerControl,
                  PSY.DynamicBranch
                  ],
    manual_additions =
        Dict("Service" => ["Reserves" => "model_library/reserves.md"],
        "StaticInjection" => ["Regulation Device" => "model_library/regulation_device.md"],
        "DynamicInjection" => ["Dynamic Inverter" => "model_library/dynamic_inverter.md",
        "Dynamic Generator" => "model_library/dynamic_generator.md",
        ],
        "StaticInjection" => ["HybridSystem" => "model_library/hybrid_device.md"],
        "Branch" => ["Dynamic Lines" => "model_library/dynamic_branch.md"]
        )
)

# This code performs the automated addition of Literate - Generated Markdowns. The desired
# section name should be the name of the file for instance network_matrices.jl -> Network Matrices
julia_file_filter = x -> occursin(".jl", x)
folders = Dict(
    "User Guide Reference" => filter(julia_file_filter, readdir("docs/src/user_guide_reference")),
    "Model Library" => filter(julia_file_filter, readdir("docs/src/model_library")),
    "Modeler Reference" => filter(julia_file_filter, readdir("docs/src/modeler_reference")),
    "Model Developer Reference" => filter(julia_file_filter, readdir("docs/src/model_developer_reference")),
    "Code Base Developer Reference" => filter(julia_file_filter, readdir("docs/src/code_base_developer_reference")),
)

for (section, folder) in folders
    for file in folder
        section_folder_name = lowercase(replace(section, " " => "_"))
        outputdir = joinpath(pwd(), "docs", "src", "$section_folder_name")
        inputfile = joinpath("$section_folder_name", "$file")
        outputfile = string("generated_", replace("$file", ".jl" => ""))
        Literate.markdown(joinpath(pwd(), "docs", "src", inputfile),
                          outputdir;
                          name = outputfile,
                          credit = false,
                          documenter = true)
        subsection = titlecase(replace(split(file, ".")[1], "_" => " "))
        push!(pages[section], ("$subsection" =>  joinpath("$section_folder_name", "$(outputfile).md")))
    end
end

makedocs(
    modules = [PowerSystems],
    format = Documenter.HTML(prettyurls = haskey(ENV, "GITHUB_ACTIONS"),),
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
    push_preview=true,
    versions = ["stable" => "v^", "v#.#"],
)
