#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Source <: StaticInjection
        name::String
        available::Bool
        bus::Bus
        V_R::Float64
        V_I::Float64
        X_th::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

This struct acts as an infinity bus.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `V_R::Float64`: Voltage Source Real Component
- `V_I::Float64`: Voltage Source Imaginary Component
- `X_th::Float64`: Source Thevenin impedance
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Source <: StaticInjection
    name::String
    available::Bool
    bus::Bus
    "Voltage Source Real Component"
    V_R::Float64
    "Voltage Source Imaginary Component"
    V_I::Float64
    "Source Thevenin impedance"
    X_th::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Source(name, available, bus, V_R, V_I, X_th, ext=Dict{String, Any}(), )
    Source(name, available, bus, V_R, V_I, X_th, ext, InfrastructureSystemsInternal(), )
end

function Source(; name, available, bus, V_R, V_I, X_th, ext=Dict{String, Any}(), )
    Source(name, available, bus, V_R, V_I, X_th, ext, )
end

# Constructor for demo purposes; non-functional.
function Source(::Nothing)
    Source(;
        name="init",
        available=false,
        bus=Bus(nothing),
        V_R=0,
        V_I=0,
        X_th=0,
        ext=Dict{String, Any}(),
    )
end

"""Get Source name."""
get_name(value::Source) = value.name
"""Get Source available."""
get_available(value::Source) = value.available
"""Get Source bus."""
get_bus(value::Source) = value.bus
"""Get Source V_R."""
get_V_R(value::Source) = value.V_R
"""Get Source V_I."""
get_V_I(value::Source) = value.V_I
"""Get Source X_th."""
get_X_th(value::Source) = value.X_th
"""Get Source ext."""
get_ext(value::Source) = value.ext
"""Get Source internal."""
get_internal(value::Source) = value.internal
