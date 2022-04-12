#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableEnergyConverterTypeA <: Converter
        T_g::Float64
        Rrpwr::Float64
        Brkpt::Float64
        Zerox::Float64
        Lvpl1::Float64
        Vo_lim::Float64
        Lv_pnts::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Io_lim::Float64
        T_fltr::Float64
        K_hv::Float64
        Iqr_lims::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Accel::Float64
        Lvpl_sw::Int
        Q_ref::Float64
        R_source::Float64
        X_source::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a renewable energy generator/converter model, this model corresponds to REGCA1 in PSSE

# Arguments
- `T_g::Float64`: Converter time constant (s), validation range: `(0, nothing)`
- `Rrpwr::Float64`: Low Voltage Power Logic (LVPL) ramp rate limit (pu/s), validation range: `(0, nothing)`
- `Brkpt::Float64`: LVPL characteristic voltage 2 (pu), validation range: `(0, nothing)`
- `Zerox::Float64`: LVPL characteristic voltage 1 (pu), validation range: `(0, nothing)`
- `Lvpl1::Float64`: LVPL gain (pu), validation range: `(0, nothing)`
- `Vo_lim::Float64`: Voltage limit for high voltage reactive current management (pu), validation range: `(0, nothing)`
- `Lv_pnts::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Voltage points for low voltage active current management (pu) (Lvpnt0, Lvpnt1)
- `Io_lim::Float64`: Current limit (pu) for high voltage reactive current management (specified as a negative value), validation range: `(nothing, 0)`
- `T_fltr::Float64`: Voltage filter time constant for low voltage active current management (s), validation range: `(0, nothing)`
- `K_hv::Float64`: Overvoltage compensation gain used in the high voltage reactive current management, validation range: `(0, nothing)`
- `Iqr_lims::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Limit on rate of change for reactive current (pu/s) (Iqr_min, Iqr_max)
- `Accel::Float64`: Acceleration factor, validation range: `(0, 1)`
- `Lvpl_sw::Int`: Low voltage power logic (LVPL) switch. (0: LVPL not present, 1: LVPL present), validation range: `(0, 1)`
- `Q_ref::Float64`: Initial machine reactive power from power flow, validation range: `(0, nothing)`
- `R_source::Float64`: Output resistor used for the Thevenin Equivalent, validation range: `(0, nothing)`
- `X_source::Float64`: Output resistor used for the Thevenin Equivalent, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:	Ip: Converter lag for Ipcmd,	Iq: Converter lag for Iqcmd,	Vmeas: Voltage filter for low voltage active current management
- `n_states::Int`: RenewableEnergyConverterTypeA has 3 states
"""
mutable struct RenewableEnergyConverterTypeA <: Converter
    "Converter time constant (s)"
    T_g::Float64
    "Low Voltage Power Logic (LVPL) ramp rate limit (pu/s)"
    Rrpwr::Float64
    "LVPL characteristic voltage 2 (pu)"
    Brkpt::Float64
    "LVPL characteristic voltage 1 (pu)"
    Zerox::Float64
    "LVPL gain (pu)"
    Lvpl1::Float64
    "Voltage limit for high voltage reactive current management (pu)"
    Vo_lim::Float64
    "Voltage points for low voltage active current management (pu) (Lvpnt0, Lvpnt1)"
    Lv_pnts::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Current limit (pu) for high voltage reactive current management (specified as a negative value)"
    Io_lim::Float64
    "Voltage filter time constant for low voltage active current management (s)"
    T_fltr::Float64
    "Overvoltage compensation gain used in the high voltage reactive current management"
    K_hv::Float64
    "Limit on rate of change for reactive current (pu/s) (Iqr_min, Iqr_max)"
    Iqr_lims::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Acceleration factor"
    Accel::Float64
    "Low voltage power logic (LVPL) switch. (0: LVPL not present, 1: LVPL present)"
    Lvpl_sw::Int
    "Initial machine reactive power from power flow"
    Q_ref::Float64
    "Output resistor used for the Thevenin Equivalent"
    R_source::Float64
    "Output resistor used for the Thevenin Equivalent"
    X_source::Float64
    ext::Dict{String, Any}
    "The states are:	Ip: Converter lag for Ipcmd,	Iq: Converter lag for Iqcmd,	Vmeas: Voltage filter for low voltage active current management"
    states::Vector{Symbol}
    "RenewableEnergyConverterTypeA has 3 states"
    n_states::Int
end

function RenewableEnergyConverterTypeA(T_g, Rrpwr, Brkpt, Zerox, Lvpl1, Vo_lim, Lv_pnts, Io_lim, T_fltr, K_hv, Iqr_lims, Accel, Lvpl_sw, Q_ref=1.0, R_source=0.0, X_source=1.0e5, ext=Dict{String, Any}(), )
    RenewableEnergyConverterTypeA(T_g, Rrpwr, Brkpt, Zerox, Lvpl1, Vo_lim, Lv_pnts, Io_lim, T_fltr, K_hv, Iqr_lims, Accel, Lvpl_sw, Q_ref, R_source, X_source, ext, [:Ip, :Iq, :Vmeas], 3, )
end

function RenewableEnergyConverterTypeA(; T_g, Rrpwr, Brkpt, Zerox, Lvpl1, Vo_lim, Lv_pnts, Io_lim, T_fltr, K_hv, Iqr_lims, Accel, Lvpl_sw, Q_ref=1.0, R_source=0.0, X_source=1.0e5, ext=Dict{String, Any}(), states=[:Ip, :Iq, :Vmeas], n_states=3, )
    RenewableEnergyConverterTypeA(T_g, Rrpwr, Brkpt, Zerox, Lvpl1, Vo_lim, Lv_pnts, Io_lim, T_fltr, K_hv, Iqr_lims, Accel, Lvpl_sw, Q_ref, R_source, X_source, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function RenewableEnergyConverterTypeA(::Nothing)
    RenewableEnergyConverterTypeA(;
        T_g=0,
        Rrpwr=0,
        Brkpt=0,
        Zerox=0,
        Lvpl1=0,
        Vo_lim=0,
        Lv_pnts=(min=0.0, max=0.0),
        Io_lim=0,
        T_fltr=0,
        K_hv=0,
        Iqr_lims=(min=0.0, max=0.0),
        Accel=0,
        Lvpl_sw=0,
        Q_ref=0,
        R_source=0,
        X_source=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`RenewableEnergyConverterTypeA`](@ref) `T_g`."""
get_T_g(value::RenewableEnergyConverterTypeA) = value.T_g
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Rrpwr`."""
get_Rrpwr(value::RenewableEnergyConverterTypeA) = value.Rrpwr
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Brkpt`."""
get_Brkpt(value::RenewableEnergyConverterTypeA) = value.Brkpt
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Zerox`."""
get_Zerox(value::RenewableEnergyConverterTypeA) = value.Zerox
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Lvpl1`."""
get_Lvpl1(value::RenewableEnergyConverterTypeA) = value.Lvpl1
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Vo_lim`."""
get_Vo_lim(value::RenewableEnergyConverterTypeA) = value.Vo_lim
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Lv_pnts`."""
get_Lv_pnts(value::RenewableEnergyConverterTypeA) = value.Lv_pnts
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Io_lim`."""
get_Io_lim(value::RenewableEnergyConverterTypeA) = value.Io_lim
"""Get [`RenewableEnergyConverterTypeA`](@ref) `T_fltr`."""
get_T_fltr(value::RenewableEnergyConverterTypeA) = value.T_fltr
"""Get [`RenewableEnergyConverterTypeA`](@ref) `K_hv`."""
get_K_hv(value::RenewableEnergyConverterTypeA) = value.K_hv
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Iqr_lims`."""
get_Iqr_lims(value::RenewableEnergyConverterTypeA) = value.Iqr_lims
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Accel`."""
get_Accel(value::RenewableEnergyConverterTypeA) = value.Accel
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Lvpl_sw`."""
get_Lvpl_sw(value::RenewableEnergyConverterTypeA) = value.Lvpl_sw
"""Get [`RenewableEnergyConverterTypeA`](@ref) `Q_ref`."""
get_Q_ref(value::RenewableEnergyConverterTypeA) = value.Q_ref
"""Get [`RenewableEnergyConverterTypeA`](@ref) `R_source`."""
get_R_source(value::RenewableEnergyConverterTypeA) = value.R_source
"""Get [`RenewableEnergyConverterTypeA`](@ref) `X_source`."""
get_X_source(value::RenewableEnergyConverterTypeA) = value.X_source
"""Get [`RenewableEnergyConverterTypeA`](@ref) `ext`."""
get_ext(value::RenewableEnergyConverterTypeA) = value.ext
"""Get [`RenewableEnergyConverterTypeA`](@ref) `states`."""
get_states(value::RenewableEnergyConverterTypeA) = value.states
"""Get [`RenewableEnergyConverterTypeA`](@ref) `n_states`."""
get_n_states(value::RenewableEnergyConverterTypeA) = value.n_states

"""Set [`RenewableEnergyConverterTypeA`](@ref) `T_g`."""
set_T_g!(value::RenewableEnergyConverterTypeA, val) = value.T_g = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Rrpwr`."""
set_Rrpwr!(value::RenewableEnergyConverterTypeA, val) = value.Rrpwr = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Brkpt`."""
set_Brkpt!(value::RenewableEnergyConverterTypeA, val) = value.Brkpt = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Zerox`."""
set_Zerox!(value::RenewableEnergyConverterTypeA, val) = value.Zerox = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Lvpl1`."""
set_Lvpl1!(value::RenewableEnergyConverterTypeA, val) = value.Lvpl1 = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Vo_lim`."""
set_Vo_lim!(value::RenewableEnergyConverterTypeA, val) = value.Vo_lim = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Lv_pnts`."""
set_Lv_pnts!(value::RenewableEnergyConverterTypeA, val) = value.Lv_pnts = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Io_lim`."""
set_Io_lim!(value::RenewableEnergyConverterTypeA, val) = value.Io_lim = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `T_fltr`."""
set_T_fltr!(value::RenewableEnergyConverterTypeA, val) = value.T_fltr = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `K_hv`."""
set_K_hv!(value::RenewableEnergyConverterTypeA, val) = value.K_hv = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Iqr_lims`."""
set_Iqr_lims!(value::RenewableEnergyConverterTypeA, val) = value.Iqr_lims = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Accel`."""
set_Accel!(value::RenewableEnergyConverterTypeA, val) = value.Accel = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Lvpl_sw`."""
set_Lvpl_sw!(value::RenewableEnergyConverterTypeA, val) = value.Lvpl_sw = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `Q_ref`."""
set_Q_ref!(value::RenewableEnergyConverterTypeA, val) = value.Q_ref = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `R_source`."""
set_R_source!(value::RenewableEnergyConverterTypeA, val) = value.R_source = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `X_source`."""
set_X_source!(value::RenewableEnergyConverterTypeA, val) = value.X_source = val
"""Set [`RenewableEnergyConverterTypeA`](@ref) `ext`."""
set_ext!(value::RenewableEnergyConverterTypeA, val) = value.ext = val

