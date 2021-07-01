#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ActiveRenewableSimple <: ActivePowerControl
        bus_control::Int
        from_branch_control::Int
        to_branch_control::Int
        branch_id_control::String
        Freq_Flag::Int
        K_pg::Float64
        K_pi::Float64
        T_p::Float64
        fdbd1::Float64
        fdbd2::Float64
        fe_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        P_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        T_g::Float64
        D_dn::Float64
        D_up::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of Active Power Controller including REPCA1 and REECB1

# Arguments
- `bus_control::Int`: Bus Number for voltage control; , validation range: `(0, nothing)`
- `from_branch_control::Int`: Monitored branch FROM bus number for line drop compensation (if 0 generator power will be used), validation range: `(0, nothing)`
- `to_branch_control::Int`: Monitored branch TO bus number for line drop compensation (if 0 generator power will be used), validation range: `(0, nothing)`
- `branch_id_control::String`: Branch circuit id for line drop compensation (as a string). If 0 generator power will be used
- `Freq_Flag::Int`: Frequency Flag for REPCA1: 0: disable, 1:enable, validation range: `(0, 1)`
- `K_pg::Float64`: Active power PI control proportional gain, validation range: `(0, nothing)`
- `K_pi::Float64`: Active power PI control integral gain, validation range: `(0, nothing)`
- `T_p::Float64`: Real power measurement filter time constant (s), validation range: `(0, nothing)`
- `fdbd1::Float64`: Frequency error dead band lower threshold, validation range: `(nothing, 0)`
- `fdbd2::Float64`: Frequency error dead band upper threshold, validation range: `(0, nothing)`
- `fe_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on frequency error `(fe_min, fe_max)`
- `P_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on power reference `(P_min, P_max)`
- `T_g::Float64`: Power Controller lag time constant, validation range: `(0, nothing)`
- `D_dn::Float64`: Droop for over-frequency conditions, validation range: `(nothing, 0)`
- `D_up::Float64`: Droop for under-frequency conditions, validation range: `(0, nothing)`
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ActiveRenewableSimple model depends on the Flag
- `n_states::Int`: The states of the ActiveRenewableSimple model depends on the Flag
"""
mutable struct ActiveRenewableSimple <: ActivePowerControl
    "Bus Number for voltage control; "
    bus_control::Int
    "Monitored branch FROM bus number for line drop compensation (if 0 generator power will be used)"
    from_branch_control::Int
    "Monitored branch TO bus number for line drop compensation (if 0 generator power will be used)"
    to_branch_control::Int
    "Branch circuit id for line drop compensation (as a string). If 0 generator power will be used"
    branch_id_control::String
    "Frequency Flag for REPCA1: 0: disable, 1:enable"
    Freq_Flag::Int
    "Active power PI control proportional gain"
    K_pg::Float64
    "Active power PI control integral gain"
    K_pi::Float64
    "Real power measurement filter time constant (s)"
    T_p::Float64
    "Frequency error dead band lower threshold"
    fdbd1::Float64
    "Frequency error dead band upper threshold"
    fdbd2::Float64
    "Upper/Lower limit on frequency error `(fe_min, fe_max)`"
    fe_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Upper/Lower limit on power reference `(P_min, P_max)`"
    P_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Power Controller lag time constant"
    T_g::Float64
    "Droop for over-frequency conditions"
    D_dn::Float64
    "Droop for under-frequency conditions"
    D_up::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the ActiveRenewableSimple model depends on the Flag"
    states::Vector{Symbol}
    "The states of the ActiveRenewableSimple model depends on the Flag"
    n_states::Int
end

function ActiveRenewableSimple(bus_control, from_branch_control, to_branch_control, branch_id_control, Freq_Flag, K_pg, K_pi, T_p, fdbd1, fdbd2, fe_lim, P_lim, T_g, D_dn, D_up, P_ref=1.0, ext=Dict{String, Any}(), )
    ActiveRenewableSimple(bus_control, from_branch_control, to_branch_control, branch_id_control, Freq_Flag, K_pg, K_pi, T_p, fdbd1, fdbd2, fe_lim, P_lim, T_g, D_dn, D_up, P_ref, ext, PowerSystems.get_activeRESimple_states(Freq_Flag)[1], PowerSystems.get_activeRESimple_states(Freq_Flag)[2], )
end

function ActiveRenewableSimple(; bus_control, from_branch_control, to_branch_control, branch_id_control, Freq_Flag, K_pg, K_pi, T_p, fdbd1, fdbd2, fe_lim, P_lim, T_g, D_dn, D_up, P_ref=1.0, ext=Dict{String, Any}(), states=PowerSystems.get_activeRESimple_states(Freq_Flag)[1], n_states=PowerSystems.get_activeRESimple_states(Freq_Flag)[2], )
    ActiveRenewableSimple(bus_control, from_branch_control, to_branch_control, branch_id_control, Freq_Flag, K_pg, K_pi, T_p, fdbd1, fdbd2, fe_lim, P_lim, T_g, D_dn, D_up, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ActiveRenewableSimple(::Nothing)
    ActiveRenewableSimple(;
        bus_control=0,
        from_branch_control=0,
        to_branch_control=0,
        branch_id_control="0",
        Freq_Flag=0,
        K_pg=0,
        K_pi=0,
        T_p=0,
        fdbd1=0,
        fdbd2=0,
        fe_lim=(min=0.0, max=0.0),
        P_lim=(min=0.0, max=0.0),
        T_g=0,
        D_dn=0,
        D_up=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ActiveRenewableSimple`](@ref) `bus_control`."""
get_bus_control(value::ActiveRenewableSimple) = value.bus_control
"""Get [`ActiveRenewableSimple`](@ref) `from_branch_control`."""
get_from_branch_control(value::ActiveRenewableSimple) = value.from_branch_control
"""Get [`ActiveRenewableSimple`](@ref) `to_branch_control`."""
get_to_branch_control(value::ActiveRenewableSimple) = value.to_branch_control
"""Get [`ActiveRenewableSimple`](@ref) `branch_id_control`."""
get_branch_id_control(value::ActiveRenewableSimple) = value.branch_id_control
"""Get [`ActiveRenewableSimple`](@ref) `Freq_Flag`."""
get_Freq_Flag(value::ActiveRenewableSimple) = value.Freq_Flag
"""Get [`ActiveRenewableSimple`](@ref) `K_pg`."""
get_K_pg(value::ActiveRenewableSimple) = value.K_pg
"""Get [`ActiveRenewableSimple`](@ref) `K_pi`."""
get_K_pi(value::ActiveRenewableSimple) = value.K_pi
"""Get [`ActiveRenewableSimple`](@ref) `T_p`."""
get_T_p(value::ActiveRenewableSimple) = value.T_p
"""Get [`ActiveRenewableSimple`](@ref) `fdbd1`."""
get_fdbd1(value::ActiveRenewableSimple) = value.fdbd1
"""Get [`ActiveRenewableSimple`](@ref) `fdbd2`."""
get_fdbd2(value::ActiveRenewableSimple) = value.fdbd2
"""Get [`ActiveRenewableSimple`](@ref) `fe_lim`."""
get_fe_lim(value::ActiveRenewableSimple) = value.fe_lim
"""Get [`ActiveRenewableSimple`](@ref) `P_lim`."""
get_P_lim(value::ActiveRenewableSimple) = value.P_lim
"""Get [`ActiveRenewableSimple`](@ref) `T_g`."""
get_T_g(value::ActiveRenewableSimple) = value.T_g
"""Get [`ActiveRenewableSimple`](@ref) `D_dn`."""
get_D_dn(value::ActiveRenewableSimple) = value.D_dn
"""Get [`ActiveRenewableSimple`](@ref) `D_up`."""
get_D_up(value::ActiveRenewableSimple) = value.D_up
"""Get [`ActiveRenewableSimple`](@ref) `P_ref`."""
get_P_ref(value::ActiveRenewableSimple) = value.P_ref
"""Get [`ActiveRenewableSimple`](@ref) `ext`."""
get_ext(value::ActiveRenewableSimple) = value.ext
"""Get [`ActiveRenewableSimple`](@ref) `states`."""
get_states(value::ActiveRenewableSimple) = value.states
"""Get [`ActiveRenewableSimple`](@ref) `n_states`."""
get_n_states(value::ActiveRenewableSimple) = value.n_states

"""Set [`ActiveRenewableSimple`](@ref) `bus_control`."""
set_bus_control!(value::ActiveRenewableSimple, val) = value.bus_control = val
"""Set [`ActiveRenewableSimple`](@ref) `from_branch_control`."""
set_from_branch_control!(value::ActiveRenewableSimple, val) = value.from_branch_control = val
"""Set [`ActiveRenewableSimple`](@ref) `to_branch_control`."""
set_to_branch_control!(value::ActiveRenewableSimple, val) = value.to_branch_control = val
"""Set [`ActiveRenewableSimple`](@ref) `branch_id_control`."""
set_branch_id_control!(value::ActiveRenewableSimple, val) = value.branch_id_control = val
"""Set [`ActiveRenewableSimple`](@ref) `Freq_Flag`."""
set_Freq_Flag!(value::ActiveRenewableSimple, val) = value.Freq_Flag = val
"""Set [`ActiveRenewableSimple`](@ref) `K_pg`."""
set_K_pg!(value::ActiveRenewableSimple, val) = value.K_pg = val
"""Set [`ActiveRenewableSimple`](@ref) `K_pi`."""
set_K_pi!(value::ActiveRenewableSimple, val) = value.K_pi = val
"""Set [`ActiveRenewableSimple`](@ref) `T_p`."""
set_T_p!(value::ActiveRenewableSimple, val) = value.T_p = val
"""Set [`ActiveRenewableSimple`](@ref) `fdbd1`."""
set_fdbd1!(value::ActiveRenewableSimple, val) = value.fdbd1 = val
"""Set [`ActiveRenewableSimple`](@ref) `fdbd2`."""
set_fdbd2!(value::ActiveRenewableSimple, val) = value.fdbd2 = val
"""Set [`ActiveRenewableSimple`](@ref) `fe_lim`."""
set_fe_lim!(value::ActiveRenewableSimple, val) = value.fe_lim = val
"""Set [`ActiveRenewableSimple`](@ref) `P_lim`."""
set_P_lim!(value::ActiveRenewableSimple, val) = value.P_lim = val
"""Set [`ActiveRenewableSimple`](@ref) `T_g`."""
set_T_g!(value::ActiveRenewableSimple, val) = value.T_g = val
"""Set [`ActiveRenewableSimple`](@ref) `D_dn`."""
set_D_dn!(value::ActiveRenewableSimple, val) = value.D_dn = val
"""Set [`ActiveRenewableSimple`](@ref) `D_up`."""
set_D_up!(value::ActiveRenewableSimple, val) = value.D_up = val
"""Set [`ActiveRenewableSimple`](@ref) `P_ref`."""
set_P_ref!(value::ActiveRenewableSimple, val) = value.P_ref = val
"""Set [`ActiveRenewableSimple`](@ref) `ext`."""
set_ext!(value::ActiveRenewableSimple, val) = value.ext = val

