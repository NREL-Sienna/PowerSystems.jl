#########################################################################
#                                                                       #
# This file provides functions for interfacing with Matpower data files #
#                                                                       #
#########################################################################

const MP_FIX_VOLTAGE_BUSES = [2, 3]

"Parses the matpwer data from either a filename or an IO object"
function parse_matpower(io::IO; validate = true)::Dict
    mp_data = _parse_matpower_string(read(io, String))
    pm_data = _matpower_to_powermodels!(mp_data)
    if validate
        correct_network_data!(pm_data)
    end
    return pm_data
end

function parse_matpower(file::String; kwargs...)::Dict
    mp_data = open(file) do io
        parse_matpower(io; kwargs...)
    end
    return mp_data
end

### Data and functions specific to Matpower format ###

const _mp_data_names = [
    "mpc.version",
    "mpc.baseMVA",
    "mpc.bus",
    "mpc.gen",
    "mpc.branch",
    "mpc.dcline",
    "mpc.gencost",
    "mpc.dclinecost",
    "mpc.bus_name",
    "mpc.storage",
    "mpc.switch",
]

const _mp_bus_columns = [
    ("bus_i", Int),
    ("bus_type", Int),
    ("pd", Float64),
    ("qd", Float64),
    ("gs", Float64),
    ("bs", Float64),
    ("area", Int),
    ("vm", Float64),
    ("va", Float64),
    ("base_kv", Float64),
    ("zone", Int),
    ("vmax", Float64),
    ("vmin", Float64),
    ("lam_p", Float64),
    ("lam_q", Float64),
    ("mu_vmax", Float64),
    ("mu_vmin", Float64),
]

const _mp_bus_name_columns = [("name", Union{String, SubString{String}})]

const _mp_gen_columns = [
    ("gen_bus", Int),
    ("pg", Float64),
    ("qg", Float64),
    ("qmax", Float64),
    ("qmin", Float64),
    ("vg", Float64),
    ("mbase", Float64),
    ("gen_status", Int),
    ("pmax", Float64),
    ("pmin", Float64),
    ("pc1", Float64),
    ("pc2", Float64),
    ("qc1min", Float64),
    ("qc1max", Float64),
    ("qc2min", Float64),
    ("qc2max", Float64),
    ("ramp_agc", Float64),
    ("ramp_10", Float64),
    ("ramp_30", Float64),
    ("ramp_q", Float64),
    ("apf", Float64),
    ("mu_pmax", Float64),
    ("mu_pmin", Float64),
    ("mu_qmax", Float64),
    ("mu_qmin", Float64),
]

const _mp_branch_columns = [
    ("f_bus", Int),
    ("t_bus", Int),
    ("br_r", Float64),
    ("br_x", Float64),
    ("br_b", Float64),
    ("rate_a", Float64),
    ("rate_b", Float64),
    ("rate_c", Float64),
    ("tap", Float64),
    ("shift", Float64),
    ("br_status", Int),
    ("angmin", Float64),
    ("angmax", Float64),
    ("pf", Float64),
    ("qf", Float64),
    ("pt", Float64),
    ("qt", Float64),
    ("mu_sf", Float64),
    ("mu_st", Float64),
    ("mu_angmin", Float64),
    ("mu_angmax", Float64),
]

const _mp_dcline_columns = [
    ("f_bus", Int),
    ("t_bus", Int),
    ("br_status", Int),
    ("pf", Float64),
    ("pt", Float64),
    ("qf", Float64),
    ("qt", Float64),
    ("vf", Float64),
    ("vt", Float64),
    ("pmin", Float64),
    ("pmax", Float64),
    ("qminf", Float64),
    ("qmaxf", Float64),
    ("qmint", Float64),
    ("qmaxt", Float64),
    ("loss0", Float64),
    ("loss1", Float64),
    ("mu_pmin", Float64),
    ("mu_pmax", Float64),
    ("mu_qminf", Float64),
    ("mu_qmaxf", Float64),
    ("mu_qmint", Float64),
    ("mu_qmaxt", Float64),
]

const _mp_storage_columns = [
    ("storage_bus", Int),
    ("ps", Float64),
    ("qs", Float64),
    ("energy", Float64),
    ("energy_rating", Float64),
    ("charge_rating", Float64),
    ("discharge_rating", Float64),
    ("charge_efficiency", Float64),
    ("discharge_efficiency", Float64),
    ("thermal_rating", Float64),
    ("qmin", Float64),
    ("qmax", Float64),
    ("r", Float64),
    ("x", Float64),
    ("p_loss", Float64),
    ("q_loss", Float64),
    ("status", Int),
]

const _mp_switch_columns = [
    ("f_bus", Int),
    ("t_bus", Int),
    ("psw", Float64),
    ("qsw", Float64),
    ("state", Int),
    ("thermal_rating", Float64),
    ("status", Int),
]

""
function _parse_matpower_string(data_string::String)
    matlab_data, func_name, colnames = parse_matlab_string(data_string; extended = true)

    case = Dict{String, Any}()

    if func_name !== nothing
        case["name"] = func_name
    else
        @info(
            string(
                "no case name found in matpower file.  The file seems to be missing \"function mpc = ...\"",
            )
        )
        case["name"] = "no_name_found"
    end

    case["source_type"] = "matpower"
    if haskey(matlab_data, "mpc.version")
        case["source_version"] = matlab_data["mpc.version"]
    else
        @info(
            string(
                "no case version found in matpower file.  The file seems to be missing \"mpc.version = ...\"",
            )
        )
        case["source_version"] = "0.0.0+"
    end

    if haskey(matlab_data, "mpc.baseMVA")
        case["baseMVA"] = Float64(matlab_data["mpc.baseMVA"])
    else
        @info(
            string(
                "no baseMVA found in matpower file.  The file seems to be missing \"mpc.baseMVA = ...\"",
            )
        )
        case["baseMVA"] = 1.0
    end

    if haskey(matlab_data, "mpc.bus")
        buses = []
        pv_bus_lookup = Dict{Int, Any}()
        for bus_row in matlab_data["mpc.bus"]
            bus_data = row_to_typed_dict(bus_row, _mp_bus_columns)
            bus_data["index"] = check_type(Int, bus_row[1])
            bus_data["source_id"] = ["bus", bus_data["index"]]
            bus_data["is_conforming"] = true
            push!(buses, bus_data)
            if bus_data["bus_type"] ∈ MP_FIX_VOLTAGE_BUSES
                pv_bus_lookup[bus_data["index"]] = bus_data
            end
        end
        case["bus"] = buses
    else
        error(
            string(
                "no bus table found in matpower file.  The file seems to be missing \"mpc.bus = [...];\"",
            ),
        )
    end

    if haskey(matlab_data, "mpc.gen")
        gens = []
        corrected_pv_bus_vm = Dict{Int, Float64}()
        for (i, gen_row) in enumerate(matlab_data["mpc.gen"])
            gen_data = row_to_typed_dict(gen_row, _mp_gen_columns)
            bus_data = get(pv_bus_lookup, gen_data["gen_bus"], nothing)
            if bus_data !== nothing
                if bus_data["bus_type"] ∈ MP_FIX_VOLTAGE_BUSES &&
                   bus_data["vm"] != gen_data["vg"]
                    @info "Correcting vm in bus $(gen_data["gen_bus"]) to $(gen_data["vg"]) to match generator set-point"
                    if gen_data["gen_bus"] ∈ keys(corrected_pv_bus_vm)
                        if corrected_pv_bus_vm[gen_data["gen_bus"]] != gen_data["vg"]
                            @error(
                                "Generator voltage set-points for bus $(gen_data["gen_bus"]) are inconsistent. This can lead to unexpected results"
                            )
                        end
                    else
                        bus_data["vm"] = gen_data["vg"]
                        corrected_pv_bus_vm[gen_data["gen_bus"]] = gen_data["vg"]
                    end
                end
            end
            gen_data["index"] = i
            gen_data["source_id"] = ["gen", i]
            push!(gens, gen_data)
        end
        case["gen"] = gens
    else
        error(
            string(
                "no gen table found in matpower file.  The file seems to be missing \"mpc.gen = [...];\"",
            ),
        )
    end

    if haskey(matlab_data, "mpc.branch")
        branches = []
        for (i, branch_row) in enumerate(matlab_data["mpc.branch"])
            branch_data = row_to_typed_dict(branch_row, _mp_branch_columns)
            branch_data["index"] = i
            branch_data["source_id"] = ["branch", i]
            push!(branches, branch_data)
        end
        case["branch"] = branches
    else
        error(
            string(
                "no branch table found in matpower file.  The file seems to be missing \"mpc.branch = [...];\"",
            ),
        )
    end

    if haskey(matlab_data, "mpc.dcline")
        dclines = []
        for (i, dcline_row) in enumerate(matlab_data["mpc.dcline"])
            dcline_data = row_to_typed_dict(dcline_row, _mp_dcline_columns)
            dcline_data["index"] = i
            dcline_data["source_id"] = ["dcline", i]
            push!(dclines, dcline_data)
        end
        case["dcline"] = dclines
    end

    if haskey(matlab_data, "mpc.storage")
        storage = []
        for (i, storage_row) in enumerate(matlab_data["mpc.storage"])
            storage_data = row_to_typed_dict(storage_row, _mp_storage_columns)
            storage_data["index"] = i
            storage_data["source_id"] = ["storage", i]
            push!(storage, storage_data)
        end
        case["storage"] = storage
    end

    if haskey(matlab_data, "mpc.switch")
        switch = []
        for (i, switch_row) in enumerate(matlab_data["mpc.switch"])
            switch_data = row_to_typed_dict(switch_row, _mp_switch_columns)
            switch_data["index"] = i
            switch_data["source_id"] = ["switch", i]
            push!(switch, switch_data)
        end
        case["switch"] = switch
    end

    if haskey(matlab_data, "mpc.bus_name")
        bus_names = []
        for (i, bus_name_row) in enumerate(matlab_data["mpc.bus_name"])
            bus_name_data = row_to_typed_dict(bus_name_row, _mp_bus_name_columns)
            bus_name_data["index"] = i
            bus_name_data["source_id"] = ["bus_name", i]
            push!(bus_names, bus_name_data)
        end
        case["bus_name"] = bus_names

        if length(case["bus_name"]) != length(case["bus"])
            error(
                "incorrect Matpower file, the number of bus names ($(length(case["bus_name"]))) is inconsistent with the number of buses ($(length(case["bus"]))).\n",
            )
        end
    end

    if haskey(matlab_data, "mpc.gencost")
        gencost = []
        for (i, gencost_row) in enumerate(matlab_data["mpc.gencost"])
            gencost_data = _mp_cost_data(gencost_row)
            gencost_data["index"] = i
            gencost_data["source_id"] = ["gencost", i]
            push!(gencost, gencost_data)
        end
        case["gencost"] = gencost

        if length(case["gencost"]) != length(case["gen"]) &&
           length(case["gencost"]) != 2 * length(case["gen"])
            error(
                "incorrect Matpower file, the number of generator cost functions ($(length(case["gencost"]))) is inconsistent with the number of generators ($(length(case["gen"]))).\n",
            )
        end
    end

    if haskey(matlab_data, "mpc.dclinecost")
        dclinecosts = []
        for (i, dclinecost_row) in enumerate(matlab_data["mpc.dclinecost"])
            dclinecost_data = _mp_cost_data(dclinecost_row)
            dclinecost_data["index"] = i
            dclinecost_data["source_id"] = ["dclinecost", i]
            push!(dclinecosts, dclinecost_data)
        end
        case["dclinecost"] = dclinecosts

        if length(case["dclinecost"]) != length(case["dcline"])
            error(
                "incorrect Matpower file, the number of dcline cost functions ($(length(case["dclinecost"]))) is inconsistent with the number of dclines ($(length(case["dcline"]))).\n",
            )
        end
    end

    for k in keys(matlab_data)
        if !in(k, _mp_data_names) && startswith(k, "mpc.")
            case_name = k[5:length(k)]
            value = matlab_data[k]
            if isa(value, Array)
                column_names = []
                if haskey(colnames, k)
                    column_names = colnames[k]
                end
                tbl = []
                for (i, row) in enumerate(matlab_data[k])
                    row_data = row_to_dict(row, column_names)
                    row_data["index"] = i
                    row_data["source_id"] = [case_name, i]
                    push!(tbl, row_data)
                end
                case[case_name] = tbl
                @info(
                    "extending matpower format with data: $(case_name) $(length(tbl))x$(length(tbl[1])-1)"
                )
            else
                case[case_name] = value
                @info("extending matpower format with constant data: $(case_name)")
            end
        end
    end

    return case
end

""
function _mp_cost_data(cost_row)
    ncost = check_type(Int, cost_row[4])
    model = check_type(Int, cost_row[1])
    if model == 1
        nr_parameters = ncost * 2
    elseif model == 2
        nr_parameters = ncost
    end

    cost_data = Dict(
        "model" => model,
        "startup" => check_type(Float64, cost_row[2]),
        "shutdown" => check_type(Float64, cost_row[3]),
        "ncost" => ncost,
        "cost" => [check_type(Float64, x) for x in cost_row[5:(5 + nr_parameters - 1)]],
    )

    #=
    # skip this literal interpretation, as its hard to invert
    cost_values = [check_type(Float64, x) for x in cost_row[5:length(cost_row)]]
    if cost_data["model"] == 1:
        if length(cost_values)%2 != 0
            error("incorrect matpower file, odd number of pwl cost function values")
        end
        for i in 0:(length(cost_values)/2-1)
            p_idx = 1+2*i
            f_idx = 2+2*i
            cost_data["p_$(i)"] = cost_values[p_idx]
            cost_data["f_$(i)"] = cost_values[f_idx]
        end
    else:
        for (i,v) in enumerate(cost_values)
            cost_data["c_$(length(cost_values)+1-i)"] = v
        end
    =#
    return cost_data
end

### Data and functions specific to PowerModels format ###

"""
Converts a Matpower dict into a PowerModels dict
"""
function _matpower_to_powermodels!(mp_data::Dict{String, <:Any})
    pm_data = mp_data

    # required default values
    if !haskey(pm_data, "dcline")
        pm_data["dcline"] = []
    end
    if !haskey(pm_data, "gencost")
        pm_data["gencost"] = []
    end
    if !haskey(pm_data, "dclinecost")
        pm_data["dclinecost"] = []
    end
    if !haskey(pm_data, "storage")
        pm_data["storage"] = []
    end
    if !haskey(pm_data, "switch")
        pm_data["switch"] = []
    end

    # translate component models
    _mp2pm_branch!(pm_data)
    _mp2pm_dcline!(pm_data)

    # translate cost models
    _add_dcline_costs!(pm_data)

    # merge data tables
    _merge_bus_name_data!(pm_data)
    _merge_cost_data!(pm_data)
    _merge_generic_data!(pm_data)

    # split loads and shunts from buses
    _split_loads_shunts!(pm_data)

    # use once available
    arrays_to_dicts!(pm_data)

    for optional in ["dcline", "load", "shunt", "storage", "switch"]
        if length(pm_data[optional]) == 0
            pm_data[optional] = Dict{String, Any}()
        end
    end

    return pm_data
end

"""
    _split_loads_shunts!(data)

Seperates Loads and Shunts in `data` under separate "load" and "shunt" keys in the
PowerModels data format. Includes references to originating bus via "load_bus"
and "shunt_bus" keys, respectively.
"""
function _split_loads_shunts!(data::Dict{String, Any})
    data["load"] = []
    data["shunt"] = []

    load_num = 1
    shunt_num = 1
    for (i, bus) in enumerate(data["bus"])
        if bus["pd"] != 0.0 || bus["qd"] != 0.0
            append!(
                data["load"],
                [
                    Dict{String, Any}(
                        "pd" => bus["pd"],
                        "qd" => bus["qd"],
                        "is_conforming" => true,
                        "load_bus" => bus["bus_i"],
                        "status" => convert(Int8, bus["bus_type"] != 4),
                        "index" => load_num,
                        "source_id" => ["bus", bus["bus_i"]],
                    ),
                ],
            )
            load_num += 1
        end

        if bus["gs"] != 0.0 || bus["bs"] != 0.0
            append!(
                data["shunt"],
                [
                    Dict{String, Any}(
                        "gs" => bus["gs"],
                        "bs" => bus["bs"],
                        "shunt_bus" => bus["bus_i"],
                        "status" => convert(Int8, bus["bus_type"] != 4),
                        "index" => shunt_num,
                        "source_id" => ["bus", bus["bus_i"]],
                    ),
                ],
            )
            shunt_num += 1
        end

        for key in ["pd", "qd", "gs", "bs"]
            delete!(bus, key)
        end
    end
end

"sets all branch transformer taps to 1.0, to simplify branch models"
function _mp2pm_branch!(data::Dict{String, Any})
    branches = [branch for branch in data["branch"]]
    if haskey(data, "ne_branch")
        append!(branches, data["ne_branch"])
    end
    for branch in branches
        if branch["tap"] == 0.0
            branch["transformer"] = false
            branch["tap"] = 1.0
        else
            branch["transformer"] = true
        end

        branch["g_fr"] = 0.0
        branch["g_to"] = 0.0

        branch["b_fr"] = branch["br_b"] / 2.0
        branch["b_to"] = branch["br_b"] / 2.0

        delete!(branch, "br_b")

        if branch["rate_a"] == 0.0
            delete!(branch, "rate_a")
        end
        if branch["rate_b"] == 0.0
            delete!(branch, "rate_b")
        end
        if branch["rate_c"] == 0.0
            delete!(branch, "rate_c")
        end
    end
end

"adds pmin and pmax values at to and from buses"
function _mp2pm_dcline!(data::Dict{String, Any})
    for dcline in data["dcline"]
        pmin = dcline["pmin"]
        pmax = dcline["pmax"]
        loss0 = dcline["loss0"]
        loss1 = dcline["loss1"]

        delete!(dcline, "pmin")
        delete!(dcline, "pmax")

        if pmin >= 0 && pmax >= 0
            pminf = pmin
            pmaxf = pmax
            pmint = loss0 - pmaxf * (1 - loss1)
            pmaxt = loss0 - pminf * (1 - loss1)
        end
        if pmin >= 0 && pmax < 0
            pminf = pmin
            pmint = pmax
            pmaxf = (-pmint + loss0) / (1 - loss1)
            pmaxt = loss0 - pminf * (1 - loss1)
        end
        if pmin < 0 && pmax >= 0
            pmaxt = -pmin
            pmaxf = pmax
            pminf = (-pmaxt + loss0) / (1 - loss1)
            pmint = loss0 - pmaxf * (1 - loss1)
        end
        if pmin < 0 && pmax < 0
            pmaxt = -pmin
            pmint = pmax
            pmaxf = (-pmint + loss0) / (1 - loss1)
            pminf = (-pmaxt + loss0) / (1 - loss1)
        end

        dcline["pmaxt"] = pmaxt
        dcline["pmint"] = pmint
        dcline["pmaxf"] = pmaxf
        dcline["pminf"] = pminf

        # preserve the old pmin and pmax values
        dcline["mp_pmin"] = pmin
        dcline["mp_pmax"] = pmax

        dcline["pt"] = -dcline["pt"] # matpower has opposite convention
        dcline["qf"] = -dcline["qf"] # matpower has opposite convention
        dcline["qt"] = -dcline["qt"] # matpower has opposite convention
    end
end

"adds dcline costs, if gen costs exist"
function _add_dcline_costs!(data::Dict{String, Any})
    if length(data["gencost"]) > 0 &&
       length(data["dclinecost"]) <= 0 &&
       length(data["dcline"]) > 0
        @info("added zero cost function data for dclines")
        model = data["gencost"][1]["model"]
        if model == 1
            for (i, dcline) in enumerate(data["dcline"])
                dclinecost = Dict(
                    "index" => i,
                    "model" => 1,
                    "startup" => 0.0,
                    "shutdown" => 0.0,
                    "ncost" => 2,
                    "cost" => [dcline["pminf"], 0.0, dcline["pmaxf"], 0.0],
                )
                push!(data["dclinecost"], dclinecost)
            end
        else
            for (i, dcline) in enumerate(data["dcline"])
                dclinecost = Dict(
                    "index" => i,
                    "model" => 2,
                    "startup" => 0.0,
                    "shutdown" => 0.0,
                    "ncost" => 3,
                    "cost" => [0.0, 0.0, 0.0],
                )
                push!(data["dclinecost"], dclinecost)
            end
        end
    end
end

"merges generator cost functions into generator data, if costs exist"
function _merge_cost_data!(data::Dict{String, Any})
    if haskey(data, "gencost")
        gen = data["gen"]
        gencost = data["gencost"]

        if length(gen) != length(gencost)
            if length(gencost) > length(gen)
                @warn(
                    "The last $(length(gencost) - length(gen)) generator cost records will be ignored due to too few generator records.",
                )
                gencost = gencost[1:length(gen)]
            else
                @warn(
                    "The number of generators ($(length(gen))) does not match the number of generator cost records ($(length(gencost))).",
                )
            end
        end

        for (i, gc) in enumerate(gencost)
            g = gen[i]
            @assert(g["index"] == gc["index"])
            delete!(gc, "index")
            delete!(gc, "source_id")

            _check_keys(g, keys(gc))
            merge!(g, gc)
        end

        delete!(data, "gencost")
    end

    if haskey(data, "dclinecost")
        dcline = data["dcline"]
        dclinecost = data["dclinecost"]

        if length(dcline) != length(dclinecost)
            @warn(
                "The number of dclines ($(length(dcline))) does not match the number of dcline cost records ($(length(dclinecost))).",
            )
        end

        for (i, dclc) in enumerate(dclinecost)
            dcl = dcline[i]
            @assert(dcl["index"] == dclc["index"])
            delete!(dclc, "index")
            delete!(dclc, "source_id")

            _check_keys(dcl, keys(dclc))
            merge!(dcl, dclc)
        end
        delete!(data, "dclinecost")
    end
end

"merges bus name data into buses, if names exist"
function _merge_bus_name_data!(data::Dict{String, Any})
    if haskey(data, "bus_name")
        # can assume same length is same as bus
        # this is validated during matpower parsing
        for (i, bus_name) in enumerate(data["bus_name"])
            bus = data["bus"][i]
            delete!(bus_name, "index")
            delete!(bus_name, "source_id")

            _check_keys(bus, keys(bus_name))
            merge!(bus, bus_name)
        end
        delete!(data, "bus_name")
    end
end

"merges Matpower tables based on the table extension syntax"
function _merge_generic_data!(data::Dict{String, Any})
    mp_matrix_names = [name[5:length(name)] for name in _mp_data_names]

    key_to_delete = []
    for (k, v) in data
        if isa(v, Array)
            for mp_name in mp_matrix_names
                if startswith(k, "$(mp_name)_")
                    mp_matrix = data[mp_name]
                    push!(key_to_delete, k)

                    if length(mp_matrix) != length(v)
                        error(
                            "failed to extend the matpower matrix \"$(mp_name)\" with the matrix \"$(k)\" because they do not have the same number of rows, $(length(mp_matrix)) and $(length(v)) respectively.",
                        )
                    end

                    @info(
                        "extending matpower format by appending matrix \"$(k)\" in to \"$(mp_name)\""
                    )

                    for (i, row) in enumerate(mp_matrix)
                        merge_row = v[i]
                        #@assert(row["index"] == merge_row["index"]) # note this does not hold for the bus table
                        delete!(merge_row, "index")
                        delete!(merge_row, "source_id")
                        for key in keys(merge_row)
                            if haskey(row, key)
                                error(
                                    "failed to extend the matpower matrix \"$(mp_name)\" with the matrix \"$(k)\" because they both share \"$(key)\" as a column name.",
                                )
                            end
                            row[key] = merge_row[key]
                        end
                    end

                    break # out of mp_matrix_names loop
                end
            end
        end
    end

    for key in key_to_delete
        delete!(data, key)
    end
end

""
function _check_keys(data, keys)
    for key in keys
        if haskey(data, key)
            error("attempting to overwrite value of $(key) in PowerModels data,\n$(data)")
        end
    end
end
