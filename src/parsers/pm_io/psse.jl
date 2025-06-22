# Parse PSS(R)E data from PTI file into PowerModels data format

"""
    _init_bus!(bus, id)

Initializes a `bus` of id `id` with default values given in the PSS(R)E
specification.
"""
function _init_bus!(bus::Dict{String, Any}, id::Int)
    bus["bus_i"] = id
    bus["bus_type"] = 1
    bus["area"] = 1
    bus["vm"] = 1.0
    bus["va"] = 0.0
    bus["base_kv"] = 1.0
    bus["zone"] = 1
    bus["name"] = "            "
    bus["vmax"] = 1.1
    bus["vmin"] = 0.9
    bus["index"] = id
    return
end

function _find_bus_value(bus_i::Int, field::String, pm_bus_data::Array)
    for bus in pm_bus_data
        if bus["index"] == bus_i
            return bus[field]
        end
    end
    @info("Could not find bus $bus_i, returning 0 for field $field")
    return 0
end

function _find_bus_value(bus_i::Int, field::String, pm_bus_data::Dict)
    if !haskey(pm_bus_data, bus_i)
        @info("Could not find bus $bus_i, returning 0 for field $field")
        return 0
    else
        return pm_bus_data[bus_i][field]
    end
end

"""
    _get_bus_value(bus_i, field, pm_data)

Returns the value of `field` of `bus_i` from the PowerModels data. Requires
"bus" Dict to already be populated.
"""
function _get_bus_value(bus_i::Int, field::String, pm_data::Dict{String, Any})
    return _find_bus_value(bus_i, field, pm_data["bus"])
end

"""
    _find_max_bus_id(pm_data)

Returns the maximum bus id in `pm_data`
"""
function _find_max_bus_id(pm_data::Dict)::Int
    max_id = 0
    for bus in values(pm_data["bus"])
        if bus["index"] > max_id && !endswith(bus["name"], "starbus")
            max_id = bus["index"]
        end
    end

    return max_id
end

"""
    create_starbus(pm_data, transformer)

Creates a starbus from a given three-winding `transformer`. "source_id" is given
by `["bus_i", "name", "I", "J", "K", "CKT"]` where "bus_i" and "name" are the
modified names for the starbus, and "I", "J", "K" and "CKT" come from the
originating transformer, in the PSS(R)E transformer specification.
"""
function _create_starbus_from_transformer(
    pm_data::Dict,
    transformer::Dict,
    starbus_id::Int,
)::Dict
    starbus = Dict{String, Any}()

    _init_bus!(starbus, starbus_id)

    starbus["name"] = "starbus_$(transformer["I"])_$(transformer["J"])_$(transformer["K"])_$(strip(transformer["CKT"]))"

    bus_type = 1
    starbus["vm"] = transformer["VMSTAR"]
    starbus["va"] = transformer["ANSTAR"]
    starbus["bus_type"] = bus_type
    if transformer["STAT"] != 0
        starbus["bus_status"] = true
    else
        starbus["bus_status"] = false
    end
    starbus["area"] = _get_bus_value(transformer["I"], "area", pm_data)
    starbus["zone"] = _get_bus_value(transformer["I"], "zone", pm_data)
    starbus["hidden"] = true
    starbus["source_id"] = push!(
        ["transformer", starbus["bus_i"], starbus["name"]],
        transformer["I"],
        transformer["J"],
        transformer["K"],
        transformer["CKT"],
    )

    return starbus
end

"Imports remaining top level component lists from `data_in` into `data_out`, excluding keys in `exclude`"
function _import_remaining_comps!(data_out::Dict, data_in::Dict; exclude = [])
    for (comp_class, v) in data_in
        if !(comp_class in exclude)
            comps_out = Dict{String, Any}()

            if isa(v, Array)
                for (n, item) in enumerate(v)
                    if isa(item, Dict)
                        comp_out = Dict{String, Any}()
                        _import_remaining_keys!(comp_out, item)
                        if !("index" in keys(item))
                            comp_out["index"] = n
                        end
                        comps_out["$(n)"] = comp_out
                    else
                        @error("psse data parsing error, please post an issue")
                    end
                end
            elseif isa(v, Dict)
                comps_out = Dict{String, Any}()
                _import_remaining_keys!(comps_out, v)
            else
                @error("psse data parsing error, please post an issue")
            end

            data_out[lowercase(comp_class)] = comps_out
        end
    end
end

"Imports remaining keys from a source component into detestation component, excluding keys in `exclude`"
function _import_remaining_keys!(comp_dest::Dict, comp_src::Dict; exclude = [])
    for (k, v) in comp_src
        if !(k in exclude)
            key = lowercase(k)
            if !haskey(comp_dest, key)
                comp_dest[key] = v
            else
                if key != "index"
                    @warn("duplicate key $(key), please post an issue")
                end
            end
        end
    end
end

"""
    _psse2pm_branch!(pm_data, pti_data)

Parses PSS(R)E-style Branch data into a PowerModels-style Dict. "source_id" is
given by `["I", "J", "CKT"]` in PSS(R)E Branch specification.
"""
function _psse2pm_branch!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Branch data into a PowerModels Dict..."
    pm_data["branch"] = []
    if haskey(pti_data, "BRANCH")
        for branch in pti_data["BRANCH"]
            if first(branch["CKT"]) != '@' && first(branch["CKT"]) != '*'
                sub_data = Dict{String, Any}()

                sub_data["f_bus"] = pop!(branch, "I")
                sub_data["t_bus"] = pop!(branch, "J")
                bus_from = pm_data["bus"][sub_data["f_bus"]]
                sub_data["base_voltage_from"] = bus_from["base_kv"]
                bus_to = pm_data["bus"][sub_data["t_bus"]]
                sub_data["base_voltage_to"] = bus_to["base_kv"]
                if pm_data["has_isolated_buses"]
                    push!(pm_data["connected_buses"], sub_data["f_bus"])
                    push!(pm_data["connected_buses"], sub_data["t_bus"])
                end
                sub_data["br_r"] = pop!(branch, "R")
                sub_data["br_x"] = pop!(branch, "X")
                sub_data["g_fr"] = pop!(branch, "GI")
                sub_data["b_fr"] =
                    if branch["BI"] == 0.0 && branch["B"] != 0.0
                        branch["B"] / 2
                    else
                        pop!(branch, "BI")
                    end
                sub_data["g_to"] = pop!(branch, "GJ")
                sub_data["b_to"] =
                    if branch["BJ"] == 0.0 && branch["B"] != 0.0
                        branch["B"] / 2
                    else
                        pop!(branch, "BJ")
                    end
                sub_data["rate_a"] = pop!(branch, "RATEA")
                sub_data["rate_b"] = pop!(branch, "RATEB")
                sub_data["rate_c"] = pop!(branch, "RATEC")
                sub_data["tap"] = 1.0
                sub_data["shift"] = 0.0
                sub_data["br_status"] = pop!(branch, "ST")
                sub_data["angmin"] = 0.0
                sub_data["angmax"] = 0.0
                sub_data["transformer"] = false
                sub_data["ext"] = Dict{String, Any}(
                    "LEN" => pop!(branch, "LEN"),
                )

                sub_data["source_id"] =
                    ["branch", sub_data["f_bus"], sub_data["t_bus"], pop!(branch, "CKT")]
                sub_data["index"] = length(pm_data["branch"]) + 1

                if import_all
                    _import_remaining_keys!(sub_data, branch; exclude = ["B", "BI", "BJ"])
                end

                if sub_data["rate_a"] == 0.0
                    delete!(sub_data, "rate_a")
                end
                if sub_data["rate_b"] == 0.0
                    delete!(sub_data, "rate_b")
                end
                if sub_data["rate_c"] == 0.0
                    delete!(sub_data, "rate_c")
                end
                branch_isolated_bus_modifications!(pm_data, sub_data)
                push!(pm_data["branch"], sub_data)
            end
        end
    end
end

function branch_isolated_bus_modifications!(pm_data::Dict, branch_data::Dict)
    bus_data = pm_data["bus"]
    from_bus_no = branch_data["f_bus"]
    to_bus_no = branch_data["t_bus"]
    from_bus = bus_data[from_bus_no]
    to_bus = bus_data[to_bus_no]
    if from_bus["bus_type"] == 4 || to_bus["bus_type"] == 4
        branch_data["br_status"] = 0
    end
    if from_bus["bus_type"] == 4
        push!(pm_data["isolated_to_pq_buses"], from_bus_no)
        from_bus["bus_status"] = false
    end
    if to_bus["bus_type"] == 4
        push!(pm_data["isolated_to_pq_buses"], to_bus_no)
        to_bus["bus_status"] = false
    end
    return
end

function transformer3W_isolated_bus_modifications!(pm_data::Dict, branch_data::Dict)
    bus_data = pm_data["bus"]
    primary_bus_number = branch_data["bus_primary"]
    secondary_bus_number = branch_data["bus_secondary"]
    tertiary_bus_number = branch_data["bus_tertiary"]
    primary_bus = bus_data[primary_bus_number]
    secondary_bus = bus_data[secondary_bus_number]
    tertiary_bus = bus_data[tertiary_bus_number]
    if primary_bus["bus_type"] == 4 || secondary_bus["bus_type"] == 4 ||
       tertiary_bus["bus_type"] == 4
        branch_data["br_status"] = 0
    end
    if primary_bus["bus_type"] == 4
        push!(pm_data["isolated_to_pq_buses"], primary_bus_number)
        primary_bus["bus_status"] = false
    end
    if secondary_bus["bus_type"] == 4
        push!(pm_data["isolated_to_pq_buses"], secondary_bus_number)
        secondary_bus["bus_status"] = false
    end
    if tertiary_bus["bus_type"] == 4
        push!(pm_data["isolated_to_pq_buses"], tertiary_bus_number)
        tertiary_bus["bus_status"] = false
    end
    return
end
"""
    _psse2pm_generator!(pm_data, pti_data)

Parses PSS(R)E-style Generator data in a PowerModels-style Dict. "source_id" is
given by `["I", "ID"]` in PSS(R)E Generator specification.
"""
function _psse2pm_generator!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Generator data into a PowerModels Dict..."
    if haskey(pti_data, "GENERATOR")
        pm_data["gen"] = Vector{Dict{String, Any}}(undef, length(pti_data["GENERATOR"]))
        for (ix, gen) in enumerate(pti_data["GENERATOR"])
            sub_data = Dict{String, Any}()

            sub_data["gen_bus"] = pop!(gen, "I")
            sub_data["gen_status"] = pop!(gen, "STAT")
            sub_data["pg"] = pop!(gen, "PG")
            sub_data["qg"] = pop!(gen, "QG")
            sub_data["vg"] = pop!(gen, "VS")
            sub_data["mbase"] = pop!(gen, "MBASE")
            sub_data["pmin"] = pop!(gen, "PB")
            sub_data["pmax"] = pop!(gen, "PT")
            sub_data["qmin"] = pop!(gen, "QB")
            sub_data["qmax"] = pop!(gen, "QT")
            sub_data["rt_source"] = pop!(gen, "RT")
            sub_data["xt_source"] = pop!(gen, "XT")
            sub_data["r_source"] = pop!(gen, "ZR")
            sub_data["x_source"] = pop!(gen, "ZX")

            # Default Cost functions
            sub_data["model"] = 2
            sub_data["startup"] = 0.0
            sub_data["shutdown"] = 0.0
            sub_data["ncost"] = 2
            sub_data["cost"] = [1.0, 0.0]

            sub_data["source_id"] =
                ["generator", string(sub_data["gen_bus"]), pop!(gen, "ID")]
            sub_data["index"] = ix

            if import_all
                _import_remaining_keys!(sub_data, gen)
            end
            device_bus_number = sub_data["gen_bus"]
            bus = pm_data["bus"][device_bus_number]
            if bus["bus_type"] == 4
                push!(pm_data["isolated_to_pv_buses"], device_bus_number)
                bus["bus_status"] = false
                sub_data["gen_status"] = false
            end
            pm_data["gen"][ix] = sub_data
        end
    else
        pm_data["gen"] = Vector{Dict{String, Any}}()
    end
end

function _psse2pm_area_interchange!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E AreaInterchange data into a PowerModels Dict..."
    pm_data["area_interchange"] = []

    if haskey(pti_data, "AREA INTERCHANGE")
        for area_int in pti_data["AREA INTERCHANGE"]
            sub_data = Dict{String, Any}()
            sub_data["area_name"] = pop!(area_int, "ARNAME")
            sub_data["area_number"] = pop!(area_int, "I")
            sub_data["bus_number"] = pop!(area_int, "ISW")
            sub_data["net_interchange"] = pop!(area_int, "PDES")
            sub_data["tol_interchange"] = pop!(area_int, "PTOL")
            sub_data["index"] = length(pm_data["area_interchange"]) + 1
            if import_all
                _import_remaining_keys!(sub_data, area_int)
            end

            push!(pm_data["area_interchange"], sub_data)
        end
    end
end

function _psse2pm_interarea_transfer!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E InterAreaTransfer data into a PowerModels Dict..."
    pm_data["interarea_transfer"] = []

    if haskey(pti_data, "INTER-AREA TRANSFER")
        for interarea in pti_data["INTER-AREA TRANSFER"]
            sub_data = Dict{String, Any}()
            sub_data["area_from"] = pop!(interarea, "ARFROM")
            sub_data["area_to"] = pop!(interarea, "ARTO")
            sub_data["power_transfer"] = pop!(interarea, "PTRAN")

            sub_data["index"] = length(pm_data["interarea_transfer"]) + 1
            if import_all
                _import_remaining_keys!(sub_data, interarea)
            end

            push!(pm_data["interarea_transfer"], sub_data)
        end
    end
end

function _psse2pm_zone!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Zone data into a PowerModels Dict..."
    pm_data["zone"] = []

    if haskey(pti_data, "ZONE")
        for zone in pti_data["ZONE"]
            sub_data = Dict{String, Any}()
            sub_data["zone_number"] = pop!(zone, "I")
            sub_data["zone_name"] = pop!(zone, "ZONAME")
            sub_data["index"] = length(pm_data["zone"]) + 1
            if import_all
                _import_remaining_keys!(sub_data, zone)
            end

            push!(pm_data["zone"], sub_data)
        end
    end
end

"""
    _psse2pm_bus!(pm_data, pti_data)

Parses PSS(R)E-style Bus data into a PowerModels-style Dict. "source_id" is given
by ["I", "NAME"] in PSS(R)E Bus specification.
"""
function _psse2pm_bus!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Bus data into a PowerModels Dict..."
    pm_data["has_isolated_buses"] = false
    pm_data["bus"] = Dict{Int, Any}()
    if haskey(pti_data, "BUS")
        for bus in pti_data["BUS"]
            sub_data = Dict{String, Any}()

            sub_data["bus_i"] = bus["I"]
            sub_data["bus_type"] = pop!(bus, "IDE")
            if sub_data["bus_type"] == 4
                @warn "The PSS(R)E data contains buses designated as isolated. The parser will check if the buses are connected or topologically isolated."
                pm_data["has_isolated_buses"] = true
                sub_data["bus_status"] = false
                pm_data["connected_buses"] = Set{Int}()
                pm_data["isolated_to_pq_buses"] = Set{Int}()
                pm_data["isolated_to_pv_buses"] = Set{Int}()
            else
                sub_data["bus_status"] = true
            end
            sub_data["area"] = pop!(bus, "AREA")
            sub_data["vm"] = pop!(bus, "VM")
            sub_data["va"] = pop!(bus, "VA")
            sub_data["base_kv"] = pop!(bus, "BASKV")
            sub_data["zone"] = pop!(bus, "ZONE")
            sub_data["name"] = pop!(bus, "NAME")
            sub_data["vmax"] = pop!(bus, "NVHI")
            sub_data["vmin"] = pop!(bus, "NVLO")
            sub_data["hidden"] = false

            sub_data["source_id"] = ["bus", "$(bus["I"])"]
            sub_data["index"] = pop!(bus, "I")

            if import_all
                _import_remaining_keys!(sub_data, bus)
            end

            if haskey(pm_data["bus"], sub_data["bus_i"])
                error("Repeated $(sub_data["bus_i"])")
            end
            pm_data["bus"][sub_data["bus_i"]] = sub_data
        end
    end
    return
end

"""
    _psse2pm_load!(pm_data, pti_data)

Parses PSS(R)E-style Load data into a PowerModels-style Dict. "source_id" is given
by `["I", "ID"]` in the PSS(R)E Load specification.
"""
function _psse2pm_load!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Load data into a PowerModels Dict..."
    pm_data["load"] = []
    if haskey(pti_data, "LOAD")
        for load in pti_data["LOAD"]
            sub_data = Dict{String, Any}()
            sub_data["load_bus"] = pop!(load, "I")
            sub_data["pd"] = pop!(load, "PL")
            sub_data["qd"] = pop!(load, "QL")
            sub_data["pi"] = pop!(load, "IP")
            sub_data["qi"] = pop!(load, "IQ")
            sub_data["py"] = pop!(load, "YP")
            sub_data["qy"] = pop!(load, "YQ")
            sub_data["conformity"] = pop!(load, "SCALE")
            sub_data["source_id"] = ["load", sub_data["load_bus"], pop!(load, "ID")]
            sub_data["status"] = pop!(load, "STATUS")
            sub_data["index"] = length(pm_data["load"]) + 1
            if import_all
                _import_remaining_keys!(sub_data, load)
            end
            device_bus_number = sub_data["load_bus"]
            bus = pm_data["bus"][device_bus_number]
            if bus["bus_type"] == 4
                push!(pm_data["isolated_to_pq_buses"], device_bus_number)
                bus["bus_status"] = false
                sub_data["status"] = false
            end
            push!(pm_data["load"], sub_data)
        end
    end
end

"""
    _psse2pm_shunt!(pm_data, pti_data)

Parses PSS(R)E-style Fixed and Switched Shunt data into a PowerModels-style
Dict. "source_id" is given by `["I", "ID"]` for Fixed Shunts, and `["I", "SWREM"]`
for Switched Shunts, as given by the PSS(R)E Fixed and Switched Shunts
specifications.
"""
function _psse2pm_shunt!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Fixed & Switched Shunt data into a PowerModels Dict..."

    pm_data["shunt"] = []
    if haskey(pti_data, "FIXED SHUNT")
        for shunt in pti_data["FIXED SHUNT"]
            sub_data = Dict{String, Any}()

            sub_data["shunt_bus"] = pop!(shunt, "I")
            sub_data["gs"] = pop!(shunt, "GL")
            sub_data["bs"] = pop!(shunt, "BL")
            sub_data["status"] = pop!(shunt, "STATUS")

            sub_data["source_id"] =
                ["fixed shunt", sub_data["shunt_bus"], pop!(shunt, "ID")]
            sub_data["index"] = length(pm_data["shunt"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, shunt)
            end
            device_bus_number = sub_data["shunt_bus"]
            bus = pm_data["bus"][device_bus_number]
            if bus["bus_type"] == 4
                push!(pm_data["isolated_to_pq_buses"], device_bus_number)
                bus["bus_status"] = false
                sub_data["status"] = false
            end
            push!(pm_data["shunt"], sub_data)
        end
    end

    pm_data["switched_shunt"] = []
    if haskey(pti_data, "SWITCHED SHUNT")
        for switched_shunt in pti_data["SWITCHED SHUNT"]
            sub_data = Dict{String, Any}()

            sub_data["shunt_bus"] = pop!(switched_shunt, "I")
            sub_data["gs"] = 0.0
            sub_data["bs"] = pop!(switched_shunt, "BINIT")
            sub_data["status"] = pop!(switched_shunt, "STAT")
            sub_data["admittance_limits"] =
                (pop!(switched_shunt, "VSWLO"), pop!(switched_shunt, "VSWHI"))

            step_numbers = Dict(
                k => v for
                (k, v) in switched_shunt if startswith(k, "N") && isdigit(last(k))
            )
            step_numbers_sorted =
                sort(collect(keys(step_numbers)); by = x -> parse(Int, x[2:end]))
            sub_data["step_number"] = [step_numbers[k] for k in step_numbers_sorted]
            sub_data["step_number"] = sub_data["step_number"][sub_data["step_number"] .!= 0]

            y_increment = Dict(
                k => v for
                (k, v) in switched_shunt if startswith(k, "B") && isdigit(last(k))
            )
            y_increment_sorted =
                sort(collect(keys(y_increment)); by = x -> parse(Int, x[2:end]))
            sub_data["y_increment"] = [y_increment[k] for k in y_increment_sorted]im
            sub_data["y_increment"] = sub_data["y_increment"][sub_data["y_increment"] .!= 0]

            sub_data["source_id"] =
                ["switched shunt", sub_data["shunt_bus"], pop!(switched_shunt, "SWREM")]
            sub_data["index"] = length(pm_data["switched_shunt"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, switched_shunt)
            end
            device_bus_number = sub_data["shunt_bus"]
            bus = pm_data["bus"][device_bus_number]
            if bus["bus_type"] == 4
                push!(pm_data["isolated_to_pq_buses"], device_bus_number)
                bus["bus_status"] = false
                sub_data["status"] = false
            end
            push!(pm_data["switched_shunt"], sub_data)
        end
    end
end

"""
    _psse2pm_transformer!(pm_data, pti_data)

Parses PSS(R)E-style Transformer data into a PowerModels-style Dict. "source_id"
is given by `["I", "J", "K", "CKT", "winding"]`, where "winding" is 0 if
transformer is two-winding, and 1, 2, or 3 for three-winding, and the remaining
keys are defined in the PSS(R)E Transformer specification.
"""
function _psse2pm_transformer!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Transformer data into a PowerModels Dict..."
    if !haskey(pm_data, "branch")
        pm_data["branch"] = []
    end

    if haskey(pti_data, "TRANSFORMER")
        starbus_id = 10^ceil(Int, log10(abs(_find_max_bus_id(pm_data)))) + 1

        for transformer in pti_data["TRANSFORMER"]
            if !(transformer["CZ"] in [1, 2, 3])
                @warn(
                    "transformer CZ value outside of valid bounds assuming the default value of 1.  Given $(transformer["CZ"]), should be 1, 2 or 3",
                )
                transformer["CZ"] = 1
            end

            if !(transformer["CW"] in [1, 2, 3])
                @warn(
                    "transformer CW value outside of valid bounds assuming the default value of 1.  Given $(transformer["CW"]), should be 1, 2 or 3",
                )
                transformer["CW"] = 1
            end

            if !(transformer["CM"] in [1, 2])
                @warn(
                    "transformer CM value outside of valid bounds assuming the default value of 1.  Given $(transformer["CM"]), should be 1 or 2",
                )
                transformer["CM"] = 1
            end

            if transformer["K"] == 0  # Two-winding Transformers
                sub_data = Dict{String, Any}()

                sub_data["f_bus"] = transformer["I"]
                sub_data["t_bus"] = transformer["J"]
                if pm_data["has_isolated_buses"]
                    push!(pm_data["connected_buses"], sub_data["f_bus"])
                    push!(pm_data["connected_buses"], sub_data["t_bus"])
                end

                # Store base_power
                if transformer["SBASE1-2"] < 0.0
                    throw(
                        IS.InvalidValue(
                            "Transformer $(sub_data["f_bus"]) -> $(sub_data["t_bus"]) has non-positive base power SBASE1-2: $(transformer["SBASE1-2"])",
                        ),
                    )
                end
                if iszero(transformer["SBASE1-2"])
                    sub_data["base_power"] = pm_data["baseMVA"]
                else
                    sub_data["base_power"] = transformer["SBASE1-2"]
                end
                if iszero(transformer["NOMV1"])
                    sub_data["base_voltage_from"] =
                        _get_bus_value(transformer["I"], "base_kv", pm_data)
                else
                    sub_data["base_voltage_from"] = transformer["NOMV1"]
                end
                if iszero(transformer["NOMV2"])
                    sub_data["base_voltage_to"] =
                        _get_bus_value(transformer["J"], "base_kv", pm_data)
                else
                    sub_data["base_voltage_to"] = transformer["NOMV2"]
                end

                # Unit Transformations
                # Data must be stored in the DEVICE_BASE
                # Z_base_device = (V_device)^2 / S_device, Z_base_sys = (V_device)^2 / S_sys
                # Z_ohms = Z_pu_sys * Z_base_sys, Z_pu_device = Z_ohms / Z_device = Z_pu_sys * S_device / S_sys
                mva_ratio = sub_data["base_power"] / pm_data["baseMVA"]
                Z_base_device = sub_data["base_voltage_from"]^2 / sub_data["base_power"]
                Z_base_sys = sub_data["base_voltage_from"]^2 / pm_data["baseMVA"]
                #_get_bus_value(transformer["I"], "base_kv", pm_data)^2 /
                #pm_data["baseMVA"]
                if transformer["CZ"] == 2  # "for resistance and reactance in pu on system MVA base and winding voltage base"
                    # Compute br_r and br_x in pu of device base
                    br_r, br_x = transformer["R1-2"], transformer["X1-2"]
                else  # NOT "for resistance and reactance in pu on system MVA base and winding voltage base"
                    if transformer["CZ"] == 3  # "for transformer load loss in watts and impedance magnitude in pu on a specified MVA base and winding voltage base."
                        br_r = 1e-6 * transformer["R1-2"] / sub_data["base_power"] # device pu
                        br_x = sqrt(transformer["X1-2"]^2 - br_r^2) # device pu
                    else # "CZ" = 1 in system base pu
                        @assert transformer["CZ"] == 1
                        br_r, br_x = transformer["R1-2"], transformer["X1-2"] # sys pu
                        if iszero(Z_base_device) # NOMV1 = 0.0: use the power ratios
                            br_r = transformer["R1-2"] * mva_ratio
                            br_x = transformer["X1-2"] * mva_ratio
                        else # NOMV1 could potentially be different than the bus_voltage, use impedance ratios
                            br_r = (transformer["R1-2"] * Z_base_sys) / Z_base_device
                            br_x = (transformer["X1-2"] * Z_base_sys) / Z_base_device
                        end
                    end
                end

                # Zeq scaling for tap2 (see eq (4.21b) in PROGRAM APPLICATION GUIDE 1 in PSSE installation folder)
                # Unit Transformations
                if transformer["CW"] == 1  # "for off-nominal turns ratio in pu of winding bus base voltage"
                    br_r *= transformer["WINDV2"]^2
                    br_x *= transformer["WINDV2"]^2
                    # NOT "for off-nominal turns ratio in pu of winding bus base voltage"
                elseif transformer["CW"] == 2 # "for winding voltage in kV"
                    br_r *=
                        (
                            transformer["WINDV2"] /
                            _get_bus_value(transformer["J"], "base_kv", pm_data)
                        )^2
                    br_x *=
                        (
                            transformer["WINDV2"] /
                            _get_bus_value(transformer["J"], "base_kv", pm_data)
                        )^2
                elseif transformer["CW"] == 3  # "for off-nominal turns ratio in pu of nominal winding voltage, NOMV1, NOMV2 and NOMV3."
                    #The nominal (rated) Winding 2 voltage base in kV, or zero to indicate
                    # that nominal Winding 2 voltage is assumed to be identical to the base
                    # voltage of bus J. NOMV2 is used in converting tap ratio data between values
                    # in per unit of nominal Winding 2 voltage and values in per unit of Winding 2
                    #bus base voltage when CW is 3. NOMV2 = 0.0 by default.
                    if iszero(transformer["NOMV2"])
                        nominal_voltage_ratio = 1.0
                    else
                        nominal_voltage_ratio =
                            transformer["NOMV2"] /
                            _get_bus_value(transformer["J"], "base_kv", pm_data)
                    end

                    br_r *= (transformer["WINDV2"] * (nominal_voltage_ratio))^2
                    br_x *= (transformer["WINDV2"] * (nominal_voltage_ratio))^2
                else
                    error("invalid transformer $(transformer["CW"])")
                end

                if transformer["X1-2"] < 0.0 && br_x < 0.0
                    @warn "Transformer $(sub_data["f_bus"]) -> $(sub_data["t_bus"]) has negative impedance values X1-2: $(transformer["X1-2"]), br_x: $(br_x)"
                end

                sub_data["br_r"] = br_r
                sub_data["br_x"] = br_x

                if transformer["CM"] == 1
                    # Transform admittance to device per unit
                    mva_ratio_12 = sub_data["base_power"] / pm_data["baseMVA"]
                    Z_base_device_1 = transformer["NOMV1"]^2 / sub_data["base_power"]
                    Z_base_sys_1 =
                        _get_bus_value(transformer["I"], "base_kv", pm_data)^2 /
                        pm_data["baseMVA"]
                    if iszero(Z_base_device_1) # NOMV1 = 0.0: use the power ratios
                        sub_data["g_fr"] = transformer["MAG1"] / mva_ratio_12
                        sub_data["b_fr"] = transformer["MAG2"] / mva_ratio_12
                    else # NOMV1 could potentially be different than the bus_voltage, use impedance ratios
                        sub_data["g_fr"] =
                            (transformer["MAG1"] / Z_base_sys_1) * Z_base_device_1
                        sub_data["b_fr"] =
                            (transformer["MAG2"] / Z_base_sys_1) * Z_base_device_1
                    end
                else # CM=2: MAG1 are no load loss in Watts and MAG2 is the exciting current in pu, in device base.
                    @assert transformer["CM"] == 2
                    G_pu = 1e-6 * transformer["MAG1"] / sub_data["base_power"]
                    B_pu = sqrt(transformer["MAG2"]^2 - G_pu^2)
                    sub_data["g_fr"] = G_pu
                    sub_data["b_fr"] = B_pu
                end
                sub_data["g_to"] = 0.0
                sub_data["b_to"] = 0.0

                sub_data["rate_a"] = pop!(transformer, "RATA1")
                sub_data["rate_b"] = pop!(transformer, "RATB1")
                sub_data["rate_c"] = pop!(transformer, "RATC1")

                if sub_data["rate_a"] == 0.0
                    delete!(sub_data, "rate_a")
                end
                if sub_data["rate_b"] == 0.0
                    delete!(sub_data, "rate_b")
                end
                if sub_data["rate_c"] == 0.0
                    delete!(sub_data, "rate_c")
                end

                if import_all
                    sub_data["windv1"] = transformer["WINDV1"]
                    sub_data["windv2"] = transformer["WINDV2"]
                    sub_data["nomv1"] = transformer["NOMV1"]
                    sub_data["nomv2"] = transformer["NOMV2"]
                end

                if abs(transformer["COD1"]) ∈ [1, 2]
                    tap_data = pop!(transformer, "WINDV1") / pop!(transformer, "WINDV2")
                    tap_positions = collect(
                        range(
                            transformer["RMI1"],
                            transformer["RMA1"];
                            length = Int(transformer["NTP1"]),
                        ),
                    )
                    closest_tap_ix = argmin(abs.(tap_positions .- tap_data))
                    if !isapprox(tap_data, tap_positions[closest_tap_ix])
                        @warn "Transformer winding tap setting is not on a step; converting original data ($tap_data) to nearest step ($(tap_positions[closest_tap_ix]))"
                        sub_data["tap"] = tap_positions[closest_tap_ix]
                    else
                        sub_data["tap"] = tap_data
                    end
                else
                    sub_data["tap"] =
                        pop!(transformer, "WINDV1") / pop!(transformer, "WINDV2")
                end
                sub_data["shift"] = pop!(transformer, "ANG1")

                if transformer["CW"] != 1  # NOT "for off-nominal turns ratio in pu of winding bus base voltage"
                    sub_data["tap"] *=
                        _get_bus_value(transformer["J"], "base_kv", pm_data) /
                        _get_bus_value(transformer["I"], "base_kv", pm_data)
                    if transformer["CW"] == 3  # "for off-nominal turns ratio in pu of nominal winding voltage, NOMV1, NOMV2 and NOMV3."
                        if iszero(transformer["NOMV1"])
                            winding1_nominal_voltage =
                                _get_bus_value(transformer["I"], "base_kv", pm_data)
                        else
                            winding1_nominal_voltage = transformer["NOMV1"]
                        end

                        if iszero(transformer["NOMV2"])
                            winding2_nominal_voltage =
                                _get_bus_value(transformer["J"], "base_kv", pm_data)
                        else
                            winding2_nominal_voltage = transformer["NOMV2"]
                        end

                        sub_data["tap"] *=
                            winding1_nominal_voltage / winding2_nominal_voltage
                    end
                end

                if import_all
                    sub_data["cw"] = transformer["CW"]
                end

                if transformer["STAT"] == 0 || transformer["STAT"] == 2
                    sub_data["br_status"] = 0
                else
                    sub_data["br_status"] = 1
                end

                sub_data["angmin"] = 0.0
                sub_data["angmax"] = 0.0

                sub_data["source_id"] = [
                    "transformer",
                    pop!(transformer, "I"),
                    pop!(transformer, "J"),
                    pop!(transformer, "K"),
                    pop!(transformer, "CKT"),
                    0,
                ]
                sub_data["ext"] = Dict{String, Any}(
                    "psse_name" => transformer["NAME"],
                    "CW" => transformer["CW"],
                    "CZ" => transformer["CZ"],
                    "CM" => transformer["CM"],
                )

                sub_data["transformer"] = true
                sub_data["correction_table"] = transformer["TAB1"]

                sub_data["index"] = length(pm_data["branch"]) + 1

                if import_all
                    _import_remaining_keys!(
                        sub_data,
                        transformer;
                        exclude = [
                            "I",
                            "J",
                            "K",
                            "CZ",
                            "CW",
                            "R1-2",
                            "R2-3",
                            "R3-1",
                            "X1-2",
                            "X2-3",
                            "X3-1",
                            "SBASE1-2",
                            "SBASE2-3",
                            "SBASE3-1",
                            "MAG1",
                            "MAG2",
                            "STAT",
                            "NOMV1",
                            "NOMV2",
                        ],
                    )
                end
                branch_isolated_bus_modifications!(pm_data, sub_data)
                push!(pm_data["branch"], sub_data)
            else  # Three-winding Transformers
                # Create 3w-transformer key
                if !haskey(pm_data, "3w_transformer")
                    pm_data["3w_transformer"] = []
                end

                bus_id1, bus_id2, bus_id3 =
                    transformer["I"], transformer["J"], transformer["K"]
                # Creates a starbus (or "dummy" bus) to which each winding of the transformer will connect
                starbus = _create_starbus_from_transformer(pm_data, transformer, starbus_id)
                pm_data["bus"][starbus_id] = starbus
                if pm_data["has_isolated_buses"]
                    push!(pm_data["connected_buses"], bus_id1)
                    push!(pm_data["connected_buses"], bus_id2)
                    push!(pm_data["connected_buses"], bus_id3)
                    push!(pm_data["connected_buses"], starbus_id)
                end
                # Add parameters to the 3w-transformer key
                sub_data = Dict{String, Any}()
                bases = [
                    transformer["SBASE1-2"],
                    transformer["SBASE2-3"],
                    transformer["SBASE3-1"],
                ]
                base_names = [
                    "base_power_12",
                    "base_power_23",
                    "base_power_13",
                ]

                for (ix, base) in enumerate(bases)
                    if base < 0.0
                        throw(
                            IS.InvalidValue(
                                "Transformer $(transformer[I]) -> $(transformer["J"]) -> $(transformer["K"]) has negative base power $base",
                            ),
                        )
                    end
                    if iszero(base)
                        sub_data[base_names[ix]] = pm_data["baseMVA"]
                    else
                        sub_data[base_names[ix]] = base
                    end
                end

                if iszero(transformer["NOMV1"])
                    sub_data["base_voltage_primary"] =
                        _get_bus_value(transformer["I"], "base_kv", pm_data)
                else
                    sub_data["base_voltage_primary"] = transformer["NOMV1"]
                end
                if iszero(transformer["NOMV2"])
                    sub_data["base_voltage_secondary"] =
                        _get_bus_value(transformer["J"], "base_kv", pm_data)
                else
                    sub_data["base_voltage_secondary"] = transformer["NOMV2"]
                end
                if iszero(transformer["NOMV3"])
                    sub_data["base_voltage_tertiary"] =
                        _get_bus_value(transformer["K"], "base_kv", pm_data)
                else
                    sub_data["base_voltage_tertiary"] = transformer["NOMV3"]
                end

                # Create 3 branches from a three winding transformer (one for each winding, which will each connect to the starbus)
                br_r12, br_r23, br_r31 =
                    transformer["R1-2"], transformer["R2-3"], transformer["R3-1"]
                br_x12, br_x23, br_x31 =
                    transformer["X1-2"], transformer["X2-3"], transformer["X3-1"]

                # Unit Transformations
                if transformer["CZ"] == 3  # "for transformer load loss in watts and impedance magnitude in pu on a specified MVA base and winding voltage base."
                    # In device base
                    br_r12 *= 1e-6 / sub_data["base_power_12"]
                    br_r23 *= 1e-6 / sub_data["base_power_23"]
                    br_r31 *= 1e-6 / sub_data["base_power_13"]

                    br_x12 = sqrt(br_x12^2 - br_r12^2)
                    br_x23 = sqrt(br_x23^2 - br_r23^2)
                    br_x31 = sqrt(br_x31^2 - br_r31^2)
                end

                # Unit Transformations
                if transformer["CZ"] == 1  # "for resistance and reactance in pu on system MVA base (transform to device base)"
                    mva_ratio_12 = sub_data["base_power_12"] / pm_data["baseMVA"]
                    mva_ratio_23 = sub_data["base_power_23"] / pm_data["baseMVA"]
                    mva_ratio_31 = sub_data["base_power_13"] / pm_data["baseMVA"]
                    Z_base_device_1 = transformer["NOMV1"]^2 / sub_data["base_power_12"]
                    Z_base_device_2 = transformer["NOMV2"]^2 / sub_data["base_power_23"]
                    Z_base_device_3 = transformer["NOMV3"]^2 / sub_data["base_power_13"]
                    Z_base_sys_1 = (sub_data["base_voltage_primary"])^2 / pm_data["baseMVA"]
                    Z_base_sys_2 =
                        (sub_data["base_voltage_secondary"])^2 / pm_data["baseMVA"]
                    Z_base_sys_3 =
                        (sub_data["base_voltage_tertiary"])^2 / pm_data["baseMVA"]
                    if iszero(Z_base_device_1) # NOMV1 = 0.0: use the power ratios
                        br_r12 *= mva_ratio_12
                        br_x12 *= mva_ratio_12
                    else # NOMV1 could potentially be different than the bus_voltage, use impedance ratios
                        br_r12 *= Z_base_sys_1 / Z_base_device_1
                        br_x12 *= Z_base_sys_1 / Z_base_device_1
                    end
                    if iszero(Z_base_device_2) # NOMV2 = 0.0: use the power ratios
                        br_r23 *= mva_ratio_23
                        br_x23 *= mva_ratio_23
                    else # NOMV2 could potentially be different than the bus_voltage, use impedance ratios
                        br_r23 *= Z_base_sys_2 / Z_base_device_2
                        br_x23 *= Z_base_sys_2 / Z_base_device_2
                    end
                    if iszero(Z_base_device_3) # NOMV3 = 0.0: use the power ratios
                        br_r31 *= mva_ratio_31
                        br_x31 *= mva_ratio_31
                    else # NOMV3 could potentially be different than the bus_voltage, use impedance ratios
                        br_r31 *= Z_base_sys_3 / Z_base_device_3
                        br_x31 *= Z_base_sys_3 / Z_base_device_3
                    end
                end

                # See "Power System Stability and Control", ISBN: 0-07-035958-X, Eq. 6.72
                Zr_p = 1 / 2 * (br_r12 - br_r23 + br_r31)
                Zr_s = 1 / 2 * (br_r23 - br_r31 + br_r12)
                Zr_t = 1 / 2 * (br_r31 - br_r12 + br_r23)
                Zx_p = 1 / 2 * (br_x12 - br_x23 + br_x31)
                Zx_s = 1 / 2 * (br_x23 - br_x31 + br_x12)
                Zx_t = 1 / 2 * (br_x31 - br_x12 + br_x23)

                sub_data["name"] = transformer["NAME"]
                sub_data["bus_primary"] = bus_id1
                sub_data["bus_secondary"] = bus_id2
                sub_data["bus_tertiary"] = bus_id3

                sub_data["available"] = false
                if transformer["STAT"] != 0
                    sub_data["available"] = true
                end

                sub_data["available_primary"] = true
                sub_data["available_secondary"] = true
                sub_data["available_tertiary"] = true

                if transformer["STAT"] == 2
                    sub_data["available_secondary"] = false
                end

                if transformer["STAT"] == 3
                    sub_data["available_tertiary"] = false
                end

                if transformer["STAT"] == 4
                    sub_data["available_primary"] = false
                end

                if transformer["STAT"] == 0
                    sub_data["available_primary"] = false
                    sub_data["available_secondary"] = false
                    sub_data["available_tertiary"] = false
                end

                sub_data["star_bus"] = starbus_id

                sub_data["active_power_flow_primary"] = 0.0
                sub_data["reactive_power_flow_primary"] = 0.0
                sub_data["active_power_flow_secondary"] = 0.0
                sub_data["reactive_power_flow_secondary"] = 0.0
                sub_data["active_power_flow_tertiary"] = 0.0
                sub_data["reactive_power_flow_tertiary"] = 0.0

                sub_data["r_primary"] = Zr_p
                sub_data["x_primary"] = Zx_p
                sub_data["r_secondary"] = Zr_s
                sub_data["x_secondary"] = Zx_s
                sub_data["r_tertiary"] = Zr_t
                sub_data["x_tertiary"] = Zx_t

                sub_data["rating_primary"] =
                    min(transformer["RATA1"], transformer["RATB1"], transformer["RATC1"])
                sub_data["rating_secondary"] =
                    min(transformer["RATA2"], transformer["RATB2"], transformer["RATC2"])
                sub_data["rating_tertiary"] =
                    min(transformer["RATA3"], transformer["RATB3"], transformer["RATC3"])
                sub_data["rating"] = min(
                    sub_data["rating_primary"],
                    sub_data["rating_secondary"],
                    sub_data["rating_tertiary"],
                )

                sub_data["r_12"] = br_r12
                sub_data["x_12"] = br_x12
                sub_data["r_23"] = br_r23
                sub_data["x_23"] = br_x23
                sub_data["r_13"] = br_r31
                sub_data["x_13"] = br_x31
                if transformer["CM"] == 1
                    # Transform admittance to device per unit
                    mva_ratio_12 = sub_data["base_power_12"] / pm_data["baseMVA"]
                    Z_base_device_1 = transformer["NOMV1"]^2 / sub_data["base_power_12"]
                    Z_base_sys_1 =
                        _get_bus_value(transformer["I"], "base_kv", pm_data)^2 /
                        pm_data["baseMVA"]
                    if iszero(Z_base_device_1) # NOMV1 = 0.0: use the power ratios
                        sub_data["g"] = transformer["MAG1"] / mva_ratio_12
                        sub_data["b"] = transformer["MAG2"] / mva_ratio_12
                    else # NOMV1 could potentially be different than the bus_voltage, use impedance ratios
                        sub_data["g"] =
                            (transformer["MAG1"] / Z_base_sys_1) * Z_base_device_1
                        sub_data["b"] =
                            (transformer["MAG2"] / Z_base_sys_1) * Z_base_device_1
                    end
                else # CM=2: MAG1 are no load loss in Watts and MAG2 is the exciting current in pu, in device base.
                    G_pu = 1e-6 * transformer["MAG1"] / sub_data["base_power_12"]
                    B_pu = sqrt(transformer["MAG2"]^2 - G_pu^2)
                    sub_data["g"] = G_pu
                    sub_data["b"] = B_pu
                end
                sub_data["g"] = transformer["MAG1"] # M. conductance MAG1 is saved in "g"
                # If CM = 1 & MAG2 != 0 -> MAG2 < 0
                # If CM = 2 & MAG2 != 0 -> MAG2 > 0
                sub_data["b"] = transformer["MAG2"] # M. susceptance MAG2 is saved in "b"

                sub_data["primary_correction_table"] = transformer["TAB1"]
                sub_data["secondary_correction_table"] = transformer["TAB2"]
                sub_data["tertiary_correction_table"] = transformer["TAB3"]

                if transformer["CW"] == 1
                    sub_data["primary_turns_ratio"] = transformer["WINDV1"]
                    sub_data["secondary_turns_ratio"] = transformer["WINDV2"]
                    sub_data["tertiary_turns_ratio"] = transformer["WINDV3"]
                else
                    sub_data["primary_turns_ratio"] =
                        transformer["WINDV1"] / sub_data["base_voltage_primary"]
                    sub_data["secondary_turns_ratio"] =
                        transformer["WINDV2"] / sub_data["base_voltage_secondary"]
                    sub_data["tertiary_turns_ratio"] =
                        transformer["WINDV3"] / sub_data["base_voltage_tertiary"]
                end

                sub_data["circuit"] = strip(transformer["CKT"])

                sub_data["ext"] = Dict{String, Any}(
                    "psse_name" => transformer["NAME"],
                    "CW" => transformer["CW"],
                    "CZ" => transformer["CZ"],
                    "CM" => transformer["CM"],
                )

                sub_data["index"] = length(pm_data["3w_transformer"]) + 1

                if import_all
                    _import_remaining_keys!(
                        sub_data,
                        transformer;
                        exclude = [
                            "NAME",
                            "STAT",
                            "MAG1",
                            "MAG2",
                            "WINDV1",
                            "WINDV2",
                            "WINDV3",
                        ],
                    )
                end
                transformer3W_isolated_bus_modifications!(pm_data, sub_data)
                push!(pm_data["3w_transformer"], sub_data)

                starbus_id += 1 # after adding the 1st 3WT, increase the counter
            end
        end
    end
end

"""
    _psse2pm_dcline!(pm_data, pti_data)

Parses PSS(R)E-style Two-Terminal and VSC DC Lines data into a PowerModels
compatible Dict structure by first converting them to a simple DC Line Model.
For Two-Terminal DC lines, "source_id" is given by `["IPR", "IPI", "NAME"]` in the
PSS(R)E Two-Terminal DC specification. For Voltage Source Converters, "source_id"
is given by `["IBUS1", "IBUS2", "NAME"]`, where "IBUS1" is "IBUS" of the first
converter bus, and "IBUS2" is the "IBUS" of the second converter bus, in the
PSS(R)E Voltage Source Converter specification.
"""
function _psse2pm_dcline!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Two-Terminal and VSC DC line data into a PowerModels Dict..."
    pm_data["dcline"] = []
    pm_data["vscline"] = []
    baseMVA = pm_data["baseMVA"]

    if haskey(pti_data, "TWO-TERMINAL DC")
        for dcline in pti_data["TWO-TERMINAL DC"]
            sub_data = Dict{String, Any}()

            # Unit conversions?
            power_demand =
                if dcline["MDC"] == 1
                    abs(dcline["SETVL"])
                elseif dcline["MDC"] == 2
                    abs(dcline["SETVL"] * dcline["VSCHD"] / 1000) # Amp * V
                else
                    0
                end

            sub_data["transfer_setpoint"] = dcline["SETVL"]

            sub_data["name"] = dcline["NAME"]
            sub_data["f_bus"] = dcline["IPR"]
            sub_data["t_bus"] = dcline["IPI"]
            if pm_data["has_isolated_buses"]
                push!(pm_data["connected_buses"], sub_data["f_bus"])
                push!(pm_data["connected_buses"], sub_data["t_bus"])
            end

            if dcline["MDC"] == 1
                sub_data["power_mode"] = true
            else
                sub_data["power_mode"] = false
            end
            sub_data["available"] = dcline["MDC"] == 0 ? false : true
            sub_data["br_status"] = sub_data["available"]

            sub_data["scheduled_dc_voltage"] = dcline["VSCHD"]
            rectifier_base_voltage = dcline["EBASR"]
            if rectifier_base_voltage == 0
                throw(
                    ArgumentError(
                        "DC line $(sub_data["name"]): Rectifier base voltage EBASER cannot be 0",
                    ),
                )
            end
            ZbaseR = rectifier_base_voltage^2 / baseMVA
            sub_data["rectifier_bridges"] = dcline["NBR"]
            sub_data["rectifier_rc"] = dcline["RCR"] / ZbaseR
            sub_data["rectifier_xc"] = dcline["XCR"] / ZbaseR
            sub_data["rectifier_base_voltage"] = rectifier_base_voltage

            inverter_base_voltage = dcline["EBASI"]
            if inverter_base_voltage == 0
                throw(
                    ArgumentError(
                        "DC line $(sub_data["name"]): Inverter base voltage EBASI cannot be 0",
                    ),
                )
            end
            ZbaseI = inverter_base_voltage^2 / baseMVA
            sub_data["inverter_bridges"] = dcline["NBI"]
            sub_data["inverter_rc"] = dcline["RCI"] / ZbaseI
            sub_data["inverter_xc"] = dcline["XCI"] / ZbaseI
            sub_data["inverter_base_voltage"] = inverter_base_voltage

            sub_data["switch_mode_voltage"] = dcline["VCMOD"]
            sub_data["compounding_resistance"] = dcline["RCOMP"]
            sub_data["min_compounding_voltage"] = dcline["DCVMIN"]

            sub_data["rectifier_transformer_ratio"] = dcline["TRR"]
            sub_data["rectifier_tap_setting"] = dcline["TAPR"]
            sub_data["rectifier_tap_limits"] = (min = dcline["TMNR"], max = dcline["TMXR"])
            sub_data["rectifier_tap_step"] = dcline["STPR"]

            sub_data["inverter_transformer_ratio"] = dcline["TRI"]
            sub_data["inverter_tap_setting"] = dcline["TAPI"]
            sub_data["inverter_tap_limits"] = (min = dcline["TMNI"], max = dcline["TMXI"])
            sub_data["inverter_tap_step"] = dcline["STPI"]

            sub_data["loss0"] = 0.0
            sub_data["loss1"] = 0.0

            sub_data["pf"] = power_demand
            sub_data["active_power_flow"] = sub_data["pf"]
            sub_data["pt"] = power_demand
            sub_data["qf"] = 0.0
            sub_data["qt"] = 0.0
            sub_data["vf"] = _get_bus_value(pop!(dcline, "IPR"), "vm", pm_data)
            sub_data["vt"] = _get_bus_value(pop!(dcline, "IPI"), "vm", pm_data)

            sub_data["pminf"] = 0.0
            sub_data["pmaxf"] = dcline["SETVL"] > 0 ? power_demand : -power_demand
            sub_data["pmint"] = pop!(dcline, "SETVL") > 0 ? -power_demand : power_demand
            sub_data["pmaxt"] = 0.0

            anmn = []
            for key in ["ANMNR", "ANMNI"]
                if abs(dcline[key]) <= 90.0
                    push!(anmn, dcline[key])
                else
                    push!(anmn, 0)
                    @info("$key outside reasonable limits, setting to 0 degress")
                end
            end
            sub_data["rectifier_delay_angle_limits"] =
                (min = deg2rad(anmn[1]), max = deg2rad(dcline["ANMXR"]))
            sub_data["inverter_extinction_angle_limits"] =
                (min = deg2rad(anmn[2]), max = deg2rad(dcline["ANMXI"]))

            sub_data["rectifier_delay_angle"] = deg2rad(anmn[1])
            sub_data["inverter_extinction_angle"] = deg2rad(anmn[2])

            sub_data["qmaxf"] = 0.0
            sub_data["qmaxt"] = 0.0
            sub_data["qminf"] =
                -max(abs(sub_data["pminf"]), abs(sub_data["pmaxf"])) * cosd(anmn[1])
            sub_data["qmint"] =
                -max(abs(sub_data["pmint"]), abs(sub_data["pmaxt"])) * cosd(anmn[2])

            sub_data["active_power_limits_from"] =
                (min = sub_data["pminf"], max = sub_data["pmaxf"])
            sub_data["active_power_limits_to"] =
                (min = sub_data["pmint"], max = sub_data["pmaxt"])
            sub_data["reactive_power_limits_from"] =
                (min = sub_data["qminf"], max = sub_data["qmaxf"])
            sub_data["reactive_power_limits_to"] =
                (min = sub_data["qmint"], max = sub_data["qmaxt"])

            sub_data["rectifier_capacitor_reactance"] = dcline["XCAPR"] / ZbaseR
            sub_data["inverter_capacitor_reactance"] = dcline["XCAPI"] / ZbaseI
            sub_data["r"] = dcline["RDC"] / ZbaseR

            sub_data["source_id"] = [
                "two-terminal dc",
                sub_data["f_bus"],
                sub_data["t_bus"],
                pop!(dcline, "NAME"),
            ]
            sub_data["index"] = length(pm_data["dcline"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, dcline)
            end
            branch_isolated_bus_modifications!(pm_data, sub_data)
            push!(pm_data["dcline"], sub_data)
        end
    end

    if haskey(pti_data, "VOLTAGE SOURCE CONVERTER")
        @info(
            "VSC-HVDC lines are supported via a dc line model approximated by two generators and an associated loss."
        )
        for dcline in pti_data["VOLTAGE SOURCE CONVERTER"]
            # Converter buses : is the distinction between ac and dc side meaningful?
            from_bus, to_bus = dcline["CONVERTER BUSES"]

            # PowerWorld conversion from PTI to matpower seems to create two
            # artificial generators from a VSC, but it is not clear to me how
            # the value of "pg" is determined and adds shunt to the DC-side bus.
            sub_data = Dict{String, Any}()
            sub_data["name"] = dcline["NAME"]

            # VSC intended to be one or bi-directional?
            sub_data["f_bus"] = from_bus["IBUS"]
            sub_data["t_bus"] = to_bus["IBUS"]
            if pm_data["has_isolated_buses"]
                push!(pm_data["connected_buses"], sub_data["f_bus"])
                push!(pm_data["connected_buses"], sub_data["t_bus"])
            end
            sub_data["br_status"] =
                if dcline["MDC"] == 0 ||
                   from_bus["TYPE"] == 0 ||
                   to_bus["TYPE"] == 0
                    0
                else
                    1
                end
            sub_data["available"] = sub_data["br_status"] == 0 ? false : true

            sub_data["dc_voltage_control_from"] = from_bus["TYPE"] == 1 ? true : false
            sub_data["dc_voltage_control_to"] = to_bus["TYPE"] == 1 ? true : false
            sub_data["ac_voltage_control_from"] = from_bus["MODE"] == 1 ? true : false
            sub_data["ac_voltage_control_to"] = to_bus["MODE"] == 1 ? true : false

            sub_data["dc_setpoint_from"] = from_bus["DCSET"]
            sub_data["dc_setpoint_to"] = to_bus["DCSET"]
            sub_data["ac_setpoint_from"] = from_bus["ACSET"]
            sub_data["ac_setpoint_to"] = to_bus["ACSET"]

            # ALOSS, MINLOSS in kW, and BLOSS in kW/A. Divide by a 1000 to transform into MW, and divide by baseMVA to normalize to per-unit.
            sub_data["converter_loss_from"] = LinearCurve(
                from_bus["BLOSS"] / (1000.0 * baseMVA),
                (from_bus["ALOSS"] + from_bus["MINLOSS"]) / (1000.0 * baseMVA),
            )
            sub_data["converter_loss_to"] = LinearCurve(
                to_bus["BLOSS"] / (1000.0 * baseMVA),
                (to_bus["ALOSS"] + to_bus["MINLOSS"]) / (1000.0 * baseMVA),
            )

            sub_data["pf"] = 0.0
            sub_data["pt"] = 0.0

            sub_data["qf"] = 0.0
            sub_data["qt"] = 0.0

            sub_data["qminf"] = from_bus["MINQ"] / baseMVA
            sub_data["qmaxf"] = from_bus["MAXQ"] / baseMVA
            sub_data["qmint"] = to_bus["MINQ"] / baseMVA
            sub_data["qmaxt"] = to_bus["MAXQ"] / baseMVA

            PTI_INF = 9999.0

            sub_data["rating_from"] =
                from_bus["SMAX"] == 0.0 ? PTI_INF : from_bus["SMAX"] / baseMVA
            sub_data["rating_to"] =
                to_bus["SMAX"] == 0.0 ? PTI_INF : to_bus["SMAX"] / baseMVA
            sub_data["rating"] = min(sub_data["rating_from"], sub_data["rating_to"])
            sub_data["max_dc_current_from"] =
                from_bus["IMAX"] == 0.0 ? PTI_INF : from_bus["IMAX"]
            sub_data["max_dc_current_to"] = to_bus["IMAX"] == 0.0 ? PTI_INF : to_bus["IMAX"]
            sub_data["power_factor_weighting_fraction_from"] = from_bus["PWF"]
            sub_data["power_factor_weighting_fraction_to"] = to_bus["PWF"]
            qmax_from = max(abs(sub_data["qminf"]), abs(sub_data["qmaxf"]))
            qmax_to = max(abs(sub_data["qmint"]), abs(sub_data["qmaxt"]))
            sub_data["pmaxf"] = sqrt(sub_data["rating_from"]^2 - qmax_from^2)
            sub_data["pmaxt"] = sqrt(sub_data["rating_to"]^2 - qmax_to^2)
            sub_data["pminf"] = -sub_data["pmaxf"]
            sub_data["pmint"] = -sub_data["pmaxt"]

            if sub_data["dc_voltage_control_from"] && !sub_data["dc_voltage_control_to"]
                base_voltage = sub_data["dc_setpoint_from"]
                flow_setpoint = sub_data["dc_setpoint_to"]
            elseif !sub_data["dc_voltage_control_from"] && sub_data["dc_voltage_control_to"]
                base_voltage = sub_data["dc_setpoint_to"]
                flow_setpoint = -sub_data["dc_setpoint_from"]
            else
                error(
                    "At least one converter in converter $(sub_data["name"]) must set a voltage control.",
                )
            end
            Zbase = base_voltage^2 / baseMVA
            sub_data["r"] = dcline["RDC"] / Zbase
            sub_data["pf"] = flow_setpoint / baseMVA
            sub_data["if"] = 1000.0 * (flow_setpoint / base_voltage)

            sub_data["EXT"] = Dict{String, Any}(
                "REMOT_FROM" => from_bus["REMOT"],
                "REMOT_TO" => to_bus["REMOT"],
                "RMPCT_FROM" => from_bus["RMPCT"],
                "RMPCT_TO" => to_bus["RMPCT"],
            )

            sub_data["source_id"] =
                ["vsc dc", sub_data["f_bus"], sub_data["t_bus"], dcline["NAME"]]
            sub_data["index"] = length(pm_data["vscline"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, dcline)

                for cb in sub_data["converter buses"]
                    for (k, v) in cb
                        cb[lowercase(k)] = v
                        delete!(cb, k)
                    end
                end
            end
            branch_isolated_bus_modifications!(pm_data, sub_data)
            push!(pm_data["vscline"], sub_data)
        end
    end
end

function _psse2pm_facts!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E FACTs devices data into a PowerModels Dict..."
    pm_data["facts"] = []

    if haskey(pti_data, "FACTS CONTROL DEVICE")
        for facts in pti_data["FACTS CONTROL DEVICE"]
            @info(
                """FACTs are supported via a simplification approach for terminal_bus = 0 (STATCOM operation)"""
            )
            sub_data = Dict{String, Any}()

            sub_data["name"] = facts["NAME"]
            sub_data["control_mode"] = facts["MODE"]

            # MODE = 0 -> Unavailable
            # MODE = 1 -> Normal mode
            # MODE = 2 -> Link bypassed
            if facts["MODE"] != 0
                sub_data["available"] = 1
            else
                sub_data["available"] = 0
            end

            sub_data["bus"] = facts["I"]  # Sending end bus number
            sub_data["tbus"] = facts["J"] # Terminal end bus number

            sub_data["voltage_setpoint"] = facts["VSET"]
            sub_data["max_shunt_current"] = facts["SHMX"]

            # % of MVAr required to hold voltage at sending bus
            if facts["RMPCT"] < 0
                @warn "% MVAr required must me positive."
            end

            sub_data["reactive_power_required"] = facts["RMPCT"]

            sub_data["source_id"] =
                ["facts", sub_data["bus"], sub_data["name"]]
            sub_data["index"] = length(pm_data["facts"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, facts)
            end
            device_bus_number = sub_data["bus"]
            bus = pm_data["bus"][device_bus_number]
            if bus["bus_type"] == 4
                push!(pm_data["isolated_to_pq_buses"], device_bus_number)
                bus["bus_status"] = false
                sub_data["available"] = false
            end

            push!(pm_data["facts"], sub_data)
        end
    end
    return
end

function _build_switch_breaker_sub_data(
    pm_data::Dict,
    branch::Dict,
    branch_type::String,
    discrete_branch_type::Int,
    index::Int,
)
    sub_data = Dict{String, Any}()

    sub_data["f_bus"] = pop!(branch, "I")
    sub_data["t_bus"] = pop!(branch, "J")
    if pm_data["has_isolated_buses"]
        push!(pm_data["connected_buses"], sub_data["f_bus"])
        push!(pm_data["connected_buses"], sub_data["t_bus"])
    end
    sub_data["r"] = pop!(branch, "R")
    sub_data["x"] = pop!(branch, "X")
    sub_data["state"] = pop!(branch, "ST")
    sub_data["active_power_flow"] = 0.0
    sub_data["reactive_power_flow"] = 0.0
    sub_data["psw"] = sub_data["active_power_flow"]
    sub_data["qsw"] = sub_data["reactive_power_flow"]
    sub_data["rating"] = pop!(branch, "RATEA")
    sub_data["discrete_branch_type"] = discrete_branch_type
    sub_data["source_id"] =
        [branch_type, sub_data["f_bus"], sub_data["t_bus"], branch["CKT"]]
    sub_data["index"] = index

    return sub_data
end

function _psse2pm_switch_breaker!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Switches & Breakers data into a PowerModels Dict..."
    pm_data["breaker"] = []
    pm_data["switch"] = []
    mapping = Dict('@' => ("breaker", 1), '*' => ("switch", 0))

    if haskey(pti_data, "BRANCH")
        for branch in pti_data["BRANCH"]
            branch_init = first(branch["CKT"])

            # Check if character is in the mapping
            if haskey(mapping, branch_init)
                branch_type, discrete_branch_type = mapping[branch_init]

                sub_data = _build_switch_breaker_sub_data(
                    pm_data,
                    branch,
                    branch_type,
                    discrete_branch_type,
                    length(pm_data[branch_type]) + 1,
                )

                if import_all
                    _import_remaining_keys!(sub_data, branch)
                end
                branch_isolated_bus_modifications!(pm_data, sub_data)
                push!(pm_data[branch_type], sub_data)
            end
        end
    end
    return
end

function _psse2pm_multisection_line!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Multi-section Lines data into a PowerModels Dict..."

    # Lookup for branches status (br_status)
    branch_status_lookup = Dict{Tuple{Int, Int, String}, Int}()
    if haskey(pm_data, "branch")
        for branch in pm_data["branch"]
            branch_id = branch["source_id"][end]
            branch_status_lookup[(branch["f_bus"], branch["t_bus"], branch_id)] =
                branch["br_status"]
        end
    end

    pm_data["multisection_line"] = []

    if haskey(pti_data, "MULTI-SECTION LINE")
        for multisec_line in pti_data["MULTI-SECTION LINE"]
            sub_data = Dict{String, Any}()

            sub_data["f_bus"] = pop!(multisec_line, "I")
            sub_data["t_bus"] = pop!(multisec_line, "J")
            if pm_data["has_isolated_buses"]
                push!(pm_data["connected_buses"], sub_data["f_bus"])
                push!(pm_data["connected_buses"], sub_data["t_bus"])
            end
            sub_data["id"] = pop!(multisec_line, "ID")
            sub_data["section_number"] = pop!(multisec_line, "MET")

            dummy_buses =
                Dict(k => v for (k, v) in multisec_line if startswith(k, "DUM") && v != "")
            sub_data["ext"] = dummy_buses

            # Check if the multisection line is available based on branch status
            # Multi-section lines are treated as a single entity regarding its status
            sub_data["available"] =
                get(
                    branch_status_lookup,
                    (sub_data["f_bus"], sub_data["t_bus"], sub_data["id"]),
                    1,
                ) == 1
            sub_data["source_id"] =
                ["multisection_line", sub_data["f_bus"], sub_data["t_bus"]]
            sub_data["index"] = length(pm_data["multisection_line"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, multisec_line)
            end
            # If from or to bus is isolated, make multi-section line unavailabe:
            bus_data = pm_data["bus"]
            from_bus_no = sub_data["f_bus"]
            to_bus_no = sub_data["t_bus"]
            from_bus = bus_data[from_bus_no]
            to_bus = bus_data[to_bus_no]
            if from_bus["bus_type"] == 4 || to_bus["bus_type"] == 4
                sub_data["available"] = 0
            end
            if from_bus["bus_type"] == 4
                push!(pm_data["isolated_to_pq_buses"], from_bus_no)
                from_bus["bus_status"] = false
            end
            if to_bus["bus_type"] == 4
                push!(pm_data["isolated_to_pq_buses"], to_bus_no)
                to_bus["bus_status"] = false
            end

            push!(pm_data["multisection_line"], sub_data)
        end
    end
    return
end

function sort_values_by_key_prefix(imp_correction::Dict{String, <:Any}, prefix::String)
    sorted_values = [
        last(pair) for pair in sort(
            [
                (parse(Int, k[2:end]), v) for
                (k, v) in imp_correction if startswith(k, prefix)
            ];
            by = first,
        )
    ]

    first_non_zero_index = findfirst(x -> x != 0.0, reverse(sorted_values))
    sorted_values = sorted_values[1:(length(sorted_values) - first_non_zero_index + 1)]

    return sorted_values
end

function _psse2pm_impedance_correction!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Transformer Impedance Correction Tables data into a PowerModels Dict..."

    pm_data["impedance_correction"] = []

    if haskey(pti_data, "IMPEDANCE CORRECTION")
        for imp_correction in pti_data["IMPEDANCE CORRECTION"]
            sub_data = Dict{String, Any}()

            sub_data["table_number"] = imp_correction["I"]

            sub_data["scaling_factor"] = sort_values_by_key_prefix(imp_correction, "F")
            sub_data["tap_or_angle"] = sort_values_by_key_prefix(imp_correction, "T")

            sub_data["index"] = length(pm_data["impedance_correction"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, imp_correction)
            end

            push!(pm_data["impedance_correction"], sub_data)
        end
    end
    return
end

function _psse2pm_storage!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @warn "This PSS(R)E parser currently doesn't support Storage data parsing..."
    pm_data["storage"] = []
    return
end

"""
    _pti_to_powermodels!(pti_data)

Converts PSS(R)E-style data parsed from a PTI raw file, passed by `pti_data`
into a format suitable for use internally in PowerModels. Imports all remaining
data from the PTI file if `import_all` is true (Default: false).
"""
function _pti_to_powermodels!(
    pti_data::Dict;
    import_all = false,
    validate = true,
    correct_branch_rating = true,
)::Dict
    pm_data = Dict{String, Any}()

    rev = pop!(pti_data["CASE IDENTIFICATION"][1], "REV")

    pm_data["per_unit"] = false
    pm_data["source_type"] = "pti"
    pm_data["source_version"] = "$rev"
    pm_data["baseMVA"] = pop!(pti_data["CASE IDENTIFICATION"][1], "SBASE")
    pm_data["name"] = pop!(pti_data["CASE IDENTIFICATION"][1], "NAME")

    if import_all
        _import_remaining_keys!(pm_data, pti_data["CASE IDENTIFICATION"][1])
    end

    _psse2pm_interarea_transfer!(pm_data, pti_data, import_all)
    _psse2pm_area_interchange!(pm_data, pti_data, import_all)
    _psse2pm_zone!(pm_data, pti_data, import_all)
    _psse2pm_bus!(pm_data, pti_data, import_all)
    _psse2pm_load!(pm_data, pti_data, import_all)
    _psse2pm_shunt!(pm_data, pti_data, import_all)
    _psse2pm_generator!(pm_data, pti_data, import_all)
    _psse2pm_facts!(pm_data, pti_data, import_all)
    _psse2pm_switch_breaker!(pm_data, pti_data, import_all)
    _psse2pm_multisection_line!(pm_data, pti_data, import_all)
    _psse2pm_branch!(pm_data, pti_data, import_all)
    _psse2pm_transformer!(pm_data, pti_data, import_all)
    _psse2pm_dcline!(pm_data, pti_data, import_all)
    _psse2pm_impedance_correction!(pm_data, pti_data, import_all)
    _psse2pm_storage!(pm_data, pti_data, import_all)

    if pm_data["has_isolated_buses"]
        bus_numbers = [v["bus_i"] for (_, v) in pm_data["bus"]]
        topologically_isolated_buses = setdiff(Set(bus_numbers), pm_data["connected_buses"])
        convert_to_pq =
            setdiff(pm_data["isolated_to_pq_buses"], pm_data["isolated_to_pv_buses"])
        convert_to_pv = pm_data["isolated_to_pv_buses"]
        for b in convert_to_pq
            pm_data["bus"][b]["bus_type"] = 1
        end
        for b in convert_to_pv
            pm_data["bus"][b]["bus_type"] = 2
        end
        if !isempty(topologically_isolated_buses)
            @error "PSEE data file contains topologically isolated buses (numbers $(topologically_isolated_buses)) that are disconnected from the system. This does not include buses that are set to isolated to make components unavailable, and likely indicates an error in the data."
            for b in topologically_isolated_buses
                pm_data["bus"][b]["bus_type"] = 4
            end
        end
    end
    if import_all
        _import_remaining_comps!(
            pm_data,
            pti_data;
            exclude = [
                "CASE IDENTIFICATION",
                "BUS",
                "LOAD",
                "FIXED SHUNT",
                "SWITCHED SHUNT",
                "GENERATOR",
                "BRANCH",
                "TRANSFORMER",
                "TWO-TERMINAL DC",
                "VOLTAGE SOURCE CONVERTER",
            ],
        )
    end

    # update lookup structure
    for (k, v) in pm_data
        if isa(v, Array)
            dict = Dict{String, Any}()
            for item in v
                @assert("index" in keys(item))
                dict[string(item["index"])] = item
            end
            pm_data[k] = dict
        end
    end

    if validate
        correct_network_data!(pm_data; correct_branch_rating = correct_branch_rating)
    end

    return pm_data
end

"""
    parse_psse(filename::String; kwargs...)::Dict

Parses directly from file
"""
function parse_psse(filename::String; kwargs...)::Dict
    pm_data = open(filename) do f
        parse_psse(f; kwargs...)
    end

    return pm_data
end

"""
    function parse_psse(io::IO; kwargs...)::Dict

Parses directly from iostream
"""
function parse_psse(io::IO; kwargs...)::Dict
    @info(
        "The PSS(R)E parser currently supports buses, loads, shunts, generators, branches, switches, breakers, transformers, facts, and dc lines",
    )
    pti_data = parse_pti(io)
    pm = _pti_to_powermodels!(pti_data; kwargs...)
    return pm
end
