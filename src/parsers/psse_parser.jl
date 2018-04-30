export psse_parser

# Function to read the raw files from psse

function psse_parser(rawfile_name::String)
    current_row = 0
    branch_index = 0
    transf_index = 1
    f = open(rawfile_name);
    lines = readlines(f)
    section = "BUS"
    branches = Dict{Any,Any}()
    gens = Dict{Any,Any}()
    buses = Dict{Any,Any}()
    #transformer varibles
    impedence_code = 0
    winding_code = 0
    admittance_code = 0
    status = 0
    f_bus = 0
    t_bus = 0
    br_b = 0
    br_r = 0
    br_x = 0
    rate_a = 0
    rate_b = 0
    rate_c = 0
    shift = 0
    tap = 0


    name = split(split(rawfile_name, "/")[end],".")[1]
    case = Dict{String,Any}(
        "per_unit" => true,
        "name" => name,
        "dcline" => Dict{String,Any}(),
        "baseMVA" => [],
        # "gencost" => [],
        "multinetwork" => false,
        "version" => "psse raw file",
    )
    case["baseMVA"] = parse(Int,split(split(lines[1], ',')[2],'.')[1])
    for ln in lines
        current_row += 1
        if contains(ln, "END")
            start = split(ln, ",")[end]
            section = split(start)[2]
            continue
        end
        if current_row == 1
            row = split(ln, ",")
        elseif section == "BUS" && current_row > 3
            bus_row = split(ln, ",")
            bus_data = Dict{String,Any}(
                "index" => parse(Int, bus_row[1]),
                "bus_name" => strip(bus_row[2],['\'']),
                "bus_i" => parse(Int, bus_row[1]),
                "bus_type" => parse(Int, bus_row[4]),
                "pd" => 0.0,
                "qd" => 0.0,
                "gs" => 0.0,
                "bs" => 0.0,
                "area" => parse(Int, bus_row[5]),
                "vm" => parse(Float64, bus_row[8]),
                "va" => parse(Float64, bus_row[9]),
                "base_kv" => parse(Float64, bus_row[3]),
                "zone" => parse(Int, bus_row[6]),
                "vmax" => 1.05, #change this later
                "vmin" => .95,
            )
            buses[strip(bus_row[1])] = bus_data

        elseif section == "GENERATOR"
            gen_row = split(ln, ",")
            index_gen = parse(Int, gen_row[1])
            gen_data = Dict{String,Any}(
                "index" => index_gen,
                "gen_bus" => index_gen,
                "pg" => parse(Float64, gen_row[3])/parse(Float64, gen_row[9]),
                "qg" => parse(Float64, gen_row[4])/parse(Float64, gen_row[9]),
                "qmax" => parse(Float64, gen_row[5])/parse(Float64, gen_row[9]),
                "qmin" => parse(Float64, gen_row[6])/parse(Float64, gen_row[9]),
                "vg" => parse(Float64, gen_row[7]),
                "mbase" => parse(Float64, gen_row[9]),
                "gen_status" => parse(Int, gen_row[15]),
                "pmax" => parse(Float64, gen_row[17])/parse(Float64, gen_row[9]),
                "pmin" => parse(Float64, gen_row[18])/parse(Float64, gen_row[9]),
                # "pc1" => 0.0,
                # "pc2" => 0.0,
                # "qc1min" => 0.0,
                # "qc1max" => 0.0,
                # "qc2min" => 0.0,
                # "qc2max" => 0.0,
                # "ramp_agc" => 0.0,
                # "ramp_10" => 0.0,
                # "ramp_30" => 0.0,
                # "ramp_q" => 0.0,
                "apf" => parse(Float64, gen_row[end]),
            )
            gens[strip(gen_row[1])] = gen_data

        elseif section == "LOAD"
            load_row = split(strip(ln, [' ']), ",")
            buses[load_row[1]]["pd"] = parse(Float64, load_row[6])/case["baseMVA"]
            buses[load_row[1]]["qd"] = parse(Float64, load_row[7])/case["baseMVA"]

        elseif section == "BRANCH"
            branch_row = split(ln, ",")
            branch_data = Dict{String,Any}(
                "index" => branch_index,
                "f_bus" => parse(Int, branch_row[1]),
                "t_bus" => parse(Int, branch_row[2]),
                "br_r" => parse(Float64, branch_row[4]),
                "br_x" => parse(Float64, branch_row[5]),
                "br_b" => parse(Float64, branch_row[6]),
                "rate_a" => parse(Float64, branch_row[7]),
                "rate_b" => parse(Float64, branch_row[8]),
                "rate_c" => parse(Float64, branch_row[9]),
                "tap" => 1.0,
                "shift" => 0.0,
                "br_status" => parse(Int, branch_row[14]),
                "angmin" => 0.0,
                "angmax" => 0.0,
                "transformer" => false,
            )
            branches[strip(string(branch_index))] = branch_data
            branch_index = branch_index + 1
        elseif section == "TRANSFORMER"
            transf_row = split(strip(ln, [' ']), ",")
            # impedence_code = 0
            if transf_index == 1
                # println("transf_index ok")
                # First line of a single 2-winding transformer's data
                # Find codes
                winding_code = parse(Int, transf_row[5])
                impedence_code = parse(Int, transf_row[6])
                admittance_code = parse(Int, transf_row[7])
                status = parse(Int, transf_row[12])
                # Find to and from buses
                f_bus = parse(Int, transf_row[1])
                t_bus = parse(Int, transf_row[2])
                # Handle codes
                if status!= 0 && status != 1
                    error("status code must be 1 or 0")
                end

                if admittance_code == 1
                    br_b = parse(Float64, transf_row[8]) # we are reading MAG1 as charging suspectence
                else
                    error("admittance code must be 1")
                end
                transf_index = 2
            elseif transf_index == 2
                # Second line of a single 2-winding transformer's data
                # Handle codes
                if impedence_code == 1
                    br_r = parse(Float64, transf_row[1])
                    br_x = parse(Float64, transf_row[2])
                else
                    error("impedence code must be 1")
                end
                transf_index = 3
            elseif transf_index == 3
                # Third line of a single 2-winding transformer's data
                # Find 3 three-phase ratings and Winding 1 phase shift
                rate_a = parse(Float64, transf_row[4])
                rate_b = parse(Float64, transf_row[5])
                rate_c = parse(Float64, transf_row[6])
                shift = parse(Float64, transf_row[3])
                # Handle codes
                if winding_code == 1
                    tap = parse(Float64, transf_row[1])
                else
                    error("winding code must be 1")
                end
                transf_index = 4
            else
                # Last line of a single 2-winding transformer's data
                transf_data = Dict{String,Any}(
                    "index" => branch_index,
                    "f_bus" => f_bus,
                    "t_bus" => t_bus,
                    "br_r" => br_r,
                    "br_x" => br_x,
                    "br_b" => br_b,
                    "rate_a" => rate_a,
                    "rate_b" => rate_b,
                    "rate_c" => rate_c,
                    "tap" => tap,
                    "shift" => shift,
                    "br_status" => status,
                    "angmin" => 0.0,
                    "angmax" => 0.0,
                    "transformer" => true,
                )
                branches[strip(string(branch_index))] = transf_data
                branch_index = branch_index + 1
                transf_index = 1
            end


        elseif section == "FIXED"
            shunt_row = split(strip(ln, [' ']), ",")
            buses[shunt_row[1]]["gs"] = (parse(Float64, shunt_row[3])*parse(Float64, shunt_row[4]))/case["baseMVA"]
            buses[shunt_row[1]]["bs"] = (parse(Float64, shunt_row[3])*parse(Float64, shunt_row[5]))/case["baseMVA"]
        end

    end
    case["branch"] = branches
    case["gen"] = gens
    case["bus"] = buses
    close(f)
    #write_dict(case, "IEEE_output.txt")
    PowerModels.check_network_data(case)
    return case
    #return case
end

