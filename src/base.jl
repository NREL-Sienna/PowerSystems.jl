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
    forecasts::Union{Nothing, SystemForecasts}
    services::Union{Nothing, Vector{ <: Service}}
    annex::Union{Nothing,Dict{Any,Any}}

    function System(buses, generators, loads, branches, storage_devices, basepower,
                    forecasts, services, annex; kwargs...)

        sys = new(buses, generators, loads, branches, storage_devices, basepower,
                    forecasts, services, annex)

        # TODO Default validate to true once validation code is written.
        if get(kwargs, :validate, false) && !validate(sys)
            error("System is not valid")
        end

        return sys
    end
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
                annex::Union{Nothing,Dict{Any,Any}}; kwargs...)
    runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
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

    if ! ( isnothing(forecasts) || isempty(forecasts) )
        timeseriescheckforecast(forecasts)
    end

    return System(buses, gen_classes, loads, branches, storage, basepower, forecasts, services, annex;
                  kwargs...)
end

"""Constructs System with Generators but no branches or storage."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, nothing, nothing, basepower, nothing, nothing, nothing; kwargs...)
end

"""Constructs System with Generators but no storage."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                branches::Vector{<:Branch},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, branches, nothing, basepower, nothing, nothing, nothing; kwargs...)
end

"""Constructs System with Generators but no branches."""
function System(buses::Vector{Bus},
                generators::Vector{<:Generator},
                loads::Vector{<:ElectricLoad},
                storage::Vector{<:Storage},
                basepower::Float64; kwargs...)
    return System(buses, generators, loads, nothing, storage, basepower, nothing, nothing, nothing; kwargs...)
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

    return System(buses, generators, loads, branches, storage, ps_dict["baseMVA"], forecasts, services, nothing;
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

"""A System struct that stores all devices in arrays with concrete types.
This is a temporary implementation that will allow consumers of PowerSystems to test the
functionality before it is finalized.
"""
struct ConcreteSystem <: PowerSystemType
    components::Dict{DataType, Vector{<:Component}}    # Contains arrays of concrete types.
    forecasts::Union{Nothing, SystemForecasts}
    basepower::Float64                                 # [MVA]
end

function ConcreteSystem(sys::System)
    components = Dict{DataType, Vector{<:Component}}()
    concrete_sys = ConcreteSystem(components, sys.forecasts, sys.basepower)

    for field in (:buses, :loads)
        for obj in getfield(sys, field)
            add_component(concrete_sys, obj)
        end
    end

    for field in (:thermal, :renewable, :hydro)
        generators = getfield(sys.generators, field)
        if !isnothing(generators)
            for gen in generators
                add_component(concrete_sys, gen)
            end
        end
    end

    for field in (:branches, :storage, :services)
        objs = getfield(sys, field)
        if !isnothing(objs)
            for obj in objs
                add_component(concrete_sys, obj)
            end
        end
    end

    for (key, value) in concrete_sys.components
        @debug "components: $(string(key)): count=$(string(length(value)))"
    end

    return concrete_sys
end

"""Adds a component to the system."""
function add_component(sys::ConcreteSystem, component::T) where T <: Component
    if !isconcretetype(T)
        error("add_component only accepts concrete types")
    end

    if !haskey(sys.components, T)
        sys.components[T] = Vector{T}()
    end

    push!(sys.components[T], component)
    return nothing
end


# TODO: implement methods to remove components and forecasts. In order to do this we will
# need each PowerSystemType to store a UUID.
# GitHub issue #203


"""Returns an iterable of components from the System. T can be concrete or abstract.

# Examples
```julia
devices = PowerSystems.get_components(ThermalDispatch, system)
generators = PowerSystems.get_components(Generator, system)
```
"""
function get_components(::Type{T}, sys::ConcreteSystem) where {T <: Component}
    if isconcretetype(T)
        return Iterators.take(sys.components[T], length(sys.components[T]))
    else
        types = [x for x in get_all_concrete_subtypes(T) if haskey(sys.components, x)]
        return Iterators.flatten(sys.components[x] for x in types)
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

    df = DataFrames.DataFrame(rows)
    print(io, df)
end
