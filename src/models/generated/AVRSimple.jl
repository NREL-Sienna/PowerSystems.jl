#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRSimple <: AVR
        Kv::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a simple proportional AVR in the derivative of EMF
i.e. an integrator controller on EMF

# Arguments
- `Kv::Float64`: Proportional Gain
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`: Fixed AVR has 1 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRSimple <: AVR
    "Proportional Gain"
    Kv::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    "Fixed AVR has 1 states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRSimple(Kv, ext=Dict{String, Any}(), )
    AVRSimple(Kv, ext, [:Vf], 1, InfrastructureSystemsInternal(), )
end

function AVRSimple(; Kv, ext=Dict{String, Any}(), )
    AVRSimple(Kv, ext, )
end

# Constructor for demo purposes; non-functional.
function AVRSimple(::Nothing)
    AVRSimple(;
        Kv=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AVRSimple Kv."""
get_Kv(value::AVRSimple) = value.Kv
"""Get AVRSimple ext."""
get_ext(value::AVRSimple) = value.ext
"""Get AVRSimple states."""
get_states(value::AVRSimple) = value.states
"""Get AVRSimple n_states."""
get_n_states(value::AVRSimple) = value.n_states
"""Get AVRSimple internal."""
get_internal(value::AVRSimple) = value.internal
