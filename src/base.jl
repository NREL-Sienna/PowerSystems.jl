
const Components = Dict{DataType, Dict{String, <:Component}}

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
    * `forecasts`::Union{Nothing, SystemForecasts} : dictionary of forecasts
    * `services`::Union{Nothing, Vector{ <: Service}} : an array of services; may be `nothing`

    # Keyword arguments

    * `runchecks`::Bool : run available checks on input fields
    DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE
"""
struct System <: PowerSystemType
    components::Components
    forecasts::SystemForecasts
    basepower::Float64             # [MVA]
    internal::PowerSystemInternal
end

"""Construct an empty System. Useful for building a System while parsing raw data."""
function System(basepower)
    components = Dict{DataType, Vector{<:Component}}()
    forecasts = SystemForecasts()
    return System(components, forecasts, basepower)
end

function System(components, forecasts, basepower)
    return System(components, forecasts, basepower, PowerSystemInternal())
end

"""System constructor when components are constructed externally."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                branches::Union{Nothing, Vector{<:Branch}},
                storage::Union{Nothing, Vector{<:Storage}},
                basepower::Float64,
                forecasts::Union{Nothing, SystemForecasts},
                services::Union{Nothing, Vector{ <: Service}},
                annex::Union{Nothing,Dict}; kwargs...)

    components = Dict{DataType, Vector{<:Component}}()

    if isnothing(forecasts)
        forecasts = SystemForecasts()
    end
    sys = System(components, forecasts, basepower)

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

    for component in Iterators.flatten(arrays)
        add_component!(sys, component)
    end

    load_zones = isnothing(annex) ? nothing : get(annex, :LoadZones, nothing)
    if !isnothing(load_zones)
        for lz in load_zones
            add_component!(sys, lz)
        end
    end

    for (key, value) in sys.components
        @debug "components: $(string(key)): count=$(string(length(value)))"
    end

    runchecks = get(kwargs, :runchecks, true)
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

"""Constructs a System from a JSON file."""
function System(filename::String)
    sys = from_json(System, filename)
    check!(sys)
    return sys
end

function check!(sys::System)
    buses = get_components(Bus, sys)
    slack_bus_check(buses)
    buscheck(buses)

    branches = get_components(Branch, sys)
    if length(branches) > 0
        check_branches!(branches)
        calculate_thermal_limits!(branches, sys.basepower)
    end

    generators = get_components(Generator, sys)
end

"""Iterates over all components.

# Examples
```julia
for component in iterate_components(sys)
    @show component
end
```

See also: [`get_components`](@ref)
"""
function iterate_components(sys::System)
    Channel() do channel
        for component in get_components(Component, sys)
            put!(channel, component)
        end
    end
end

"""Iterates over all forecasts in order of initial time.

# Examples
```julia
for forecast in iterate_forecasts(sys)
    @show forecast
end
```

See also: [`get_forecasts`](@ref)
"""
function iterate_forecasts(sys::System)
    Channel() do channel
        for initial_time in get_forecast_initial_times(sys)
            for forecast in get_forecasts(Forecast, sys, initial_time)
                put!(channel, forecast)
            end
        end
    end
end

function JSON2.write(io::IO, components::Components)
    return JSON2.write(io, encode_for_json(components))
end

function JSON2.write(components::Components)
    return JSON2.write(encode_for_json(components))
end

function encode_for_json(components::Components)
    # Convert each name-to-value component dictionary to arrays.
    new_components = Dict{DataType, Vector{<:Component}}()
    for (data_type, component_dict) in components
        new_components[data_type] = [x for x in values(component_dict)]
    end

    return new_components
end

"""Deserializes a System from String or IO."""
function from_json(io::Union{IO, String}, ::Type{System})
    raw = JSON2.read(io, NamedTuple)
    sys = System(float(raw.basepower))

    names_and_types = [(x, getfield(PowerSystems, Symbol(strip_module_names(string(x)))))
                        for x in fieldnames(typeof(raw.components))]

    # Deserialize each component into the correct type.
    # JSON versions of Service and Forecast objects have UUIDs for components instead
    # of actual components, so they have to be skipped on the first pass.
    for (name, component_type) in names_and_types
        if component_type <: Service
            continue
        end

        for component in getfield(raw.components, name)
            add_component!(sys, convert_type(component_type, component))
        end
    end

    # Service objects actually have Device instances, but Forecasts have Components. Since
    # we are sharing the dict, use the higher-level type.
    iter = get_components(Component, sys)
    components = LazyDictFromIterator(Base.UUID, Component, iter, get_uuid)
    for (name, component_type) in names_and_types
        if component_type <: Service
            for component in getfield(raw.components, name)
                add_component!(sys, convert_type(component_type, component, components))
            end
        end
    end

    # Services have been added; reset the iterator to make sure we find them.
    replace_iterator(components, get_components(Component, sys))
    convert_type!(sys.forecasts, raw.forecasts, components)

    return sys
end

"""
    add_component!(sys::System, component::T) where T <: Component

Add a component to the system.

Throws InvalidParameter if the component's name is already stored for its concrete type.
"""
function add_component!(sys::System, component::T) where T <: Component
    if !isconcretetype(T)
        error("add_component! only accepts concrete types")
    end

    if !haskey(sys.components, T)
        sys.components[T] = Dict{String, T}()
    elseif haskey(sys.components[T], component.name)
        throw(InvalidParameter("$(component.name) is already stored for type $T"))
    end

    sys.components[T][component.name] = component
    return nothing
end

"""
    remove_components!(::Type{T}, sys::System) where T <: Component

Remove all components of type T from the system.

Throws InvalidParameter if the type is not stored.
"""
function remove_components!(::Type{T}, sys::System) where T <: Component
    if !haskey(sys.components, T)
        throw(InvalidParameter("component $T is not stored"))
    end

    pop!(sys.components, T)
    @debug "Removed all components of type" T
end

"""
    remove_component!(sys::System, component::T) where T <: Component

Remove a component from the system by its value.

Throws InvalidParameter if the component is not stored.
"""
function remove_component!(sys::System, component::T) where T <: Component
    _remove_component!(T, sys, get_name(component))
end

"""
    remove_component!(
                      ::Type{T},
                      sys::System,
                      name::AbstractString,
                      ) where T <: Component

Remove a component from the system by its name.

Throws InvalidParameter if the component is not stored.
"""
function remove_component!(
                           ::Type{T},
                           sys::System,
                           name::AbstractString,
                          ) where T <: Component
    _remove_component!(T, sys, name)
end

function _remove_component!(
                            ::Type{T},
                            sys::System,
                            name::AbstractString,
                           ) where T <: Component
    if !haskey(sys.components, T)
        throw(InvalidParameter("component $T is not stored"))
    end

    if !haskey(sys.components[T], name)
        throw(InvalidParameter("component $T name=$name is not stored"))
    end

    pop!(sys.components[T], name)
    @debug "Removed component" T name
end

function get_bus(sys::System, bus_number::Int)
    for bus in get_components(Bus, sys)
        if bus.number == bus_number
            return bus
        end
    end

    return nothing
end

function get_buses(sys::System, bus_numbers::Set{Int})
    buses = Vector{Bus}()
    for bus in get_components(Bus, sys)
        if bus.number in bus_numbers
            push!(buses, bus)
        end
    end

    return buses
end

""" Checks that the component exists in the systems and the UUID's match"""
function _validate_forecast(sys::System, forecast::T) where T <: Forecast
        # Validate that each forecast's component is stored in the system.
        comp = forecast.component
        ctype = typeof(comp)
        component = get_component(ctype, sys, get_name(comp))
        if isnothing(component)
            throw(InvalidParameter("no $ctype with name=$(get_name(comp)) is stored"))
        end

        user_uuid = get_uuid(comp)
        ps_uuid = get_uuid(component)
        if user_uuid != ps_uuid
            throw(InvalidParameter(
                "forecast component UUID doesn't match, perhaps it was copied?; " *
                "$ctype name=$(get_name(comp)) user=$user_uuid system=$ps_uuid"))
        end
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

Throws InvalidParameter if the forecast's component is not stored in the system.

"""
function add_forecasts!(sys::System, forecasts)
    if length(forecasts) == 0
        return
    end

    for forecast in forecasts
        _validate_forecast(sys,forecast)
    end

    _add_forecasts!(sys.forecasts, forecasts)
end

"""
    add_forecast!(sys::System, forecasts)

Add forecasts to the system.

# Arguments
- `sys::System`: system
- `forecast`: Any object of subtype forecast

Throws InvalidParameter if the forecast's component is not stored in the system.

"""
function add_forecast!(sys::System, forecast::T) where T <: Forecast
    _validate_forecast(sys, forecast)
    _add_forecasts!(sys.forecasts, [forecast])
end

"""Return the horizon for all forecasts."""
get_forecasts_horizon(sys::System)::Int64 = sys.forecasts.horizon

"""Return the earliest initial_time for a forecast."""
get_forecasts_initial_time(sys::System)::Dates.DateTime = sys.forecasts.initial_time

"""Return the interval for all forecasts."""
get_forecasts_interval(sys::System)::Dates.Period = sys.forecasts.interval

"""Return the resolution for all forecasts."""
get_forecasts_resolution(sys::System)::Dates.Period = sys.forecasts.resolution

"""
    get_forecast_initial_times(sys::System)::Vector{Dates.DateTime}

Return sorted forecast initial times.

"""
function get_forecast_initial_times(sys::System)::Vector{Dates.DateTime}
    return _get_forecast_initial_times(sys.forecasts.data)
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
    if isconcretetype(T)
        key = ForecastKey(initial_time, T)
        forecasts = get(sys.forecasts.data, key, nothing)
        if isnothing(forecasts)
            iter = FlattenIteratorWrapper(T, Vector{Vector{T}}([]))
        else
            iter = FlattenIteratorWrapper(T, Vector{Vector{T}}([forecasts]))
        end
    else
        keys_ = [ForecastKey(initial_time, x.forecast_type)
                 for x in keys(sys.forecasts.data) if x.initial_time == initial_time &&
                                                      x.forecast_type <: T]
        iter = FlattenIteratorWrapper(T, Vector{Vector{T}}([sys.forecasts.data[x]
                                                            for x in keys_]))
    end

    @assert eltype(iter) == T
    return iter
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
- `sys::System`: system
- `initial_time::Dates.DateTime`: time designator for the forecast
- `components_iter`: iterable (array, iterator, etc.) of Component values
- `label::Union{String, Nothing}`: forecast label or nothing

Return forecasts that match the components and label.

This method is slower than the first version because it has to compare components and label
as well as build a new vector.

Throws InvalidParameter if eltype(components_iterator) is a concrete type and no forecast is
found for a component.
"""
function get_forecasts(
                       ::Type{T},
                       sys::System,
                       initial_time::Dates.DateTime,
                       components_iterator,
                       label::Union{String, Nothing}=nothing,
                      )::Vector{T} where T <: Forecast
    forecasts = Vector{T}()
    elem_type = eltype(components_iterator)
    throw_on_unmatched_component = isconcretetype(elem_type)
    @debug "get_forecasts" initial_time label elem_type throw_on_unmatched_component

    # Cache the component UUIDs and matched component UUIDs so that we iterate over
    # components_iterator and forecasts only once.
    components = Set{Base.UUID}((get_uuid(x) for x in components_iterator))
    matched_components = Set{Base.UUID}()
    for forecast in get_forecasts(T, sys, initial_time)
        if !isnothing(label) && label != forecast.label
            continue
        end

        component_uuid = get_uuid(forecast.component)
        if in(component_uuid, components)
            push!(forecasts, forecast)
            push!(matched_components, component_uuid)
        end
    end

    if length(components) != length(matched_components)
        unmatched_components = setdiff(components, matched_components)
        @warn "Did not find forecasts with UUIDs" unmatched_components
        if throw_on_unmatched_component
            throw(InvalidParameter("did not find forecasts for one or more components"))
        end
    end

    return forecasts
end

"""
    remove_forecast(sys::System, forecast::Forecast)

Remove the forecast from the system.

Throws InvalidParameter if the forecast is not stored.
"""
function remove_forecast!(sys::System, forecast::T) where T <: Forecast
    key = ForecastKey(forecast.initial_time, T)

    if !haskey(sys.forecasts.data, key)
        throw(InvalidParameter("Forecast not found: $(forecast.label)"))
    end

    found = false
    for (i, forecast_) in enumerate(sys.forecasts.data[key])
        if get_uuid(forecast) == get_uuid(forecast_)
            found = true
            deleteat!(sys.forecasts.data[key], i)
            @info "Deleted forecast $(get_uuid(forecast))"
            if length(sys.forecasts.data[key]) == 0
                pop!(sys.forecasts.data, key)
            end
            break
        end
    end

    if !found
        throw(InvalidParameter("Forecast not found: $(forecast.label)"))
    end

    if length(sys.forecasts.data) == 0
        reset_info!(sys.forecasts)
    end
end

"""
    get_component(
                  ::Type{T},
                  sys::System,
                  name::AbstractString
                 )::Union{T, Nothing} where {T <: Component}

Get the component of concrete type T with name. Returns nothing if no component matches.

See [`get_components_by_name`](@ref) if the concrete type is unknown.

Throws InvalidParameter if T is not a concrete type.
"""
function get_component(
                       ::Type{T},
                       sys::System,
                       name::AbstractString
                      )::Union{T, Nothing} where {T <: Component}
    if !isconcretetype(T)
        throw(InvalidParameter("get_component only supports concrete types: $T"))
    end

    if !haskey(sys.components, T)
        @debug "components of type $T are not stored"
        return nothing
    end

    return get(sys.components[T], name, nothing)
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

Throws InvalidParameter if T is not an abstract type.
"""
function get_components_by_name(
                                ::Type{T},
                                sys::System,
                                name::AbstractString
                               )::Vector{T} where {T <: Component}
    if !isabstracttype(T)
        throw(InvalidParameter("get_components_by_name only supports abstract types: $T"))
    end

    components = Vector{T}()
    for subtype in get_all_concrete_subtypes(T)
        component = get_component(subtype, sys, name)
        if !isnothing(component)
            push!(components, component)
        end
    end

    return components
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
    if isconcretetype(T)
        components = get(sys.components, T, nothing)
        if isnothing(components)
            iter = FlattenIteratorWrapper(T, Vector{Base.ValueIterator}([]))
        else
            iter = FlattenIteratorWrapper(T,
                                          Vector{Base.ValueIterator}([values(components)]))
        end
    else
        types = [x for x in get_all_concrete_subtypes(T) if haskey(sys.components, x)]
        iter = FlattenIteratorWrapper(T, [values(sys.components[x]) for x in types])
    end

    @assert eltype(iter) == T
    return iter
end

"""Shows the component types and counts in a table."""
function Base.summary(io::IO, sys::System)
    println(io, "System")
    println(io, "======")
    println(io, "Base Power: $(sys.basepower)\n")

    Base.summary(io, sys.components)
    println(io, "\n")
    Base.summary(io, sys.forecasts)
end

function Base.summary(io::IO, components::Components)
    counts = Dict{String, Int}()
    rows = []

    for (subtype, values) in components
        type_str = strip_module_names(string(subtype))
        counts[type_str] = length(values)
        parents = [strip_module_names(string(x)) for x in supertypes(subtype)]
        row = (ConcreteType=type_str,
               SuperTypes=join(parents, " <: "),
               Count=length(values))
        push!(rows, row)
    end

    sort!(rows, by = x -> x.ConcreteType)

    df = DataFrames.DataFrame(rows)
    println(io, "Components")
    println(io, "==========")
    Base.show(io, df)
end

function compare_values(x::System, y::System)::Bool
    match = true
    for key in keys(x.components)
        if !compare_values(x.components[key], y.components[key])
            @debug "System components do not match"
            match = false
        end
    end

    if !compare_values(x.forecasts, y.forecasts)
        @debug "System forecasts do not match"
        match = false
    end

    if x.basepower != y.basepower
        @debug "basepower does not match" x.basepower y.basepower
        match = false
    end

    return match
end
