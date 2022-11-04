
"""Container for data parsed by PowerModels"""
struct PowerModelsData
    data::Dict{String, Any}
end

"""
Constructs PowerModelsData from a raw file.
Currently Supports MATPOWER and PSSE data files parsed by PowerModels.
"""
function PowerModelsData(file::Union{String, IO}; kwargs...)
    validate = get(kwargs, :pm_data_corrections, true)
    import_all = get(kwargs, :import_all, false)
    pm_dict = parse_file(file; import_all = import_all, validate = validate)
    pm_data = PowerModelsData(pm_dict)
    correct_pm_transformer_status!(pm_data)
    return pm_data
end

"""
Constructs a System from PowerModelsData.

# Arguments
- `pm_data::Union{PowerModelsData, Union{String, IO}}`: PowerModels data object or supported
load flow case (*.m, *.raw)

# Keyword arguments
- `ext::Dict`: Contains user-defined parameters. Should only contain standard types.
- `runchecks::Bool`: Run available checks on input fields and when add_component! is called.
  Throws InvalidValue if an error is found.
- `time_series_in_memory::Bool=false`: Store time series data in memory instead of HDF5.
- `config_path::String`: specify path to validation config file
- `pm_data_corrections::Bool=true` : Run the PowerModels data corrections (aka :validate in PowerModels)
- `import_all:Bool=false` : Import all fields from PTI files

# Examples
```julia
sys = System(
    pm_data, config_path = "ACTIVSg25k_validation.json",
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
    read_storage!(sys, data, bus_number_to_bus; kwargs...)
    if runchecks
        check(sys)
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
    if haskey(device_dict, "name")
        name = device_dict["name"]
    elseif haskey(device_dict, "source_id")
        name = strip(join(string.(device_dict["source_id"]), "-"))
    else
        name = string(device_dict["index"])
    end
    return name
end

"""
Internal branch name retreval from pm2ps_dict
"""
function _get_pm_branch_name(device_dict, bus_f, bus_t)
    # Additional if-else are used to catch line id in PSSe parsing cases
    if haskey(device_dict, "name")
        index = device_dict["name"]
    elseif device_dict["source_id"][1] == "branch" && length(device_dict["source_id"]) > 2
        index = strip(device_dict["source_id"][4])
    elseif device_dict["source_id"][1] == "transformer" &&
           length(device_dict["source_id"]) > 3
        index = strip(device_dict["source_id"][5])
    else
        index = device_dict["index"]
    end
    return "$(get_name(bus_f))-$(get_name(bus_t))-i_$index"
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
        bus_dict["voltage_limits"],
        bus_dict["base_voltage"],
        bus_dict["area"],
        bus_dict["zone"],
    )
    return bus
end

function make_bus(bus_name, bus_number, d, bus_types, area)
    bus = make_bus(
        Dict{String, Any}(
            "name" => bus_name,
            "number" => bus_number,
            "bustype" => bus_types[d["bus_type"]],
            "angle" => d["va"],
            "voltage" => d["vm"],
            "voltage_limits" => (min = d["vmin"], max = d["vmax"]),
            "base_voltage" => d["base_kv"],
            "area" => area,
            "zone" => nothing,
        ),
    )
    return bus
end

# "From http://www.pserc.cornell.edu/matpower/MATPOWER-manual.pdf Table B-1"
IS.@scoped_enum(
    MatpowerBusTypes,
    MATPOWER_PQ = 1,
    MATPOWER_PV = 2,
    MATPOWER_REF = 3,
    MATPOWER_ISOLATED = 4,
)

const _BUS_TYPE_MAP = Dict(
    MatpowerBusTypes.MATPOWER_ISOLATED => BusTypes.ISOLATED,
    MatpowerBusTypes.MATPOWER_PQ => BusTypes.PQ,
    MatpowerBusTypes.MATPOWER_PV => BusTypes.PV,
    MatpowerBusTypes.MATPOWER_REF => BusTypes.REF,
)

function Base.convert(::Type{BusTypes}, x::MatpowerBusTypes)
    return _BUS_TYPE_MAP[x]
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
    @info "Reading Bus data in PowerModels dict to populate System ..."

    bus_number_to_bus = Dict{Int, Bus}()

    bus_types = instances(MatpowerBusTypes)
    bus_data = sort!(collect(data["bus"]), by = x -> parse(Int, x[1]))

    if isempty(bus_data)
        @error "No bus data found" # TODO : need for a model without a bus
    end

    _get_name = get(kwargs, :bus_name_formatter, _get_pm_dict_name)
    for (i, (d_key, d)) in enumerate(bus_data)
        # d id the data dict for each bus
        # d_key is bus key
        d["name"] = get(d, "name", string(d["bus_i"]))
        bus_name = strip(_get_name(d))
        bus_number = Int(d["bus_i"])

        area_name = string(d["area"])
        area = get_component(Area, sys, area_name)
        if isnothing(area)
            area = Area(area_name)
            add_component!(sys, area; skip_validation = SKIP_PM_VALIDATION)
        end

        bus = make_bus(bus_name, bus_number, d, bus_types, area)
        has_component(Bus, sys, bus_name) && throw(
            DataFormatError(
                "Found duplicate bus names of $(get_name(bus)), consider formatting names with `bus_name_formatter` kwarg",
            ),
        )

        bus_number_to_bus[bus.number] = bus

        add_component!(sys, bus; skip_validation = SKIP_PM_VALIDATION)
    end

    return bus_number_to_bus
end

function make_load(d, bus, sys_mbase; kwargs...)
    _get_name = get(kwargs, :load_name_formatter, x -> strip(join(x["source_id"])))
    return PowerLoad(;
        name = _get_name(d),
        available = true,
        model = LoadModels.ConstantPower,
        bus = bus,
        active_power = d["pd"],
        reactive_power = d["qd"],
        max_active_power = d["pd"],
        max_reactive_power = d["qd"],
        base_power = sys_mbase,
    )
end

function read_loads!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading Load data in PowerModels dict to populate System ..."

    if !haskey(data, "load")
        @error "There are no loads in this file"
        return
    end
  
    sys_mbase = data["baseMVA"]
    for d_key in keys(data["load"])
        d = data["load"][d_key]
        bus = bus_number_to_bus[d["load_bus"]]
        load = make_load(d, bus, sys_mbase; kwargs...)
        has_component(PowerLoad, sys, get_name(load)) && throw(
            DataFormatError(
                "Found duplicate load names of $(get_name(load)), consider formatting names with `load_name_formatter` kwarg",
            ),
        )
        add_component!(sys, load; skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_loadzone(name, active_power, reactive_power; kwargs...)
    _get_name = get(kwargs, :loadzone_name_formatter, _get_pm_dict_name)
    return LoadZone(;
        name = name,
        peak_active_power = sum(active_power),
        peak_reactive_power = sum(reactive_power),
    )
end

function read_loadzones!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading LoadZones data in PowerModels dict to populate System ..."

    zones = Set{Int}()
    for (i, bus) in data["bus"]
        push!(zones, bus["zone"])
    end

    for zone in zones
        buses = [
            bus_number_to_bus[b["bus_i"]] for b in values(data["bus"]) if b["zone"] == zone
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

function make_hydro_gen(gen_name, d, bus, sys_mbase)
    ramp_agc = get(d, "ramp_agc", get(d, "ramp_10", get(d, "ramp_30", abs(d["pmax"]))))
    curtailcost = TwoPartCost(0.0, 0.0)

    base_conversion = sys_mbase / d["mbase"]
    return HydroDispatch( # No way to define storage parameters for gens in PM so can only make HydroDispatch
        name = gen_name,
        available = Bool(d["gen_status"]),
        bus = bus,
        active_power = d["pg"] * base_conversion,
        reactive_power = d["qg"] * base_conversion,
        rating = calculate_rating(d["pmax"], d["qmax"]) * base_conversion,
        prime_mover = parse_enum_mapping(PrimeMovers, d["type"]),
        active_power_limits = (
            min = d["pmin"] * base_conversion,
            max = d["pmax"] * base_conversion,
        ),
        reactive_power_limits = (
            min = d["qmin"] * base_conversion,
            max = d["qmax"] * base_conversion,
        ),
        ramp_limits = (up = ramp_agc, down = ramp_agc),
        time_limits = nothing,
        operation_cost = curtailcost,
        base_power = d["mbase"],
    )
end

function make_renewable_dispatch(gen_name, d, bus, sys_mbase)
    cost = TwoPartCost(0.0, 0.0)
    base_conversion = sys_mbase / d["mbase"]

    rating = calculate_rating(d["pmax"], d["qmax"])
    if rating > d["mbase"]
        @warn "rating is larger than base power for $gen_name, setting to $(d["mbase"])"
        rating = d["mbase"]
    end

    generator = RenewableDispatch(;
        name = gen_name,
        available = Bool(d["gen_status"]),
        bus = bus,
        active_power = d["pg"] * base_conversion,
        reactive_power = d["qg"] * base_conversion,
        rating = rating * base_conversion,
        prime_mover = parse_enum_mapping(PrimeMovers, d["type"]),
        reactive_power_limits = (
            min = d["qmin"] * base_conversion,
            max = d["qmax"] * base_conversion,
        ),
        power_factor = 1.0,
        operation_cost = cost,
        base_power = d["mbase"],
    )

    return generator
end

function make_renewable_fix(gen_name, d, bus, sys_mbase)
    base_conversion = sys_mbase / d["mbase"]
    generator = RenewableFix(;
        name = gen_name,
        available = Bool(d["gen_status"]),
        bus = bus,
        active_power = d["pg"] * base_conversion,
        reactive_power = d["qg"] * base_conversion,
        rating = float(d["pmax"]) * base_conversion,
        prime_mover = parse_enum_mapping(PrimeMovers, d["type"]),
        power_factor = 1.0,
        base_power = d["mbase"],
    )

    return generator
end

function make_generic_battery(storage_name, d, bus)
    storage = GenericBattery(;
        name = storage_name,
        available = Bool(d["status"]),
        bus = bus,
        prime_mover = PrimeMovers.BA,
        initial_energy = d["energy"],
        state_of_charge_limits = (min = 0.0, max = d["energy_rating"]),
        rating = d["thermal_rating"],
        active_power = d["ps"],
        input_active_power_limits = (min = 0.0, max = d["charge_rating"]),
        output_active_power_limits = (min = 0.0, max = d["discharge_rating"]),
        efficiency = (in = d["charge_efficiency"], out = d["discharge_efficiency"]),
        reactive_power = d["qs"],
        reactive_power_limits = (min = d["qmin"], max = d["qmax"]),
        base_power = d["thermal_rating"],
    )
    return storage
end

"""
The polynomial term follows the convention that for an n-degree polynomial, at least n + 1 components are needed.
    c(p) = c_n*p^n+...+c_1p+c_0
    c_o is stored in the  field in of the Econ Struct
"""
function make_thermal_gen(gen_name::AbstractString, d::Dict, bus::Bus, sys_mbase::Number)
    if haskey(d, "model")
        model = GeneratorCostModels(d["model"])
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
                cost = (0.0, d["cost"][1]) ./ sys_mbase
                fixed = d["cost"][2]
            elseif d["ncost"] == 3
                cost = (d["cost"][1] / sys_mbase, d["cost"][2]) ./ sys_mbase
                fixed = d["cost"][3]
            else
                throw(
                    DataFormatError(
                        "invalid value for ncost: $(d["ncost"]). PowerSystems only supports polynomials up to second degree",
                    ),
                )
            end
        end
        startup = d["startup"]
        shutdn = d["shutdown"]
    else
        @warn "Generator cost data not included for Generator: $gen_name"
        tmpcost = ThreePartCost(nothing)
        cost = tmpcost.variable
        fixed = tmpcost.fixed
        startup = tmpcost.start_up
        shutdn = tmpcost.shut_down
    end

    # Ignoring due to  GitHub #148: ramp_agc isn't always present. This value may not be correct.
    ramp_lim = get(d, "ramp_10", get(d, "ramp_30", abs(d["pmax"])))

    operation_cost = ThreePartCost(;
        variable = cost,
        fixed = fixed,
        start_up = startup,
        shut_down = shutdn,
    )

    ext = Dict{String, Any}()
    if haskey(d, "r_source")
        ext["z_source"] = (r = d["r_source"], x = d["x_source"])
    end

    base_conversion = sys_mbase / d["mbase"]
    thermal_gen = ThermalStandard(
        name = gen_name,
        status = Bool(d["gen_status"]),
        available = true,
        bus = bus,
        active_power = d["pg"] * base_conversion,
        reactive_power = d["qg"] * base_conversion,
        rating = calculate_rating(d["pmax"], d["qmax"]) * base_conversion,
        prime_mover = parse_enum_mapping(PrimeMovers, d["type"]),
        fuel = parse_enum_mapping(ThermalFuels, d["fuel"]),
        active_power_limits = (
            min = d["pmin"] * base_conversion,
            max = d["pmax"] * base_conversion,
        ),
        reactive_power_limits = (
            min = d["qmin"] * base_conversion,
            max = d["qmax"] * base_conversion,
        ),
        ramp_limits = (up = ramp_lim, down = ramp_lim),
        time_limits = nothing,
        operation_cost = operation_cost,
        base_power = d["mbase"],
        ext = ext,
    )

    return thermal_gen
end

"""
Transfer generators to ps_dict according to their classification
"""
function read_gen!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading Generator data in PowerModels dict to populate System ..."
   
    if !haskey(data, "gen")
        @error "There are no Generators in this file"
        return nothing
    end

    generator_mapping = get(kwargs, :generator_mapping, nothing)
    if generator_mapping isa AbstractString || isnothing(generator_mapping)
        generator_mapping = get_generator_mapping(generator_mapping)
    end

    sys_mbase = data["baseMVA"]

    _get_name = get(kwargs, :gen_name_formatter, _get_pm_dict_name)

    for (name, pm_gen) in data["gen"]
        gen_name = _get_name(pm_gen)

        bus = bus_number_to_bus[pm_gen["gen_bus"]]
        pm_gen["fuel"] = get(pm_gen, "fuel", "OTHER")
        pm_gen["type"] = get(pm_gen, "type", "OT")
        @debug "Found generator" _group = IS.LOG_GROUP_PARSING gen_name bus pm_gen["fuel"] pm_gen["type"]

        gen_type = get_generator_type(pm_gen["fuel"], pm_gen["type"], generator_mapping)
        if gen_type == ThermalStandard
            generator = make_thermal_gen(gen_name, pm_gen, bus, sys_mbase)
        elseif gen_type == HydroEnergyReservoir
            generator = make_hydro_gen(gen_name, pm_gen, bus, sys_mbase)
        elseif gen_type == RenewableDispatch
            generator = make_renewable_dispatch(gen_name, pm_gen, bus, sys_mbase)
        elseif gen_type == RenewableFix
            generator = make_renewable_fix(gen_name, pm_gen, bus, sys_mbase)
        elseif gen_type == GenericBattery
            @warn "GenericBattery should be defined as a PowerModels storage... Skipping"
            continue
        else
            @error "Skipping unsupported generator" gen_type
            continue
        end

        has_component(typeof(generator), sys, get_name(generator)) && throw(
            DataFormatError(
                "Found duplicate $(typeof(generator)) names of $(get_name(generator)), consider formatting names with `gen_name_formatter` kwarg",
            ),
        )
        add_component!(sys, generator; skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_branch(name, d, bus_f, bus_t)
    primary_shunt = d["b_fr"]
    alpha = d["shift"]
    branch_type = get_branch_type(d["tap"], alpha, d["transformer"])

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
        active_power_flow = pf,
        reactive_power_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        b = (from = d["b_fr"], to = d["b_to"]),
        rate = d["rate_a"],
        angle_limits = (min = d["angmin"], max = d["angmax"]),
    )
end

function make_transformer_2w(name, d, bus_f, bus_t)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)
    return Transformer2W(;
        name = name,
        available = d["br_status"] == 1,
        active_power_flow = pf,
        reactive_power_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        primary_shunt = d["b_fr"],  # TODO: which b ??
        rate = d["rate_a"],
    )
end

function make_tap_transformer(name, d, bus_f, bus_t)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)
    return TapTransformer(;
        name = name,
        available = d["br_status"] == 1,
        active_power_flow = pf,
        reactive_power_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        tap = d["tap"],
        primary_shunt = d["b_fr"],  # TODO: which b ??
        rate = d["rate_a"],
    )
end

function make_phase_shifting_transformer(name, d, bus_f, bus_t, alpha)
    pf = get(d, "pf", 0.0)
    qf = get(d, "qf", 0.0)
    return PhaseShiftingTransformer(;
        name = name,
        available = d["br_status"] == 1,
        active_power_flow = pf,
        reactive_power_flow = qf,
        arc = Arc(bus_f, bus_t),
        r = d["br_r"],
        x = d["br_x"],
        tap = d["tap"],
        primary_shunt = d["b_fr"],  # TODO: which b ??
        α = alpha,
        rate = d["rate_a"],
    )
end

function read_branch!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading Branch data in PowerModels dict to populate System ..."
   
    if !haskey(data, "branch")
        @info "There is no Branch data in this file"
        return
    end

    _get_name = get(kwargs, :branch_name_formatter, _get_pm_branch_name)

    for (d_key, d) in data["branch"]
        bus_f = bus_number_to_bus[d["f_bus"]]
        bus_t = bus_number_to_bus[d["t_bus"]]
        name = _get_name(d, bus_f, bus_t)
        value = make_branch(name, d, bus_f, bus_t)

        add_component!(sys, value; skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_dcline(name, d, bus_f, bus_t)
    return HVDCLine(;
        name = name,
        available = d["br_status"] == 1,
        active_power_flow = get(d, "pf", 0.0),
        arc = Arc(bus_f, bus_t),
        active_power_limits_from = (min = d["pminf"], max = d["pmaxf"]),
        active_power_limits_to = (min = d["pmint"], max = d["pmaxt"]),
        reactive_power_limits_from = (min = d["qminf"], max = d["qmaxf"]),
        reactive_power_limits_to = (min = d["qmint"], max = d["qmaxt"]),
        loss = (l0 = d["loss0"], l1 = d["loss1"]),
    )
end

function read_dcline!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading DC Line data in PowerModels dict to populate System ..."
   
    if !haskey(data, "dcline")
        @info "There is no DClines data in this file"
        return
    end

    _get_name = get(kwargs, :branch_name_formatter, _get_pm_branch_name)

    for (d_key, d) in data["dcline"]
        d["name"] = get(d, "name", d_key)
        bus_f = bus_number_to_bus[d["f_bus"]]
        bus_t = bus_number_to_bus[d["t_bus"]]
        name = _get_name(d, bus_f, bus_t)
        dcline = make_dcline(name, d, bus_f, bus_t)
        add_component!(sys, dcline, skip_validation = SKIP_PM_VALIDATION)
    end
end

function make_shunt(name, d, bus)
    return FixedAdmittance(;
        name = name,
        available = Bool(d["status"]),
        bus = bus,
        Y = (d["gs"] + d["bs"]im),
    )
end

function read_shunt!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading Shunt data in PowerModels dict to populate System ..."
    
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

function read_storage!(sys::System, data, bus_number_to_bus::Dict{Int, Bus}; kwargs...)
    @info "Reading Storage data ..."
    if !haskey(data, "storage")
        @info "There is no storage data in this file"
        return
    end

    _get_name = get(kwargs, :gen_name_formatter, _get_pm_dict_name)

    for (d_key, d) in data["storage"]
        d["name"] = get(d, "name", d_key)
        name = _get_name(d)
        bus = bus_number_to_bus[d["storage_bus"]]
        storage = make_generic_battery(name, d, bus)

        add_component!(sys, storage; skip_validation = SKIP_PM_VALIDATION)
    end
end
