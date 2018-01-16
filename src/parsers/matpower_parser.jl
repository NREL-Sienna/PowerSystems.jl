export matpower_parser

function matpower_parser(file::String)

    data = PowerModels.parse_file(file)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        error("There are no busses in this matpower file")
    end

    return data

end


