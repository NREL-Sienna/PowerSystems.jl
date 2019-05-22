abstract type ControllableLoad <: ElectricLoad end

struct InterruptibleLoad <: ControllableLoad
    name::String
    available::Bool
    bus::Bus
    model::String # [Z, I, P]
    maxactivepower::Float64 # [MW]
    maxreactivepower::Float64 # [MVAr]
    econ::EconLoad
    internal::PowerSystemInternal
end

function InterruptibleLoad(name, available, bus, model, maxactivepower, maxreactivepower, econ)
    return InterruptibleLoad(name, available, bus, model, maxactivepower, maxreactivepower,
                             econ, PowerSystemInternal())
end

InterruptibleLoad(; name = "init", available = true, bus = Bus(), model = "0", maxactivepower = 0, maxreactivepower=0,
                econ = EconLoad()) = InterruptibleLoad(name, available, bus, model, maxactivepower, maxreactivepower, econ)
