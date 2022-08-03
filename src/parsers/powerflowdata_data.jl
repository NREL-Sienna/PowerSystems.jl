"""Container for data parsed by PowerFlowData"""
struct PowerFlowDataNetwork
    data::PowerFlowData.Network
end

"""
Constructs PowerFlowDataNetwork from a raw file.
Currently Supports PSSE data files v30, v32 and v33
"""
function PowerFlowDataNetwork(file::Union{String, IO}; kwargs...)
    return PowerFlowDataNetwork(PowerFlowData.parse_network(file))
end

"""
Constructs a System from PowerModelsData.

# Arguments
- `pfd_data::Union{PowerFlowDataNetwork, Union{String, IO}}`: PowerModels data object or supported
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
function System(net_data::PowerFlowDataNetwork; kwargs...)
    runchecks = get(kwargs, :runchecks, true)
    data = net_data.data
    if length(data.buses) < 1
        throw(DataFormatError("There are no buses in this file."))
    end

    @info "Constructing System from PowerFlowData version v$(data.caseid.rev)"

    sys = System(data.caseid.sbase; frequency = data.caseid.basfrq, kwargs...)
    bus_number_to_bus = read_bus!(sys, data.buses, data; kwargs...)
    read_loads!(sys, data.loads, data.caseid.sbase, bus_number_to_bus; kwargs...)
    read_gen!(sys, data.generators, data.caseid.sbase, bus_number_to_bus; kwargs...)
    read_branch!(sys, data.branches, data.caseid.sbase, bus_number_to_bus; kwargs...)
    read_shunt!(sys, data, bus_number_to_bus; kwargs...)
    read_switched_shunt!(sys, data.fixed_shunts, data.caseid.sbase, bus_number_to_bus; kwargs...)
    read_dcline!(sys, data.multi_terminal_dc, data.caseid.sbase, bus_number_to_bus; kwargs...)

    if runchecks
        check(sys)
    end
    return sys
end

function read_bus!(
    sys::System,
    buses::PowerFlowData.Buses33,
    data::PowerFlowData.Network;
    kwargs...,
)
    bus_number_to_bus = Dict{Int, Bus}()

    bus_types = instances(MatpowerBusTypes)

    _get_name = get(kwargs, :bus_name_formatter, strip)
    for ix in eachindex(buses.i)
        # d id the data dict for each bus
        # d_key is bus key
        bus_name = _get_name(buses.name[ix])
        has_component(Bus, sys, bus_name) && throw(
            DataFormatError(
                "Found duplicate bus names of $bus_name, consider formatting names with `bus_name_formatter` kwarg",
            ),
        )
        bus_number = buses.i[ix]
        if isempty(data.area_interchanges)
            area_name = string(buses.area[ix])
            @debug "File doesn't contain area names"
        else
            area_ix = data.area_interchanges.i .== buses.area[ix]
            area_name = first(data.area_interchanges.arname[area_ix])
        end

        area = get_component(Area, sys, area_name)
        if isnothing(area)
            area = Area(area_name)
            add_component!(sys, area; skip_validation = SKIP_PM_VALIDATION)
        end

        # TODO: LoadZones need to be created and populated here

        bus = Bus(
            bus_number,
            bus_name,
            bus_types[buses.ide[ix]],
            clamp(buses.va[ix] * (π / 180), -π / 2, π / 2),
            buses.vm[ix],
            (min = buses.nvlo[ix], max = buses.nvhi[ix]),
            buses.basekv[ix],
            area,
        )

        bus_number_to_bus[bus_number] = bus

        add_component!(sys, bus; skip_validation = SKIP_PM_VALIDATION)
    end

    return bus_number_to_bus
end

function read_bus!(
    sys::System,
    buses::PowerFlowData.Buses30,
    data::PowerFlowData.Network;
    kwargs...,
)
    bus_number_to_bus = Dict{Int, Bus}()

    bus_types = instances(MatpowerBusTypes)

    _get_name = get(kwargs, :bus_name_formatter, strip)
    for ix in 1:length(buses)
        # d id the data dict for each bus
        # d_key is bus key
        bus_name = _get_name(buses.name[ix])
        has_component(Bus, sys, bus_name) && throw(
            DataFormatError(
                "Found duplicate bus names of $bus_name, consider formatting names with `bus_name_formatter` kwarg",
            ),
        )
        bus_number = buses.i[ix]
        if isempty(data.area_interchanges)
            area_name = string(buses.area[ix])
            @debug "File doesn't contain area names"
        else
            area_ix = data.area_interchanges.i .== buses.area[ix]
            area_name = first(data.area_interchanges.arname[area_ix])
        end
        area = get_component(Area, sys, area_name)
        if isnothing(area)
            area = Area(area_name)
            add_component!(sys, area; skip_validation = SKIP_PM_VALIDATION)
        end

        # TODO: LoadZones need to be created and populated here

        bus = Bus(
            bus_number,
            bus_name,
            bus_types[buses.ide[ix]],
            clamp(buses.va[ix] * (π / 180), -π / 2, π / 2),
            buses.vm[ix],
            nothing, # PSSe 30 data doesn't have magnitude limits
            buses.basekv[ix],
            area,
        )

        bus_number_to_bus[bus_number] = bus

        add_component!(sys, bus; skip_validation = SKIP_PM_VALIDATION)

        if buses.bl[ix] > 0 || buses.gl[ix] > 0
            shunt = FixedAdmittance(bus_name, true, bus, buses.gl[ix] + 1im * buses.bl[ix])
            add_component!(sys, shunt; skip_validation = SKIP_PM_VALIDATION)
        end
    end

    return bus_number_to_bus
end

function read_loads!(
    sys::System,
    loads::PowerFlowData.Loads,
    sys_mbase::Float64,
    bus_number_to_bus::Dict{Int, Bus};
    kwargs...,
)
    if isempty(loads)
        @error "There are no loads in this file"
        return
    end
    for ix in eachindex(loads.i)
        total_load =
            loads.pl[ix] +
            loads.ql[ix] +
            loads.ip[ix] +
            loads.iq[ix] +
            loads.yp[ix] +
            loads.yq[ix]
        if total_load != 0.0
            bus = bus_number_to_bus[loads.i[ix]]

            load_name = "load-$(get_name(bus))-$(loads.i[ix])-$(loads.id[ix])"
            if has_component(PowerLoad, sys, load_name)
                throw(DataFormatError("Found duplicate load names of $(load_name)"))
            end

            load = StandardLoad(;
                name = load_name,
                available = true,
                bus = bus,
                constant_active_power = loads.pl[ix] / sys_mbase,
                constant_reactive_power = loads.ql[ix] / sys_mbase,
                impedance_active_power = loads.yp[ix] / sys_mbase,
                impedance_reactive_power = loads.yq[ix] / sys_mbase,
                current_active_power = loads.ip[ix] / sys_mbase,
                current_reactive_power = loads.iq[ix] / sys_mbase,
                max_constant_active_power = loads.pl[ix] / sys_mbase,
                max_constant_reactive_power = loads.ql[ix] / sys_mbase,
                max_impedance_active_power = loads.yp[ix] / sys_mbase,
                max_impedance_reactive_power = loads.yq[ix] / sys_mbase,
                max_current_active_power = loads.ip[ix] / sys_mbase,
                max_current_reactive_power = loads.iq[ix] / sys_mbase,
                base_power = sys_mbase,
            )

            add_component!(sys, load; skip_validation = SKIP_PM_VALIDATION)
        end
    end
    return nothing
end

function _get_active_power_limits(pt::Float64, pb::Float64, machine_base::Float64, system_base::Float64)
    min_p = 0.0
    if pb < 0.0
        @info "Min power in dataset is negative, active_power_limits minimum set to 0.0"
    else
        min_p = pb
    end

    if machine_base != system_base && pt >= machine_base
        @info "Max active power limit is $(pt/machine_base) than the generator base. Check the data"
    end

    return (min = min_p / machine_base, max = pt / machine_base)
end

function read_gen!(
    sys::System,
    gens::PowerFlowData.Generators,
    sys_mbase::Float64,
    bus_number_to_bus::Dict{Int, Bus};
    kwargs...,
)
    @info "Reading generator data"

    if isempty(gens)
        @error "There are no generators in this file"
        return
    end

    for ix in eachindex(gens.i)
        bus = get(bus_number_to_bus, gens.i[ix], nothing)
        if isnothing(bus)
            error("Incorrect bus id for generator $(gens.i[ix])-$(gens.id[ix])")
        end

        gen_name = "gen-$(get_name(bus))-$(gens.i[ix])-$(gens.id[ix])"
        if has_component(ThermalStandard, sys, gen_name)
            throw(DataFormatError("Found duplicate load names of $(gen_name)"))
        end

        load = ThermalStandard(;
            name = gen_name,
            available = gens.stat[ix] > 0 ? true : false,
            status = gens.stat[ix] > 0 ? true : false,
            bus = bus,
            active_power = gens.pg[ix] / gens.mbase[ix],
            reactive_power = gens.qg[ix] / gens.mbase[ix],
            active_power_limits = _get_active_power_limits(gens.pt[ix], gens.pb[ix], gens.mbase[ix], sys_mbase),
            reactive_power_limits = (min = gens.qb[ix] / sys_mbase, max = gens.qt[ix] / sys_mbase),
            base_power = gens.mbase[ix],
            rating = gens.mbase[ix],
            ramp_limits = nothing,
            time_limits = nothing,
            operation_cost = TwoPartCost(0.0, 0.0)
        )

        add_component!(sys, load; skip_validation = SKIP_PM_VALIDATION)
    end
    return nothing
end

function read_branch!(
    sys::System,
    branches::PowerFlowData.Branches30,
    sys_mbase::Float64,
    bus_number_to_bus::Dict{Int, Bus};
    kwargs...,
)
    @info "Reading line data"

    if isempty(branches)
        @error "There are no lines in this file"
        return
    end

    for ix in eachindex(branches.i)
        bus_from = bus_number_to_bus[branches.i[ix]]
        bus_to = bus_number_to_bus[branches.j[ix]]
        branch_name = "line-$(get_name(bus_from))-$(get_name(bus_to))-$(branches.ckt[ix])"
        max_rate = max(branches.rate_a[ix],branches.rate_b[ix], branches.rate_c[ix])
        if max_rate == 0.0
            max_rate = abs(1/(branches.r[ix] + 1im * branches.x[ix])) * sys_mbase
        end
        branch = Line(
            name = branch_name,
            available = branches.st[ix] > 0 ? true : false,
            active_power_flow = 0.0,
            reactive_power_flow = 0.0,
            arc = Arc(bus_from, bus_to),
            r = branches.r[ix],
            x = branches.x[ix],
            b = (from = branches.bi[ix], to = branches.bj[ix]),
            angle_limits = (min = -π/2, max = π/2),
            rate = max_rate
        )

        add_component!(sys, branch; skip_validation = SKIP_PM_VALIDATION)
    end

    return nothing
end

function read_shunt!(
    sys::System,
    ::Nothing,
    sys_mbase::Float64,
    bus_number_to_bus::Dict{Int, Bus};
    kwargs...,
)
    return nothing
end

function read_shunt!(
    sys::System,
    ::PowerFlowData.SwitchedShunts30,
    sys_mbase::Float64,
    bus_number_to_bus::Dict{Int, Bus};
    kwargs...,
)
    return nothing
end

function read_dcline!(sys::System,
    dc_lines::PowerFlowData.TwoTerminalDCLines,
    sys_mbase::Float64,
    bus_number_to_bus::Dict{Int, Bus};
    kwargs...,
)
    return nothing
end
