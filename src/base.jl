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
    forecasts::Union{Nothing, Dict{Symbol, Vector{ <: Forecast}}}
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
                forecasts::Union{Nothing, Dict{Symbol, Vector{ <: Forecast}}},
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
    data::Dict{DataType, Vector{<:Component}}  # Contains arrays of concrete types.
    components::Dict{DataType, Any}             # Nested dict based on type hierarchy
                                                # containing references to component arrays.
    basepower::Float64                          # [MVA]
end

function ConcreteSystem(sys::System)
    data = Dict{DataType, Vector{<:Component}}()
    for subtype in get_all_concrete_subtypes(Component)
        data[subtype] = Vector{subtype}()
    end

    @debug "Created data keys" keys(data)

    for field in (:buses, :loads)
        objs = getfield(sys, field)
        for obj in objs
            push!(data[typeof(obj)], obj)
        end
    end

    for field in (:thermal, :renewable, :hydro)
        generators = getfield(sys.generators, field)
        if !isnothing(generators)
            for gen in generators
                push!(data[typeof(gen)], gen)
            end
        end
    end

    for field in (:branches, :storage)
        objs = getfield(sys, field)
        if !isnothing(objs)
            for obj in objs
                push!(data[typeof(obj)], obj)
            end
        end
    end

    for (key, value) in data
        @debug "data: $(string(key)): count=$(string(length(value)))"
    end

    components = _get_components_by_type(Component, data)
    return ConcreteSystem(data, components, sys.basepower)
end

"""Returns an array of components from the System. T must be a concrete type.

# Example
```julia
devices = PowerSystems.get_components(ThermalDispatch, system)
```
"""
function get_components(::Type{T}, sys::ConcreteSystem)::Vector{T} where {T <: Component}
    if !isconcretetype(T)
        error("$T must be a concrete type")
    end

    return sys.data[T]
end

"""Returns an iterable over component arrays that are subtypes of T. To create a new array
with all component arrays concatenated, call collect on the returned iterable.  Note that
this will involve copying the data and the resulting array will be less performant than
arrays of concrete types.

# Example
```julia
iter = PowerSystems.get_mixed_components(Device, system)
for device in iter
    @show device
end
```
"""
function get_mixed_components(::Type{T}, sys::ConcreteSystem) where {T <: Component}
    return _get_mixed_components(T, sys.data)
end

function _get_mixed_components(
                               ::Type{T},
                               data::Dict{DataType, Vector{<:Component}},
                              ) where {T <: Component}
    if !isabstracttype(T)
        error("$T must be an abstract type")
    end

    return Iterators.flatten(data[x] for x in get_all_concrete_subtypes(T))
end

"""Builds a nested dictionary by traversing through the PowerSystems type hierarchy. The
bottom of each dictionary is an array of concrete types.

# Example
```julia
data[Device][Injection][Generator][ThermalGen][ThermalDispatch][1]
ThermalDispatch:
   name: 322_CT_6
   available: true
   bus: Bus(name="Cole")
   tech: TechThermal
   econ: EconThermal
```
"""
function _get_components_by_type(
                                 ::Type{T},
                                 data::Dict{DataType, Vector{<:Component}},
                                 components::Dict{DataType, Any}=Dict{DataType, Any}(),
                                ) where {T <: Component}
    abstract_types = get_abstract_subtypes(T)
    if length(abstract_types) > 0
        for abstract_type in abstract_types
            components[abstract_type] = Dict{DataType, Any}()
            _get_components_by_type(abstract_type, data, components[abstract_type])
        end
    end

    for concrete_type in get_concrete_subtypes(T)
        components[concrete_type] = data[concrete_type]
    end

    return components
end

"""Returns a Tuple of Arrays of component types and counts."""
function get_component_counts(components::Dict{DataType, Any})
    return _get_component_counts(components)
end

function _get_component_counts(components::Dict{DataType, Any}, types=[], counts=[])
    for (ps_type, val) in components
        if isabstracttype(ps_type)
            _get_component_counts(val, types, counts)
        else
            push!(types, ps_type)
            push!(counts, length(val))
        end
    end

    return types, counts
end

"""Shows the component types and counts in a table. If show_hierarchy is true then include
a column showing the type hierachy. The display is in order of depth-first type
hierarchy.
"""
function show_component_counts(sys::ConcreteSystem, io::IO=stderr;
                               show_hierarchy::Bool=false)
    # Build a table of strings showing the counts.
    types, counts = get_component_counts(sys.components)
    if show_hierarchy
        hierarchies = []
        for ps_type in types
            text = join([string(type_to_symbol(x)) for x in supertypes(ps_type)], " <: ")
            push!(hierarchies, text)
        end

        df = DataFrames.DataFrame(PowerSystemType=types, Count=counts,
                                  Hierarchy=hierarchies)
    else
        df = DataFrames.DataFrame(PowerSystemType=types, Count=counts)
    end

    print(io, df)
    return nothing
end
