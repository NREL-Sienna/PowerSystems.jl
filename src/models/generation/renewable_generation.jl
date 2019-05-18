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

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableFix(name, status, bus, rating::Float64)
    tech = TechRenewable(rating, nothing, 1.0)
    RenewableFix(name, status, bus, tech)
end

RenewableFix(; name="init",
        status = false,
        bus = Bus(),
        rating = 0.0) = RenewableFix(name, status, bus, rating)

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

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableCurtailment(name::String, status::Bool, bus::Bus, rating::Float64, econ::Union{EconRenewable,Nothing})
    tech = TechRenewable(rating, nothing, 1.0)
    return RenewableCurtailment(name, status, bus, tech, econ)
end

RenewableCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                rating = 0.0,
                econ = EconRenewable()) = RenewableCurtailment(name, status, bus, rating, econ)

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
                rating = 0.0,
                econ = EconRenewable()) = RenewableCurtailment(name, status, bus, rating, econ)
