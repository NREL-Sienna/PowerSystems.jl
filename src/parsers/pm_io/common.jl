"""
    parse_file(file; import_all)

Parses a Matpower .m `file` or PTI (PSS(R)E-v33) .raw `file` into a
PowerModels data structure. All fields from PTI files will be imported if
`import_all` is true (Default: false).
"""
function parse_file(file::String; import_all=false, validate=true)
    if endswith(file, ".m")
        pm_data =  parse_matpower(file, validate=validate)
    elseif endswith(lowercase(file), ".raw")
        @info("The PSS(R)E parser currently supports buses, loads, shunts, generators, branches, transformers, and dc lines")
        pm_data =  parse_psse(file; import_all=import_all, validate=validate)
    else
        pm_data = parse_json(file, validate=validate)
    end

    # TODO:  not sure if this relevant for all three file types, or only .m, JJS 3/7/19
    move_genfuel_and_gentype!(pm_data)

    return pm_data
end


""
function parse_json(file_string::String; kwargs...)
    open(file_string) do f
        pm_data = parse_json(f, kwargs...)
    end
    return pm_data
end


""
function parse_json(io::IO; validate=true)
    data_string = read(io, String)
    pm_data = JSON2.read(data_string,Dict{Any,Array{Dict}})
    if validate
        check_network_data(pm_data)
    end
    return pm_data
end


"""
Runs various data quality checks on a PowerModels data dictionary.
Applies modifications in some cases.  Reports modified component ids.
"""
function check_network_data(data::Dict{String,Any})
    mod_bus = Dict{Symbol,Set{Int}}()
    mod_gen = Dict{Symbol,Set{Int}}()
    mod_branch = Dict{Symbol,Set{Int}}()
    mod_dcline = Dict{Symbol,Set{Int}}()

    check_conductors(data)
    make_per_unit(data)
    check_connectivity(data)

    mod_branch[:xfer_fix] = check_transformer_parameters(data)
    mod_branch[:vad_bounds] = check_voltage_angle_differences(data)
    mod_branch[:mva_zero] = check_thermal_limits(data)
    mod_branch[:orientation] = check_branch_directions(data)
    check_branch_loops(data)

    mod_dcline[:losses] = check_dcline_limits(data)

    mod_bus[:type] = check_bus_types(data)
    check_voltage_setpoints(data)

    check_storage_parameters(data)

    gen, dcline = check_cost_functions(data)
    mod_gen[:cost_pwl] = gen
    mod_dcline[:cost_pwl] = dcline

    simplify_cost_terms(data)

    return Dict(
        "bus" => mod_bus,
        "gen" => mod_gen,
        "branch" => mod_branch,
        "dcline" => mod_dcline
    )
end


#=
function row_to_typed_dict(row_data, columns)
    @info("call to depreciated function  row_to_typed_dict, use row_to_typed_dict")
    return row_to_typed_dict(row_data, columns)
end

function row_to_dict(row_data, columns)
    @info("call to depreciated function  row_to_dict, use row_to_dict")
    return row_to_dict(row_data, columns)
end
=#



