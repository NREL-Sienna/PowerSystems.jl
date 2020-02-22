"""
Create a System by parsing power-system parameters from a Matpower, PTI, or JSON file and do
some data checks.

# Examples
```julia
sys = parse_standard_files(
    "case_file.m",
    configpath = "custom_validation.json",
    bus_name_formatter = x->string(x["name"]*"-"*string(x["index"])),
    load_name_formatter = x->strip(join(x["source_id"], "_"))
) -> System
```

"""
function parse_standard_files(file::String; kwargs...)
    data = PowerModelsData(file)
    return System(data; kwargs...)
end
