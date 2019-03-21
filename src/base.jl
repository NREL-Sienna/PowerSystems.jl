### Struct and different Power System constructors depending on the data provided ####

"""
    PowerSystem

A power system defined by fields for buses, generators, loads, branches, and
overall system parameters.

# Constructor
```julia
PowerSystem(buses, generators, loads, branches, storage, basepower; kwargs...)
PowerSystem(ps_dict; kwargs...)
PowerSystem(file, ts_folder; kwargs...)
```

# Arguments

* `buses`::Array{Bus,1} : an array of buses
* `generators`::Array{Generator,1} : an array of generators of (possibly) different types
* `loads`::Array{ElectricLoad,1} : an array of load specifications that includes timing of the loads
* `branches`::Array{Branch,1} : an array of branches; may be `nothing`
* `storage`::Array{Storage,1} : an array of storage devices; may be `nothing`
* `basepower`::Float64 : the base power of the system (DOCTODO: is this true? what are the units of base power?)
* `ps_dict`::Dict{String,Any} : the dictionary object containing PowerSystem data
* `file`::String, `ts_folder`::String : the filename and foldername that contain the PowerSystem data

# Keyword arguments

* `runchecks`::Bool : run available checks on input fields
DOCTODO: any other keyword arguments?

"""
struct PowerSystem{L <: ElectricLoad,
                   B <: Union{Nothing,Array{ <: Branch,1}},
                   S <: Union{Nothing,Array{ <: Storage,1}}
                   }
    # DOCTODO docs for PowerSystem fields are currently not working, JJS 1/15/19
    """
    docstrings for buses field
    """
    buses::Array{Bus,1}
    generators::GenClasses
    loads::Array{L,1}
    branches::B
    storage::S
    basepower::Float64 # [MVA]
    time_periods::Int64

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::Nothing,
                        storage::Nothing,
                        basepower::Float64; kwargs...) where {G <: Generator, L <: ElectricLoad}
        
        runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
        if runchecks
                generators = checkramp(generators, minimumtimestep(loads))
        end
        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length) : true
        new{L, Nothing, Nothing}(buses,
                                 sources,
                                 loads,
                                 nothing,
                                 nothing,
                                 basepower,
                                 time_length)

    end

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::B,
                        storage::Nothing,
                        basepower::Float64; kwargs...) where {G <: Generator, L <: ElectricLoad, B <: Array{<:Branch,1}}

        runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
        if runchecks
                slackbuscheck(buses)
                buscheck(buses)
                pvbuscheck(buses, generators)
                generators = checkramp(generators, minimumtimestep(loads))
        end
        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length) : true

        runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
        if runchecks
                calculatethermallimits!(branches,basepower)
                check_branches!(branches)
                #timeserieschecksources(sources.hydro, time_length)
        end

        new{L, B, Nothing}(buses,
                           sources,
                           loads,
                           branches,
                           nothing,
                           basepower,
                           time_length)

    end

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::Nothing,
                        storage::S,
                        basepower::Float64; kwargs...) where {G <: Generator, L <: ElectricLoad, S <: Array{<: Storage,1}}

        
        runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
        if runchecks
                generators = checkramp(generators, minimumtimestep(loads))
        end
        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length) : true

        new{L, Nothing, S}(buses,
                           sources,
                           loads,
                           nothing,
                           storage,
                           basepower,
                           time_length)

    end

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::B,
                        storage::S,
                        basepower::Float64; kwargs...) where {G <: Generator, L <: ElectricLoad, B <: Array{<:Branch,1}, S <: Array{<: Storage,1}}
        
        runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
        if runchecks
                slackbuscheck(buses)
                buscheck(buses)
                pvbuscheck(buses, generators)
                calculatethermallimits!(branches,basepower)
                check_branches!(branches)
        end
        generators = checkramp(generators, minimumtimestep(loads))
        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length) : true

        new{L, B, S}(buses,
                     sources,
                     loads,
                     branches,
                     storage,
                     basepower,
                     time_length)

    end

end

# DOCTODO JJS What is the purpose of this statement? OK, it looks like a
# constructor to allow the arguments to be made as keyword arguments, with
# defaults for those that are not provided. If so, this should be added to list
# of constructors in the docstring above
PowerSystem(; buses = [Bus()],
            generators = [ThermalDispatch(), RenewableFix()],
            loads = [ PowerLoad()],
            branches =  nothing,
            storage = nothing,
            basepower = 1000.0,
            kwargs... ,
        ) = PowerSystem(buses, generators, loads, branches, storage,  basepower; kwargs...)


function PowerSystem(ps_dict::Dict{String,Any}; kwargs...)
        Buses, Generators, Storage, Branches, Loads, LoadZones, Shunts, Services = ps_dict2ps_struct(ps_dict)
        sys = PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]; kwargs...);
        return sys
end

function PowerSystem(file::String, ts_folder::String; kwargs...)

        ps_dict = parsestandardfiles(file,ts_folder; kwargs...)
        Buses, Generators, Storage, Branches, Loads, LoadZones, Shunts, Services = ps_dict2ps_struct(ps_dict)
        sys = PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]; kwargs...);

        return sys
end
