#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct AVRSimple <: AVR
        Kv::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        states_types::Vector{StateTypes}
        internal::InfrastructureSystemsInternal
    end

Parameters of a simple proportional AVR in the derivative of EMF
i.e. an integrator controller on EMF

# Arguments
- `Kv::Float64`: Proportional Gain, validation range: `(0, nothing)`
- `V_ref::Float64`: (default: `1.0`) (optional) Reference Voltage Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) The states are:
	Vf: field voltage
- `n_states::Int`: (**Do not modify.**) Fixed AVR has 1 states
- `states_types::Vector{StateTypes}`: (**Do not modify.**) Simple AVR has 1 [differential](@ref states_list) [states](@ref S)
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct AVRSimple <: AVR
    "Proportional Gain"
    Kv::Float64
    "(optional) Reference Voltage Set-point (pu)"
    V_ref::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) The states are:
	Vf: field voltage"
    states::Vector{Symbol}
    "(**Do not modify.**) Fixed AVR has 1 states"
    n_states::Int
    "(**Do not modify.**) Simple AVR has 1 [differential](@ref states_list) [states](@ref S)"
    states_types::Vector{StateTypes}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function AVRSimple(Kv, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRSimple(Kv, V_ref, ext, [:Vf], 1, [StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function AVRSimple(; Kv, V_ref=1.0, ext=Dict{String, Any}(), states=[:Vf], n_states=1, states_types=[StateTypes.Differential], internal=InfrastructureSystemsInternal(), )
    AVRSimple(Kv, V_ref, ext, states, n_states, states_types, internal, )
end

# Constructor for demo purposes; non-functional.
function AVRSimple(::Nothing)
    AVRSimple(;
        Kv=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`AVRSimple`](@ref) `Kv`."""
get_Kv(value::AVRSimple) = value.Kv
"""Get [`AVRSimple`](@ref) `V_ref`."""
get_V_ref(value::AVRSimple) = value.V_ref
"""Get [`AVRSimple`](@ref) `ext`."""
get_ext(value::AVRSimple) = value.ext
"""Get [`AVRSimple`](@ref) `states`."""
get_states(value::AVRSimple) = value.states
"""Get [`AVRSimple`](@ref) `n_states`."""
get_n_states(value::AVRSimple) = value.n_states
"""Get [`AVRSimple`](@ref) `states_types`."""
get_states_types(value::AVRSimple) = value.states_types
"""Get [`AVRSimple`](@ref) `internal`."""
get_internal(value::AVRSimple) = value.internal

"""Set [`AVRSimple`](@ref) `Kv`."""
set_Kv!(value::AVRSimple, val) = value.Kv = val
"""Set [`AVRSimple`](@ref) `V_ref`."""
set_V_ref!(value::AVRSimple, val) = value.V_ref = val
"""Set [`AVRSimple`](@ref) `ext`."""
set_ext!(value::AVRSimple, val) = value.ext = val
"""Set [`AVRSimple`](@ref) `states_types`."""
set_states_types!(value::AVRSimple, val) = value.states_types = val
