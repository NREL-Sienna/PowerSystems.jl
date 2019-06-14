### Struct and different Power System constructors depending on the data provided ####

"""
    _System

An internal struct that collects system components.

# Constructors are identical to `System`

"""
struct _System <: PowerSystemType
    # DOCTODO docs for _System fields are currently not working, JJS 1/15/19
    buses::Vector{Bus}
    generators::GenClasses
    loads::Vector{<:ElectricLoad}
    branches::Union{Nothing, Vector{<:Branch}}
    storage::Union{Nothing, Vector{<:Storage}}
    basepower::Float64 # [MVA]
    forecasts::Union{Nothing, Forecasts}
    services::Union{Nothing, Vector{ <: Service}}
    annex::Union{Nothing,Dict{Any,Any}}
#=
    function _System(buses, generators, loads, branches, storage, basepower,
                    forecasts, services, annex; kwargs...)

        sys = new(buses, generators, loads, branches, storage, basepower,
                    forecasts, services, annex; kwargs...)

        # TODO Default validate to true once validation code is written.
        if get(kwargs, :validate, false) && !validate(sys)
            error("System is not valid")
        end

        return sys
    end=#
end

"""Primary _System constructor. Funnel point for all other outer constructors."""
function _System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                branches::Union{Nothing, Vector{<:Branch}},
                storage::Union{Nothing, Vector{<:Storage}},
                basepower::Float64,
                forecasts::Union{Nothing, Forecasts},
                services::Union{Nothing, Vector{ <: Service}},
                annex::Union{Nothing,Dict}; kwargs...)

    runchecks = get(kwargs, :runchecks, true)
    if runchecks
        slackbuscheck(buses)
        buscheck(buses)
        if !isnothing(branches)
            calculatethermallimits!(branches, basepower)
            check_branches!(branches)
        end

        pvbuscheck(buses, generators)
    end
    # This constructor receives an array of Generator structs. It separates them by category
    # in GenClasses.
    gen_classes = genclassifier(generators)

    if !( isnothing(forecasts) || isempty(forecasts) )
        timeseriescheckforecast(forecasts)
    end

    return _System(buses, gen_classes, loads, branches, storage, basepower, forecasts, services, annex)
end

"""Constructs _System with default values."""
function _System(; buses=[Bus()],
                generators=[ThermalStandard(), RenewableFix()],
                loads=[PowerLoad()],
                branches=nothing,
                storage=nothing,
                basepower=100.0,
                forecasts = nothing,
                services = nothing,
                annex = nothing,
                kwargs...)
    return _System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
end

"""Constructs _System from a ps_dict."""
function _System(ps_dict::Dict{String,Any}; kwargs...)
    buses, generators, storage, branches, loads, loadZones, shunts, forecasts, services =
        ps_dict2ps_struct(ps_dict)

    return _System(buses, generators, loads, branches, storage, Float64(ps_dict["baseMVA"]),
                  forecasts, services, Dict(:LoadZones=>loadZones);
                  kwargs...);
end

const Components = Dict{DataType, Vector{<:Component}}

"""
    System

    A power system defined by fields for basepower, components, and forecasts.

    # Constructor
    ```julia
    System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
    System(buses, generators, loads, basepower; kwargs...)
    System(ps_dict; kwargs...)
    System(file, ts_folder; kwargs...)
    System(; kwargs...)
    ```

    # Arguments

    * `buses`::Vector{Bus} : an array of buses
    * `generators`::Vector{Generator} : an array of generators of (possibly) different types
    * `loads`::Vector{ElectricLoad} : an array of load specifications that includes timing of the loads
    * `branches`::Union{Nothing, Vector{Branch}} : an array of branches; may be `nothing`
    * `storage`::Union{Nothing, Vector{Storage}} : an array of storage devices; may be `nothing`
    * `basepower`::Float64 : the base power value for the system
    * `ps_dict`::Dict{String,Any} : the dictionary object containing System data
    * `forecasts`::Union{Nothing, SystemForecasts} : dictionary of forecasts
    * `services`::Union{Nothing, Vector{ <: Service}} : an array of services; may be `nothing`
    * `file`::String, `ts_folder`::String : the filename and foldername that contain the System data

    # Keyword arguments

    * `runchecks`::Bool : run available checks on input fields
    DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE
"""
struct System <: PowerSystemType
    components::Components    # Contains arrays of concrete types.
    forecasts::SystemForecasts
    basepower::Float64                                 # [MVA]
    internal::PowerSystemInternal
end

function System(basepower)
    components = Dict{DataType, Vector{<:Component}}()
    forecasts = SystemForecasts()
    return System(components, forecasts, basepower)
end

function System(components, forecasts, basepower)
    return System(components, forecasts, basepower, PowerSystemInternal())
end

function System(sys::_System)
    components = Dict{DataType, Vector{<:Component}}()
    if !isnothing(sys.forecasts) && !isempty(sys.forecasts)
        error("Constructing a System with an array of forecasts is not supported")
    end

    forecasts = SystemForecasts()
    concrete_sys = System(components, forecasts, sys.basepower)

    for field in (:buses, :loads)
        for obj in getfield(sys, field)
            add_component!(concrete_sys, obj)
        end
    end

    for field in (:thermal, :renewable, :hydro)
        generators = getfield(sys.generators, field)
        if !isnothing(generators)
            for gen in generators
                add_component!(concrete_sys, gen)
            end
        end
    end

    for field in (:branches, :storage, :services)
        objs = getfield(sys, field)
        if !isnothing(objs)
            for obj in objs
                add_component!(concrete_sys, obj)
            end
        end
    end

    load_zones = isnothing(sys.annex) ? nothing : get(sys.annex, :LoadZones, nothing)
    if !isnothing(load_zones)
        for lz in load_zones
            add_component!(concrete_sys, lz)
        end
    end

    for (key, value) in concrete_sys.components
        @debug "components: $(string(key)): count=$(string(length(value)))"
    end

    return concrete_sys
end

"""Primary System constructor. Funnel point for all other outer constructors."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                branches::Union{Nothing, Vector{<:Branch}},
                storage::Union{Nothing, Vector{<:Storage}},
                basepower::Float64,
                forecasts::Union{Nothing, SystemForecasts},
                services::Union{Nothing, Vector{ <: Service}},
                annex::Union{Nothing,Dict}; kwargs...)
    _sys = _System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
    return System(_sys)
end

"""System constructor without nothing-able arguments."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, nothing, nothing, basepower, nothing, nothing, nothing; kwargs...)
end

"""Constructs System with default values."""
function System(; buses=[Bus()],
                generators=[ThermalStandard(), RenewableFix()],
                loads=[PowerLoad()],
                branches=nothing,
                storage=nothing,
                basepower=100.0,
                forecasts = nothing,
                services = nothing,
                annex = nothing,
                kwargs...)
    return System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
end

"""Constructs System from a ps_dict."""
function System(ps_dict::Dict{String,Any}; kwargs...)
    return System(_System(ps_dict; kwargs...))
end

"""Constructs a System from a JSON file."""
function System(filename::String)
    return from_json(System, filename)
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

"""Deserializes a System from String or IO."""
function from_json(io::Union{IO, String}, ::Type{System})
    components = Dict{DataType, Vector{<: Component}}()
    raw = JSON2.read(io, NamedTuple)

    names_and_types = [(x, getfield(PowerSystems, Symbol(strip_module_names(string(x)))))
                        for x in fieldnames(typeof(raw.components))]

    # Deserialize each component into the correct type.
    # JSON versions of Service and Forecast objects have UUIDs for components instead
    # of actual components, so they have to be skipped on the first pass.
    for (name, component_type) in names_and_types
        components[component_type] = Vector{component_type}()
        if component_type <: Service
            continue
        end

        for component in getfield(raw.components, name)
            obj = convert_type(component_type, component)
            push!(components[component_type], obj)
        end
    end

    sys = System(components, SystemForecasts(raw.forecasts), float(raw.basepower))

    # Service objects actually have Device instances, but Forecasts have Components. Since
    # we are sharing the dict, use the higher-level type.
    iter = get_components(Component, sys)
    components = LazyDictFromIterator(Base.UUID, Component, iter, get_uuid)
    for (name, component_type) in names_and_types
        if component_type <: Service
            for component in getfield(raw.components, name)
                push!(sys.components[component_type],
                      convert_type(component_type, component, components))
            end
        end
    end

    # Services have been added; reset the iterator to make sure we find them.
    replace_iterator(components, get_components(Component, sys))
    convert_type!(sys.forecasts, raw.forecasts, components)

    return sys
end

"""Adds a component to the system."""
function add_component!(sys::System, component::T) where T <: Component
    if !isconcretetype(T)
        error("add_component! only accepts concrete types")
    end

    if !haskey(sys.components, T)
        sys.components[T] = Vector{T}()
    end

    push!(sys.components[T], component)
    return nothing
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

"""
function add_forecasts!(sys::System, forecasts)
    if length(forecasts) == 0
        return
    end

    _add_forecasts!(sys.forecasts, forecasts)
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
                      )::FlattenedVectorsIterator{T} where T <: Forecast
    if isconcretetype(T)
        key = ForecastKey(initial_time, T)
        forecasts = get(sys.forecasts.data, key, nothing)
        if isnothing(forecasts)
            iter = FlattenedVectorsIterator(Vector{Vector{T}}([]))
        else
            iter = FlattenedVectorsIterator(Vector{Vector{T}}([forecasts]))
        end
    else
        keys_ = [ForecastKey(initial_time, x.forecast_type)
                 for x in keys(sys.forecasts.data) if x.initial_time == initial_time &&
                                                      x.forecast_type <: T]
        iter = FlattenedVectorsIterator(Vector{Vector{T}}([sys.forecasts.data[x]
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

# TODO: implement methods to remove components. In order to do this we will
# need each PowerSystemType to store a UUID.
# GitHub issue #203


"""
    get_components(
                   ::Type{T},
                   sys::System,
                  )::FlattenedVectorsIterator{T} where {T <: Component}

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
                       )::FlattenedVectorsIterator{T} where {T <: Component}
    if isconcretetype(T)
        components = get(sys.components, T, nothing)
        if isnothing(components)
            iter = FlattenedVectorsIterator(Vector{Vector{T}}([]))
        else
            iter = FlattenedVectorsIterator(Vector{Vector{T}}([components]))
        end
    else
        types = [x for x in get_all_concrete_subtypes(T) if haskey(sys.components, x)]
        iter = FlattenedVectorsIterator(Vector{Vector{T}}([sys.components[x]
                                                           for x in types]))
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
