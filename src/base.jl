### Struct and different Power System constructors depending on the data provided ####

"""
    PowerSystem

A power system defined by fields for buses, generators, loads, branches, and
overall system parameters.

# Constructor
```julia
PowerSystem(buses, generators, loads, branches, storage, basepower; kwargs...)
PowerSystem(buses, generators, loads, branches, basepower; kwargs...)
PowerSystem(buses, generators, loads, branches, basepower; kwargs...)
PowerSystem(buses, generators, loads, basepower; kwargs...)
PowerSystem(ps_dict; kwargs...)
PowerSystem(file, ts_folder; kwargs...)
PowerSystem(; kwargs...)
```

# Arguments

* `buses`::Buses : an array of buses
* `generators`::Generators : an array of generators of (possibly) different types
* `loads`::ElectricLoads : an array of load specifications that includes timing of the loads
* `branches`::OptionalBranches : an array of branches; may be `nothing`
* `storage`::OptionalStorage : an array of storage devices; may be `nothing`
* `basepower`::Float64 : the base power of the system (DOCTODO: is this true? what are the units of base power?)
* `ps_dict`::Dict{String,Any} : the dictionary object containing PowerSystem data
* `file`::String, `ts_folder`::String : the filename and foldername that contain the PowerSystem data

# Keyword arguments

* `runchecks`::Bool : run available checks on input fields
DOCTODO: any other keyword arguments? genmap_file, REGEX_FILE

"""
struct PowerSystem
    # DOCTODO docs for PowerSystem fields are currently not working, JJS 1/15/19
    buses::Buses
    generators::GenClasses
    loads::ElectricLoads
    branches::OptionalBranches
    storage::OptionalStorage
    basepower::Float64 # [MVA]
    time_periods::Int64

    function PowerSystem(buses, generators, loads, branches, storage_devices, basepower,
                         time_periods; kwargs...)

        sys = new(buses, generators, loads, branches, storage_devices, basepower,
                  time_periods)

        # TODO Default validate to true once validation code is written.
        if get(kwargs, :validate, false) && !validate(sys)
            error("PowerSystem is not valid")
        end

        return sys
    end
end

"""Primary PowerSystem constructor. Funnel point for all other outer constructors."""
function PowerSystem(buses::Buses,
                     generators::Generators,
                     loads::ElectricLoads,
                     branches::OptionalBranches,
                     storage::OptionalStorage,
                     basepower::Float64; kwargs...)
    runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
    if runchecks
        slackbuscheck(buses)
        buscheck(buses)
        if !isnothing(branches)
            calculatethermallimits!(branches, basepower)
            check_branches!(branches)
        end

        pvbuscheck(buses, generators)
        generators = checkramp(generators, minimumtimestep(loads))
    end

    time_periods = timeseriescheckload(loads)

    # This constructor receives an array of Generator structs. It separates them by category
    # in GenClasses.
    gen_classes = genclassifier(generators)
    if !isnothing(gen_classes.renewable)
        timeserieschecksources(gen_classes.renewable, time_periods)
    end

    if !isnothing(gen_classes.hydro)
        timeserieschecksources(gen_classes.hydro, time_periods)
    end

    return PowerSystem(buses, gen_classes, loads, branches, storage, basepower, time_periods;
                       kwargs...)
end

"""Constructs PowerSystem with Generators but no branches or storage."""
function PowerSystem(buses::Buses,
                     generators::Generators,
                     loads::ElectricLoads,
                     basepower::Float64; kwargs...)
    return PowerSystem(buses, generators, loads, nothing, nothing, basepower; kwargs...)
end

"""Constructs PowerSystem with Generators but no storage."""
function PowerSystem(buses::Buses,
                     generators::Generators,
                     loads::ElectricLoads,
                     branches::Branches,
                     basepower::Float64; kwargs...)
    return PowerSystem(buses, generators, loads, branches, nothing, basepower; kwargs...)
end

"""Constructs PowerSystem with Generators but no branches."""
function PowerSystem(buses::Buses,
                     generators::Generators,
                     loads::ElectricLoads,
                     storage::StorageDevices,
                     basepower::Float64; kwargs...)
    return PowerSystem(buses, generators, loads, nothing, storage, basepower; kwargs...)
end

"""Constructs PowerSystem with default values."""
function PowerSystem(; buses=[Bus()],
                     generators=[ThermalDispatch(), RenewableFix()],
                     loads=[PowerLoad()],
                     branches=nothing,
                     storage=nothing,
                     basepower=1000.0,
                     kwargs...)
    return PowerSystem(buses, generators, loads, branches, storage,  basepower; kwargs...)
end

"""Constructs PowerSystem from a ps_dict."""
function PowerSystem(ps_dict::Dict{String,Any}; kwargs...)
    buses, generators, storage, branches, loads, loadZones, shunts, services =
        ps_dict2ps_struct(ps_dict)

    return PowerSystem(buses, generators, loads, branches, storage, ps_dict["baseMVA"];
                       kwargs...);
end

"""Constructs PowerSystem from a file containing Matpower, PTI, or JSON data."""
function PowerSystem(file::String, ts_folder::String; kwargs...)
    ps_dict = parsestandardfiles(file,ts_folder; kwargs...)
    buses, generators, storage, Branches, Loads, LoadZones, Shunts, Services =
        ps_dict2ps_struct(ps_dict)

    return PowerSystem(Buses, Generators, Loads, Branches, Storage, ps_dict["baseMVA"];
                       kwargs...);
end
