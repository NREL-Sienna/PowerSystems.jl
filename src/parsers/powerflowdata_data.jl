"""Container for data parsed by PowerFlowData"""
struct PowerFlowDataNetwork
    data::PowerFlowData.Network
end

"""
Constructs PowerFlowDataNetwork from a raw file.
Currently Supports PSSE data files v30, v32 and v33
"""
function PowerFlowDataNetwork(file::Union{String,IO}; kwargs...)
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
    read_gen!(sys, data, bus_number_to_bus; kwargs...)
    #read_branch!(sys, data, bus_number_to_bus; kwargs...)
    #read_shunt!(sys, data, bus_number_to_bus; kwargs...)
    #read_dcline!(sys, data, bus_number_to_bus; kwargs...)
    #read_storage!(sys, data, bus_number_to_bus; kwargs...)
    #if runchecks
    #    check(sys)
    #end
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

            load_name = "$(get_name(bus))_load_$(loads.id[ix])"
            has_component(PowerLoad, sys, load_name) &&
                throw(DataFormatError("Found duplicate load names of $(load_name)"))

            load = PowerLoad(;
                name = load_name,
                available = true,
                model = LoadModels.ConstantPower,
                bus = bus,
                active_power = loads.pl[ix] / sys_mbase,
                reactive_power = loads.ql[ix] / sys_mbase,
                max_active_power = loads.pl[ix] / sys_mbase,
                max_reactive_power = loads.ql[ix] / sys_mbase,
                base_power = sys_mbase,
            )

            add_component!(sys, load; skip_validation = SKIP_PM_VALIDATION)
        end
    end
end
