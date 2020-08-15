#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroTurbineGov <: TurbineGov
        R::Float64
        r::Float64
        Tr::Float64
        Tf::Float64
        Tg::Float64
        VELM::Float64
        gate_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Tw::Float64
        At::Float64
        D_T::Float64
        q_nl::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Hydro Turbine-Governor.

# Arguments
- `R::Float64`: Permanent droop parameter, validation range: (0, nothing)
- `r::Float64`: Temporary Droop, validation range: (0, nothing)
- `Tr::Float64`: Governor time constant, validation range: (&quot;eps()&quot;, nothing), action if invalid: error
- `Tf::Float64`: Filter Time constant, validation range: (&quot;eps()&quot;, nothing)
- `Tg::Float64`: Servo time constant, validation range: (&quot;eps()&quot;, nothing), action if invalid: error
- `VELM::Float64`: gate velocity limit
- `gate_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Gate position limits
- `Tw::Float64`: water time constant, validation range: (&quot;eps()&quot;, nothing), action if invalid: error
- `At::Float64`: Turbine gain
- `D_T::Float64`: Turbine Damping, validation range: (0, nothing)
- `q_nl::Float64`: No-power flow, validation range: (0, nothing)
- `P_ref::Float64`: Reference Power Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the HydroTurbineGov model are:
	x_g1: filter_output,
	x_g2: desired gate, 
	x_g3: gate opening, 
	x_g4: turbine flow
- `n_states::Int`: HYGOV has 4 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroTurbineGov <: TurbineGov
    "Permanent droop parameter"
    R::Float64
    "Temporary Droop"
    r::Float64
    "Governor time constant"
    Tr::Float64
    "Filter Time constant"
    Tf::Float64
    "Servo time constant"
    Tg::Float64
    "gate velocity limit"
    VELM::Float64
    "Gate position limits"
    gate_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "water time constant"
    Tw::Float64
    "Turbine gain"
    At::Float64
    "Turbine Damping"
    D_T::Float64
    "No-power flow"
    q_nl::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the HydroTurbineGov model are:
	x_g1: filter_output,
	x_g2: desired gate, 
	x_g3: gate opening, 
	x_g4: turbine flow"
    states::Vector{Symbol}
    "HYGOV has 4 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroTurbineGov(R, r, Tr, Tf, Tg, VELM, gate_position_limits, Tw, At, D_T, q_nl, P_ref=1.0, ext=Dict{String, Any}(), )
    HydroTurbineGov(R, r, Tr, Tf, Tg, VELM, gate_position_limits, Tw, At, D_T, q_nl, P_ref, ext, [:x_g1, :x_g2, :x_g3, :x_g4], 4, InfrastructureSystemsInternal(), )
end

function HydroTurbineGov(; R, r, Tr, Tf, Tg, VELM, gate_position_limits, Tw, At, D_T, q_nl, P_ref=1.0, ext=Dict{String, Any}(), )
    HydroTurbineGov(R, r, Tr, Tf, Tg, VELM, gate_position_limits, Tw, At, D_T, q_nl, P_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function HydroTurbineGov(::Nothing)
    HydroTurbineGov(;
        R=0,
        r=0,
        Tr=0,
        Tf=0,
        Tg=0,
        VELM=0,
        gate_position_limits=(min=0.0, max=0.0),
        Tw=0,
        At=0,
        D_T=0,
        q_nl=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get HydroTurbineGov R."""
get_R(value::HydroTurbineGov) = value.R
"""Get HydroTurbineGov r."""
get_r(value::HydroTurbineGov) = value.r
"""Get HydroTurbineGov Tr."""
get_Tr(value::HydroTurbineGov) = value.Tr
"""Get HydroTurbineGov Tf."""
get_Tf(value::HydroTurbineGov) = value.Tf
"""Get HydroTurbineGov Tg."""
get_Tg(value::HydroTurbineGov) = value.Tg
"""Get HydroTurbineGov VELM."""
get_VELM(value::HydroTurbineGov) = value.VELM
"""Get HydroTurbineGov gate_position_limits."""
get_gate_position_limits(value::HydroTurbineGov) = value.gate_position_limits
"""Get HydroTurbineGov Tw."""
get_Tw(value::HydroTurbineGov) = value.Tw
"""Get HydroTurbineGov At."""
get_At(value::HydroTurbineGov) = value.At
"""Get HydroTurbineGov D_T."""
get_D_T(value::HydroTurbineGov) = value.D_T
"""Get HydroTurbineGov q_nl."""
get_q_nl(value::HydroTurbineGov) = value.q_nl
"""Get HydroTurbineGov P_ref."""
get_P_ref(value::HydroTurbineGov) = value.P_ref
"""Get HydroTurbineGov ext."""
get_ext(value::HydroTurbineGov) = value.ext
"""Get HydroTurbineGov states."""
get_states(value::HydroTurbineGov) = value.states
"""Get HydroTurbineGov n_states."""
get_n_states(value::HydroTurbineGov) = value.n_states
"""Get HydroTurbineGov internal."""
get_internal(value::HydroTurbineGov) = value.internal

"""Set HydroTurbineGov R."""
set_R!(value::HydroTurbineGov, val::Float64) = value.R = val
"""Set HydroTurbineGov r."""
set_r!(value::HydroTurbineGov, val::Float64) = value.r = val
"""Set HydroTurbineGov Tr."""
set_Tr!(value::HydroTurbineGov, val::Float64) = value.Tr = val
"""Set HydroTurbineGov Tf."""
set_Tf!(value::HydroTurbineGov, val::Float64) = value.Tf = val
"""Set HydroTurbineGov Tg."""
set_Tg!(value::HydroTurbineGov, val::Float64) = value.Tg = val
"""Set HydroTurbineGov VELM."""
set_VELM!(value::HydroTurbineGov, val::Float64) = value.VELM = val
"""Set HydroTurbineGov gate_position_limits."""
set_gate_position_limits!(value::HydroTurbineGov, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.gate_position_limits = val
"""Set HydroTurbineGov Tw."""
set_Tw!(value::HydroTurbineGov, val::Float64) = value.Tw = val
"""Set HydroTurbineGov At."""
set_At!(value::HydroTurbineGov, val::Float64) = value.At = val
"""Set HydroTurbineGov D_T."""
set_D_T!(value::HydroTurbineGov, val::Float64) = value.D_T = val
"""Set HydroTurbineGov q_nl."""
set_q_nl!(value::HydroTurbineGov, val::Float64) = value.q_nl = val
"""Set HydroTurbineGov P_ref."""
set_P_ref!(value::HydroTurbineGov, val::Float64) = value.P_ref = val
"""Set HydroTurbineGov ext."""
set_ext!(value::HydroTurbineGov, val::Dict{String, Any}) = value.ext = val
"""Set HydroTurbineGov states."""
set_states!(value::HydroTurbineGov, val::Vector{Symbol}) = value.states = val
"""Set HydroTurbineGov n_states."""
set_n_states!(value::HydroTurbineGov, val::Int) = value.n_states = val
"""Set HydroTurbineGov internal."""
set_internal!(value::HydroTurbineGov, val::InfrastructureSystemsInternal) = value.internal = val
