export ParseStandardFiles

function ParseStandardFiles(file::String)

    data = PowerModels.parse_file(file)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        error("There are no buses in this file")
    end

    return data

end


