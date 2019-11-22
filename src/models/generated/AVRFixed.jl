#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRFixed <: AVR
        Vs::Float64
        ext::Dict{String, Any}
        states::Array{Symbol,1}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a AVR that returns a fixed voltage to the rotor winding

# Arguments
- `Vs::Float64`
- `ext::Dict{String, Any}`
- `states::Array{Symbol,1}`: Fixed AVR has no states
- `n_states::Int64`: Fixed AVR has no states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRFixed <: AVR
    Vs::Float64
    ext::Dict{String, Any}
    "Fixed AVR has no states"
    states::Array{Symbol,1}
    "Fixed AVR has no states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRFixed(Vs, ext=Dict{String, Any}(), )
    AVRFixed(Vs, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function AVRFixed(; Vs, ext=Dict{String, Any}(), )
    AVRFixed(Vs, ext, )
end



"""Get AVRFixed Vs."""
get_Vs(value::AVRFixed) = value.Vs
"""Get AVRFixed ext."""
get_ext(value::AVRFixed) = value.ext
"""Get AVRFixed states."""
get_states(value::AVRFixed) = value.states
"""Get AVRFixed n_states."""
get_n_states(value::AVRFixed) = value.n_states
"""Get AVRFixed internal."""
get_internal(value::AVRFixed) = value.internal
