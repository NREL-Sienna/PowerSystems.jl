export ElectricLoad
export StaticLoad
export ControllableLoad
export InterruptibleLoad

abstract type 
    ElectricLoad  
end

struct StaticLoad <: ElectricLoad
    name::String 
    bus::Bus
    model::String # [Z, I, P]
    maxrealpower::Real # [MW]
    maxreactivepower::Real # [MVAr]
    scalingfactor::TimeSeries.TimeArray
end

StaticLoad(; name = "init", bus = Bus(), model = "0", maxrealpower = 0, maxreactivepower=0, scalingfactor=TimeArray(DateTime(today()), [1.0])) =
StaticLoad(name, bus, model, maxrealpower, maxreactivepower, scalingfactor)

struct InterruptibleLoad <: ElectricLoad
    name::String 
    bus::Bus
    model::String # [Z, I, P]
    maxrealpower::Real # [MW]
    maxreactivepower::Real # [MVAr]
    sheddingcost::Real # $/MWh
    maxenergyloss::Nullable{Real}
    scalingfactor::TimeSeries.TimeArray
end

InterruptableLoad(; name = "init", bus = Bus(), model = "0", maxrealpower = 0, maxreactivepower=0, sheddingcost = 999, maxenergyloss = Nullable{Real}(), scalingfactor=TimeArray(DateTime(today()), [1.0])) =
InterruptableLoad(name, bus, model, maxrealpower, maxreactivepower, sheddingcost, maxenergyloss, scalingfactor)


struct ControllableLoad <: ElectricLoad
    name::String 
    bus::Bus
    realpower::Function 
    reactivepower::Nullable{Function}
end