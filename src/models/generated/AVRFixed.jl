#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRFixed <: AVR
        Vf::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Parameters of a AVR that returns a fixed voltage to the rotor winding

# Arguments
- `Vf::Float64`: Fixed voltage field applied to the rotor winding, validation range: `(0, nothing)`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: Fixed AVR has no states
- `n_states::Int`: Fixed AVR has no states
- `states_types::Vector{StateTypes.StateType}`: Fixed AVR has no states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRFixed <: AVR
    "Fixed voltage field applied to the rotor winding"
    Vf::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "Fixed AVR has no states"
    states::Vector{Symbol}
    "Fixed AVR has no states"
    n_states::Int
    "Fixed AVR has no states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRFixed(Vf, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRFixed(Vf, V_ref, ext, Vector{Symbol}(), 0, Vector{StateTypes.StateType}(), InfrastructureSystemsInternal(), )
end

function AVRFixed(; Vf, V_ref=1.0, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, states_types=Vector{StateTypes.StateType}(), internal=InfrastructureSystemsInternal(), )
    AVRFixed(Vf, V_ref, ext, states, n_states, states_types, internal, )
end

# Constructor for demo purposes; non-functional.
function AVRFixed(::Nothing)
    AVRFixed(;
        Vf=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`AVRFixed`](@ref) `Vf`."""
get_Vf(value::AVRFixed) = value.Vf
"""Get [`AVRFixed`](@ref) `V_ref`."""
get_V_ref(value::AVRFixed) = value.V_ref
"""Get [`AVRFixed`](@ref) `ext`."""
get_ext(value::AVRFixed) = value.ext
"""Get [`AVRFixed`](@ref) `states`."""
get_states(value::AVRFixed) = value.states
"""Get [`AVRFixed`](@ref) `n_states`."""
get_n_states(value::AVRFixed) = value.n_states
"""Get [`AVRFixed`](@ref) `states_types`."""
get_states_types(value::AVRFixed) = value.states_types
"""Get [`AVRFixed`](@ref) `internal`."""
get_internal(value::AVRFixed) = value.internal

"""Set [`AVRFixed`](@ref) `Vf`."""
set_Vf!(value::AVRFixed, val) = value.Vf = val
"""Set [`AVRFixed`](@ref) `V_ref`."""
set_V_ref!(value::AVRFixed, val) = value.V_ref = val
"""Set [`AVRFixed`](@ref) `ext`."""
set_ext!(value::AVRFixed, val) = value.ext = val
"""Set [`AVRFixed`](@ref) `states_types`."""
set_states_types!(value::AVRFixed, val) = value.states_types = val

