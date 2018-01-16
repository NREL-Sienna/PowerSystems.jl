export dict_to_struct

function dict_to_struct(data)

    # Check for at least one bus in input file
    if (length(data["bus"]) < 1)
        error("There are no busses in this matpower file")
    end

   
    base_kv = data["bus"]["1"]["base_kv"] # Load base kv from first bus
    NBus = system_param(base_kv, data["baseMVA"], 0.0, 1); # check busses have same basevoltage and then fill this

    nodes = Array{ps_types.bus}(0)
    Loads = Array{ps_types.load}(0)
    bus_types = ["PV", "PQ", "SF"] # Index into this using int val in buses

    for (i, i2) in zip([1:length(data["bus"]);], sort!([parse(Int, key) for key in keys(data["bus"])])) # Parse key as int for proper sorting

        d = data["bus"][string(i2)]

        push!(nodes, bus(d["bus_i"], string("node", string(i)), bus_types[d["bus_type"]], d["vm"], d["vmax"], d["vmin"], 0, d["base_kv"]))
        # If there is a load for this bus, only information so far is the installed load. 
        if d["pd"] != 0.0
            push!(Loads, load(string("Load", string(i2)), nodes[i2],
                load_tech("P", d["pd"], d["qd"], d["base_kv"]),
                #hardcoded until we get a better structure for economic data for loads
                load_econ("interruptible", 1000, 999),
                TimeArray(Dates.today(), [1.0])
                ))
        end
    end

    Generators = Array{ps_types.thermal_generation}(0) # Initialize it with 0 elements; pushing onto array initialized with >0 elements leaves nulls at beginning
    # Note: Order is based on sorted order of string keys, which is different than that of ints. I.e., this loop is currently unordered for our purpose
    for (i, k) in zip([1:length(data["gen"]);], keys(data["gen"])) 
        d = data["gen"][k]
        push!(Generators,
            ng_generator(k, nodes[d["gen_bus"]],
                generator_tech(d["pg"], d["qg"], d["pmax"], d["pmin"], d["qmax"], d["qmin"],
                    Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}()),
                # Just the linear and constant coefficients from the dictionary, needs to expansion 
                #for different cost models. 
                generator_econ(d["pmax"], d["cost"][2], d["cost"][3], 1, "Gas"))
                ) 
    end

    Base.convert(::Type{Bool}, x::Int) = x==0 ? false : x==1 ? true : throw(InexactError())

    Branches = Array{ps_types.branch}(0)
    for d in data["branch"]
        push!(Branches, branch(d[2]["index"], convert(Bool, d[2]["br_status"]), d[2]["transformer"]==false ? "line" : "transf",
            (nodes[d[2]["f_bus"]], nodes[d[2]["t_bus"]]),
            d[2]["br_r"], d[2]["br_x"], d[2]["br_b"], d[2]["rate_a"], d[2]["rate_a"],
            nodes[d[2]["f_bus"]].BaseVoltage)) # Get base voltage from from_bus
    end

return nodes, Generators, Loads, Branches

end