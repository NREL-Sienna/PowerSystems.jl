export ElectricLoad
export StaticLoad
export ControllableLoad
export InterruptibleLoad
#export FixedShunt

abstract type
    ElectricLoad
end

struct StaticLoad <: ElectricLoad
    name::String
    status::Bool
    bus::Bus
    model::String # [Z, I, P]
    maxrealpower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    scalingfactor::TimeSeries.TimeArray
end

StaticLoad(; name = "init", status = true, bus = Bus(), model = "0", maxrealpower = 0, maxreactivepower=0, scalingfactor=TimeArray(DateTime(today()), [1.0])) =
StaticLoad(name, status, bus, model, maxrealpower, maxreactivepower, scalingfactor)

struct InterruptibleLoad <: ElectricLoad
    name::String
    status::Bool
    bus::Bus
    model::String # [Z, I, P]
    maxrealpower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    sheddingcost::Float64 # $/MWh
    maxenergyloss::Union{Float64, Nothing}
    scalingfactor::TimeSeries.TimeArray
end

InterruptibleLoad(; name = "init", status = true, bus = Bus(), model = "0", maxrealpower = 0, maxreactivepower=0, sheddingcost = 999, maxenergyloss = nothing, scalingfactor=TimeArray(DateTime(today()), [1.0])) =
InterruptibleLoad(name, status, bus, model, maxrealpower, maxreactivepower, sheddingcost, maxenergyloss, scalingfactor)

struct ControllableLoad <: ElectricLoad
    name::String
    status::Bool
    bus::Bus
    realpower::Function
    reactivepower::Union{Function,Nothing}
end
