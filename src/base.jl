
const SKIP_PM_VALIDATION = false

"""
    System

    A power system defined by fields for basepower, components, and forecasts.

    # Constructor
    ```julia
    System(basepower)
    System(components, forecasts, basepower)
    System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
    System(buses, generators, loads, basepower; kwargs...)
    System(file; kwargs...)
    System(; buses, generators, loads, branches, storage, basepower, forecasts, services, annex, kwargs...)
    System(; kwargs...)
    ```

    # Arguments

    * `buses`::Vector{Bus} : an array of buses
    * `generators`::Vector{Generator} : an array of generators of (possibly) different types
    * `loads`::Vector{ElectricLoad} : an array of load specifications that includes timing of the loads
    * `branches`::Union{Nothing, Vector{Branch}} : an array of branches; may be `nothing`
    * `storage`::Union{Nothing, Vector{Storage}} : an array of storage devices; may be `nothing`
    * `basepower`::Float64 : the base power value for the system
    * `forecasts`::Union{Nothing, IS.Forecasts} : dictionary of forecasts
    * `services`::Union{Nothing, Vector{ <: Service}} : an array of services; may be `nothing`

    # Keyword arguments

    * `runchecks`::Bool : run available checks on input fields. If an error is found in a field, that component will not be added to the system and InvalidRange is thrown.
    * `configpath`::String : specify path to validation config file
    DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE
"""
struct System <: PowerSystemType
    data::IS.SystemData
    basepower::Float64             # [MVA]
    runchecks::Bool
    internal::InfrastructureSystemsInternal

    function System(data, basepower, internal; kwargs...)
        runchecks = get(kwargs, :runchecks, true)
        sys = new(data, basepower, runchecks, internal)
    end
end

"""Construct an empty System. Useful for building a System while parsing raw data."""
function System(basepower; kwargs...)
    return System(_create_system_data_from_kwargs(; kwargs...), basepower)
end

function System(data, basepower; kwargs...)
    return System(data, basepower, InfrastructureSystemsInternal(); kwargs...)
end

"""System constructor when components are constructed externally."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                branches::Union{Nothing, Vector{<:Branch}},
                storage::Union{Nothing, Vector{<:Storage}},
                basepower::Float64,
                forecasts::Union{Nothing, IS.Forecasts},
                services::Union{Nothing, Vector{ <: Service}},
                annex::Union{Nothing,Dict}; kwargs...)

    data = _create_system_data_from_kwargs(; kwargs...)

    if isnothing(forecasts)
        forecasts = IS.Forecasts()
    end

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
            if isa(e, InvalidRange)
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
                if isa(e, InvalidRange)
                    error_detected = true
                else
                    rethrow()
                end
            end
        end
    end

    runchecks = get(kwargs, :runchecks, true)

    if error_detected
        throw(InvalidRange("Invalid value(s) detected"))
    end

    if runchecks
        check!(sys)
    end

    return sys
end

"""System constructor without nothing-able arguments."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, nothing, nothing, basepower, nothing, nothing, nothing; kwargs...)
end

"""System constructor with keyword arguments."""
function System(; basepower=100.0,
                buses,
                generators,
                loads,
                branches,
                storage,
                forecasts,
                services,
                annex,
                kwargs...)
    return System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
end

"""Constructs a non-functional System for demo purposes."""
function System(::Nothing; buses=[Bus(nothing)],
                generators=[ThermalStandard(nothing), RenewableFix(nothing)],
                loads=[PowerLoad(nothing)],
                branches=nothing,
                storage=nothing,
                basepower=100.0,
                forecasts = nothing,
                services = nothing,
                annex = nothing,
                kwargs...)
    return System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
end


"""
    to_json(sys::System, filename::AbstractString)

Serializes a system to a JSON string.
"""
function to_json(sys::System, filename::AbstractString)
    return IS.to_json(sys, filename)
end

"""
    to_json(io::IO, sys::System)

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
    add_component!(sys::System, component::T; kwargs...) where T <: Component

Add a component to the system.

Throws ArgumentError if the component's name is already stored for its concrete type.

Throws InvalidRange if any of the component's field values are outside of defined valid
range.
"""
function add_component!(sys::System, component::T; kwargs...) where T <: Component
    if T <: Branch
        arc = get_arc(component)
        check_bus(sys, get_from(arc), arc)
        check_bus(sys, get_to(arc), arc)
    elseif Bus in fieldtypes(T)
        check_bus(sys, get_bus(component), component)
    end

    if sys.runchecks && !validate_struct(sys, component)
        throw(InvalidValue("Invalid value for $(component)"))
    end

    IS.add_component!(sys.data, component; kwargs...)
end

"""
    add_forecasts!(
                   sys::System,
                   metadata::Union{AbstractString, Vector{IS.TimeseriesFileMetadata}};
                   resolution=nothing,
                  )

Adds forecasts from a metadata file or metadata descriptors.

# Arguments
- `sys::System`: system
- `metadata::Union{AbstractString, Vector{IS.TimeseriesFileMetadata}}`: metdata filename
  that includes an array of IS.TimeseriesFileMetadata instances or a vector.
- `resolution::DateTime.Period=nothing`: skip forecast that don't match this resolution.
"""
function add_forecasts!(
                        sys::System,
                        metadata::Union{AbstractString, Vector{IS.TimeseriesFileMetadata}};
                        resolution=nothing)
    forecasts = Vector{Forecast}()
    for forecast in make_forecasts(sys, metadata; resolution=resolution)
        component = IS.get_component(forecast)
        if component isa LoadZones
            uuids = Set([IS.get_uuid(x) for x in get_buses(component)])
            for component_ in (load for load in get_components(ElectricLoad, sys)
                              if get_bus(load) |> IS.get_uuid in uuids)
                if forecast isa Deterministic
                    forecast_ = Deterministic(component_,
                                                 IS.get_label(forecast),
                                                 IS.get_timeseries(forecast))
                # TODO: others
                else
                    @assert false
                end
                push!(forecasts, forecast_)
            end
        else
            push!(forecasts, forecast)
        end
    end

    add_forecasts!(sys, forecasts)
end

"""
    iterate_components(sys::System)

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
    remove_components!(::Type{T}, sys::System) where T <: Component

Remove all components of type T from the system.

Throws ArgumentError if the type is not stored.
"""
function remove_components!(::Type{T}, sys::System) where T <: Component
    return IS.remove_components!(T, sys.data)
end

"""
    remove_component!(sys::System, component::T) where T <: Component

Remove a component from the system by its value.

Throws ArgumentError if the component is not stored.
"""
function remove_component!(sys::System, component)
    return IS.remove_component!(sys.data, component)
end

"""
    remove_component!(
                      ::Type{T},
                      sys::System,
                      name::AbstractString,
                      ) where T <: Component

Remove a component from the system by its name.

Throws ArgumentError if the component is not stored.
"""
function remove_component!(
                           ::Type{T},
                           sys::System,
                           name::AbstractString,
                          ) where T <: Component
    return IS.remove_component!(T, sys.data, name)
end

"""
    get_component(
                  ::Type{T},
                  sys::System,
                  name::AbstractString
                 )::Union{T, Nothing} where {T <: Component}

Get the component of concrete type T with name. Returns nothing if no component matches.

See [`get_components_by_name`](@ref) if the concrete type is unknown.

Throws ArgumentError if T is not a concrete type.
"""
function get_component(::Type{T}, sys::System, name::AbstractString) where T <: Component
    return IS.get_component(T, sys.data, name)
end

"""
    get_components(
                   ::Type{T},
                   sys::System,
                  )::FlattenIteratorWrapper{T} where {T <: Component}

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
                       )::FlattenIteratorWrapper{T} where {T <: Component}
    return IS.get_components(T, sys.data)
end

"""
    get_components_by_name(
                           ::Type{T},
                           sys::System,
                           name::AbstractString
                          )::Vector{T} where {T <: Component}

Get the components of abstract type T with name. Note that PowerSystems enforces unique
names on each concrete type but not across concrete types.

See [`get_component`](@ref) if the concrete type is known.

Throws ArgumentError if T is not an abstract type.
"""
function get_components_by_name(
                                ::Type{T},
                                sys::System,
                                name::AbstractString
                               )::Vector{T} where {T <: Component}
    return IS.get_components_by_name(T, sys.data, name)
end

"""
    get_component_forecasts(
                            ::Type{T},
                            sys::System,
                            initial_time::Dates.DateTime,
                            ) where T <: Component

Get the forecasts of a component of type T with initial_time.
    The resulting container can contain Forecasts of dissimilar types.

Throws ArgumentError if T is not a concrete type.

See also: [`get_component`](@ref)
"""
function get_component_forecasts(
                                 ::Type{T},
                                 sys::System,
                                 initial_time::Dates.DateTime,
                                ) where T <: Component
    return IS.get_component_forecasts(T, sys.data, initial_time)
end

"""
    add_forecast!(sys::System, forecast)

Adds forecast to the system.

# Arguments
- `sys::System`: system
- `forecast`: Any object of subtype forecast

Throws ArgumentError if the forecast's component is not stored in the system.

"""
function add_forecast!(sys::System, forecast)
    return IS.add_forecast!(sys.data, forecast)
end

"""
    add_forecast!(
                  sys::System,
                  filename::AbstractString,
                  component::Component,
                  label::AbstractString,
                  scaling_factor::Union{String, Float64}=1.0,
                 )

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
    add_forecast!(
                  sys::System,
                  ta::TimeSeries.TimeArray,
                  component,
                  label,
                  scaling_factor::Union{String, Float64}=1.0,
                 )

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
    add_forecast!(
                  sys::System,
                  df::DataFrames.DataFrame,
                  component,
                  label,
                  scaling_factor::Union{String, Float64}=1.0,
                 )

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
    add_forecasts!(sys::System, forecasts)

Add forecasts to the system.

# Arguments
- `sys::System`: system
- `forecasts`: iterable (array, iterator, etc.) of Forecast values

Throws DataFormatError if
- A component-label pair is not unique within a forecast array.
- A forecast has a different resolution than others.
- A forecast has a different horizon than others.

Throws ArgumentError if the forecast's component is not stored in the system.

"""
function add_forecasts!(sys::System, forecasts)
    return IS.add_forecasts!(sys.data, forecasts)
end

"""
    make_forecasts(sys::System, metadata_file::AbstractString; resolution=nothing)

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
    make_forecasts(data::SystemData, timeseries_metadata::Vector{TimeseriesFileMetadata};
                   resolution=nothing)

Return a vector of forecasts from a vector of TimeseriesFileMetadata values.

# Arguments
- `data::SystemData`: system
- `timeseries_metadata::Vector{TimeseriesFileMetadata}`: metadata values
- `resolution::{Nothing, Dates.Period}`: skip any forecasts that don't match this resolution
"""
function make_forecasts(sys::System, metadata::Vector{IS.TimeseriesFileMetadata};
                        resolution=nothing)
    return IS.make_forecasts(sys.data, metadata, PowerSystems; resolution=resolution)
end

"""
    get_forecasts(::Type{T}, sys::System, initial_time::Dates.DateTime)

Return an iterator of forecasts. T can be concrete or abstract.

Call collect on the result if an array is desired.

This method is fast and efficient because it returns an iterator to existing vectors.

# Examples
```julia
iter = PowerSystems.get_forecasts(Deterministic{RenewableFix}, sys, initial_time)
iter = PowerSystems.get_forecasts(Forecast, sys, initial_time)
forecasts = PowerSystems.get_forecasts(Forecast, sys, initial_time) |> collect
forecasts = collect(PowerSystems.get_forecasts(Forecast, sys))
```

See also: [`iterate_forecasts`](@ref)
"""
function get_forecasts(
                       ::Type{T},
                       sys::System,
                       initial_time::Dates.DateTime,
                      )::FlattenIteratorWrapper{T} where T <: Forecast
    return IS.get_forecasts(T, sys.data, initial_time)
end

"""
    get_forecasts(
                  ::Type{T},
                  sys::System,
                  initial_time::Dates.DateTime,
                  components_iterator,
                  label::Union{String, Nothing}=nothing,
                 )::Vector{Forecast}

# Arguments
- `forecasts::Forecasts`: system
- `initial_time::Dates.DateTime`: time designator for the forecast
- `components_iter`: iterable (array, iterator, etc.) of Component values
- `label::Union{String, Nothing}`: forecast label or nothing

Return forecasts that match the components and label.

This method is slower than the first version because it has to compare components and label
as well as build a new vector.

Throws ArgumentError if eltype(components_iterator) is a concrete type and no forecast is
found for a component.
"""
function get_forecasts(
                       ::Type{T},
                       sys::System,
                       initial_time::Dates.DateTime,
                       components_iterator,
                       label::Union{String, Nothing}=nothing,
                      )::Vector{T} where T <: Forecast
    return IS.get_forecasts(T, sys.data, initial_time, components_iterator, label)
end

"""
    iterate_forecasts(sys::System)

Iterates over all forecasts in order of initial time.

# Examples
```julia
for forecast in iterate_forecasts(sys)
    @show forecast
end
```

See also: [`get_forecasts`](@ref)
"""
function iterate_forecasts(sys::System)
    return IS.iterate_forecasts(sys.data)
end

"""
    remove_forecast(sys::System, forecast::Forecast)

Remove the forecast from the system.

Throws ArgumentError if the forecast is not stored.
"""
function remove_forecast!(sys::System, forecast::Forecast)
    return IS.remove_forecast!(sys.data, forecast)
end

"""
    clear_forecasts!(sys::System)

Remove all forecasts from the system.
"""
function clear_forecasts!(sys::System)
    return IS.clear_forecasts!(sys.data)
end

"""
    split_forecasts!(
                     sys::System,
                     forecasts::FlattenIteratorWrapper{T}, # must be an iterable
                     interval::Dates.Period,
                     horizon::Int,
                    ) where T <: Forecast

Replaces system forecasts with a set of forecasts by incrementing through an iterable
set of forecasts by interval and horizon.

"""
function split_forecasts!(
                          sys::System,
                          forecasts::FlattenIteratorWrapper{T}, # must be an iterable
                          interval::Dates.Period,
                          horizon::Int,
                         ) where T <: Forecast
    return IS.split_forecasts!(sys.data, forecasts, interval, horizon)
end

"""
    get_forecast_initial_times(sys::System)::Vector{Dates.DateTime}

Return sorted forecast initial times.

"""
function get_forecast_initial_times(sys::System)::Vector{Dates.DateTime}
    return IS.get_forecast_initial_times(sys.data)
end

"""
    get_forecasts_horizon(sys::System)

Return the horizon for all forecasts.
"""
function get_forecasts_horizon(sys::System)
    return IS.get_forecasts_horizon(sys.data)
end

"""
    get_forecasts_initial_time(sys::System)

Return the earliest initial_time for a forecast.
"""
function get_forecasts_initial_time(sys::System)
    return IS.get_forecasts_initial_time(sys.data)
end

"""
    get_forecasts_interval(sys::System)

Return the interval for all forecasts.
"""
function get_forecasts_interval(sys::System)
    return IS.get_forecasts_interval(sys.data)
end

"""
    get_forecasts_resolution(sys::System)

Return the resolution for all forecasts.
"""
function get_forecasts_resolution(sys::System)
    return IS.get_forecasts_resolution(sys.data)
end

"""
    validate_struct(sys::System, value::PowerSystemType)

Validates an instance of a PowerSystemType against System data.
Returns true if the instance is valid.

Users implementing this function for custom types should consider implementing
InfrastructureSystems.validate_struct instead if the validation logic only requires data
contained within the instance.
"""
function validate_struct(sys::System, value::PowerSystemType)::Bool
    return true
end

function check!(sys::System)
    buses = get_components(Bus, sys)
    slack_bus_check(buses)
    buscheck(buses)
end

function JSON2.read(io::IO, ::Type{System})
    raw = JSON2.read(io, NamedTuple)
    sys = System(float(raw.basepower); runchecks=raw.runchecks)
    component_cache = Dict{Base.UUID, Component}()

    # Buses and Arcs are encoded as UUIDs.
    composite_components = [Bus]
    for composite_component in composite_components
        for component in IS.get_components_raw(IS.SystemData, composite_component, raw.data)
            comp = IS.convert_type(composite_component, component)
            add_component!(sys, comp)
            component_cache[IS.get_uuid(comp)] = comp
        end
    end

    # Skip Services this round because they have Devices.
    for c_type_sym in IS.get_component_types_raw(IS.SystemData, raw.data)
        c_type = getfield(PowerSystems, Symbol(IS.strip_module_names(string(c_type_sym))))
        (c_type in composite_components || c_type <: Service) && continue
        for component in IS.get_components_raw(IS.SystemData, c_type, raw.data)
            comp = IS.convert_type(c_type, component, component_cache)
            add_component!(sys, comp)
            component_cache[IS.get_uuid(comp)] = comp
        end
    end

    # Now get the Services.
    for c_type_sym in IS.get_component_types_raw(IS.SystemData, raw.data)
        c_type = getfield(PowerSystems, Symbol(IS.strip_module_names(string(c_type_sym))))
        if c_type <: Service
            for component in IS.get_components_raw(IS.SystemData, c_type, raw.data)
                comp = IS.convert_type(c_type, component, component_cache)
                add_component!(sys, comp)
                component_cache[IS.get_uuid(comp)] = comp
            end
        end
    end

    # Now get the Forecasts, which have reference to components.
    IS.convert_forecasts!(sys.data, raw.data, component_cache)
    return sys
end

function JSON2.write(io::IO, component::T) where T <: Component
    return JSON2.write(io, encode_for_json(component))
end

function JSON2.write(component::T) where T <: Component
    return JSON2.write(encode_for_json(component))
end

"""
Encode composite buses as UUIDs.
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

function get_bus(sys::System, bus_number::Int)
    for bus in get_components(Bus, sys)
        if bus.number == bus_number
            return bus
        end
    end

    return nothing
end

"""
    get_buses(sys::System, bus_numbers::Set{Int})

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

"""
Throws ArgumentError if the bus is not stored in the system.
"""
function check_bus(sys::System, bus::Bus, component::Component)
    name = get_name(bus)
    if isnothing(get_component(Bus, sys, name))
        throw(ArgumentError("$component has bus $name that is not stored in the system"))
    end
end

function IS.compare_values(x::System, y::System)::Bool
    match = true

    if !IS.compare_values(x.data, y.data)
        @debug "SystemData values do not match"
        match = false
    end

    if x.basepower != y.basepower
        @debug "basepower does not match" x.basepower y.basepower
        match = false
    end

    return match
end

function _create_system_data_from_kwargs(; kwargs...)
    validation_descriptor_file = nothing
    runchecks = get(kwargs, :runchecks, true)
    if runchecks
        validation_descriptor_file = get(kwargs, :configpath,
                                         POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE)
    end

    return IS.SystemData(; validation_descriptor_file=validation_descriptor_file)
end
