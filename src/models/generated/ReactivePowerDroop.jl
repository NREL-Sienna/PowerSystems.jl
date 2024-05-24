#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ReactivePowerDroop <: ReactivePowerControl
        kq::Float64
        ωf::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Reactive Power droop controller

# Arguments
- `kq::Float64`: frequency droop gain, validation range: `(0, nothing)`
- `ωf::Float64`: filter frequency cutoff, validation range: `(0, nothing)`
- `V_ref::Float64`: (optional) Reference Voltage Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) The [states](@ref S) of the ReactivePowerDroop model are:
	q_oc: Filtered reactive output power
- `n_states::Int`: (**Do not modify.**) ReactivePowerDroop has 1 state
"""
mutable struct ReactivePowerDroop <: ReactivePowerControl
    "frequency droop gain"
    kq::Float64
    "filter frequency cutoff"
    ωf::Float64
    "(optional) Reference Voltage Set-point (pu)"
    V_ref::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) The [states](@ref S) of the ReactivePowerDroop model are:
	q_oc: Filtered reactive output power"
    states::Vector{Symbol}
    "(**Do not modify.**) ReactivePowerDroop has 1 state"
    n_states::Int
end

function ReactivePowerDroop(kq, ωf, V_ref=1.0, ext=Dict{String, Any}(), )
    ReactivePowerDroop(kq, ωf, V_ref, ext, [:q_oc], 1, )
end

function ReactivePowerDroop(; kq, ωf, V_ref=1.0, ext=Dict{String, Any}(), states=[:q_oc], n_states=1, )
    ReactivePowerDroop(kq, ωf, V_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReactivePowerDroop(::Nothing)
    ReactivePowerDroop(;
        kq=0,
        ωf=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReactivePowerDroop`](@ref) `kq`."""
get_kq(value::ReactivePowerDroop) = value.kq
"""Get [`ReactivePowerDroop`](@ref) `ωf`."""
get_ωf(value::ReactivePowerDroop) = value.ωf
"""Get [`ReactivePowerDroop`](@ref) `V_ref`."""
get_V_ref(value::ReactivePowerDroop) = value.V_ref
"""Get [`ReactivePowerDroop`](@ref) `ext`."""
get_ext(value::ReactivePowerDroop) = value.ext
"""Get [`ReactivePowerDroop`](@ref) `states`."""
get_states(value::ReactivePowerDroop) = value.states
"""Get [`ReactivePowerDroop`](@ref) `n_states`."""
get_n_states(value::ReactivePowerDroop) = value.n_states

"""Set [`ReactivePowerDroop`](@ref) `kq`."""
set_kq!(value::ReactivePowerDroop, val) = value.kq = val
"""Set [`ReactivePowerDroop`](@ref) `ωf`."""
set_ωf!(value::ReactivePowerDroop, val) = value.ωf = val
"""Set [`ReactivePowerDroop`](@ref) `V_ref`."""
set_V_ref!(value::ReactivePowerDroop, val) = value.V_ref = val
"""Set [`ReactivePowerDroop`](@ref) `ext`."""
set_ext!(value::ReactivePowerDroop, val) = value.ext = val
