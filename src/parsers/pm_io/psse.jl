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
    if transformer["STAT"] == 0
        bus_type = 4
    end

    starbus["vm"] = transformer["VMSTAR"]
    starbus["va"] = transformer["ANSTAR"]
    starbus["bus_type"] = bus_type
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
        for (i, branch) in enumerate(pti_data["BRANCH"])
            sub_data = Dict{String, Any}()

            sub_data["f_bus"] = pop!(branch, "I")
            sub_data["t_bus"] = pop!(branch, "J")
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

            sub_data["source_id"] =
                ["branch", sub_data["f_bus"], sub_data["t_bus"], pop!(branch, "CKT")]
            sub_data["index"] = i

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

            push!(pm_data["branch"], sub_data)
        end
    end
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

            pm_data["gen"][ix] = sub_data
        end
    else
        pm_data["gen"] = Vector{Dict{String, Any}}()
    end
end

"""
    _psse2pm_bus!(pm_data, pti_data)

Parses PSS(R)E-style Bus data into a PowerModels-style Dict. "source_id" is given
by ["I", "NAME"] in PSS(R)E Bus specification.
"""
function _psse2pm_bus!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Bus data into a PowerModels Dict..."
    pm_data["bus"] = Dict{Int, Any}()
    if haskey(pti_data, "BUS")
        for bus in pti_data["BUS"]
            sub_data = Dict{String, Any}()

            sub_data["bus_i"] = bus["I"]
            sub_data["bus_type"] = pop!(bus, "IDE")
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
            sub_data["source_id"] = ["load", sub_data["load_bus"], pop!(load, "ID")]
            sub_data["status"] = pop!(load, "STATUS")
            sub_data["index"] = length(pm_data["load"]) + 1
            if import_all
                _import_remaining_keys!(sub_data, load)
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
    @info "Parsing PSS(R)E Shunt data into a PowerModels Dict..."

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

            push!(pm_data["shunt"], sub_data)
        end
    end

    pm_data["switched_shunt"] = []
    if haskey(pti_data, "SWITCHED SHUNT")
        @info("Switched shunt converted to fixed shunt, with default value gs=0.0")

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

            y_increment = Dict(
                k => v for
                (k, v) in switched_shunt if startswith(k, "B") && isdigit(last(k))
            )
            y_increment_sorted =
                sort(collect(keys(y_increment)); by = x -> parse(Int, x[2:end]))
            sub_data["y_increment"] = [y_increment[k] for k in y_increment_sorted]

            sub_data["source_id"] =
                ["switched shunt", sub_data["shunt_bus"], pop!(switched_shunt, "SWREM")]
            sub_data["index"] = length(pm_data["switched_shunt"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, switched_shunt)
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

                # Unit Transformations
                if transformer["CZ"] == 1  # "for resistance and reactance in pu on system MVA base and winding voltage base"
                    br_r, br_x = transformer["R1-2"], transformer["X1-2"]
                else  # NOT "for resistance and reactance in pu on system MVA base and winding voltage base"
                    if transformer["CZ"] == 3  # "for transformer load loss in watts and impedance magnitude in pu on a specified MVA base and winding voltage base."
                        br_r = 1e-6 * transformer["R1-2"] / transformer["SBASE1-2"]
                        br_x = sqrt(transformer["X1-2"]^2 - br_r^2)
                    else
                        br_r, br_x = transformer["R1-2"], transformer["X1-2"]
                    end
                    per_unit_factor =
                        (
                            transformer["NOMV1"]^2 /
                            _get_bus_value(transformer["I"], "base_kv", pm_data)^2
                        ) * (pm_data["baseMVA"] / transformer["SBASE1-2"])
                    if per_unit_factor == 0
                        @warn "Per unit conversion for transformer $(sub_data["f_bus"]) -> $(sub_data["t_bus"]) couldn't be done, assuming system base instead. Check field NOMV1 is valid"
                        per_unit_factor = 1
                    end
                    br_r *= per_unit_factor
                    br_x *= per_unit_factor
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

                sub_data["g_fr"] = pop!(transformer, "MAG1")
                sub_data["b_fr"] = pop!(transformer, "MAG2")
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

                sub_data["tap"] = pop!(transformer, "WINDV1") / pop!(transformer, "WINDV2")
                sub_data["shift"] = pop!(transformer, "ANG1")

                # Unit Transformations
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
                sub_data["transformer"] = true
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

                # Create 3 branches from a three winding transformer (one for each winding, which will each connect to the starbus)
                br_r12, br_r23, br_r31 =
                    transformer["R1-2"], transformer["R2-3"], transformer["R3-1"]
                br_x12, br_x23, br_x31 =
                    transformer["X1-2"], transformer["X2-3"], transformer["X3-1"]

                # Unit Transformations
                if transformer["CZ"] == 3  # "for transformer load loss in watts and impedance magnitude in pu on a specified MVA base and winding voltage base."
                    br_r12 *= 1e-6 / transformer["SBASE1-2"]
                    br_r23 *= 1e-6 / transformer["SBASE2-3"]
                    br_r31 *= 1e-6 / transformer["SBASE3-1"]

                    br_x12 = sqrt(br_x12^2 - br_r12^2)
                    br_x23 = sqrt(br_x23^2 - br_r23^2)
                    br_x31 = sqrt(br_x31^2 - br_r31^2)
                end

                # Unit Transformations
                if transformer["CZ"] != 1  # NOT "for resistance and reactance in pu on system MVA base and winding voltage base"
                    br_r12 *=
                        (
                            transformer["NOMV1"] /
                            _get_bus_value(bus_id1, "base_kv", pm_data)
                        )^2 * (pm_data["baseMVA"] / transformer["SBASE1-2"])
                    br_r23 *=
                        (
                            transformer["NOMV2"] /
                            _get_bus_value(bus_id2, "base_kv", pm_data)
                        )^2 * (pm_data["baseMVA"] / transformer["SBASE2-3"])
                    br_r31 *=
                        (
                            transformer["NOMV3"] /
                            _get_bus_value(bus_id3, "base_kv", pm_data)
                        )^2 * (pm_data["baseMVA"] / transformer["SBASE3-1"])

                    br_x12 *=
                        (
                            transformer["NOMV1"] /
                            _get_bus_value(bus_id1, "base_kv", pm_data)
                        )^2 * (pm_data["baseMVA"] / transformer["SBASE1-2"])
                    br_x23 *=
                        (
                            transformer["NOMV2"] /
                            _get_bus_value(bus_id2, "base_kv", pm_data)
                        )^2 * (pm_data["baseMVA"] / transformer["SBASE2-3"])
                    br_x31 *=
                        (
                            transformer["NOMV3"] /
                            _get_bus_value(bus_id3, "base_kv", pm_data)
                        )^2 * (pm_data["baseMVA"] / transformer["SBASE3-1"])
                end

                # See "Power System Stability and Control", ISBN: 0-07-035958-X, Eq. 6.72
                Zr_p = 1 / 2 * (br_r12 - br_r23 + br_r31)
                Zr_s = 1 / 2 * (br_r23 - br_r31 + br_r12)
                Zr_t = 1 / 2 * (br_r31 - br_r12 + br_r23)
                Zx_p = 1 / 2 * (br_x12 - br_x23 + br_x31)
                Zx_s = 1 / 2 * (br_x23 - br_x31 + br_x12)
                Zx_t = 1 / 2 * (br_x31 - br_x12 + br_x23)

                # Add parameters to the 3w-transformer key 
                sub_data = Dict{String, Any}()
                sub_data["name"] = transformer["NAME"]

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

                sub_data["primary_secondary_arc"] = 0.0
                sub_data["secondary_tertiary_arc"] = 0.0
                sub_data["primary_tertiary_arc"] = 0.0
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
                sub_data["g"] = transformer["MAG1"]
                sub_data["b"] = transformer["MAG2"]

                if transformer["CW"] == 1
                    sub_data["primary_turns_ratio"] = transformer["WINDV1"]
                    sub_data["secondary_turns_ratio"] = transformer["WINDV2"]
                    sub_data["tertiary_turns_ratio"] = transformer["WINDV3"]
                else
                    sub_data["primary_turns_ratio"] = 1.0
                    sub_data["secondary_turns_ratio"] = 1.0
                    sub_data["tertiary_turns_ratio"] = 1.0
                end

                sub_data["circuit"] = transformer["CKT"]

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

                push!(pm_data["3w_transformer"], sub_data)

                starbus_id += 1 # after adding the 1st 3WT, increase the counter

                # Build each of the three transformer branches
                for (m, (bus_id, br_r, br_x)) in enumerate(
                    zip(
                        [bus_id1, bus_id2, bus_id3],
                        [Zr_p, Zr_s, Zr_t],
                        [Zx_p, Zx_s, Zx_t],
                    ),
                )
                    sub_data = Dict{String, Any}()

                    sub_data["f_bus"] = bus_id
                    sub_data["t_bus"] = starbus["bus_i"]

                    sub_data["br_r"] = br_r
                    sub_data["br_x"] = br_x

                    sub_data["g_fr"] = m == 1 ? pop!(transformer, "MAG1") : 0.0
                    sub_data["b_fr"] = m == 1 ? pop!(transformer, "MAG2") : 0.0
                    sub_data["g_to"] = 0.0
                    sub_data["b_to"] = 0.0

                    sub_data["rate_a"] = pop!(transformer, "RATA$m")
                    sub_data["rate_b"] = pop!(transformer, "RATB$m")
                    sub_data["rate_c"] = pop!(transformer, "RATC$m")

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
                        sub_data["windv$m"] = transformer["WINDV$m"]
                        #sub_data["windvs"] = 1.0
                        sub_data["nomv$m"] = transformer["NOMV$m"]
                    end

                    sub_data["tap"] = pop!(transformer, "WINDV$m")
                    sub_data["shift"] = pop!(transformer, "ANG$m")

                    # Unit Transformations
                    if transformer["CW"] != 1  # NOT "for off-nominal turns ratio in pu of winding bus base voltage"
                        sub_data["tap"] /= _get_bus_value(bus_id, "base_kv", pm_data)
                        if transformer["CW"] == 3  # "for off-nominal turns ratio in pu of nominal winding voltage, NOMV1, NOMV2 and NOMV3."
                            sub_data["tap"] *= transformer["NOMV$m"]
                        end
                    end

                    if import_all
                        sub_data["cw"] = transformer["CW"]
                    end

                    sub_data["br_status"] = 1
                    if transformer["STAT"] == 0
                        sub_data["br_status"] = 0
                    elseif transformer["STAT"] == 2 && m == 2
                        sub_data["br_status"] = 0
                    elseif transformer["STAT"] == 3 && m == 3
                        sub_data["br_status"] = 0
                    elseif transformer["STAT"] == 4 && m == 1
                        sub_data["br_status"] = 0
                    end

                    sub_data["angmin"] = 0.0
                    sub_data["angmax"] = 0.0

                    sub_data["source_id"] = [
                        "transformer",
                        transformer["I"],
                        transformer["J"],
                        transformer["K"],
                        transformer["CKT"],
                        m,
                    ]
                    sub_data["transformer"] = true
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
                                "CKT",
                                "SBASE3-1",
                                "MAG1",
                                "MAG2",
                                "STAT",
                                "NOMV1",
                                "NOMV2",
                                "NOMV3",
                                "WINDV1",
                                "WINDV2",
                                "WINDV3",
                                "RATA1",
                                "RATA2",
                                "RATA3",
                                "RATB1",
                                "RATB2",
                                "RATB3",
                                "RATC1",
                                "RATC2",
                                "RATC3",
                                "ANG1",
                                "ANG2",
                                "ANG3",
                            ],
                        )
                    end
                end
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

    if haskey(pti_data, "TWO-TERMINAL DC")
        for dcline in pti_data["TWO-TERMINAL DC"]
            @info(
                "Two-Terminal DC lines are supported via a simple *lossless* dc line model approximated by two generators."
            )
            sub_data = Dict{String, Any}()

            # Unit conversions?
            power_demand =
                if dcline["MDC"] == 1
                    abs(dcline["SETVL"])
                elseif dcline["MDC"] == 2
                    abs(dcline["SETVL"] / pop!(dcline, "VSCHD") / 1000)
                else
                    0
                end

            sub_data["f_bus"] = dcline["IPR"]
            sub_data["t_bus"] = dcline["IPI"]
            sub_data["br_status"] = pop!(dcline, "MDC") == 0 ? 0 : 1
            sub_data["pf"] = power_demand
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
                    push!(anmn, pop!(dcline, key))
                else
                    push!(anmn, 0)
                    @info("$key outside reasonable limits, setting to 0 degress")
                end
            end

            sub_data["qmaxf"] = 0.0
            sub_data["qmaxt"] = 0.0
            sub_data["qminf"] =
                -max(abs(sub_data["pminf"]), abs(sub_data["pmaxf"])) * cosd(anmn[1])
            sub_data["qmint"] =
                -max(abs(sub_data["pmint"]), abs(sub_data["pmaxt"])) * cosd(anmn[2])

            # Can we use "number of bridges in series (NBR/NBI)" to compute a loss?
            sub_data["loss0"] = 0.0
            sub_data["loss1"] = 0.0

            # Costs (set to default values)
            sub_data["startup"] = 0.0
            sub_data["shutdown"] = 0.0
            sub_data["ncost"] = 3
            sub_data["cost"] = [0.0, 0.0, 0.0]
            sub_data["model"] = 2

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

            push!(pm_data["dcline"], sub_data)
        end
    end

    if haskey(pti_data, "VOLTAGE SOURCE CONVERTER")
        @info(
            "VSC-HVDC lines are supported via a dc line model approximated by two generators and an associated loss."
        )
        for dcline in pti_data["VOLTAGE SOURCE CONVERTER"]
            # Converter buses : is the distinction between ac and dc side meaningful?
            dcside, acside = dcline["CONVERTER BUSES"]

            # PowerWorld conversion from PTI to matpower seems to create two
            # artificial generators from a VSC, but it is not clear to me how
            # the value of "pg" is determined and adds shunt to the DC-side bus.
            sub_data = Dict{String, Any}()

            # VSC intended to be one or bi-directional?
            sub_data["f_bus"] = pop!(dcside, "IBUS")
            sub_data["t_bus"] = pop!(acside, "IBUS")
            sub_data["br_status"] =
                if pop!(dcline, "MDC") == 0 ||
                   pop!(dcside, "TYPE") == 0 ||
                   pop!(acside, "TYPE") == 0
                    0
                else
                    1
                end

            sub_data["pf"] = 0.0
            sub_data["pt"] = 0.0

            sub_data["qf"] = 0.0
            sub_data["qt"] = 0.0

            sub_data["vf"] = pop!(dcside, "MODE") == 1 ? pop!(dcside, "ACSET") : 1.0
            sub_data["vt"] = pop!(acside, "MODE") == 1 ? pop!(acside, "ACSET") : 1.0

            sub_data["pmaxf"] =
                if dcside["SMAX"] == 0.0 && dcside["IMAX"] == 0.0
                    max(abs(dcside["MAXQ"]), abs(dcside["MINQ"]))
                else
                    min(pop!(dcside, "IMAX"), pop!(dcside, "SMAX"))
                end
            sub_data["pmaxt"] =
                if acside["SMAX"] == 0.0 && acside["IMAX"] == 0.0
                    max(abs(acside["MAXQ"]), abs(acside["MINQ"]))
                else
                    min(pop!(acside, "IMAX"), pop!(acside, "SMAX"))
                end
            sub_data["pminf"] = -sub_data["pmaxf"]
            sub_data["pmint"] = -sub_data["pmaxt"]

            sub_data["qminf"] = pop!(dcside, "MINQ")
            sub_data["qmaxf"] = pop!(dcside, "MAXQ")
            sub_data["qmint"] = pop!(acside, "MINQ")
            sub_data["qmaxt"] = pop!(acside, "MAXQ")

            sub_data["loss0"] =
                (
                    pop!(dcside, "ALOSS") +
                    pop!(acside, "ALOSS") +
                    pop!(dcside, "MINLOSS") +
                    pop!(acside, "MINLOSS")
                ) * 1e-3
            sub_data["loss1"] = (pop!(dcside, "BLOSS") + pop!(acside, "BLOSS")) * 1e-3 # how to include resistance?

            # Costs (set to default values)
            sub_data["startup"] = 0.0
            sub_data["shutdown"] = 0.0
            sub_data["ncost"] = 3
            sub_data["cost"] = [0.0, 0.0, 0.0]
            sub_data["model"] = 2

            sub_data["source_id"] =
                ["vsc dc", sub_data["f_bus"], sub_data["t_bus"], pop!(dcline, "NAME")]
            sub_data["index"] = length(pm_data["dcline"]) + 1

            if import_all
                _import_remaining_keys!(sub_data, dcline)

                for cb in sub_data["converter buses"]
                    for (k, v) in cb
                        cb[lowercase(k)] = v
                        delete!(cb, k)
                    end
                end
            end

            push!(pm_data["dcline"], sub_data)
        end
    end
end

function _psse2pm_storage!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @warn "This PSS(R)E parser currently doesn't support Storage data parsing..."
    pm_data["storage"] = []
    return
end

function _psse2pm_switch!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @warn "This PSS(R)E parser currently doesn't support Switch data parsing..."
    pm_data["switch"] = []
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

    _psse2pm_bus!(pm_data, pti_data, import_all)
    _psse2pm_load!(pm_data, pti_data, import_all)
    _psse2pm_shunt!(pm_data, pti_data, import_all)
    _psse2pm_generator!(pm_data, pti_data, import_all)
    _psse2pm_branch!(pm_data, pti_data, import_all)
    _psse2pm_transformer!(pm_data, pti_data, import_all)
    _psse2pm_dcline!(pm_data, pti_data, import_all)
    _psse2pm_storage!(pm_data, pti_data, import_all)
    _psse2pm_switch!(pm_data, pti_data, import_all)

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
        "The PSS(R)E parser currently supports buses, loads, shunts, generators, branches, transformers, and dc lines",
    )
    pti_data = parse_pti(io)
    pm = _pti_to_powermodels!(pti_data; kwargs...)
    return pm
end
