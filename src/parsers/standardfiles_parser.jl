# TODO: assert a naming convention -- ??
"""
Read in power-system parameters from a Matpower, PTI, or JSON file and do some
data checks.
"""
function parsestandardfiles(file::String, genmap_file::Union{String,Nothing}=nothing,
                            ts_folder::Union{String,Nothing}=nothing; kwargs...)

    # function `parse_file` is in pm_io/common.jl
    data = parse_file(file)

    # make sure that data is mixed units (in pm_io/data.jl)
    make_mixed_units(data)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        @error "There are no buses in this file"
    end

    # in pm2ps_parser.jl
    data = pm2ps_dict(data, genmap_file)

    if ts_folder!=nothing
        ts_data = read_data_files(ts_folder; kwargs...)
        # assign_ts_data is in forecast_parser.jl
        data = assign_ts_data(data,ts_data)
    end
    
    return data

end

    
# function parsestandardfiles(file::String, ts_folder::String; kwargs...)

#     # TODO: assert a naming convention
#     data = parsestandardfiles(file)

#     ts_data = read_data_files(ts_folder; kwargs...)

#     # assign_ts_data is in forecast_parser.jl
#     data = assign_ts_data(data,ts_data)

#     return data
# end
