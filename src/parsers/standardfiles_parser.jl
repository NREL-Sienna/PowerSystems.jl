"""
Create a System by parsing power-system parameters from a Matpower, PTI, or JSON file and do
some data checks.

# Examples
```julia
sys = parse_standard_files("case_file.m", configpath = "custom_validation.json",
                    bus_name_formatter = x->string(x["name"]*"-"*string(x["index"])),
                    load_name_formatter = x->strip(join(x["source_id"], "_")))
```

"""
function parse_standard_files(file::String; kwargs...)::System

    # function `parse_file` is in pm_io/common.jl
    data = parse_file(file)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        @error "There are no buses in this file"
    end


    # in pm2ps_parser.jl
    sys = pm2ps_dict(data; kwargs...)

    return sys

end
