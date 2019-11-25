"""Accepts rating as a Float64 and then creates a TwoPartCost."""
function TwoPartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return TwoPartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a ThreePartCost."""
function ThreePartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return ThreePartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableFix(name::String, available::Bool, bus::Bus,
                        activepower::Float64, reactivepower::Float64,
                        prime_mover::PrimeMovers, rating::Float64)
    tech = TechRenewable(rating, prime_mover, nothing, 1.0)
    RenewableFix(name, available, bus, activepower, reactivepower, tech)
end

"""Accepts rating as a Float64 and then creates a TechRenewable."""
function RenewableDispatch(name::String, available::Bool, bus::Bus,
                           activepower::Float64, reactivepower::Float64,
                           prime_mover::PrimeMovers, rating::Float64, op_cost::TwoPartCost)
    tech = TechRenewable(rating, prime_mover, nothing, 1.0)
    return RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost)
end

function PowerLoadPF(name::String, available::Bool, bus::Bus,
                     model::Union{Nothing, LoadModel}, activepower::Float64,
                     maxactivepower::Float64, power_factor::Float64)
    maxreactivepower = maxactivepower * sin(acos(power_factor))
    reactivepower = activepower * sin(acos(power_factor))
    return PowerLoad(name,
                     available,
                     bus,
                     model,
                     activepower,
                     reactivepower,
                     maxactivepower,
                     maxreactivepower)
end

function PowerLoadPF(::Nothing)
    return PowerLoadPF("init", true, Bus(nothing), nothing, 0.0, 0.0, 1.0)
end

"""Accepts anglelimits as a Float64."""
function Line(name, available::Bool, activepower_flow::Float64,
    reactivepower_flow::Float64, arc::Arc, r, x, b, rate, anglelimits::Float64)
    return Line(name, available, activepower_flow, reactivepower_flow, arc::Arc, r, x, b, rate,
                (min=-anglelimits, max=anglelimits))
end

"""Allows construction with bus type specified as a string for legacy code."""
function Bus(number, name, bustype::String, angle, voltage, voltagelimits, basevoltage; ext=Dict{String,Any}())
    return Bus(number, name, get_enum_value(BusType, bustype), angle, voltage,
               voltagelimits, basevoltage, ext, InfrastructureSystemsInternal())
end
