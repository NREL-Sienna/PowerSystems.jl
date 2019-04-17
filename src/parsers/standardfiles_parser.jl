# TODO: assert a naming convention -- ??
"""
Read in power-system parameters from a Matpower, PTI, or JSON file and do some
data checks.
"""
function parsestandardfiles(file::String; kwargs...)

    # function `parse_file` is in pm_io/common.jl
    data = parse_file(file)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        @error "There are no buses in this file"
    end

    # in pm2ps_parser.jl
    data = pm2ps_dict(data; kwargs...)

    return data

end

    
function parsestandardfiles(file::String, ts_folder::String; kwargs...)

    # TODO: assert a naming convention
    data = parsestandardfiles(file)
    sys = System(data)
    
    ts_data = read_data_files(ts_folder; kwargs...)

    forecast = make_forecast_array(sys,ts_data)
    add_forecast!(sys,:default=>forecast)

    return data
end
