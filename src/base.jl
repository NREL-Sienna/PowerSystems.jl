
const SKIP_PM_VALIDATION = false

"""
System

A power system defined by fields for basepower, components, and forecasts.

```julia
System(basepower)
System(components, basepower)
System(buses, generators, loads, branches, storage, basepower, services, annex; kwargs...)
System(buses, generators, loads, basepower; kwargs...)
System(file; kwargs...)
System(; buses, generators, loads, branches, storage, basepower, services, annex, kwargs...)
System(; kwargs...)
```

# Arguments
- `buses::Vector{Bus}`: an array of buses
- `generators::Vector{Generator}`: an array of generators of (possibly) different types
- `loads::Vector{ElectricLoad}`: an array of load specifications that includes timing of the loads
- `branches::Union{Nothing, Vector{Branch}}`: an array of branches; may be `nothing`
- `storage::Union{Nothing, Vector{Storage}}`: an array of storage devices; may be `nothing`
- `basepower::Float64`: the base power value for the system
- `services::Union{Nothing, Vector{<:Service}}`: an array of services; may be `nothing`

# Keyword arguments
- `runchecks::Bool`: Run available checks on input fields and when add_component! is called.
  Throws InvalidRange if an error is found.
- `time_series_in_memory::Bool=false`: Store time series data in memory instead of HDF5.
- `configpath::String`: specify path to validation config file
"""
struct System <: PowerSystemType
    data::IS.SystemData
    basepower::Float64             # [MVA]
    bus_numbers::Set{Int}
    runchecks::Bool
    internal::IS.InfrastructureSystemsInternal

    function System(data, basepower, internal; kwargs...)
        bus_numbers = Set{Int}()
        runchecks = get(kwargs, :runchecks, true)
        sys = new(data, basepower, bus_numbers, runchecks, internal)
        return sys
    end
end

"""Construct an empty `System`. Useful for building a System while parsing raw data."""
function System(basepower; kwargs...)
    return System(_create_system_data_from_kwargs(; kwargs...), basepower)
end

"""Construct a `System` from `InfrastructureSystems.SystemData`"""
function System(data, basepower; kwargs...)
    internal = get(kwargs, :internal, IS.InfrastructureSystemsInternal())
    return System(data, basepower, internal; kwargs...)
end

"""System constructor when components are constructed externally."""
function System(
    buses::Vector{Bus},
    generators::Vector{<:Generator},
    loads::Vector{<:ElectricLoad},
    branches::Union{Nothing, Vector{<:Branch}},
    storage::Union{Nothing, Vector{<:Storage}},
    basepower::Float64,
    services::Union{Nothing, Vector{<:Service}},
    annex::Union{Nothing,Dict},
    ;
    kwargs...
)

    data = _create_system_data_from_kwargs(; kwargs...)

    sys = System(data, basepower; kwargs...)

    arrays = [buses, generators, loads]
    if !isnothing(branches)
        push!(arrays, branches)
    end
    if !isnothing(storage)
        push!(arrays, storage)
    end
    if !isnothing(services)
        push!(arrays, services)
    end

    error_detected = false
    for component in Iterators.flatten(arrays)
        try
            add_component!(sys, component)
        catch e
            if isa(e, IS.InvalidRange)
                error_detected = true
            else
                rethrow()
            end
        end
    end

    load_zones = isnothing(annex) ? nothing : get(annex, :LoadZones, nothing)
    if !isnothing(load_zones)
        for lz in load_zones
            try
                add_component!(sys, lz)
            catch e
                if isa(e, IS.InvalidRange)
                    error_detected = true
                else
                    rethrow()
                end
            end
        end
    end

    runchecks = get(kwargs, :runchecks, true)

    if error_detected
        throw(IS.InvalidRange("Invalid value(s) detected"))
    end

    if runchecks
        check!(sys)
    end

    return sys
end

"""System constructor without nothing-able arguments."""
function System(
    buses::Vector{Bus},
    generators::Vector{<:Generator},
    loads::Vector{<:ElectricLoad},
    basepower::Float64,
    ;
    kwargs...
)
    return System(
        buses,
        generators,
        loads,
        nothing,
        nothing,
        basepower,
        nothing,
        nothing,
        nothing,
        ;
        kwargs...
    )
end

"""System constructor with keyword arguments."""
function System(;
    basepower=100.0,
    buses,
    generators,
    loads,
    branches,
    storage,
    services,
    annex,
    kwargs...
)
    return System(
        buses,
        generators,
        loads,
        branches,
        storage,
        basepower,
        services,
        annex,
        ;
        kwargs...
    )
end

"""Constructs a non-functional System for demo purposes."""
function System(
    ::Nothing,
    ;
    buses=[Bus(nothing)],
    generators = [ThermalStandard(nothing), RenewableFix(nothing)],
    loads = [PowerLoad(nothing)],
    branches = nothing,
    storage = nothing,
    basepower = 100.0,
    services = nothing,
    annex = nothing,
    kwargs...
)
    return System(
        buses,
        generators,
        loads,
        branches,
        storage,
        basepower,
        services,
        annex,
        ;
        kwargs...
    )
end


"""
Serializes a system to a JSON string.
"""
function to_json(sys::System, filename::AbstractString)
    IS.prepare_for_serialization!(sys.data, filename)
    return IS.to_json(sys, filename)
end

"""
Serializes a system an IO stream in JSON.
"""
function to_json(io::IO, sys::System)
    return IS.to_json(io, sys)
end

"""Constructs a System from a JSON file."""
function System(filename::String)
    sys = IS.from_json(System, filename)
    check!(sys)
    return sys
end

"""
Return a user-modifiable dictionary to store extra information.
"""
get_ext(sys::System) = IS.get_ext(sys.internal)

"""
Clear any value stored in ext.
"""
clear_ext(sys::System) = IS.clear_ext(sys.internal)

"""
Add a component to the system.

Throws ArgumentError if the component's name is already stored for its concrete type.
Throws ArgumentError if any Component-specific rule is violated.
Throws InvalidRange if any of the component's field values are outside of defined valid
range.

# Examples
```julia
sys = System(100.0)

# Add a single component.
add_component!(sys, bus)

# Add many at once.
buses = [bus1, bus2, bus3]
generators = [gen1, gen2, gen3]
foreach(x -> add_component!(sys, x), Iterators.flatten((buses, generators)))
```
"""
function add_component!(sys::System, component::T; kwargs...) where T <: Component
    check_component_addition(sys, component)
    check_for_services_on_addition(sys, component)

    if Bus in fieldtypes(T)
        check_bus(sys, get_bus(component), component)
    end

    if sys.runchecks && !validate_struct(sys, component)
        throw(IS.InvalidValue("Invalid value for $(component)"))
    end

    IS.add_component!(sys.data, component; kwargs...)

    # Whatever this may change should have been validated above in check_component_addition,
    # so this should not fail.
    handle_component_addition!(sys, component)
end

"""
    add_service!(sys::System, service::Service, contributing_devices; kwargs...)

Similar to [`add_component!`](@ref) but for services.

# Arguments
- `sys::System`: system
- `service::Service`: service to add
- `contributing_devices`: Must be an iterable of type Device
"""
function add_service!(sys::System, service::Service, contributing_devices; kwargs...)
    if sys.runchecks && !validate_struct(sys, service)
        throw(InvalidValue("Invalid value for $service"))
    end

    for device in contributing_devices
        device_type = typeof(device)
        if !(device_type <: Device)
            throw(ArgumentError("contributing_devices must be of type Device"))
        end

        name = get_name(device)
        sys_device = get_component(device_type, sys, name)
        if isnothing(sys_device)
            throw(ArgumentError("device $device_type $name is not part of the system"))
        end
    end

    # Since this isn't atomic, order is important. Add to system before adding to devices.
    IS.add_component!(sys.data, service; kwargs...)

    for device in contributing_devices
        add_service!(device, service)
    end
end

"""
Adds forecasts from a metadata file or metadata descriptors.

# Arguments
- `sys::System`: system
- `metadata_file::AbstractString`: metadata file for timeseries
  that includes an array of IS.TimeseriesFileMetadata instances or a vector.
- `resolution::DateTime.Period=nothing`: skip forecast that don't match this resolution.
"""
function add_forecasts!(
    sys::System,
    metadata_file::AbstractString;
    resolution = nothing,
)
    return IS.add_forecasts!(Component, sys.data, metadata_file; resolution=resolution)
end

"""
Adds forecasts from a metadata file or metadata descriptors.

# Arguments
- `sys::System`: system
- `timeseries_metadata::Vector{IS.TimeseriesFileMetadata}`: metadata for timeseries
- `resolution::DateTime.Period=nothing`: skip forecast that don't match this resolution.
"""
function add_forecasts!(
    sys::System,
    timeseries_metadata::Vector{IS.TimeseriesFileMetadata};
    resolution = nothing,
)
    return IS.add_forecasts!(Component, sys.data, timeseries_metadata;
                             resolution=resolution)
end

function IS.add_forecast!(
    ::Type{<:Component},
    data::IS.SystemData,
    forecast_cache::IS.ForecastCache,
    metadata::IS.TimeseriesFileMetadata;
    resolution=nothing,
)
    IS.set_component!(metadata, data, PowerSystems)
    component = metadata.component
    if isnothing(component)
        return
    end

    forecast, ts_data = IS.make_forecast!(forecast_cache, metadata; resolution=resolution)
    if isnothing(forecast)
        return
    end

    if component isa LoadZones
        uuids = Set([IS.get_uuid(x) for x in get_buses(component)])
        for component_ in (
            load for load in IS.get_components(ElectricLoad, data) if get_bus(load) |> IS.get_uuid in uuids
        )
            IS.add_forecast!(data, component_, forecast, ts_data)
        end
    else
        IS.add_forecast!(data, component, forecast, ts_data)
    end
end

"""
Iterates over all components.

# Examples
```julia
for component in iterate_components(sys)
    @show component
end
```

See also: [`get_components`](@ref)
"""
function iterate_components(sys::System)
    return IS.iterate_components(sys.data)
end

"""
Remove all components from the system.
"""
function clear_components!(sys::System)
    return IS.clear_components!(sys.data)
end

"""
Remove all components of type T from the system.

Throws ArgumentError if the type is not stored.
"""
function remove_components!(::Type{T}, sys::System) where T <: Component
    for component in IS.remove_components!(T, sys.data)
        handle_component_removal!(sys, component)
    end
end

"""
Remove a component from the system by its value.

Throws ArgumentError if the component is not stored.
"""
function remove_component!(sys::System, component::T) where T <: Component
    IS.remove_component!(sys.data, component)
    handle_component_removal!(sys, component)
end

"""
Remove a component from the system by its name.

Throws ArgumentError if the component is not stored.
"""
function remove_component!(
    ::Type{T},
    sys::System,
    name::AbstractString,
) where T <: Component
    component = IS.remove_component!(T, sys.data, name)
    handle_component_removal!(sys, component)
end

"""
Get the component of concrete type T with name. Returns nothing if no component matches.

See [`get_components_by_name`](@ref) if the concrete type is unknown.

Throws ArgumentError if T is not a concrete type.
"""
function get_component(::Type{T}, sys::System, name::AbstractString) where T <: Component
    return IS.get_component(T, sys.data, name)
end

"""
Returns an iterator of components. T can be concrete or abstract.
Call collect on the result if an array is desired.

# Examples
```julia
iter = PowerSystems.get_components(ThermalStandard, sys)
iter = PowerSystems.get_components(Generator, sys)
generators = PowerSystems.get_components(Generator, sys) |> collect
generators = collect(PowerSystems.get_components(Generator, sys))
```

See also: [`iterate_components`](@ref)
"""
function get_components(
    ::Type{T},
    sys::System,
) where {T <: Component}
    # TODO: Verify that return type annotation is not required
    return IS.get_components(T, sys.data)
end

# The following functions are reimplemented because Reserve subtypes are parameterized and
# so we cannot auto-discover the types.

function get_components(::Type{Component}, sys::System)
    return FlattenIteratorWrapper(
        Component,
        [
            IS.get_components(Component, sys.data),
            get_components(Service, sys),
        ],
    )
end

function get_components(::Type{Service}, sys::System)
    return FlattenIteratorWrapper(
        Service,
        [IS.get_components(x, sys.data) for x in SERVICE_STRUCT_TYPES]
    )
end

function get_components(::Type{Reserve}, sys::System)
    return FlattenIteratorWrapper(
        Reserve,
        [IS.get_components(x, sys.data) for x in RESERVE_STRUCT_TYPES]
    )
end

function get_components(::Type{StaticReserve}, sys::System)
    return FlattenIteratorWrapper(
        StaticReserve,
        [IS.get_components(x, sys.data) for x in STATIC_RESERVE_STRUCT_TYPES]
    )
end

function get_components(::Type{VariableReserve}, sys::System)
    return FlattenIteratorWrapper(
        VariableReserve,
        [IS.get_components(x, sys.data) for x in VARIABLE_RESERVE_STRUCT_TYPES]
    )
end

function IS.get_components_by_name(
    ::Type{Service},
    data::IS.SystemData,
    name::AbstractString
)
    return _get_components_by_name(SERVICE_STRUCT_TYPES, data, name)
end

function IS.get_components_by_name(
    ::Type{Reserve},
    data::IS.SystemData,
    name::AbstractString
)
    return _get_components_by_name(RESERVE_STRUCT_TYPES, data, name)
end

function IS.get_components_by_name(
    ::Type{StaticReserve},
    data::IS.SystemData,
    name::AbstractString
)
    return _get_components_by_name(STATIC_RESERVE_STRUCT_TYPES, data, name)
end

function IS.get_components_by_name(
    ::Type{VariableReserve},
    data::IS.SystemData,
    name::AbstractString
)
    return _get_components_by_name(VARIABLE_RESERVE_STRUCT_TYPES, data, name)
end

function _get_components_by_name(abstract_types, data::IS.SystemData, name::AbstractString)
    _components = []
    for subtype in abstract_types
        component = IS.get_component(subtype, data, name)
        if !isnothing(component)
            push!(_components, component)
        end
    end

    return _components
end

"""
    get_components_by_name(
                           ::Type{T},
                           sys::System,
                           name::AbstractString
                          ) where {T <: Component}

Get the components of abstract type T with name. Note that PowerSystems enforces unique
names on each concrete type but not across concrete types.

See [`get_component`](@ref) if the concrete type is known.

Throws ArgumentError if T is not an abstract type.
"""
function get_components_by_name(
    ::Type{T},
    sys::System,
    name::AbstractString
) where {T <: Component}
    # TODO: Verify that return type annotation is not required
    return IS.get_components_by_name(T, sys.data, name)
end

"""
    get_contributing_devices(sys::System, service::Service)

Return a vector of devices contributing to the service.
"""
function get_contributing_devices(sys::System, service::T) where T <: Service
    if isnothing(get_component(T, sys, get_name(service)))
        throw(ArgumentError("service $(get_name(service)) is not part of the system"))
    end

    return [x for x in get_components(Device, sys) if has_service(x, service)]
end

struct ServiceContributingDevices
    service::Service
    contributing_devices::Vector{Device}
end

const ServiceContributingDevicesKey = NamedTuple{(:type, :name), Tuple{DataType, String}}
const ServiceContributingDevicesMapping = Dict{
    ServiceContributingDevicesKey,
    ServiceContributingDevices
}

"""
    get_contributing_device_mapping(sys::System)

Return an instance of ServiceContributingDevicesMapping.
"""
function get_contributing_device_mapping(sys::System)
    services = ServiceContributingDevicesMapping()
    for service in get_components(Service, sys)
        uuid = IS.get_uuid(service)
        devices = ServiceContributingDevices(service, Vector{Device}())
        for device in get_components(Device, sys)
            for _service in get_services(device)
                if IS.get_uuid(_service) == uuid
                    push!(devices.contributing_devices, device)
                    break
                end
            end

            key = ServiceContributingDevicesKey((typeof(service), get_name(service)))
            services[key] = devices
        end
    end

    return services
end

"""
Adds forecast to the system.

Throws ArgumentError if the component is not stored in the system.

"""
function add_forecast!(sys::System, component::Component, forecast::Forecast)
    return IS.add_forecast!(sys.data, component, forecast)
end

"""
Add a forecast to a system from a CSV file.

See [`InfrastructureSystems.TimeseriesFileMetadata`](@ref) for description of
scaling_factor.
"""
function add_forecast!(
    sys::System,
    filename::AbstractString,
    component::Component,
    label::AbstractString,
    scaling_factor::Union{String, Float64}=1.0,
)
    return IS.add_forecast!(sys.data, filename, component, label, scaling_factor)
end

"""
Add a forecast to a system from a TimeSeries.TimeArray.

See [`InfrastructureSystems.TimeseriesFileMetadata`](@ref) for description of
scaling_factor.
"""
function add_forecast!(
    sys::System,
    ta::TimeSeries.TimeArray,
    component,
    label,
    scaling_factor::Union{String, Float64}=1.0,
)
    return IS.add_forecast!(sys.data, ta, component, label, scaling_factor)
end

"""
Add a forecast to a system from a DataFrames.DataFrame.

See [`InfrastructureSystems.TimeseriesFileMetadata`](@ref) for description of
scaling_factor.
"""
function add_forecast!(
    sys::System,
    df::DataFrames.DataFrame,
    component,
    label,
    scaling_factor::Union{String, Float64}=1.0,
)
    return IS.add_forecast!(sys.data, df, component, label, scaling_factor)
end

"""
Return a vector of forecasts from a metadata file.

# Arguments
- `data::SystemData`: system
- `metadata_file::AbstractString`: path to metadata file
- `resolution::{Nothing, Dates.Period}`: skip any forecasts that don't match this resolution

See [`InfrastructureSystems.TimeseriesFileMetadata`](@ref) for description of what the file
should contain.
"""
function make_forecasts(sys::System, metadata_file::AbstractString; resolution=nothing)
    return IS.make_forecasts(sys.data, metadata_file, PowerSystems; resolution=resolution)
end

"""
Return a vector of forecasts from a vector of TimeseriesFileMetadata values.

# Arguments
- `data::SystemData`: system
- `timeseries_metadata::Vector{TimeseriesFileMetadata}`: metadata values
- `resolution::{Nothing, Dates.Period}`: skip any forecasts that don't match this resolution
"""
function make_forecasts(
    sys::System,
    metadata::Vector{IS.TimeseriesFileMetadata};
    resolution = nothing
)
    return IS.make_forecasts(sys.data, metadata, PowerSystems; resolution=resolution)
end

"""
Return true if forecasts are stored contiguously.

Throws ArgumentError if there are no forecasts stored.
"""
function are_forecasts_contiguous(sys::System)
    return IS.are_forecasts_contiguous(sys.data)
end

"""
"""
function are_forecasts_contiguous(component::Component)
    return IS.are_forecasts_contiguous(component)
end

"""
Generates all possible initial times for the stored forecasts. This should return the same
result regardless of whether the forecasts have been stored as one contiguous array or
chunks of contiguous arrays, such as one 365-day forecast vs 365 one-day forecasts.

Throws ArgumentError if there are no forecasts stored, interval is not a multiple of the
system's forecast resolution, or if the stored forecasts have overlapping timestamps.

# Arguments
- `sys::System`: System.
- `interval::Dates.Period`: Amount of time in between each initial time.
- `horizon::Int`: Length of each forecast array.
- `initial_time::Union{Nothing, Dates.DateTime}=nothing`: Start with this time. If nothing,
  use the first initial time.
"""
function generate_initial_times(
    sys::System,
    interval::Dates.Period,
    horizon::Int;
    initial_time::Union{Nothing, Dates.DateTime} = nothing
)
    return IS.generate_initial_times(
        sys.data, interval, horizon; initial_time = initial_time
    )
end

"""
Generate initial times for a component.
"""
function generate_initial_times(
    component::IS.InfrastructureSystemsType,
    interval::Dates.Period,
    horizon::Int;
    initial_time::Union{Nothing, Dates.DateTime} = nothing,
)
    return IS.generate_initial_times(
        component, interval, horizon; initial_time = initial_time
    )
end

"""
Return a forecast for the entire time series range stored for these parameters.
"""
function get_forecast(
    ::Type{T},
    component::Component,
    initial_time::Dates.DateTime,
    label::AbstractString,
) where T <: Forecast
    return IS.get_forecast(T, component, initial_time, label)
end

"""
Return a forecast for a subset of the time series range stored for these parameters.
"""
function get_forecast(
    ::Type{T},
    component::IS.InfrastructureSystemsType,
    initial_time::Dates.DateTime,
    label::AbstractString,
    horizon::Int,
) where T <: Forecast
    return IS.get_forecast(T, component, initial_time, label, horizon)
end

function get_forecast_initial_times(
                                    ::Type{T},
                                    component::Component,
                                   ) where T <: Forecast
    return IS.get_forecast_initial_times(T, component)
end

function get_forecast_initial_times(
                                    ::Type{T},
                                    component::Component,
                                    label::AbstractString
                                   ) where T <: Forecast
    return IS.get_forecast_initial_times(T, component, label)
end

function get_forecast_labels(
                             ::Type{T},
                             component::Component,
                             initial_time::Dates.DateTime,
                            ) where T <: Forecast
    return IS.get_forecast_labels(T, component, initial_time)
end

"""
Return a TimeSeries.TimeArray where the forecast data has been multiplied by the forecasted
component field.
"""
function get_forecast_values(component::Component, forecast::Forecast)
    return IS.get_forecast_values(PowerSystems, component, forecast)
end

"""
Return sorted forecast initial times.
"""
function get_forecast_initial_times(sys::System)
    return IS.get_forecast_initial_times(sys.data)
end

"""
Return an iterable of NamedTuple keys for forecasts stored for this component.
"""
function get_forecast_keys(component::Component)
    return IS.get_forecast_keys(component)
end

"""
Return the horizon for all forecasts.
"""
function get_forecasts_horizon(sys::System)
    return IS.get_forecasts_horizon(sys.data)
end

"""
Return the earliest initial_time for a forecast.
"""
function get_forecasts_initial_time(sys::System)
    return IS.get_forecasts_initial_time(sys.data)
end

"""
Return the interval for all forecasts.
"""
function get_forecasts_interval(sys::System)
    return IS.get_forecasts_interval(sys.data)
end

"""
Return the resolution for all forecasts.
"""
function get_forecasts_resolution(sys::System)
    return IS.get_forecasts_resolution(sys.data)
end

"""
Iterates over all forecasts in order of initial time.

# Examples
```julia
for forecast in iterate_forecasts(sys)
    @show forecast
end
```
"""
function iterate_forecasts(sys::System)
    return IS.iterate_forecasts(sys.data)
end

"""
Remove all forecasts from the system.
"""
function clear_forecasts!(sys::System)
    return IS.clear_forecasts!(sys.data)
end

"""
Throws DataFormatError if forecasts have inconsistent parameters.
"""
function check_forecast_consistency(sys::System)
    IS.check_forecast_consistency(sys.data)
end

"""
Return true if all forecasts have consistent parameters.
"""
function validate_forecast_consistency(sys::System)
    return IS.validate_forecast_consistency(sys.data)
end

"""
Remove the time series data for a component.
"""
function remove_forecast!(
    ::Type{T},
    sys::System,
    component::Component,
    initial_time::Dates.DateTime,
    label::String,
) where T <: Forecast
    return IS.remove_forecast!(T, sys.data, component, initial_time, label)
end

"""
Validates an instance of a PowerSystemType against System data.
Returns true if the instance is valid.

Users implementing this function for custom types should consider implementing
InfrastructureSystems.validate_struct instead if the validation logic only requires data
contained within the instance.
"""
function validate_struct(sys::System, value::PowerSystemType)
    return true
end

function check!(sys::System)
    buses = get_components(Bus, sys)
    slack_bus_check(buses)
    buscheck(buses)
end

function JSON2.write(io::IO, sys::System)
    return JSON2.write(io, encode_for_json(sys))
end

function JSON2.write(sys::System)
    return JSON2.write(encode_for_json(sys))
end

function encode_for_json(sys::T) where T <: System
    fields = fieldnames(T)
    final_fields = Vector{Symbol}()
    vals = []

    for field in fields
        # Exclude bus_numbers because they will get rebuilt during deserialization.
        if field != :bus_numbers
            push!(vals, getfield(sys, field))
            push!(final_fields, field)
        end
    end

    return NamedTuple{Tuple(final_fields)}(vals)
end

function JSON2.read(io::IO, ::Type{System})
    raw = JSON2.read(io, NamedTuple)
    data = IS.deserialize(IS.SystemData, Component, raw.data)
    internal = IS.convert_type(InfrastructureSystemsInternal, raw.internal)
    sys = System(data, float(raw.basepower); internal=internal, runchecks=raw.runchecks)
    return sys
end

function IS.deserialize_components(
                                   ::Type{Component},
                                   data::IS.SystemData,
                                   raw::NamedTuple,
                                  )
    # TODO: This adds components through IS.SystemData instead of System, which is what
    # should happen. There is a catch-22 between creating System and SystemData.
    # This means that the restrictions in add_component! are not applied here.

    # Maintain a lookup of UUID to component because some component types encode
    # composed types as UUIDs instead of actual types.
    component_cache = Dict{Base.UUID, Component}()

    components_as_uuids = [Bus]
    for component_as_uuid in components_as_uuids
        for component in IS.get_components_raw(IS.SystemData, component_as_uuid, raw)
            comp = IS.convert_type(component_as_uuid, component)
            IS.add_component!(data, comp)
            component_cache[IS.get_uuid(comp)] = comp
        end
    end

    # Skip Devices this round because they have Services.
    for c_type_sym in IS.get_component_types_raw(IS.SystemData, raw)
        c_type = _get_component_type(c_type_sym)
        (c_type in components_as_uuids || c_type <: Device) && continue
        for component in IS.get_components_raw(IS.SystemData, c_type, raw)
            comp = IS.convert_type(c_type, component, component_cache)
            IS.add_component!(data, comp)
            component_cache[IS.get_uuid(comp)] = comp
        end
    end

    # Now get the Devices.
    for c_type_sym in IS.get_component_types_raw(IS.SystemData, raw)
        c_type = _get_component_type(c_type_sym)
        if c_type <: Device
            for component in IS.get_components_raw(IS.SystemData, c_type, raw)
                comp = IS.convert_type(c_type, component, component_cache)
                IS.add_component!(data, comp)
            end
        end
    end
end

function _get_component_type(component_type::Symbol)
    base_name = IS.strip_module_name(string(component_type))
    type_name, parameters = IS.separate_type_and_parameter_types(base_name)
    c_type = getfield(PowerSystems, Symbol(type_name))
    if !isempty(parameters)
        parametric_types = [getfield(PowerSystems, Symbol(x)) for x in parameters]
        c_type = c_type{parametric_types...}
    end

    return c_type
end

function JSON2.write(io::IO, component::T) where T <: Component
    return JSON2.write(io, encode_for_json(component))
end

function JSON2.write(component::T) where T <: Component
    return JSON2.write(encode_for_json(component))
end

"""
Encode composed buses as UUIDs.
"""
function encode_for_json(component::T) where T <: Component
    fields = fieldnames(T)
    vals = []

    for name in fields
        val = getfield(component, name)
        if val isa Bus
            push!(vals, IS.get_uuid(val))
        else
            push!(vals, val)
        end
    end

    return NamedTuple{fields}(vals)
end

function IS.convert_type(
                         ::Type{T},
                         data::NamedTuple,
                         component_cache::Dict,
                        ) where T <: Component
    @debug T data
    values = []
    for (fieldname, fieldtype)  in zip(fieldnames(T), fieldtypes(T))
        val = getfield(data, fieldname)
        if fieldtype <: Bus
            uuid = Base.UUID(val.value)
            bus = component_cache[uuid]
            push!(values, bus)
        elseif fieldtype <: Component
            # Recurse.
            push!(values, IS.convert_type(fieldtype, val, component_cache))
        else
            obj = IS.convert_type(fieldtype, val)
            push!(values, obj)
        end
    end

    return T(values...)
end

"""
Return bus with name.
"""
function get_bus(sys::System, name::String)
    return get_component(Bus, sys, name)
end

"""
Return bus with bus_number.
"""
function get_bus(sys::System, bus_number::Int)
    for bus in get_components(Bus, sys)
        if bus.number == bus_number
            return bus
        end
    end

    return nothing
end

"""
Return all buses values with bus_numbers.
"""
function get_buses(sys::System, bus_numbers::Set{Int})
    buses = Vector{Bus}()
    for bus in get_components(Bus, sys)
        if bus.number in bus_numbers
            push!(buses, bus)
        end
    end

    return buses
end

check_for_services_on_addition(sys::System, component::Component) = nothing

function check_for_services_on_addition(sys::System, component::Device)
    if length(get_services(component)) > 0
        throw(ArgumentError("type Device cannot be added with services"))
    end
end

"""
Throws ArgumentError if a PowerSystems rule blocks addition to the system.

This method is tied with handle_component_addition!. If the methods are re-implemented for
a subtype then whatever is added in handle_component_addition! must be checked here.
"""
check_component_addition(sys::System, component::Component) = nothing

"""
Refer to docstring for check_component_addition!
"""
handle_component_addition!(sys::System, component::Component) = nothing

handle_component_removal!(sys::System, component::Component) = nothing

function check_component_addition(sys::System, branch::Branch)
    arc = get_arc(branch)
    check_bus(sys, get_from(arc), arc)
    check_bus(sys, get_to(arc), arc)
end

function check_component_addition(sys::System, bus::Bus)
    number = get_number(bus)
    if number in sys.bus_numbers
        throw(ArgumentError("bus number $number is already stored in the system"))
    end
end

function handle_component_addition!(sys::System, bus::Bus)
    number = get_number(bus)
    @assert !(number in sys.bus_numbers) "bus number $number is already stored"
    push!(sys.bus_numbers, number)
end

"""
Throws ArgumentError if the bus number is not stored in the system.
"""
function handle_component_removal!(sys::System, bus::Bus)
    number = get_number(bus)
    @assert number in sys.bus_numbers "bus number $number is not stored"
    pop!(sys.bus_numbers, number)
end

function handle_component_removal!(sys::System, device::Device)
    # This may have to be refactored if handle_component_removal! needs to be implemented
    # for a subtype.
    clear_services!(device)
end

function handle_component_removal!(sys::System, service::Service)
    for device in get_components(Device, sys)
        _remove_service!(device, service)
    end
end

"""
Return a sorted vector of bus numbers in the system.
"""
function get_bus_numbers(sys::System)
    return sort(collect(sys.bus_numbers))
end

"""
Throws ArgumentError if the bus is not stored in the system.
"""
function check_bus(sys::System, bus::Bus, component::Component)
    name = get_name(bus)
    if isnothing(get_component(Bus, sys, name))
        throw(ArgumentError("$component has bus $name that is not stored in the system"))
    end
end

function IS.compare_values(x::System, y::System)
    match = true

    if x.basepower != y.basepower
        @debug "basepower does not match" x.basepower y.basepower
        match = false
    end

    if !IS.compare_values(x.data, y.data)
        @debug "SystemData values do not match"
        match = false
    end

    return match
end

function _create_system_data_from_kwargs(; kwargs...)
    validation_descriptor_file = nothing
    runchecks = get(kwargs, :runchecks, true)
    time_series_in_memory = get(kwargs, :time_series_in_memory, false)
    if runchecks
        validation_descriptor_file = get(
            kwargs, :configpath, POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE
        )
    end

    return IS.SystemData(;
        validation_descriptor_file = validation_descriptor_file,
        time_series_in_memory = time_series_in_memory
    )
end
