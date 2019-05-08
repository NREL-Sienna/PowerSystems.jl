abstract type RenewableGen <: Generator end

# TODO DT temporary workaround
function get_uuid(obj::T)::Base.UUID where T <: RenewableGen
    return uuid(obj)
end

struct RenewableGenBase
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    internal::PowerSystemInternal
end

function RenewableGenBase(name, available, bus, tech)
    return RenewableGenBase(name, available, bus, tech, PowerSystemInternal())
end

RenewableGenBase(; name="init",
                 status=false,
                 bus=Bus(),
                 installedcapacity=0.0) = RenewableGenBase(name, status, bus,
                                                           installedcapacity)

@forward((RenewableGenBase, :internal), PowerSystemInternal)

name(value::RenewableGenBase) = value.name
available(value::RenewableGenBase) = value.available
bus(value::RenewableGenBase) = value.bus
tech(value::RenewableGenBase) = value.tech

struct RenewableFix <: RenewableGen
    base::RenewableGenBase
end

function RenewableFix(name, available, bus, tech)
    return RenewableFix(RenewableGenBase(name, available, bus, tech))
end

"""Accepts installedcapacity as a Float64 and then creates a TechRenewable."""
function RenewableFix(name, status, bus, installedcapacity::Float64)
    tech = TechRenewable(installedcapacity, nothing, 1.0)
    RenewableFix(RenewableGenBase(name, status, bus, tech))
end

RenewableFix(; name="init",
        status = false,
        bus = Bus(),
        installedcapacity = 0.0) = RenewableFix(name, status, bus, installedcapacity)

@forward((RenewableFix, :base), RenewableGenBase)

struct RenewableCurtailment <: RenewableGen
    base::RenewableGenBase
    econ::Union{EconRenewable,Nothing}
end

function RenewableCurtailment(name, available, bus, tech, econ)
    return RenewableCurtailment(RenewableGenBase(name, available, bus, tech), econ)
end

"""Accepts installedcapacity as a Float64 and then creates a TechRenewable."""
function RenewableCurtailment(name::String, status::Bool, bus::Bus, installedcapacity::Float64, econ::Union{EconRenewable,Nothing})
    tech = TechRenewable(installedcapacity, nothing, 1.0)
    return RenewableCurtailment(name, status, bus, tech, econ)
end

RenewableCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                installedcapacity = 0.0,
                econ = EconRenewable()) = RenewableCurtailment(name, status, bus, installedcapacity, econ)

econ(value::RenewableCurtailment) = value.econ

@forward((RenewableCurtailment, :base), RenewableGenBase)

struct RenewableFullDispatch <: RenewableGen
    base::RenewableGenBase
    econ::Union{EconRenewable,Nothing}
end

function RenewableFullDispatch(name, available, bus, tech, econ)
    return RenewableFullDispatch(RenewableGenBase(name, available, bus, tech), econ)
end

function RenewableFullDispatch(; name = "init",
                               status = false,
                               bus= Bus(),
                               installedcapacity = 0.0,
                               econ = EconRenewable())
    rc = RenewableCurtailment(name, status, bus, installedcapacity, econ)
    return RenewableFullDispatch(PowerSystems.name(rc),
                                 PowerSystems.available(rc),
                                 PowerSystems.bus(rc),
                                 PowerSystems.tech(rc),
                                 PowerSystems.econ(rc))
end

econ(value::RenewableFullDispatch) = value.econ

@forward((RenewableFullDispatch, :base), RenewableGenBase)
