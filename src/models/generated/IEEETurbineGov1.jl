#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct IEEETurbineGov1 <: TurbineGov
        R::Float64
        Ts::Float64
        Tc::Float64
        T3::Float64
        T4::Float64
        T5::Float64
        P_min::Float64
        P_max::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

IEEE Type 1 Speed-Governing Model

# Arguments
- `R::Float64`: Droop parameter, validation range: `(0, nothing)`
- `Ts::Float64`: Governor time constant, validation range: `(0, nothing)`
- `Tc::Float64`: Servo time constant, validation range: `(0, nothing)`
- `T3::Float64`: Transient gain time constant, validation range: `(0, nothing)`
- `T4::Float64`: Power fraction time constant, validation range: `(0, nothing)`
- `T5::Float64`: Reheat time constant, validation range: `(0, nothing)`
- `P_min::Float64`: Min Power into the Governor, validation range: `(0, nothing)`
- `P_max::Float64`: Max Power into the Governor, validation range: `(0, nothing)`
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the TGTypeI model are:
	x_g1: Governor state,
	x_g2: Servo state,
	x_g3: Reheat state
- `n_states::Int64`: TGTypeI has 3 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct IEEETurbineGov1 <: TurbineGov
    "Droop parameter"
    R::Float64
    "Governor time constant"
    Ts::Float64
    "Servo time constant"
    Tc::Float64
    "Transient gain time constant"
    T3::Float64
    "Power fraction time constant"
    T4::Float64
    "Reheat time constant"
    T5::Float64
    "Min Power into the Governor"
    P_min::Float64
    "Max Power into the Governor"
    P_max::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the TGTypeI model are:
	x_g1: Governor state,
	x_g2: Servo state,
	x_g3: Reheat state"
    states::Vector{Symbol}
    "TGTypeI has 3 states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function IEEETurbineGov1(R, Ts, Tc, T3, T4, T5, P_min, P_max, P_ref=1.0, ext=Dict{String, Any}(), )
    IEEETurbineGov1(R, Ts, Tc, T3, T4, T5, P_min, P_max, P_ref, ext, [:x_g1, :x_g2, :x_g3], 3, InfrastructureSystemsInternal(), )
end

function IEEETurbineGov1(; R, Ts, Tc, T3, T4, T5, P_min, P_max, P_ref=1.0, ext=Dict{String, Any}(), )
    IEEETurbineGov1(R, Ts, Tc, T3, T4, T5, P_min, P_max, P_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function IEEETurbineGov1(::Nothing)
    IEEETurbineGov1(;
        R=0,
        Ts=0,
        Tc=0,
        T3=0,
        T4=0,
        T5=0,
        P_min=0,
        P_max=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`IEEETurbineGov1`](@ref) `R`."""
get_R(value::IEEETurbineGov1) = value.R
"""Get [`IEEETurbineGov1`](@ref) `Ts`."""
get_Ts(value::IEEETurbineGov1) = value.Ts
"""Get [`IEEETurbineGov1`](@ref) `Tc`."""
get_Tc(value::IEEETurbineGov1) = value.Tc
"""Get [`IEEETurbineGov1`](@ref) `T3`."""
get_T3(value::IEEETurbineGov1) = value.T3
"""Get [`IEEETurbineGov1`](@ref) `T4`."""
get_T4(value::IEEETurbineGov1) = value.T4
"""Get [`IEEETurbineGov1`](@ref) `T5`."""
get_T5(value::IEEETurbineGov1) = value.T5
"""Get [`IEEETurbineGov1`](@ref) `P_min`."""
get_P_min(value::IEEETurbineGov1) = value.P_min
"""Get [`IEEETurbineGov1`](@ref) `P_max`."""
get_P_max(value::IEEETurbineGov1) = value.P_max
"""Get [`IEEETurbineGov1`](@ref) `P_ref`."""
get_P_ref(value::IEEETurbineGov1) = value.P_ref
"""Get [`IEEETurbineGov1`](@ref) `ext`."""
get_ext(value::IEEETurbineGov1) = value.ext
"""Get [`IEEETurbineGov1`](@ref) `states`."""
get_states(value::IEEETurbineGov1) = value.states
"""Get [`IEEETurbineGov1`](@ref) `n_states`."""
get_n_states(value::IEEETurbineGov1) = value.n_states
"""Get [`IEEETurbineGov1`](@ref) `internal`."""
get_internal(value::IEEETurbineGov1) = value.internal

"""Set [`IEEETurbineGov1`](@ref) `R`."""
set_R!(value::IEEETurbineGov1, val) = value.R = val
"""Set [`IEEETurbineGov1`](@ref) `Ts`."""
set_Ts!(value::IEEETurbineGov1, val) = value.Ts = val
"""Set [`IEEETurbineGov1`](@ref) `Tc`."""
set_Tc!(value::IEEETurbineGov1, val) = value.Tc = val
"""Set [`IEEETurbineGov1`](@ref) `T3`."""
set_T3!(value::IEEETurbineGov1, val) = value.T3 = val
"""Set [`IEEETurbineGov1`](@ref) `T4`."""
set_T4!(value::IEEETurbineGov1, val) = value.T4 = val
"""Set [`IEEETurbineGov1`](@ref) `T5`."""
set_T5!(value::IEEETurbineGov1, val) = value.T5 = val
"""Set [`IEEETurbineGov1`](@ref) `P_min`."""
set_P_min!(value::IEEETurbineGov1, val) = value.P_min = val
"""Set [`IEEETurbineGov1`](@ref) `P_max`."""
set_P_max!(value::IEEETurbineGov1, val) = value.P_max = val
"""Set [`IEEETurbineGov1`](@ref) `P_ref`."""
set_P_ref!(value::IEEETurbineGov1, val) = value.P_ref = val
"""Set [`IEEETurbineGov1`](@ref) `ext`."""
set_ext!(value::IEEETurbineGov1, val) = value.ext = val
"""Set [`IEEETurbineGov1`](@ref) `states`."""
set_states!(value::IEEETurbineGov1, val) = value.states = val
"""Set [`IEEETurbineGov1`](@ref) `n_states`."""
set_n_states!(value::IEEETurbineGov1, val) = value.n_states = val
"""Set [`IEEETurbineGov1`](@ref) `internal`."""
set_internal!(value::IEEETurbineGov1, val) = value.internal = val
