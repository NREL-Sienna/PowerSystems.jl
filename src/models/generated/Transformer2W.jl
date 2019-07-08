#=
This file is auto-generated. Do not edit.
=#

"""The 2-W transformer model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer. The model allocates the iron losses and magnetizing susceptance to the primary side."""
mutable struct Transformer2W <: ACBranch
    name::String
    available::Bool
    connectionpoints::Arch
    r::Float64
    x::Float64
    primaryshunt::Float64
    rate::Union{Nothing, Float64}
    internal::PowerSystems.PowerSystemInternal
end

function Transformer2W(name, available, connectionpoints, r, x, primaryshunt, rate, )
    Transformer2W(name, available, connectionpoints, r, x, primaryshunt, rate, PowerSystemInternal())
end

function Transformer2W(; name, available, connectionpoints, r, x, primaryshunt, rate, )
    Transformer2W(name, available, connectionpoints, r, x, primaryshunt, rate, )
end

# Constructor for demo purposes; non-functional.

function Transformer2W(::Nothing)
    Transformer2W(;
        name="init",
        available=false,
        connectionpoints=Arch(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primaryshunt=0.0,
        rate=nothing,
    )
end

"""Get Transformer2W name."""
get_name(value::Transformer2W) = value.name
"""Get Transformer2W available."""
get_available(value::Transformer2W) = value.available
"""Get Transformer2W connectionpoints."""
get_connectionpoints(value::Transformer2W) = value.connectionpoints
"""Get Transformer2W r."""
get_r(value::Transformer2W) = value.r
"""Get Transformer2W x."""
get_x(value::Transformer2W) = value.x
"""Get Transformer2W primaryshunt."""
get_primaryshunt(value::Transformer2W) = value.primaryshunt
"""Get Transformer2W rate."""
get_rate(value::Transformer2W) = value.rate
"""Get Transformer2W internal."""
get_internal(value::Transformer2W) = value.internal
