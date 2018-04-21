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

## Slack Bus Definition ### 

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




struct PowerSystem
    buses::Array{Bus}
    generators::Array{Generator}
    loads::Array{ElectricLoad}
    network::Union{Nothing,Network}
    storage::Union{Nothing,Array{Storage}}
    basevoltage::Real # [kV]
    basepower::Real # [MVA]
    timesteps::Int
    dynamics::Union{Nothing,Any}
    function PowerSystem(buses, generators, loads, network, storage, basevoltage, basepower, timesteps, dynamics)
        
    end
end

function PowerSystem(buses, generators, loads, branches, storage, basevoltage, basepower, timesteps, dynamics)
        
end


PowerSystem(; buses = [Bus()],
            generators = [ThermalGen(), ReFix()],
            loads = [StaticLoad()],
            network =  nothing,
            storage = nothing,           
            basevoltage = 0.0,
            basepower = 1000
        ) = PowerSystem(buses, generators, loads, network, storage, basevoltage, basepower)