abstract type StaticLoad <: ElectricLoad end 

struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    maxactivepower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    scalingfactor::TimeSeries.TimeArray
end

function PowerLoad(name::String, available::Bool, bus::Bus, maxactivepower::Float64, maxreactivepower::Float64, scalingfactor=nothing)
    scalingfactor=TimeArray(today(),ones(1)) 
    return PowerLoad(name, available, bus, model, maxactivepower, maxreactivepower, scalingfactor)
end

function PowerLoadPF(name::String, available::Bool, bus::Bus, maxactivepower::Float64, power_factor::Float64, scalingfactor::TimeSeries.TimeArray)
    maxreactivepower = maxactivepower*sin(acos(power_factor)) 
    return PowerLoad(name, available, bus, model, maxactivepower, maxreactivepower, scalingfactor)
end


PowerLoad(; name = "init", available = true, bus = Bus(), maxactivepower = 0, maxreactivepower=0, 
            scalingfactor=TimeArray(today(),ones(1))) = PowerLoad(name, available, bus, maxactivepower, maxreactivepower, scalingfactor)