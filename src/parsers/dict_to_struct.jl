export dict_to_struct

# Global method definition needs to be at top level in .7
# Convert bool to int
Base.convert(::Type{Bool}, x::Int) = x==0 ? false : x==1 ? true : throw(InexactError())

function dict_to_struct(data)

    if data["version"] == "psse raw file"

        # Check for at least one bus in input file
        if (length(data["bus"]) < 1)
            error("There are no busses in this psse file")
        end

        base_kv = data["bus"][collect(keys(data["bus"]))[1]]["base_kv"] # Load base kv from first bus
        NBus = SystemParam(length(data["bus"]), base_kv, data["baseMVA"], 1); 

        nodes = Array{Bus}(0)
        Loads = Array{ElectricLoad}(0) # Using least constrained Load
        bus_types = ["PV", "PQ", "SF"] # Index into this using int val in buses

        for (i, i2) in zip([1:length(data["bus"]);], sort!([parse(Int, key) for key in keys(data["bus"])])) # Parse key as int for proper sorting

            d = data["bus"][string(i2)]

            push!(nodes, Bus(d["bus_i"], string("node", string(i)), bus_types[d["bus_type"]], 0, d["vm"], (d["vmin"], d["vmax"]), d["base_kv"])) # NOTE: angle 0, tuple(min, max)
            # If there is a load for this bus, only information so far is the installed load.
            if d["pd"] != 0.0
                push!(Loads, StaticLoad(string("Load", string(i2)), nodes[i2], "P", d["pd"], d["qd"],
                    # hardcoded until we get a better structure for economic data for loads
                    # load_econ("interruptible", 1000, 999),
                    TimeSeries.TimeArray(Dates.today(), [1.0])
                    ))
            end
        end

        Generators = Array{ThermalGen}(0) # Initialize it with 0 elements; pushing onto array initialized with >0 elements leaves nulls at beginning
        # Note: Order is based on sorted order of string keys, which is different than that of ints. I.e., this loop is currently unordered for our purpose
        for (i, k) in zip([1:length(data["gen"]);], keys(data["gen"]))
            d = data["gen"][k]
            push!(Generators,
                ThermalGen(k, d["gen_status"], nodes[d["gen_bus"]],
                    TechGen(d["pg"], (d["pmin"], d["pmax"]), d["qg"], (d["qmin"], d["qmax"]),
                        nothing, nothing),
                    # Just the linear and constant coefficients from the dictionary; needs expansion
                    # for different cost models.
                    nothing # No econ data in psse file
                    ))

        end

        Branches = Array{Branch}(0)
        for d in data["branch"]
            # Check if transformer2w, else line
            if d[2]["transformer"]
                push!(Branches, Transformer2W(d[1], convert(Bool, d[2]["br_status"]),
                    (nodes[d[2]["f_bus"]], nodes[d[2]["t_bus"]]),
                    d[2]["br_r"], d[2]["br_x"], d[2]["br_b"],
                    d[2]["tap"], d[2]["angmax"], d[2]["rate_a"])
                    )
            else
                push!(Branches, Line(d[1], convert(Bool, d[2]["br_status"]),
                    (nodes[d[2]["f_bus"]], nodes[d[2]["t_bus"]]),
                    d[2]["br_r"], d[2]["br_x"], d[2]["br_b"],
                    d[2]["rate_a"], (d[2]["angmin"], d[2]["angmax"]))
                    )
            end
        end

    elseif data["version"] == "2" # matpower

        # Check for at least one bus in input file
        if (length(data["bus"]) < 1)
            error("There are no busses in this matpower file")
        end

        base_kv = data["bus"][collect(keys(data["bus"]))[1]]["base_kv"] # Load base kv from first bus
        NBus = SystemParam(length(data["bus"]), base_kv, data["baseMVA"], 1); # TODO: Check busses have same base voltage

        nodes = Array{Bus}(0)
        Loads = Array{ElectricLoad}(0) # Using least constrained Load
        bus_types = ["PV", "PQ", "SF"] # Index into this using int val in buses
        bus_nums = Dict{String, String}() # Map potentially nonsequential bus keys to sequential ones for storing in array
        for (i, i2) in zip([1:length(data["bus"]);], sort!([parse(Int, key) for key in keys(data["bus"])])) # Parse key as int for proper sorting
            # i is sequential index starting at 1
            # i2 is bus key
            bus_nums[string(i2)] = string(i)
            d = data["bus"][string(i2)] # current bus
            # data["bus"][string(i)] = data["bus"][string(i2)]
            # delete!(data["bus"], string(i2)) # modify dict in place. ok?

            push!(nodes, Bus(d["bus_i"], string("node", string(i)), bus_types[d["bus_type"]], 0, d["vm"], @NT(min=d["vmin"], max=d["vmax"]), d["base_kv"])) # NOTE: angle 0, tuple(min, max)
            # If there is a load for this bus, only information so far is the installed load.
            if d["pd"] != 0.0
                # NOTE: access nodes using index i in case numbering of original data not sequential/consistent
                push!(Loads, StaticLoad(string("Load", string(i)), true, nodes[i], "P", d["pd"], d["qd"],
                    # hardcoded until we get a better structure for economic data for loads
                    # load_econ("interruptible", 1000, 999),
                    TimeSeries.TimeArray(Dates.today(), [1.0])
                    ))
            end
        end

        Generators = Array{ThermalGen}(0) # Initialize it with 0 elements; pushing onto array initialized with >0 elements leaves nulls at beginning
        # Note: Order is based on sorted order of string keys, which is different than that of ints. I.e., this loop is currently unordered for our purpose
        for (i, k) in zip([1:length(data["gen"]);], keys(data["gen"]))
            d = data["gen"][k]
            push!(Generators,
                ThermalGen(k, d["gen_status"], nodes[parse(Int64, bus_nums[string(d["gen_bus"])])], # TODO: fix this access index
                    TechGen(d["pg"], @NT(min=d["pmin"], max=d["pmax"]), d["qg"], @NT(min=d["qmin"], max=d["qmax"]),
                        nothing, nothing),
                    # Just the linear and constant coefficients from the dictionary; needs expansion
                    # for different cost models.
                    EconGen(d["pmax"], nothing, d["cost"][1], d["cost"][2], d["cost"][3], nothing))
                    )

        end

        Branches = Array{Branch}(0)
        for d in data["branch"]
            # Check if transformer2w, else line
            if d[2]["transformer"]
                push!(Branches, Transformer2W(d[1], convert(Bool, d[2]["br_status"]),
                    (nodes[parse(Int64, bus_nums[string(d[2]["f_bus"])])], nodes[parse(Int64, bus_nums[string(d[2]["t_bus"])])]),
                    d[2]["br_r"], d[2]["br_x"], d[2]["br_b"],
                    d[2]["tap"], d[2]["angmax"], d[2]["rate_a"])
                    )
            else
                push!(Branches, Line(d[1], convert(Bool, d[2]["br_status"]),
                    (nodes[parse(Int64, bus_nums[string(d[2]["f_bus"])])], nodes[parse(Int64, bus_nums[string(d[2]["t_bus"])])]),
                    d[2]["br_r"], d[2]["br_x"], d[2]["br_b"],
                    d[2]["rate_a"], (d[2]["angmin"], d[2]["angmax"]))
                    )
            end
        end

    else
        warn("The dictionary has no data model descriptor; the parser is not guaranteed to work")

        # Check for at least one bus in input file
        if (length(data["bus"]) < 1)
            error("There are no busses in the data")
        end

        base_kv = data["bus"][collect(keys(data["bus"]))[1]]["base_kv"] # Load base kv from first bus
        NBus = SystemParam(length(data["bus"]), base_kv, data["baseMVA"], 1); # TODO: Check busses have same base voltage

        nodes = Array{Bus}(0)
        Loads = Array{ElectricLoad}(0) # Using least constrained Load
        bus_types = ["PV", "PQ", "SF"] # Index into this using int val in buses

        for (i, i2) in zip([1:length(data["bus"]);], sort!([parse(Int, key) for key in keys(data["bus"])])) # Parse key as int for proper sorting

            d = data["bus"][string(i2)]

            push!(nodes, Bus(d["bus_i"], string("node", string(i)), bus_types[d["bus_type"]], 0, d["vm"], @NT(min=d["vmin"], max=d["vmax"]), d["base_kv"])) # NOTE: angle 0, tuple(min, max)
            # If there is a load for this bus, only information so far is the installed load.
            if d["pd"] != 0.0
                push!(Loads, StaticLoad(string("Load", string(i2)), nodes[i2], "P", d["pd"], d["qd"],
                    # hardcoded until we get a better structure for economic data for loads
                    # load_econ("interruptible", 1000, 999),
                    TimeSeries.TimeArray(Dates.today(), [1.0])
                    ))
            end
        end

        Generators = Array{ThermalGen}(0) # Initialize it with 0 elements; pushing onto array initialized with >0 elements leaves nulls at beginning
        # Note: Order is based on sorted order of string keys, which is different than that of ints. I.e., this loop is currently unordered for our purpose
        for (i, k) in zip([1:length(data["gen"]);], keys(data["gen"]))
            d = data["gen"][k]
            push!(Generators,
                ThermalGen(k, d["gen_status"], nodes[d["gen_bus"]],
                    TechGen(d["pg"], (d["pmin"], d["pmax"]), d["qg"], (d["qmin"], d["qmax"]),
                        nothing, nothing),
                    # Just the linear and constant coefficients from the dictionary; needs expansion
                    # for different cost models.
                    EconGen(d["pmax"], nothing, d["cost"][1], d["cost"][2], d["cost"][3], nothing))
                    )

        end

        Branches = Array{Branch}(0)
        for d in data["branch"]
            # Check if transformer2w, else line
            if d[2]["transformer"]
                push!(Branches, Transformer2W(d[1], convert(Bool, d[2]["br_status"]),
                    (nodes[d[2]["f_bus"]], nodes[d[2]["t_bus"]]),
                    d[2]["br_r"], d[2]["br_x"], d[2]["br_b"],
                    d[2]["tap"], d[2]["angmax"], d[2]["rate_a"])
                    )
            else
                push!(Branches, Line(d[1], convert(Bool, d[2]["br_status"]),
                    (nodes[d[2]["f_bus"]], nodes[d[2]["t_bus"]]),
                    d[2]["br_r"], d[2]["br_x"], d[2]["br_b"],
                    d[2]["rate_a"], (d[2]["angmin"], d[2]["angmax"]))
                    )
            end
        end


    end

return nodes, Generators, Loads, Branches

end
