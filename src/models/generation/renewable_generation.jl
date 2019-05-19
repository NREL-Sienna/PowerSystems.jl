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
        available = false,
        bus = Bus(),
        rating = 0.0) = RenewableFix(name, status, bus, rating)


struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    internal::PowerSystemInternal
end

function RenewableDispatch(name, available, bus, tech, econ)
    return RenewableDispatch(name, available, bus, tech, econ, PowerSystemInternal())
end

RenewableDispatch(; name = "init",
                available = false,
                bus= Bus(),
                tech = TechRenewable(),
                rating = 0.0,
                econ = EconRenewable()) = RenewableDispatch(name, status, bus, rating, econ)


"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableDispatch(name::String, status::Bool, bus::Bus, rating::Float64, econ::Union{EconRenewable,Nothing})
    tech = TechRenewable(rating, nothing, 1.0)
    return RenewableDispatch(name, status, bus, tech, econ)
end