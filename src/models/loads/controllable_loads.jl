abstract type ControllableLoad <: ElectricLoad end

struct InterruptibleLoad <: ControllableLoad
    name::String
    available::Bool
    bus::Bus
    model::String # [Z, I, P]
    maxactivepower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    sheddingcost::Float64 # $/MWh
    scalingfactor::TimeSeries.TimeArray
end

InterruptibleLoad(; name = "init", status = true, bus = Bus(), model = "0", maxactivepower = 0, maxreactivepower=0, sheddingcost = 999, 
                scalingfactor = TimeSeries.TimeArray(Dates.today(),ones(1))) = InterruptibleLoad(name, status, bus, model, maxactivepower, maxreactivepower, sheddingcost, scalingfactor)
