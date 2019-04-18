abstract type
    RenewableGen <: Generator
end

struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    internal::PowerSystemInternal
end

function RenewableFix(name, available, bus, tech)
    return RenewableFix(name, available, bus, tech, PowerSystemInternal())
end

"""Accepts installedcapacity as a Float64 and then creates a TechRenewable."""
function RenewableFix(name, status, bus, installedcapacity::Float64)
    tech = TechRenewable(installedcapacity, nothing, 1.0)
    RenewableFix(name, status, bus, tech)
end

RenewableFix(; name="init",
        status = false,
        bus = Bus(),
        installedcapacity = 0.0) = RenewableFix(name, status, bus, installedcapacity)

struct RenewableCurtailment <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    internal::PowerSystemInternal
end

function RenewableCurtailment(name, available, bus, tech, econ)
    return RenewableCurtailment(name, available, bus, tech, econ, PowerSystemInternal())
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

struct RenewableFullDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    internal::PowerSystemInternal
end

function RenewableFullDispatch(name, available, bus, tech, econ)
    return RenewableFullDispatch(name, available, bus, tech, econ, PowerSystemInternal())
end

RenewableFullDispatch(; name = "init",
                status = false,
                bus= Bus(),
                installedcapacity = 0.0,
                econ = EconRenewable()) = RenewableCurtailment(name, status, bus, installedcapacity, econ)
