### Struct and different Power System constructors depending on the data provided ####

struct PowerSystem{L <: ElectricLoad,
                   B <: Union{Nothing,Array{ <: Branch,1}},
                   S <: Union{Nothing,Array{ <: Storage,1}}}
    buses::Array{Bus,1}
    generators::Sources
    loads::Array{L,1}
    branches::B
    storage::S
    basevoltage::Float64 # [kV]
    basepower::Float64 # [MVA]
    time_periods::Int64

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::Nothing,
                        storage::Nothing,
                        basevoltage::Float64,
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad}

        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length): true

        new{L, Nothing, Nothing,}(buses,
                        sources,
                        loads,
                        nothing,
                        nothing,
                        basevoltage,
                        basepower,
                        time_length)

    end

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::B,
                        storage::Nothing,
                        basevoltage::Float64,
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad, B <: Array{<:Branch,1}}

        slackbuscheck(buses)
        buscheck(buses)
        pvbuscheck(buses, generators)

        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length): true
        calculatethermallimits!(branches,basepower)
        checkanglelimits!(branches)
        #timeserieschecksources(sources.hydro, time_length)

        new{L, B, Nothing}(buses,
                sources,
                loads,
                branches,
                nothing,
                basevoltage,
                basepower,
                time_length)

    end

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::Nothing,
                        storage::S,
                        basevoltage::Float64,
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad, S <: Array{<: Storage,1}}

        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length): true

        new{L, Nothing, S}(buses,
                sources,
                loads,
                nothing,
                storage,
                basevoltage,
                basepower,
                time_length)

    end

    function PowerSystem(buses::Array{Bus,1},
                        generators::Array{G,1},
                        loads::Array{L,1},
                        branches::B,
                        storage::S,
                        basevoltage::Float64,
                        basepower::Float64) where {G <: Generator, L <: ElectricLoad, B <: Array{<:Branch,1}, S <: Array{<: Storage,1}}

        slackbuscheck(buses)
        buscheck(buses)
        pvbuscheck(buses, generators)
        calculatethermallimits!(branches,basepower)
        checkanglelimits!(branches)


        sources = genclassifier(generators);
        time_length = timeseriescheckload(loads)
        !isa(sources.renewable, Nothing) ? timeserieschecksources(sources.renewable, time_length) : true
        !isa(sources.hydro, Nothing) ? timeserieschecksources(sources.hydro, time_length): true

        new{L, B, S}(buses,
                sources,
                loads,
                branches,
                storage,
                basevoltage,
                basepower,
                time_length)

    end

end

PowerSystem(; buses = [Bus()],
            generators = [ThermalDispatch(), RenewableFix()],
            loads = [StaticLoad()],
            branches =  nothing,
            storage = nothing,
            basevoltage = 0.0,
            basepower = 1000.0,
        ) = PowerSystem(buses, generators, loads, branches, storage, basevoltage, basepower)
