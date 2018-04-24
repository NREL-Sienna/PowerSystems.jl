export PowerSystem

### Utility Functions needed for the construction of the Power System, mostly used for consistency checking ####

## Time Series Length ## 

function TimeSeriesCheckLoad(loads::Array{T}) where {T<:ElectricLoad}
    t = length(loads[1].scalingfactor)
    for l in loads
        if t == length(l.scalingfactor)
            continue
        else 
            error("Inconsistent load scaling factor time series length")
        end
    end
    return t
end

function TimeSeriesCheckRE(generators::Array{T}, t) where {T<:Generator}
    for g in generators 
        if typeof(g) <: RenewableGen
            if t == length(g.scalingfactor)
                continue
            else 
                error("Inconsistent generation scaling factor time series length")
            end
        end
    end
end

## Check that all the buses have a type defintion ##

function BusCheckAC(buses::Array{Bus})
    for b in buses
        if b.bustype == nothing
            error("Bus/Nodes data does not contain information to build an AC network")
        end
    end
end

## Slack Bus Definition ##

function SlackBusCheck(buses::Array{Bus})
    slack = -9
    for b in buses 
        if b.bustype == "SF"
            slack = b.number
        end
    end
    if slack == -9
        error("Model doesn't contain a slack bus")
    end
end

### PV Bus Check ### 

function PVBusCheck(buses::Array{Bus}, generators::Array{T}) where {T<:Generator}
    pv_list = -1*ones(Int64, length(generators))
    for (ix,g) in enumerate(generators)
        g.bus.bustype == "PV" ? pv_list[ix] = g.bus.number : continue
    end
    
    for b in buses 
        if b.bustype == "PV"
            b.number in pv_list ? continue : error("The bus ", b.number, " is declared as PV without a generator connected to it")  
        else
            continue
        end
    end
end

## TO DO checks 
# 1. Check for islanded Buses 

### Struct and different Power System constructors depending on the data provided ####

struct PowerSystem
    buses::Array{Bus}
    generators::Array{Generator}
    loads::Array{ElectricLoad}
    network::Union{Nothing,Network}
    storage::Union{Nothing,Array{Storage}}
    basevoltage::Real # [kV]
    basepower::Real # [MVA]
    timesteps::Int
    dynamics::Union{Nothing,Bool}
    function PowerSystem(buses, generators, loads,  network, storage, basevoltage, basepower, dynamics)
        
        if network != nothing
            SlackBusCheck(buses)
            PVBusCheck(buses, generators)
        end

        time_length = TimeSeriesCheckLoad(loads)
        TimeSeriesCheckRE(generators, time_length)

        new(buses, 
            generators,
            loads,
            network,
            storage,
            basevoltage,
            basepower,
            time_length,
            dynamics)

    end
end

function PowerSystem(buses::Array{Bus}, 
                    generators::Array{T} where {T<:Generator}, 
                    loads::Array{T} where {T<:ElectricLoad}, 
                    branches::Array{T} where {T<:Branch}, 
                    storage::Array{T} where {T<:Storage}, 
                    basevoltage::Real, 
                    basepower::Real, 
                    dynamics=false)
    PowerSystem(buses, generators, loads, Network(branches, buses), storage, basevoltage, basepower, dynamics)    
end

function PowerSystem(buses::Array{Bus}, 
    generators::Array{T} where {T<:Generator}, 
    loads::Array{T} where {T<:ElectricLoad}, 
    network::Network, 
    basevoltage::Real, 
    basepower::Real, 
    dynamics=false)
PowerSystem(buses, generators, loads, network, nothing, basevoltage, basepower, dynamics)  
end

function PowerSystem(buses::Array{Bus}, 
                    generators::Array{T} where {T<:Generator}, 
                    loads::Array{T} where {T<:ElectricLoad}, 
                    branches::Array{T} where {T<:Branch}, 
                    basevoltage::Float64, 
                    basepower::Float64, 
                    dynamics=false)   
    PowerSystem(buses, generators, loads, Network(branches, buses), nothing, basevoltage, basepower, dynamics)  
end

function PowerSystem(buses::Array{Bus}, 
                    generators::Array{T} where {T<:Generator}, 
                    loads::Array{T} where {T<:ElectricLoad}, 
                    storage::Array{T} where {T<:Storage}, 
                    basevoltage::Real, 
                    basepower::Real, 
                    dynamics=false)
    PowerSystem(buses, generators, loads, nothing, storage, basevoltage, basepower, dynamics)  
end

function PowerSystem(buses::Array{Bus}, 
                    generators::Array{T} where {T<:Generator}, 
                    loads::Array{T} where {T<:ElectricLoad}, 
                    basevoltage::Real, 
                    basepower::Real, 
                    dynamics=false)
    PowerSystem(buses, generators, loads, nothing, nothing, basevoltage, basepower, dynamics)  
end

PowerSystem(; buses = [Bus()],
            generators = [ThermalGen(), ReFix()],
            loads = [StaticLoad()],
            network =  nothing,
            storage = nothing,           
            basevoltage = 0.0,
            basepower = 1000.0,
            dynamics = false,
        ) = PowerSystem(buses, generators, loads, network, storage, basevoltage, basepower, dynamics)        