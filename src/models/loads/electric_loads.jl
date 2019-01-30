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
    scalingfactor=TimeSeries.TimeArray(Dates.today(),ones(1)) 
    return PowerLoad(name, available, bus, maxactivepower, maxreactivepower, scalingfactor)
end

function PowerLoadPF(name::String, available::Bool, bus::Bus, maxactivepower::Float64, power_factor::Float64, scalingfactor::TimeSeries.TimeArray)
    maxreactivepower = maxactivepower*sin(acos(power_factor)) 
    return PowerLoad(name, available, bus, maxactivepower, maxreactivepower, scalingfactor)
end

function PowerLoadPF(name::String, available::Bool, bus::Bus, maxactivepower::Float64, power_factor::Float64, scalingfactor=nothing)
    scalingfactor=TimeSeries.TimeArray(Dates.today(),ones(1))
    maxreactivepower = maxactivepower*sin(acos(power_factor)) 
    return PowerLoad(name, available, bus, maxactivepower, maxreactivepower, scalingfactor)
end


PowerLoadPF(; name = "init", available = true, bus = Bus(), maxactivepower = 0.0, power_factor=1.0, 
            scalingfactor=TimeSeries.TimeArray(Dates.today(),ones(1))) = PowerLoadPF(name, available, bus, maxactivepower, power_factor, scalingfactor)

PowerLoad(; name = "init", available = true, bus = Bus(), maxactivepower = 0.0, maxreactivepower=0.0, 
            scalingfactor=TimeSeries.TimeArray(Dates.today(),ones(1))) = PowerLoad(name, available, bus, maxactivepower, maxreactivepower, scalingfactor)            