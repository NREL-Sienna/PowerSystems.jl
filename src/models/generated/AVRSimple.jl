#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRSimple <: AVR
        Kv::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a simple proportional AVR in the derivative of EMF
i.e. an integrator controller on EMF

# Arguments
- `Kv::Float64`: Proportional Gain, validation range: (0, nothing)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`: Fixed AVR has 1 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRSimple <: AVR
    "Proportional Gain"
    Kv::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    "Fixed AVR has 1 states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRSimple(Kv, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRSimple(Kv, V_ref, ext, [:Vf], 1, InfrastructureSystemsInternal(), )
end

function AVRSimple(; Kv, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRSimple(Kv, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function AVRSimple(::Nothing)
    AVRSimple(;
        Kv=0.0,
        V_ref=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get AVRSimple Kv."""
get_Kv(value::AVRSimple) = value.Kv
"""Get AVRSimple V_ref."""
get_V_ref(value::AVRSimple) = value.V_ref
"""Get AVRSimple ext."""
get_ext(value::AVRSimple) = value.ext
"""Get AVRSimple states."""
get_states(value::AVRSimple) = value.states
"""Get AVRSimple n_states."""
get_n_states(value::AVRSimple) = value.n_states
"""Get AVRSimple internal."""
get_internal(value::AVRSimple) = value.internal

"""Set AVRSimple Kv."""
set_Kv!(value::AVRSimple, val::Float64) = value.Kv = val
"""Set AVRSimple V_ref."""
set_V_ref!(value::AVRSimple, val::Float64) = value.V_ref = val
"""Set AVRSimple ext."""
set_ext!(value::AVRSimple, val::Dict{String, Any}) = value.ext = val
"""Set AVRSimple states."""
set_states!(value::AVRSimple, val::Vector{Symbol}) = value.states = val
"""Set AVRSimple n_states."""
set_n_states!(value::AVRSimple, val::Int64) = value.n_states = val
"""Set AVRSimple internal."""
set_internal!(value::AVRSimple, val::InfrastructureSystemsInternal) = value.internal = val
