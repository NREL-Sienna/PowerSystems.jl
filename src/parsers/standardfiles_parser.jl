function parsestandardfiles(file::String)

    data = parse_file(file)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        @error "There are no buses in this file"
    end

    data = pm2ps_dict(data)

    return data

end

function parsestandardfiles(file::String, ts_folder::String; kwargs...)

    # TODO: assert a naming convention
    data = parsestandardfiles(file)

    ts_data = read_data_files(ts_folder; kwargs...)

    data = assign_ts_data(data,ts_data)

    return data
end


function parse_file(file::String)

    data = parse_file(file)

    return data

end
