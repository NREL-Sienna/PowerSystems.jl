#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRFixed <: AVR
        Vs::Float64
        n_states::Int64
        states::Array{Symbol,1}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Parameters of a AVR that returns a fixed voltage to the rotor winding

# Arguments
- `Vs::Float64`
- `n_states::Int64`
- `states::Array{Symbol,1}`
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRFixed <: AVR
    Vs::Float64
    n_states::Int64
    states::Array{Symbol,1}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end
function AVRFixed(Vs, n_states=0, states=Vector{Symbol}(), ext=Dict{String, Any}(), )
    AVRFixed(Vs, n_states, states, ext, InfrastructureSystemsInternal())
end
function AVRFixed(; Vs, n_states=0, states=Vector{Symbol}(), ext=Dict{String, Any}(), )
    AVRFixed(Vs, n_states, states, ext, )
end

"""Get AVRFixed Vs."""
get_Vs(value::AVRFixed) = value.Vs
"""Get AVRFixed n_states."""
get_n_states(value::AVRFixed) = value.n_states
"""Get AVRFixed states."""
get_states(value::AVRFixed) = value.states
"""Get AVRFixed ext."""
get_ext(value::AVRFixed) = value.ext
"""Get AVRFixed internal."""
get_internal(value::AVRFixed) = value.internal
