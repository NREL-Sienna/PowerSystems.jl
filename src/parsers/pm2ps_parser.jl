
"""
Converts a dictionary parsed by PowerModels to a System.
Currently Supports MATPOWER and PSSE data files parsed by PowerModels.
"""
function pm2ps_dict(data::Dict{String,Any}; kwargs...)
    if length(data["bus"]) < 1
        throw(DataFormatError("There are no buses in this file."))
    end

    @info "Constructing System from Power Models" data["name"] data["source_type"]

    sys = System(data["baseMVA"])

    bus_number_to_bus = read_bus!(sys, data)
    read_loads!(sys, data, bus_number_to_bus)
    read_loadzones!(sys, data, bus_number_to_bus)
    read_gen!(sys, data, bus_number_to_bus; kwargs...)
    read_branch!(sys, data, bus_number_to_bus)
    read_shunt!(sys, data, bus_number_to_bus)
    read_dcline!(sys, data, bus_number_to_bus)

    check!(sys)
    return sys
end


"""
Creates a PowerSystems.Bus from a PowerSystems bus dictionary
"""
function make_bus(bus_dict::Dict{String,Any})
    bus = Bus(bus_dict["number"],
                     bus_dict["name"],
                     bus_dict["bustype"],
                     bus_dict["angle"],
                     bus_dict["voltage"],
                     bus_dict["voltagelimits"],
                     bus_dict["basevoltage"]
                     )
     return bus
 end

function make_bus(bus_name, bus_number, d, bus_types)
    bus = make_bus(Dict{String,Any}("name" => bus_name ,
                            "number" => bus_number,
                            "bustype" => bus_types[d["bus_type"]],
                            "angle" => 0, # NOTE: angle 0, tuple(min, max)
                            "voltage" => d["vm"],
                            "voltagelimits" => (min=d["vmin"], max=d["vmax"]),
                            "basevoltage" => d["base_kv"]
                            ))
    return bus
end

function read_bus!(sys::System, data, )
    @info "Reading bus data"
    bus_number_to_bus = Dict{Int, Bus}()
    bus_types = ["PV", "PQ", "REF","isolated"]
    data = sort(collect(data["bus"]), by = x->parse(Int64,x[1]))

    if length(data) == 0
        @error "No bus data found" # TODO : need for a model without a bus
    end

    for (i, (d_key, d)) in enumerate(data)
        # d id the data dict for each bus
        # d_key is bus key
        bus_name = haskey(d,"bus_name") ? d["bus_name"] : string(d["bus_i"])
        bus_number = Int(d["bus_i"])
        bus = make_bus(bus_name, bus_number, d, bus_types)
        bus_number_to_bus[bus.number] = bus
        add_component!(sys, bus)
    end

    return bus_number_to_bus
end

function make_load(d, bus)
    return PowerLoad(;
        name=bus.name,
        available=true,
        bus=bus,
        maxactivepower=d["pd"],
        maxreactivepower=d["qd"],
    )
end

function read_loads!(sys::System, data, bus_number_to_bus::Dict{Int, Bus})
    if !haskey(data, "load")
        @error "There are no loads in this file"
        return
    end

    for d_key in keys(data["load"])
        d = data["load"][d_key]
        if d["pd"] != 0.0
            bus = bus_number_to_bus[d["load_bus"]]
            load = make_load(d, bus)

            add_component!(sys, load)
        end
    end
end

function make_loadzones(d_key, d, bus_l, activepower, reactivepower)
    return LoadZones(;
        number=d["index"],
        name=d_key,
        buses=bus_l,
        maxactivepower=sum(activepower),
        maxreactivepower=sum(reactivepower),
    )
end

function read_loadzones!(sys::System, data, bus_number_to_bus::Dict{Int, Bus})
    if !haskey(data, "areas")
        @info "There are no Load Zones data in this file"
        return
    end

    for (d_key, d) in data["areas"]
        buses = [bus_number_to_bus[b["bus_i"]] for (b_key, b) in data["bus"]
                 if b["area"] == d["index"]]
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

        load_zones = make_loadzones(d_key, d, buses, active_power, reactive_power)
        add_component!(sys, load_zones)
    end
end

function make_hydro_gen(gen_name, d, bus)
    ramp_agc = get(d, "ramp_agc", get(d, "ramp_10", get(d, "ramp_30", d["pmax"])))
    tech = TechHydro(;
        rating=calculate_rating(d["pmax"], d["qmax"]),
        activepower=d["pg"],
        activepowerlimits=(min=d["pmin"], max=d["pmax"]),
        reactivepower=d["qg"],
        reactivepowerlimits=(min=d["qmin"], max=d["qmax"]),
        ramplimits=(up=ramp_agc / d["mbase"], down=ramp_agc / d["mbase"]),
        timelimits=nothing,
    )

    curtailcost = 0.0

    return HydroDispatch(gen_name, Bool(d["gen_status"]), bus, tech, curtailcost)
end

function make_tech_renewable(d)
    tech = TechRenewable(;
        rating=float(d["pmax"]),
        reactivepower=d["qg"],
        reactivepowerlimits=(min=d["qmin"], max=d["qmax"]),
        powerfactor=1,
    )

    return tech
end

function make_renewable_dispatch(gen_name, d, bus)
    tech = make_tech_renewable(d)
    cost = TwoPartCost(0.0, 0.0)
    generator = RenewableDispatch(;
        name=gen_name,
        available=Bool(d["gen_status"]),
        bus=bus,
        tech=tech,
        op_cost=cost,
    )

    return generator
end

function make_renewable_fix(gen_name, d, bus)
    tech = make_tech_renewable(d)
    generator = RenewableFix(;
        name=gen_name,
        available=Bool(d["gen_status"]),
        bus=bus,
        tech=tech,
    )

    return generator
end

function make_generic_battery(gen_name, d, bus)

    # TODO: placeholder
    #battery=GenericBattery(;
    #    name=gen_name,
    #    available=Bool(d["gen_status"]),
    #    bus=bus,
    #    energy=,
    #    capacity=,
    #    rating=,
    #    activepower=,
    #    inputactivepowerlimits=,
    #    outputactivepowerlimits=,
    #    efficiency=,
    #    reactivepower=,
    #    reactivepowerlimits=,
    #)
    #return battery
end

"""
The polynomial term follows the convention that for an n-degree polynomial, at least n + 1 components are needed.
    c(p) = c_n*p^n+...+c_1p+c_0
    c_o is stored in the  field in of the Econ Struct
"""
function make_thermal_gen(gen_name::AbstractString, d::Dict, bus::Bus)
    if haskey(d, "model")
        model = GeneratorCostModel(d["model"])
        if model == PIECEWISE_LINEAR::GeneratorCostModel
            cost_component = d["cost"]
            power_p = [i for (ix,i) in enumerate(cost_component) if isodd(ix)]
            cost_p =  [i for (ix,i) in enumerate(cost_component) if iseven(ix)]
            cost = [(p,c) for (p,c) in zip(cost_p,power_p)]
            fixed = cost[1][2]
        elseif model == POLYNOMIAL::GeneratorCostModel
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

    # TODO GitHub #148: ramp_agc isn't always present. This value may not be correct.
    ramp_agc = get(d, "ramp_agc", get(d, "ramp_10", get(d, "ramp_30", d["pmax"])))

    tech = TechThermal(;
        rating=sqrt(d["pmax"]^2 + d["qmax"]^2),
        activepower=d["pg"],
        activepowerlimits=(min=d["pmin"], max=d["pmax"]),
        reactivepower=d["qg"],
        reactivepowerlimits=(min=d["qmin"], max=d["qmax"]),
        ramplimits=(up=ramp_agc / d["mbase"], down=ramp_agc / d["mbase"]),
        timelimits=nothing,
    )
    op_cost = ThreePartCost(;
        variable=cost,
        fixed=fixed,
        startup=startup,
        shutdn=shutdn,
    )

    thermal_gen = ThermalStandard(
        name=gen_name,
        available=Bool(d["gen_status"]),
        bus=bus,
        tech=tech,
        op_cost=op_cost,
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
        if haskey(pm_gen, "name")
            gen_name = pm_gen["name"]
        elseif haskey(pm_gen, "source_id")
            gen_name = strip(string(pm_gen["source_id"][1]) * "-" * pm_gen["source_id"][2])
        else
            gen_name = name
        end

        bus = bus_number_to_bus[pm_gen["gen_bus"]]
        fuel = get(pm_gen, "fuel", "generic")
        unit_type = get(pm_gen, "type", "generic")
        @debug "Found generator" gen_name bus fuel unit_type

        gen_type = get_generator_type(fuel, unit_type, genmap)
        if gen_type == ThermalStandard
            generator = make_thermal_gen(gen_name, pm_gen, bus)
        elseif gen_type == HydroDispatch
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

        add_component!(sys, generator)
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
    return Line(;
        name=name,
        available=Bool(d["br_status"]),
        arch=Arch(bus_f, bus_t),
        r=d["br_r"],
        x=d["br_x"],
        b=(from=d["b_fr"], to=d["b_to"]),
        rate=d["rate_a"],
        anglelimits=(min=rad2deg(d["angmin"]), max=rad2deg(d["angmax"])),
    )
end

function make_transformer_2w(name, d, bus_f, bus_t)
    return Transformer2W(;
        name=name,
        available=Bool(d["br_status"]),
        arch=Arch(bus_f, bus_t),
        r=d["br_r"],
        x=d["br_x"],
        primaryshunt=d["b_fr"],  # TODO: which b ??
        rate=d["rate_a"],
    )
end

function make_tap_transformer(name, d, bus_f, bus_t)
    return TapTransformer(;
        name=name,
        available=Bool(d["br_status"]),
        arch=Arch(bus_f, bus_t),
        r=d["br_r"],
        x=d["br_x"],
        tap=d["tap"],
        primaryshunt=d["b_fr"],  # TODO: which b ??
        rate=d["rate_a"],
    )
end

function make_phase_shifting_transformer(name, d, bus_f, bus_t, alpha)
    return PhaseShiftingTransformer(;
        name=name,
        available=Bool(d["br_status"]),
        arch=Arch(bus_f, bus_t),
        r=d["br_r"],
        x=d["br_x"],
        tap=d["tap"],
        primaryshunt=d["b_fr"],  # TODO: which b ??
        α=alpha,
        rate=d["rate_a"],
    )
end

function read_branch!(sys::System, data, bus_number_to_bus::Dict{Int, Bus})
    @info "Reading branch data"
    if !haskey(data, "branch")
        @info "There is no Branch data in this file"
        return
    end

    for (d_key, d) in data["branch"]
        name = get(d, "name", d_key)
        bus_f = bus_number_to_bus[d["f_bus"]]
        bus_t = bus_number_to_bus[d["t_bus"]]
        value = make_branch(name, d, bus_f, bus_t)

        add_component!(sys, value)
    end
end

function make_dcline(name, d, bus_f, bus_t)
    return HVDCLine(;
        name=name,
        available=Bool(d["br_status"]),
        arch=Arch(bus_f, bus_t),
        activepowerlimits_from=(min=d["pminf"] , max=d["pmaxf"]),
        activepowerlimits_to=(min=d["pmint"], max=d["pmaxt"]),
        reactivepowerlimits_from=(min=d["qminf"], max=d["qmaxf"]),
        reactivepowerlimits_to=(min=d["qmint"], max=d["qmaxt"]),
        loss=(l0=d["loss0"], l1 =d["loss1"]),
    )
end

function read_dcline!(sys::System, data, bus_number_to_bus::Dict{Int, Bus})
    @info "Reading DC Line data"
    if !haskey(data,"dcline")
        @info "There is no DClines data in this file"
        return
    end

    for (d_key, d) in data["dcline"]
        name = get(d, "name", d_key)
        bus_f = bus_number_to_bus[d["f_bus"]]
        bus_t = bus_number_to_bus[d["t_bus"]]

        dcline = make_dcline(name, d, bus_f, bus_t)
        add_component!(sys, dcline)
    end
end

function make_shunt(name, d, bus)
    return FixedAdmittance(;
        name=name,
        available=Bool(d["status"]),
        bus=bus,
        Y=(-d["gs"] + d["bs"]im),
    )
end

function read_shunt!(sys::System, data, bus_number_to_bus::Dict{Int, Bus})
    @info "Reading branch data"
    if !haskey(data,"shunt")
        @info "There is no shunt data in this file"
        return
    end

    for (d_key,d) in data["shunt"]
        name = get(d, "name", d_key)
        bus = bus_number_to_bus[d["shunt_bus"]]
        shunt = make_shunt(name, d, bus)

        add_component!(sys, shunt)
    end
end
