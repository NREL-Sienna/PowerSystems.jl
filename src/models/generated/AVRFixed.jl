#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRFixed <: AVR
        Vf::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Parameters of a AVR that returns a fixed voltage to the rotor winding

# Arguments
- `Vf::Float64`: Fixed voltage field applied to the rotor winding, validation range: (0, nothing)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: Fixed AVR has no states
- `n_states::Int64`: Fixed AVR has no states
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
    n_states::Int64
    "Fixed AVR has no states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRFixed(Vf, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRFixed(Vf, V_ref, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function AVRFixed(; Vf, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRFixed(Vf, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function AVRFixed(::Nothing)
    AVRFixed(;
        Vf=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AVRFixed Vf."""
get_Vf(value::AVRFixed) = value.Vf
"""Get AVRFixed V_ref."""
get_V_ref(value::AVRFixed) = value.V_ref
"""Get AVRFixed ext."""
get_ext(value::AVRFixed) = value.ext
"""Get AVRFixed states."""
get_states(value::AVRFixed) = value.states
"""Get AVRFixed n_states."""
get_n_states(value::AVRFixed) = value.n_states
"""Get AVRFixed states_types."""
get_states_types(value::AVRFixed) = value.states_types
"""Get AVRFixed internal."""
get_internal(value::AVRFixed) = value.internal

"""Set AVRFixed Vf."""
set_Vf!(value::AVRFixed, val::Float64) = value.Vf = val
"""Set AVRFixed V_ref."""
set_V_ref!(value::AVRFixed, val::Float64) = value.V_ref = val
"""Set AVRFixed ext."""
set_ext!(value::AVRFixed, val::Dict{String, Any}) = value.ext = val
"""Set AVRFixed states."""
set_states!(value::AVRFixed, val::Vector{Symbol}) = value.states = val
"""Set AVRFixed n_states."""
set_n_states!(value::AVRFixed, val::Int64) = value.n_states = val
"""Set AVRFixed states_types."""
set_states_types!(value::AVRFixed, val::Vector{StateTypes.StateType}) = value.states_types = val
"""Set AVRFixed internal."""
set_internal!(value::AVRFixed, val::InfrastructureSystemsInternal) = value.internal = val
