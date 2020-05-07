#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRFixed <: AVR
        Emf::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a AVR that returns a fixed voltage to the rotor winding

# Arguments
- `Emf::Float64`: Fixed voltage to the rotor winding, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: Fixed AVR has no states
- `n_states::Int64`: Fixed AVR has no states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRFixed <: AVR
    "Fixed voltage to the rotor winding"
    Emf::Float64
    ext::Dict{String, Any}
    "Fixed AVR has no states"
    states::Vector{Symbol}
    "Fixed AVR has no states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRFixed(Emf, ext=Dict{String, Any}(), )
    AVRFixed(Emf, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function AVRFixed(; Emf, ext=Dict{String, Any}(), )
    AVRFixed(Emf, ext, )
end

# Constructor for demo purposes; non-functional.
function AVRFixed(::Nothing)
    AVRFixed(;
        Emf=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AVRFixed Emf."""
get_Emf(value::AVRFixed) = value.Emf
"""Get AVRFixed ext."""
get_ext(value::AVRFixed) = value.ext
"""Get AVRFixed states."""
get_states(value::AVRFixed) = value.states
"""Get AVRFixed n_states."""
get_n_states(value::AVRFixed) = value.n_states
"""Get AVRFixed internal."""
get_internal(value::AVRFixed) = value.internal

"""Set AVRFixed Emf."""
set_Emf(value::AVRFixed, val) = value.Emf = val
"""Set AVRFixed ext."""
set_ext(value::AVRFixed, val) = value.ext = val
"""Set AVRFixed states."""
set_states(value::AVRFixed, val) = value.states = val
"""Set AVRFixed n_states."""
set_n_states(value::AVRFixed, val) = value.n_states = val
"""Set AVRFixed internal."""
set_internal(value::AVRFixed, val) = value.internal = val
