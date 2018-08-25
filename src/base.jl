### Struct and different Power System constructors depending on the data provided ####

struct PowerSystem{L <: ElectricLoad,
                   T <: Union{Nothing,Array{ <: Thermal,1}},
                   R <: Union{Nothing,Array{ <: Renewable,1}},     
                   H <: Union{Nothing,Array{ <: Hydro,1}},
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
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad}
        generators = checkramp(generators, minimumtimestep(loads))
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
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad, B <: Array{<:Branch,1}}

        slackbuscheck(buses)
        buscheck(buses)
        pvbuscheck(buses, generators)
        generators = checkramp(generators, minimumtimestep(loads))
        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length) : true
        calculatethermallimits!(branches,basepower)
        checkanglelimits!(branches)
        #timeserieschecksources(sources.hydro, time_length)

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
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad, S <: Array{<: Storage,1}}

        generators = checkramp(generators, minimumtimestep(loads))
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
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad, B <: Array{<:Branch,1}, S <: Array{<: Storage,1}}

        slackbuscheck(buses)
        buscheck(buses)
        pvbuscheck(buses, generators)
        calculatethermallimits!(branches,basepower)
        checkanglelimits!(branches)
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

PowerSystem(; buses = [Bus()],
            generators = [ThermalDispatch(), RenewableFix()],
            loads = [StaticLoad()],
            branches =  nothing,
            storage = nothing,
            basepower = 1000.0,
        ) = PowerSystem(buses, generators, loads, branches, storage,  basepower)
