using Documenter, PowerSystems
import DataStructures: OrderedDict
using Literate

# This is commented out because the output is not user-friendly. Deliberation on how to best
# communicate this information to users is ongoing.
#include(joinpath(@__DIR__, "src", "generate_validation_table.jl"))
include(joinpath(@__DIR__, "make_model_library.jl"))

pages = OrderedDict(
        "Welcome Page" => "index.md",
        "Quick Start Guide" => "quick_start_guide.md",
        "Tutorials" =>  Any[
            "Introduction" => "tutorials/basics.md",
            "Parsing PowerFlow Data" => "tutorials/parse_powerflow_cases.md",
            "Parsing Tabular Data" => "tutorials/parse_tabular_data.md",
            "Add Forecasts" => "tutorials/add_forecasts.md",
            "Serialize Data" => "tutorials/serialize_data.md",
            "Use Dynamic Data" => "tutorials/dynamic_data.md",
            "PowerSystemCaseBuilder" => "tutorials/powersystembuilder.md",
        ],
        "How to..." =>  Any[
        ],
        "Explanation" =>
            Any[
            "explanation/type_structure.md",
            "explanation/system.md",
            "explanation/per_unit.md",
            "explanation/time_series.md",
            "explanation/example_dynamic_data.md",
            "explanation/system_dynamic_data.md",
            "explanation/cost_functions.md",
            "explanation/market_bid_cost.md",
            "explanation/modeling_with_JuMP.md",
            "explanation/parsing.md",

            ],
        "Model Developer Guide" =>
            Any["Extending Parsing" => "model_developer_guide/extending_parsing.md",
                "Adding Types" => "model_developer_guide/adding_custom_types.md",
                "Adding Additional Fields" => "model_developer_guide/adding_additional_fields.md",

            ],
            "Code Base Developer Guide" =>
            Any["Developer Guide" => "code_base_developer_guide/developer.md",
            "Adding New Types" => "code_base_developer_guide/adding_new_types.md",
            "Troubleshooting" => "code_base_developer_guide/troubleshooting.md"
            ],
        "Model Library" => Any[],
        "Reference" =>
            Any["Public API" => "api/public.md",
            "Internal API Reference" => "api/internal.md",
            "Glossary and Acronyms" => "api/glossary.md",
            "Specifying the type of..." => "api/enumerated_types.md"
            ]


)

pages["Model Library"] = make_model_library(
     categories = [
        Topology,
        StaticInjection,
        Service,
        Branch,
    ],
    exceptions = [PSY.DynamicComponent,
                  PSY.ActivePowerControl,
                  PSY.ReactivePowerControl,
                  PSY.DynamicBranch,
                  PSY.HybridSystem
                  ],
    manual_additions =
        Dict("Service" => ["Reserves" => "model_library/reserves.md"],
        "StaticInjection" => ["Regulation Device" => "model_library/regulation_device.md",
        "HybridSystem" => "model_library/hybrid_system.md"],
        "DynamicInjection" => ["Dynamic Inverter" => "model_library/dynamic_inverter.md",
        "Dynamic Generator" => "model_library/dynamic_generator.md",
        ],
        "Branch" => ["Dynamic Lines" => "model_library/dynamic_branch.md"],
        "Costs" => ["Operating Costs" => "model_library/costs.md",
        "Variable Cost Curves" => "model_library/cost_curves.md"
        ]
        )
)

# postprocess function to insert md
function insert_md(content)
    m = match(r"APPEND_MARKDOWN\(\"(.*)\"\)", content)
    if !isnothing(m)
        md_content = read(m.captures[1], String)
        content = replace(content, r"APPEND_MARKDOWN\(\"(.*)\"\)" => md_content)
    end
    return content
end

# This code performs the automated addition of Literate - Generated Markdowns. The desired
# section name should be the name of the file for instance network_matrices.jl -> Network Matrices
julia_file_filter = x -> occursin(".jl", x)
folders = Dict(
    "Model Library" => filter(julia_file_filter, readdir("docs/src/model_library")),
    "Explanation" => filter(julia_file_filter, readdir("docs/src/explanation")),
    "How to..." => filter(julia_file_filter, readdir("docs/src/how_to")),
    "Model Developer Guide" => filter(julia_file_filter, readdir("docs/src/model_developer_guide")),
    "Code Base Developer Guide" => filter(julia_file_filter, readdir("docs/src/code_base_developer_guide")),
)
for (section, folder) in folders
    for file in folder
        @show file
        section_folder_name = lowercase(replace(section, " " => "_"))
        outputdir = joinpath(pwd(), "docs", "src", "$section_folder_name")
        inputfile = joinpath("$section_folder_name", "$file")
        infile_path = joinpath(pwd(), "docs", "src", inputfile)
        outputfile = string("generated_", replace("$file", ".jl" => ""))
        execute = occursin("EXECUTE = TRUE", uppercase(readline(infile_path))) ? true : false
        execute && include(infile_path)
        Literate.markdown(infile_path,
                          outputdir;
                          name = outputfile,
                          credit = false,
                          flavor = Literate.DocumenterFlavor(),
                          documenter = true,
                          postprocess = insert_md,
                          execute = execute)
        subsection = titlecase(replace(split(file, ".")[1], "_" => " "))
        push!(pages[section], ("$subsection" =>  joinpath("$section_folder_name", "$(outputfile).md")))
    end
end

makedocs(
    modules = [PowerSystems, InfrastructureSystems],
    format = Documenter.HTML(prettyurls = haskey(ENV, "GITHUB_ACTIONS"),),
    sitename = "PowerSystems.jl",
    authors = "Jose Daniel Lara, Daniel Thom, Kate Doubleday, and Clayton Barrows",
    pages = Any[p for p in pages]
)

deploydocs(
    repo = "github.com/NREL-Sienna/PowerSystems.jl.git",
    target = "build",
    branch = "gh-pages",
    devbranch = "main",
    devurl = "dev",
    push_preview=true,
    versions = ["stable" => "v^", "v#.#"],
)
