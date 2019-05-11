### Struct and different Power System constructors depending on the data provided ####

"""
    System

A power system defined by fields for buses, generators, loads, branches, and
overall system parameters.

# Constructor
```julia
System(buses, generators, loads, branches, storage, basepower; kwargs...)
System(buses, generators, loads, branches, basepower; kwargs...)
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
* `basepower`::Float64 : the base power of the system (DOCTODO: is this true? what are the units of base power?)
* `ps_dict`::Dict{String,Any} : the dictionary object containing System data
* `file`::String, `ts_folder`::String : the filename and foldername that contain the System data

# Keyword arguments

* `runchecks`::Bool : run available checks on input fields
DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE

"""
struct System <: PowerSystemType
    # DOCTODO docs for System fields are currently not working, JJS 1/15/19
    buses::Vector{Bus}
    generators::GenClasses
    loads::Vector{<:ElectricLoad}
    branches::Union{Nothing, Vector{<:Branch}}
    storage::Union{Nothing, Vector{<:Storage}}
    basepower::Float64 # [MVA]
    forecasts::Union{Nothing, SystemForecastsDeprecated}
    services::Union{Nothing, Vector{ <: Service}}
    annex::Union{Nothing,Dict{Any,Any}}
#=
    function System(buses, generators, loads, branches, storage, basepower,
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

"""Primary System constructor. Funnel point for all other outer constructors."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                branches::Union{Nothing, Vector{<:Branch}},
                storage::Union{Nothing, Vector{<:Storage}},
                basepower::Float64,
                forecasts::Union{Nothing, SystemForecastsDeprecated},
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

    return System(buses, gen_classes, loads, branches, storage, basepower, forecasts, services, annex)
end

"""Constructs System with default values."""
function System(; buses=[Bus()],
                generators=[ThermalDispatch(), RenewableFix()],
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
    buses, generators, storage, branches, loads, loadZones, shunts, forecasts, services =
        ps_dict2ps_struct(ps_dict)

    return System(buses, generators, loads, branches, storage, ps_dict["baseMVA"],
                  forecasts, services, Dict(:LoadZones=>loadZones);
                  kwargs...);
end

"""Constructs System from a file containing Matpower, PTI, or JSON data."""
function System(file::String, ts_folder::String; kwargs...)
    ps_dict = parsestandardfiles(file,ts_folder; kwargs...)
    buses, generators, storage, branches, loads, loadZones, shunts, services =
        ps_dict2ps_struct(ps_dict)

    return System(buses, generators, loads, branches, storage, ps_dict["baseMVA"];
                  kwargs...);
end

# - Assign Forecast to System Struct

"""
Args:
    A System struct
    A :Symbol=>Array{ <: Forecast,1} Pair denoting the forecast name and array of device forecasts
Returns:
    A System struct with a modified forecasts field
"""
function add_forecast!(sys::System,fc::Pair{Symbol,Array{Forecast,1}})
    sys.forecasts[fc.first] = fc.second
end

"""A System struct that stores all devices in arrays with concrete types.
This is a temporary implementation that will allow consumers of PowerSystems to test the
functionality before it is finalized.
"""
struct ConcreteSystem <: PowerSystemType
    components::Dict{DataType, Vector{<:Component}}    # Contains arrays of concrete types.
    forecasts::Union{Nothing, SystemForecasts}
    basepower::Float64                                 # [MVA]
    internal::PowerSystemInternal
end

function ConcreteSystem(components, forecasts, basepower)
    return ConcreteSystem(components, forecasts, basepower, PowerSystemInternal())
end

function ConcreteSystem(sys::System)
    components = Dict{DataType, Vector{<:Component}}()
    forecasts = isnothing(sys.forecasts) ? nothing : SystemForecasts()
    concrete_sys = ConcreteSystem(components, forecasts, sys.basepower)

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

    if !isnothing(concrete_sys.forecasts)
        _convert_forecasts!(concrete_sys.forecasts, sys.forecasts)
    end
    return concrete_sys
end

"""Constructs a ConcreteSystem from a JSON file."""
function ConcreteSystem(filename::String)
    return from_json(ConcreteSystem, filename)
end

"""Deserializes a ConcreteSystem from String or IO."""
function from_json(io::Union{IO, String}, ::Type{ConcreteSystem})
    components = Dict{DataType, Vector{<: Component}}()
    raw = JSON2.read(io, NamedTuple)

    names_and_types = [(x, getfield(PowerSystems, Symbol(strip_module_names(string(x)))))
                        for x in fieldnames(typeof(raw.components))]

    # Deserialize each component into the correct type.
    # JSON versions of Service and Deterministic objects have UUIDs for components instead
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

    forecasts = SystemForecasts()
    forecast_names = fieldnames(typeof(raw.forecasts))
    for name in forecast_names
        forecasts[name] = Vector{Forecast}()
        for forecast in getfield(raw.forecasts, name)
            # Infer Deterministic structs by the presence of the field component.
            if !(:component in fieldnames(typeof(forecast)))
                push!(forecasts[name], convert_type(getfield(PowerSystems, name)))
            end
        end
    end

    sys = ConcreteSystem(components, forecasts, float(raw.basepower))

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
    for name in forecast_names
        for forecast in getfield(raw.forecasts, name)
            if :component in fieldnames(typeof(forecast))
                push!(sys.forecasts[name],
                      convert_type(Deterministic, forecast, components))
            end
        end
    end

    return sys
end

"""Adds a component to the system."""
function add_component!(sys::ConcreteSystem, component::T) where T <: Component
    if !isconcretetype(T)
        error("add_component! only accepts concrete types")
    end

    if !haskey(sys.components, T)
        sys.components[T] = Vector{T}()
    end

    push!(sys.components[T], component)
    return nothing
end

function _convert_forecasts!(system_forecasts::SystemForecasts,
                             old_forecasts::SystemForecastsDeprecated)
    for (sym, forecasts) in old_forecasts
        for forecast in forecasts
            add_forecast!(system_forecasts, forecast)
        end
    end

    if !_validate_component_label_uniqueness(system_forecasts)
        throw(DataFormatError("components and labels are not unique within forecast array"))
    end
    return system_forecasts
end

function _validate_component_label_uniqueness(system_forecasts::SystemForecasts)::Bool
    match = true

    for (issue_time, forecasts) in system_forecasts
        unique_components = Set{Tuple{<:Component, String}}()
        num_not_unique = 0
        for forecast in forecasts
            component_label = (forecast.component, forecast.label)
            if component_label in unique_components
                num_not_unique += 1
                match = false
                @error("not all components in forecast vector are unique", component_label,
                       issue_time)
            else
                push!(unique_components, component_label)
            end
        end
        @info "summary" num_not_unique length(forecasts)
    end

    return match
end

function add_forecast!(forecasts::SystemForecasts, issue_time::IssueTime,
                       forecast::Forecast)
    if !haskey(forecasts, issue_time)
        forecasts[issue_time] = Forecasts{Forecast}()
    end

    push!(forecasts[issue_time], forecast)
end

function add_forecast!(forecasts::SystemForecasts, forecast::Forecast)
    issue_time = get_issue_time(forecast)
    add_forecast!(forecasts, issue_time, forecast)
end

"""
Args:
    A ConcreteSystem struct
    A :Symbol=>Array{ <: Forecast,1} Pair denoting the forecast name and array of device forecasts
Returns:
    A System struct with a modified forecasts field
"""
function add_forecast!(sys::ConcreteSystem, fc::Pair{Symbol, Vector{Forecast}})
    tmp = SystemForecastsDeprecated()
    tmp[fc.first] = fc.second
    system_forecasts = SystemForecasts()
    _convert_forecasts!(system_forecasts, tmp)

    for (issue_time, forecasts) in system_forecasts
        # This assumes that issue_time is the same for each forecast in the vector because
        # that is how _convert_forecasts works above.
        for forecast in forecasts
            add_forecast!(sys.forecasts, issue_time, forecast)
        end
    end

    if !_validate_component_label_uniqueness(sys.forecasts)
        throw(DataFormatError("components and labels are not unique within forecast array"))
    end
end

"""Returns an iterator to the forecast IssueTime values stored in the System."""
function get_forecast_issue_times(sys::ConcreteSystem)
    return keys(sys.forecasts)
end

"""Returns an iterator to the forecasts for the given IssueTime stored in the System."""
function get_forecasts(sys::ConcreteSystem, issue_time::IssueTime)
    if !haskey(sys.forecasts, issue_time)
        error("forecast issue_time {issue_time} does not exist")
    end

    return Iterators.take(sys.forecasts[issue_time], length(sys.forecasts[issue_time]))
end

"""Returns a vector of forecasts that match the components and label."""
function get_forecasts(sys::ConcreteSystem, issue_time::IssueTime, components_iterator,
                       label::Union{String, Nothing}=nothing)
    forecasts = Vector{Forecast}()

    # This code caches the passed component UUIDs in a dict so that we don't have to
    # iterate across them for each forecast.
    components = LazyDictFromIterator(Base.UUID, Component, components_iterator, get_uuid)
    for forecast in get_forecasts(sys, issue_time)
        if !isnothing(label) && label != forecast.label 
            continue
        end

        if !isnothing(get(components, get_uuid(forecast.component)))
            push!(forecasts, forecast)
        end
    end

    return forecasts
end

# TODO: implement methods to remove components and forecasts. In order to do this we will
# need each PowerSystemType to store a UUID.
# GitHub issue #203

# Const Definitions


"""Defines the Iterator to contain variables of type Component.
"""
const ComponentIterator{T} = Base.Iterators.Flatten{Vector{Vector{T}}} where {T <: Component}

"""Returns a ComponentIterator{T} from the System. T can be concrete or abstract.

# Examples
```julia
devices = PowerSystems.get_components(ThermalDispatch, system)
generators = PowerSystems.get_components(Generator, system)
```
"""
function get_components(::Type{T}, sys::ConcreteSystem)::ComponentIterator{T} where {T <: Component}
    if isconcretetype(T)
        components = get(sys.components, T, nothing)
        if isnothing(components)
            return ComponentIterator{T}(Vector{T}())
        else
            return ComponentIterator{T}([components])
        end
    else
        types = [x for x in get_all_concrete_subtypes(T) if haskey(sys.components, x)]
        return ComponentIterator{T}([sys.components[x] for x in types])
    end
end

"""Shows the component types and counts in a table."""
function Base.summary(io::IO, sys::ConcreteSystem)
    counts = Dict{String, Int}()

    rows = []
    for (subtype, values) in sys.components
        type_str = strip_module_names(string(subtype))
        counts[type_str] = length(values)
        parents = [strip_module_names(string(x)) for x in supertypes(subtype)]
        row = (ConcreteType=type_str,
               SuperTypes=join(parents, " <: "),
               Count=length(values))
        push!(rows, row)
    end

    sort!(rows, by = x -> x.ConcreteType)

    #df = DataFrames.DataFrame(rows)
    print(io, "This is currently broken")
end

function compare_values(x::ConcreteSystem, y::ConcreteSystem)::Bool
    match = true
    for key in keys(x.components)
        if !compare_values(x.components[key], y.components[key])
            @debug "ConcreteSystem components do not match"
            match = false
        end
    end

    if !compare_values(x.forecasts, y.forecasts)
        @debug "ConcreteSystem forecasts do not match"
        match = false
    end

    if x.basepower != y.basepower
        @debug "basepower does not match" x.basepower y.basepower
        match = false
    end

    return match
end
