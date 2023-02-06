#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TModelHVDCLine <: DCBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        r::Float64
        l::Float64
        c::Float64
        rate::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

a HVDC T-Model DC line.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `arc::Arc`
- `r::Float64`: Series Resistance system per-unit value
- `l::Float64`: Series Inductance system per-unit value
- `c::Float64`: Shunt capacitance system per-unit value
- `rate::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TModelHVDCLine <: DCBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    "Series Resistance system per-unit value"
    r::Float64
    "Series Inductance system per-unit value"
    l::Float64
    "Shunt capacitance system per-unit value"
    c::Float64
    rate::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TModelHVDCLine(name, available, active_power_flow, arc, r, l, c, rate, services=Device[], ext=Dict{String, Any}(), )
    TModelHVDCLine(name, available, active_power_flow, arc, r, l, c, rate, services, ext, InfrastructureSystemsInternal(), )
end

function TModelHVDCLine(; name, available, active_power_flow, arc, r, l, c, rate, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TModelHVDCLine(name, available, active_power_flow, arc, r, l, c, rate, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function TModelHVDCLine(::Nothing)
    TModelHVDCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(DCBus(nothing), DCBus(nothing)),
        r=0.0,
        l=0.0,
        c=0.0,
        rate=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`TModelHVDCLine`](@ref) `name`."""
get_name(value::TModelHVDCLine) = value.name
"""Get [`TModelHVDCLine`](@ref) `available`."""
get_available(value::TModelHVDCLine) = value.available
"""Get [`TModelHVDCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::TModelHVDCLine) = get_value(value, value.active_power_flow)
"""Get [`TModelHVDCLine`](@ref) `arc`."""
get_arc(value::TModelHVDCLine) = value.arc
"""Get [`TModelHVDCLine`](@ref) `r`."""
get_r(value::TModelHVDCLine) = value.r
"""Get [`TModelHVDCLine`](@ref) `l`."""
get_l(value::TModelHVDCLine) = value.l
"""Get [`TModelHVDCLine`](@ref) `c`."""
get_c(value::TModelHVDCLine) = value.c
"""Get [`TModelHVDCLine`](@ref) `rate`."""
get_rate(value::TModelHVDCLine) = get_value(value, value.rate)
"""Get [`TModelHVDCLine`](@ref) `services`."""
get_services(value::TModelHVDCLine) = value.services
"""Get [`TModelHVDCLine`](@ref) `ext`."""
get_ext(value::TModelHVDCLine) = value.ext
"""Get [`TModelHVDCLine`](@ref) `internal`."""
get_internal(value::TModelHVDCLine) = value.internal

"""Set [`TModelHVDCLine`](@ref) `available`."""
set_available!(value::TModelHVDCLine, val) = value.available = val
"""Set [`TModelHVDCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TModelHVDCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`TModelHVDCLine`](@ref) `arc`."""
set_arc!(value::TModelHVDCLine, val) = value.arc = val
"""Set [`TModelHVDCLine`](@ref) `r`."""
set_r!(value::TModelHVDCLine, val) = value.r = val
"""Set [`TModelHVDCLine`](@ref) `l`."""
set_l!(value::TModelHVDCLine, val) = value.l = val
"""Set [`TModelHVDCLine`](@ref) `c`."""
set_c!(value::TModelHVDCLine, val) = value.c = val
"""Set [`TModelHVDCLine`](@ref) `rate`."""
set_rate!(value::TModelHVDCLine, val) = value.rate = set_value(value, val)
"""Set [`TModelHVDCLine`](@ref) `services`."""
set_services!(value::TModelHVDCLine, val) = value.services = val
"""Set [`TModelHVDCLine`](@ref) `ext`."""
set_ext!(value::TModelHVDCLine, val) = value.ext = val
