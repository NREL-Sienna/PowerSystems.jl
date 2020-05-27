
"""Container for data parsed by PowerModels"""
struct PowerModelsData
    data::Dict{String, Any}
end

"""
Constructs PowerModelsData from a raw file.
Currently Supports MATPOWER and PSSE data files parsed by PowerModels.
"""
function PowerModelsData(file::Union{String, IO}; kwargs...)
    pm_dict = parse_file(file; kwargs...)
    pm_data = PowerModelsData(pm_dict)
    correct_pm_transformer_status!(pm_data)
    return pm_data
end

"""
Constructs a System from PowerModelsData.
Supports kwargs to supply formatters for different device types,
such as `bus_name_formatter` or `gen_name_formatter`.

# Examples
```julia
sys = System(
    pm_data, configpath = "ACTIVSg25k_validation.json",
    bus_name_formatter = x->string(x["name"]*"-"*string(x["index"])),
    load_name_formatter = x->strip(join(x["source_id"], "_"))
)
```
"""
function System(pm_data::PowerModelsData; kwargs...)
    runchecks = get(kwargs, :runchecks, true)
    data = pm_data.data
    if length(data["bus"]) < 1
        throw(DataFormatError("There are no buses in this file."))
    end

    @info "Constructing System from Power Models" data["name"] data["source_type"]

    sys = System(data["baseMVA"]; kwargs...)

    bus_number_to_bus = read_bus!(sys, data; kwargs...)
    read_loads!(sys, data, bus_number_to_bus; kwargs...)
    read_loadzones!(sys, data, bus_number_to_bus; kwargs...)
    read_gen!(sys, data, bus_number_to_bus; kwargs...)
    read_branch!(sys, data, bus_number_to_bus; kwargs...)
    read_shunt!(sys, data, bus_number_to_bus; kwargs...)
    read_dcline!(sys, data, bus_number_to_bus; kwargs...)
    if runchecks
        check!(sys)
    end
    return sys
end

function correct_pm_transformer_status!(pm_data::PowerModelsData)
    for (k, branch) in pm_data.data["branch"]
        if !branch["transformer"] &&
           pm_data.data["bus"][string(branch["f_bus"])]["base_kv"] !=
           pm_data.data["bus"][string(branch["t_bus"])]["base_kv"]
            branch["transformer"] = true
            @warn "Branch $k endpoints have different voltage levels, converting to transformer."
        end
    end
end

"""
Internal component name retreval from pm2ps_dict
"""
function _get_pm_dict_name(device_dict)
    return get(device_dict, "name", string(device_dict["index"]))
end

"""
Creates a PowerSystems.Bus from a PowerSystems bus dictionary
"""
function make_bus(bus_dict::Dict{String, Any})
    bus = Bus(
        bus_dict["number"],
        bus_dict["name"],
        bus_dict["bustype"],
        bus_dict["angle"],
        bus_dict["voltage"],
        bus_dict["voltagelimits"],
        bus_dict["basevoltage"],
        bus_dict["area"],
        bus_dict["zone"],
    )
    return bus
end

function make_bus(bus_name, bus_number, d, bus_types, area)
    bus = make_bus(Dict{String, Any}(
        "name" => bus_name,
        "number" => bus_number,
        "bustype" => bus_types[d["bus_type"]],
        "angle" => d["va"],
        "voltage" => d["vm"],
        "voltagelimits" => (min = d["vmin"], max = d["vmax"]),
        "basevoltage" => d["base_kv"],
        "area" => area,
        "zone" => nothing,
    ),)
    return bus
end

# "From http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf Table B-1"
IS.@scoped_enum MatpowerBusType begin
    MATPOWER_PQ = 1
    MATPOWER_PV = 2
    MATPOWER_REF = 3
    MATPOWER_ISOLATED = 4
end

function Base.convert(::Type{BusTypes.BusType}, x::MatpowerBusTypes.MatpowerBusType)
    map = Dict(
        MatpowerBusTypes.MATPOWER_ISOLATED => BusTypes.ISOLATED,
        MatpowerBusTypes.MATPOWER_PQ => BusTypes.PQ,
        MatpowerBusTypes.MATPOWER_PV => BusTypes.PV,
        MatpowerBusTypes.MATPOWER_REF => BusTypes.REF,
    )
    return map[x]
end

# Disabling this because not all matpower files define areas even when bus definitions
# contain area references.
#function read_area!(sys::System, data; kwargs...)
#    if !haskey(data, "areas")
#        @info "There are no Areas in this file"
#        return
#    end
#
#    for (key, val) in data["areas"]
#        area = Area(string(val["col_1"]))
#        add_component!(sys, area; skip_validation = SKIP_PM_VALIDATION)
#    end
#end

function read_bus!(sys::System, data; kwargs...)
    @info "Reading bus data"
    bus_number_to_bus = Dict{Int, Bus}()

    bus_types = instances(MatpowerBusTypes.MatpowerBusType)
    bus_data = sort(collect(data["bus"]), by = x -> parse(Int64, x[1]))

    if isempty(bus_data)
        @error "No bus data found" # TODO : need for a model without a bus
    end

    _get_name = get(kwargs, :bus_name_formatter, _get_pm_dict_name)
    for (i, (d_key, d)) in enumerate(bus_data)
        # d id the data dict for each bus
        # d_key is bus key
        d["name"] = get(d, "name", string(d["bus_i"]))
        bus_name = _get_name(d)
        bus_number = Int(d["bus_i"])

        area_name = string(d["area"])
        area = get_component(Area, sys, area_name)
        if isnothing(area)
            area = Area(area_name)
            add_component!(sys, area; skip_validation = SKIP_PM_VALIDATION)
        end

        bus = make_bus(bus_name, bus_number, d, bus_types, area)
        bus_number_to_bus[bus.number] = bus

        add_component!(sys, bus; skip_validation = SKIP_PM_VALIDATION)
    end

    return bus_number_to_bus
end

function make_load(d, bus; kwargs...)
    _get_name = get(kwargs, :load_name_formatter, x -> strip(join(x["source_id"])))
    return PowerLoad(;
        name = _get_name(d),
        available = true,
        model = LoadModels.ConstantPower,
        bus = bus,
        activepower = d["pd"],
        reactivepower = d["qd"],
        maxactivepower = d["pd"],
        maxreactivepower = d["qd"],
    )
end

function read_loads!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    if !haskey(data, "load")
        @error "There are no loads in this file"
        return
    end

    for d_key in keys(data["load"])
        d = data["load"][d_key]
        if d["pd"] != 0.0
            bus = bus_number_to_bus[d["load_bus"]]
            load = make_load(d, bus; kwargs...)

            add_component!(sys, load; skip_validation = SKIP_PM_VALIDATION)
        end
    end
end

function make_loadzone(name, activepower, reactivepower; kwargs...)
    _get_name = get(kwargs, :loadzone_name_formatter, _get_pm_dict_name)
    return LoadZone(;
        name = name,
        maxactivepower = sum(activepower),
        maxreactivepower = sum(reactivepower),
    )
end

function read_loadzones!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    zones = Set{Int}()
    for (i, bus) in data["bus"]
        push!(zones, bus["zone"])
    end

    for zone in zones
        buses = [
            bus_number_to_bus[b["bus_i"]]
            for (b_key, b) in data["bus"] if b["zone"] == zone
        ]
        bus_names = Set{String}()
        for bus in buses
            push!(bus_names, get_name(bus))
        end

        active_power = Vector{Float64}()
        reactive_power = Vector{Float64}()

        for (key, load) in data["load"]
            load_bus = bus_number_to_bus[load["load_bus"]]
            if get_name(load_bus) in bus_names
                push!(active_power, load["pd"])
                push!(reactive_power, load["qd"])
            end
        end

        load_zone = make_loadzone(string(zone), active_power, reactive_power; kwargs...)
        for bus in buses
            set_load_zone!(bus, load_zone)
        end
        add_component!(sys, load_zone; skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_hydro_gen(gen_name, d, bus)
    ramp_agc = get(d, "ramp_agc", get(d, "ramp_10", get(d, "ramp_30", abs(d["pmax"]))))
    curtailcost = TwoPartCost(0.0, 0.0)

    return HydroEnergyReservoir(
        name = gen_name,
        available = Bool(d["gen_status"]),
        bus = bus,
        activepower = d["pg"],
        reactivepower = d["qg"],
        rating = calculate_rating(d["pmax"], d["qmax"]),
        primemover = convert(PrimeMovers.PrimeMover, d["type"]),
        activepowerlimits = (min = d["pmin"], max = d["pmax"]),
        reactivepowerlimits = (min = d["qmin"], max = d["qmax"]),
        ramplimits = (up = ramp_agc / d["mbase"], down = ramp_agc / d["mbase"]),
        timelimits = nothing,
        op_cost = curtailcost,
        machine_basepower = d["mbase"],
        storage_capacity = 0.0, #TODO: Implement better Solution for this
        inflow = 0.0,
        initial_storage = 0.0,
    )
end

function make_renewable_dispatch(gen_name, d, bus)
    cost = TwoPartCost(0.0, 0.0)
    generator = RenewableDispatch(;
        name = gen_name,
        available = Bool(d["gen_status"]),
        bus = bus,
        activepower = d["pg"],
        reactivepower = d["qg"],
        rating = float(d["pmax"]),
        primemover = convert(PrimeMovers.PrimeMover, d["type"]),
        reactivepowerlimits = (min = d["qmin"], max = d["qmax"]),
        powerfactor = 1.0,
        op_cost = cost,
        machine_basepower = d["mbase"],
    )

    return generator
end

function make_renewable_fix(gen_name, d, bus)
    generator = RenewableFix(;
        name = gen_name,
        available = Bool(d["gen_status"]),
        bus = bus,
        activepower = d["pg"],
        reactivepower = d["qg"],
        rating = float(d["pmax"]),
        primemover = convert(PrimeMovers.PrimeMover, d["type"]),
        powerfactor = 1.0,
        machine_basepower = d["mbase"]
    )

    return generator
end

function make_generic_battery(gen_name, d, bus)
    error("Not implemented yet.")
end

"""
The polynomial term follows the convention that for an n-degree polynomial, at least n + 1 components are needed.
    c(p) = c_n*p^n+...+c_1p+c_0
    c_o is stored in the  field in of the Econ Struct
"""
function make_thermal_gen(gen_name::AbstractString, d::Dict, bus::Bus)
    if haskey(d, "model")
        model = GeneratorCostModels.GeneratorCostModel(d["model"])
        if model == GeneratorCostModels.PIECEWISE_LINEAR
            cost_component = d["cost"]
            power_p = [i for (ix, i) in enumerate(cost_component) if isodd(ix)]
            cost_p = [i for (ix, i) in enumerate(cost_component) if iseven(ix)]
            cost = [(p, c) for (p, c) in zip(cost_p, power_p)]
            fixed = max(
                0.0,
                cost[1][1] -
                (cost[2][1] - cost[1][1]) / (cost[2][2] - cost[1][2]) * cost[1][2],
            )
            cost = [(c[1] - fixed, c[2]) for c in cost]
        elseif model == GeneratorCostModels.POLYNOMIAL
            if d["ncost"] == 0
                cost = (0.0, 0.0)
                fixed = 0.0
            elseif d["ncost"] == 1
                cost = (0.0, 0.0)
                fixed = d["cost"][1]
            elseif d["ncost"] == 2
                cost = (0.0, d["cost"][1])
                fixed = d["cost"][2]
            elseif d["ncost"] == 3
                cost = (d["cost"][1], d["cost"][2])
                fixed = d["cost"][3]
            else
                throw(DataFormatError("invalid value for ncost: $(d["ncost"]). PowerSystems only supports polynomials up to second degree"))
            end
        end
        startup = d["startup"]
        shutdn = d["shutdown"]
    else
        @warn "Generator cost data not included for Generator: $gen_name"
        tmpcost = ThreePartCost(nothing)
        cost = tmpcost.variable
        fixed = tmpcost.fixed
        startup = tmpcost.startup
        shutdn = tmpcost.shutdn
    end

    # Ignoring due to  GitHub #148: ramp_agc isn't always present. This value may not be correct.
    ramp_lim = get(d, "ramp_10", get(d, "ramp_30", abs(d["pmax"])))

    op_cost =
        ThreePartCost(; variable = cost, fixed = fixed, startup = startup, shutdn = shutdn)

    thermal_gen = ThermalStandard(
        name = gen_name,
        status = Bool(d["gen_status"]),
        available = true,
        bus = bus,
        activepower = d["pg"],
        reactivepower = d["qg"],
        rating = sqrt(d["pmax"]^2 + d["qmax"]^2),
        primemover = convert(PrimeMovers.PrimeMover, d["type"]),
        fuel = convert(ThermalFuels.ThermalFuel, d["fuel"]),
        activepowerlimits = (min = d["pmin"], max = d["pmax"]),
        reactivepowerlimits = (min = d["qmin"], max = d["qmax"]),
        ramplimits = (up = ramp_lim / d["mbase"], down = ramp_lim / d["mbase"]),
        timelimits = nothing,
        op_cost = op_cost,
        machine_basepower = d["mbase"],
    )

    return thermal_gen
end

"""
Transfer generators to ps_dict according to their classification
"""
function read_gen!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading generator data"

    if !haskey(data, "gen")
        @error "There are no Generators in this file"
        return nothing
    end

    genmap_file = get(kwargs, :genmap_file, nothing)
    genmap = get_generator_mapping(genmap_file)

    for (name, pm_gen) in data["gen"]
        if haskey(kwargs, :gen_name_formatter)
            _get_name = kwargs[:gen_name_formatter]
        elseif haskey(pm_gen, "name")
            _get_name = _get_pm_dict_name
        elseif haskey(pm_gen, "source_id")
            _get_name =
                d -> strip(
                    string(d["source_id"][1]) *
                    "-" *
                    string(d["source_id"][2]) *
                    "-" *
                    string(d["index"]),
                )
        end

        gen_name = _get_name(pm_gen)

        bus = bus_number_to_bus[pm_gen["gen_bus"]]
        pm_gen["fuel"] = get(pm_gen, "fuel", "OTHER")
        pm_gen["type"] = get(pm_gen, "type", "OT")
        @debug "Found generator" gen_name bus pm_gen["fuel"] pm_gen["type"]

        gen_type = get_generator_type(pm_gen["fuel"], pm_gen["type"], genmap)
        if gen_type == ThermalStandard
            generator = make_thermal_gen(gen_name, pm_gen, bus)
        elseif gen_type == HydroEnergyReservoir
            generator = make_hydro_gen(gen_name, pm_gen, bus)
        elseif gen_type == RenewableDispatch
            generator = make_renewable_dispatch(gen_name, pm_gen, bus)
        elseif gen_type == RenewableFix
            generator = make_renewable_fix(gen_name, pm_gen, bus)
        elseif gen_type == GenericBattery
            @warn "Skipping GenericBattery"
            continue
            # TODO
            #generator = make_generic_battery(gen_name, pm_gen, bus)
        else
            @error "Skipping unsupported generator" gen_type
            continue
        end

        add_component!(sys, generator; skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_branch(name, d, bus_f, bus_t)
    primary_shunt = d["b_fr"]
    alpha = d["shift"]
    branch_type = get_branch_type(d["tap"], alpha)

    if d["transformer"]
        if branch_type == Line
            throw(DataFormatError("Data is mismatched; this cannot be a line. $d"))
        elseif branch_type == Transformer2W
            value = make_transformer_2w(name, d, bus_f, bus_t)
        elseif branch_type == TapTransformer
            value = make_tap_transformer(name, d, bus_f, bus_t)
        elseif branch_type == PhaseShiftingTransformer
            value = make_phase_shifting_transformer(name, d, bus_f, bus_t, alpha)
        else
            error("Unsupported branch type $branch_type")
        end
    else
        # The get_branch_type() logic doesn't work for this data.
        # tap can be 1.0 for this data.
        value = make_line(name, d, bus_f, bus_t)
    end

    return value
end

function make_line(name, d, bus_f, bus_t)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)

    return Line(;
        name = name,
        available = d["br_status"] == 1,
        activepower_flow = pf,
        reactivepower_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        b = (from = d["b_fr"], to = d["b_to"]),
        rate = d["rate_a"],
        anglelimits = (min = d["angmin"], max = d["angmax"]),
    )
end

function make_transformer_2w(name, d, bus_f, bus_t)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)
    return Transformer2W(;
        name = name,
        available = d["br_status"] == 1,
        activepower_flow = pf,
        reactivepower_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        primaryshunt = d["b_fr"],  # TODO: which b ??
        rate = d["rate_a"],
    )
end

function make_tap_transformer(name, d, bus_f, bus_t)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)
    return TapTransformer(;
        name = name,
        available = d["br_status"] == 1,
        activepower_flow = pf,
        reactivepower_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        tap = d["tap"],
        primaryshunt = d["b_fr"],  # TODO: which b ??
        rate = d["rate_a"],
    )
end

function make_phase_shifting_transformer(name, d, bus_f, bus_t, alpha)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)
    return PhaseShiftingTransformer(;
        name = name,
        available = d["br_status"] == 1,
        activepower_flow = pf,
        reactivepower_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        tap = d["tap"],
        primaryshunt = d["b_fr"],  # TODO: which b ??
        α = alpha,
        rate = d["rate_a"],
    )
end

function read_branch!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading branch data"
    if !haskey(data, "branch")
        @info "There is no Branch data in this file"
        return
    end

    _get_name = get(kwargs, :branch_name_formatter, _get_pm_dict_name)

    for (d_key, d) in data["branch"]
        d["name"] = get(d, "name", d_key)
        name = _get_name(d)
        bus_f = bus_number_to_bus[d["f_bus"]]
        bus_t = bus_number_to_bus[d["t_bus"]]
        value = make_branch(name, d, bus_f, bus_t)

        add_component!(sys, value; skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_dcline(name, d, bus_f, bus_t)
    return HVDCLine(;
        name = name,
        available = d["br_status"] == 1,
        activepower_flow = get(d, "pf", 0.0),
        arc = Arc(bus_f, bus_t),
        activepowerlimits_from = (min = d["pminf"], max = d["pmaxf"]),
        activepowerlimits_to = (min = d["pmint"], max = d["pmaxt"]),
        reactivepowerlimits_from = (min = d["qminf"], max = d["qmaxf"]),
        reactivepowerlimits_to = (min = d["qmint"], max = d["qmaxt"]),
        loss = (l0 = d["loss0"], l1 = d["loss1"]),
    )
end

function read_dcline!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading DC Line data"
    if !haskey(data, "dcline")
        @info "There is no DClines data in this file"
        return
    end

    _get_name = get(kwargs, :branch_name_formatter, _get_pm_dict_name)

    for (d_key, d) in data["dcline"]
        d["name"] = get(d, "name", d_key)
        name = _get_name(d)
        bus_f = bus_number_to_bus[d["f_bus"]]
        bus_t = bus_number_to_bus[d["t_bus"]]

        dcline = make_dcline(name, d, bus_f, bus_t)
        add_component!(sys, dcline, skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_shunt(name, d, bus)
    return FixedAdmittance(;
        name = name,
        available = Bool(d["status"]),
        bus = bus,
        Y = (-d["gs"] + d["bs"]im),
    )
end

function read_shunt!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading branch data"
    if !haskey(data, "shunt")
        @info "There is no shunt data in this file"
        return
    end

    _get_name = get(kwargs, :shunt_name_formatter, _get_pm_dict_name)

    for (d_key, d) in data["shunt"]
        d["name"] = get(d, "name", d_key)
        name = _get_name(d)
        bus = bus_number_to_bus[d["shunt_bus"]]
        shunt = make_shunt(name, d, bus)

        add_component!(sys, shunt; skip_validation = SKIP_PM_VALIDATION)
    end
end
