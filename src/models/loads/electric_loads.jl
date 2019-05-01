abstract type StaticLoad <: ElectricLoad end 

struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    maxactivepower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    internal::PowerSystemInternal
end

function PowerLoad(name, available, bus, maxactivepower, maxreactivepower)
    return PowerLoad(name, available, bus, maxactivepower, maxreactivepower,
                     PowerSystemInternal())
end

function PowerLoadPF(name::String, available::Bool, bus::Bus, maxactivepower::Float64, power_factor::Float64)
    maxreactivepower = maxactivepower*sin(acos(power_factor)) 
    return PowerLoad(name, available, bus, maxactivepower, maxreactivepower)
end


PowerLoadPF(; name = "init", available = true, bus = Bus(), maxactivepower = 0.0, 
            power_factor=1.0) = PowerLoadPF(name, available, bus, maxactivepower, power_factor)

PowerLoad(; name = "init", available = true, bus = Bus(), maxactivepower = 0.0, 
            maxreactivepower=0.0) = PowerLoad(name, available, bus, maxactivepower, maxreactivepower)            
