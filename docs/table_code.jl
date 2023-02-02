
using PowerSystems #src
function create_md() #src
    descriptor = PowerSystems._read_config_file(joinpath( #src
        dirname(pathof(PowerSystems)), #src
        "descriptors", #src
        "power_system_inputs.json", #src
    )) #src
    columns = [ #src
        "name", #src
        "description", #src
        "unit", #src
        "unit_system", #src
        "base_reference", #src
        "default_value", #src
        "value_options", #src
        "value_range", #src
    ] #src
    header = "| " * join(columns, " | ") * " |\n" * repeat("|----", length(columns)) * "|\n" #src
    s = "" #src
    for (cat, items) in descriptor #src
        csv = "" #src
        for name in PowerSystems.INPUT_CATEGORY_NAMES #src
            if name[2] == cat #src
                csv = name[1] #src
                break #src
            end #src
        end #src
        csv == "" && continue #src
        s = string(s, "### $csv.csv:\n\n") #src
        s = string(s, header) #src
        for item in items #src
            extra_cols = setdiff(keys(item), columns) #src
            if !isempty(extra_cols) #src
                throw(@error "config file fields not included in header" extra_cols) #src
            end #src
            row = [] #src
            for col in columns #src
                val = string(get(item, col, " ")) #src
                if col == "default_value" && val == " " #src
                    val = "*REQUIRED*" #src
                end #src
                push!(row, val) #src
            end #src
            s = string(s, "|" * join(row, "|") * "|\n") #src
        end #src
        s = string(s, "\n") #src
    end #src
    s = replace(s, r"[_$]" => s"\\\g<0>"); #src
    return s #src
end #src
txt = create_md(); #src
fname = joinpath(dirname(dirname(pathof(PowerSystems))), "docs", "src", "modeler_guide", "generated_inputs_tables.md") #src
open(fname, "w") do io #src
      write(io, txt) #src
end #src
nothing #src

# APPEND_MARKDOWN("docs/src/modeler_guide/generated_inputs_tables.md")
