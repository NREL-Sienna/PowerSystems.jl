"Abstract struct for thermal generation technologies"
abstract type
    ThermalGen <: Generator
end

""""
Data Structure for thermal generation technologies.
    The data structure contains all the information for technical and economical modeling.
    The data fields can be filled using named fields or directly.

    Examples

"""
struct ThermalStandard <: ThermalGen
    name::String
    available::Bool
    bus::Bus
    tech::Union{TechThermal,Nothing}
    econ::Union{EconThermal,Nothing}
    internal::PowerSystemInternal
end

function ThermalStandard(name, available, bus, tech, econ)
    return ThermalStandard(name, available, bus, tech, econ, PowerSystemInternal())
end

ThermalStandard(; name = "init",
                available = false,
                bus = Bus(),
                tech = TechThermal(),
                econ = EconThermal()) = ThermalStandard(name, available, bus, tech, econ)
