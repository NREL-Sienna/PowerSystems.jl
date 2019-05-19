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
struct StandardThermal <: ThermalGen
    name::String
    available::Bool
    bus::Bus
    tech::Union{TechThermal,Nothing}
    econ::Union{EconThermal,Nothing}
    internal::PowerSystemInternal
end

function StandardThermal(name, available, bus, tech, econ)
    return StandardThermal(name, available, bus, tech, econ, PowerSystemInternal())
end

StandardThermal(; name = "init",
                available = false,
                bus = Bus(),
                tech = TechThermal(),
                econ = EconThermal()) = StandardThermal(name, status, bus, tech, econ)
