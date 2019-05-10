### Struct and different Power System constructors depending on the data provided ####

"""
    _System

An internal struct that collects system components.

# Constructor
```julia
_System(buses, generators, loads, branches, storage, basepower; kwargs...)
_System(buses, generators, loads, branches, basepower; kwargs...)
_System(buses, generators, loads, basepower; kwargs...)
_System(ps_dict; kwargs...)
_System(file, ts_folder; kwargs...)
_System(; kwargs...)
```

# Arguments

* `buses`::Vector{Bus} : an array of buses
* `generators`::Vector{Generator} : an array of generators of (possibly) different types
* `loads`::Vector{ElectricLoad} : an array of load specifications that includes timing of the loads
* `branches`::Union{Nothing, Vector{Branch}} : an array of branches; may be `nothing`
* `storage`::Union{Nothing, Vector{Storage}} : an array of storage devices; may be `nothing`
* `basepower`::Float64 : the base power of the system (DOCTODO: is this true? what are the units of base power?)
* `ps_dict`::Dict{String,Any} : the dictionary object containing _System data
* `file`::String, `ts_folder`::String : the filename and foldername that contain the _System data

# Keyword arguments

* `runchecks`::Bool : run available checks on input fields
DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE

"""
struct _System <: PowerSystemType
    # DOCTODO docs for _System fields are currently not working, JJS 1/15/19
    buses::Vector{Bus}
    generators::GenClasses
    loads::Vector{<:ElectricLoad}
    branches::Union{Nothing, Vector{<:Branch}}
    storage::Union{Nothing, Vector{<:Storage}}
    basepower::Float64 # [MVA]
    forecasts::Union{Nothing, SystemForecasts}
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
                forecasts::Union{Nothing, SystemForecasts},
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
                generators=[ThermalDispatch(), RenewableFix()],
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

    return _System(buses, generators, loads, branches, storage, ps_dict["baseMVA"],
                  forecasts, services, Dict(:LoadZones=>loadZones);
                  kwargs...);
end

"""Constructs _System from a file containing Matpower, PTI, or JSON data."""
function _System(file::String, ts_folder::String; kwargs...)
    ps_dict = parsestandardfiles(file,ts_folder; kwargs...)
    buses, generators, storage, branches, loads, loadZones, shunts, services =
        ps_dict2ps_struct(ps_dict)

    return _System(buses, generators, loads, branches, storage, ps_dict["baseMVA"];
                  kwargs...);
end

# - Assign Forecast to _System Struct

"""
Args:
    A _System struct
    A :Symbol=>Array{ <: Forecast,1} Pair denoting the forecast name and array of device forecasts
Returns:
    A _System struct with a modified forecasts field
"""
function add_forecast!(sys::_System,fc::Pair{Symbol,Array{Forecast,1}})
    sys.forecasts[fc.first] = fc.second
end

"""
    System

    A power system defined by fields for buses, generators, loads, branches, and
    overall system parameters.

    # Constructor
    ```julia
    System(buses, generators, loads, branches, storage, basepower, forecasts, services, annex; kwargs...)
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
    components::Dict{DataType, Vector{<:Component}}    # Contains arrays of concrete types.
    forecasts::Union{Nothing, SystemForecasts}
    basepower::Float64                                 # [MVA]
end

function System(sys::_System)
    components = Dict{DataType, Vector{<:Component}}()
    concrete_sys = System(components, sys.forecasts, sys.basepower)

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

    
    return = System(buses, generators, loads, nothing, nothing, basepower, nothing, nothing, nothing; kwargs...)
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
function get_components(::Type{T}, sys::System)::ComponentIterator{T} where {T <: Component}
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
function Base.summary(io::IO, sys::System)
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
