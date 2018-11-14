### Struct and different Power System constructors depending on the data provided ####

struct PowerSystem{T <: Union{Nothing,Array{ <: ThermalGen,1}},
                   R <: Union{Nothing,Array{ <: RenewableGen,1}},
                   H <: Union{Nothing,Array{ <: HydroGen,1}},
                   L <: ElectricLoad,
                   B <: Union{Nothing,Array{ <: Branch,1}},
                   S <: Union{Nothing,Array{ <: Storage,1}}
                   }
    buses::Array{Bus,1}
    generators::NamedTuple{(:thermal, :renewable, :hydro), Tuple{T, R, H}}
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
        new{Union{Nothing,Array{ <: ThermalGen,1}}, Union{Nothing,Array{ <: RenewableGen,1}}, Union{Nothing,Array{ <: HydroGen,1}}, L, Nothing, Nothing}(buses,
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
                checkanglelimits!(branches)
                #timeserieschecksources(sources.hydro, time_length)
        end

        new{Union{Nothing,Array{ <: ThermalGen,1}}, Union{Nothing,Array{ <: RenewableGen,1}}, Union{Nothing,Array{ <: HydroGen,1}}, L, B, Nothing}(buses,
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

        new{Union{Nothing,Array{ <: ThermalGen,1}}, Union{Nothing,Array{ <: RenewableGen,1}}, Union{Nothing,Array{ <: HydroGen,1}}, L, Nothing, S}(buses,
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
                checkanglelimits!(branches)
        end
        generators = checkramp(generators, minimumtimestep(loads))
        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length) : true

        new{Union{Nothing,Array{ <: ThermalGen,1}}, Union{Nothing,Array{ <: RenewableGen,1}}, Union{Nothing,Array{ <: HydroGen,1}}, L, B, S}(buses,
                sources,
                loads,
                branches,
                storage,
                basepower,
                time_length)

    end

end

PowerSystem(; buses = [Bus()],
            generators = [ThermalDispatch(), RenewableFix()],
            loads = [StaticLoad()],
            branches =  nothing,
            storage = nothing,
            basepower = 1000.0,
            kwargs... ,
        ) = PowerSystem(buses, generators, loads, branches, storage,  basepower; kwargs...)


function PowerSystem(ps_dict::Dict{String,Any}; kwargs...)
        Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts = ps_dict2ps_struct(ps_dict)
        sys = PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]; kwargs...);
        return sys
end

function PowerSystem(file::String, ts_folder::String; kwargs...)

        ps_dict = parsestandardfiles(file,ts_folder; kwargs...)
        Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts = ps_dict2ps_struct(ps_dict)
        sys = PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]; kwargs...);

        return sys
end