#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReactivePowerDroop <: ReactivePowerControl
        kq::Float64
        ωf::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of a Reactive Power droop controller

# Arguments
- `kq::Float64`: frequency droop gain, validation range: `(0, nothing)`
- `ωf::Float64`: filter frequency cutoff, validation range: `(0, nothing)`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ReactivePowerDroop model are:
	q_oc: Filtered reactive output power
- `n_states::Int64`: ReactivePowerDroop has 1 state
"""
mutable struct ReactivePowerDroop <: ReactivePowerControl
    "frequency droop gain"
    kq::Float64
    "filter frequency cutoff"
    ωf::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "The states of the ReactivePowerDroop model are:
	q_oc: Filtered reactive output power"
    states::Vector{Symbol}
    "ReactivePowerDroop has 1 state"
    n_states::Int64
end

function ReactivePowerDroop(kq, ωf, V_ref=1.0, ext=Dict{String, Any}(), )
    ReactivePowerDroop(kq, ωf, V_ref, ext, [:q_oc], 1, )
end

function ReactivePowerDroop(; kq, ωf, V_ref=1.0, ext=Dict{String, Any}(), )
    ReactivePowerDroop(kq, ωf, V_ref, ext, )
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
"""Set [`ReactivePowerDroop`](@ref) `states`."""
set_states!(value::ReactivePowerDroop, val) = value.states = val
"""Set [`ReactivePowerDroop`](@ref) `n_states`."""
set_n_states!(value::ReactivePowerDroop, val) = value.n_states = val
