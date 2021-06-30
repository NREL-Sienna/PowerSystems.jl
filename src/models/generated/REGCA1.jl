#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct REGCA1 <: Converter
        Tg::Float64
        Rrpwr::Float64
        Brkpt::Float64
        Zerox::Float64
        Lvpl1::Float64
        Volim::Float64
        Lvpnt1::Float64
        Lvpnt0::Float64
        Iolim::Float64
        Tfltr::Float64
        Khv::Float64
        Iqrmax::Float64
        Iqrmin::Float64
        Accel::Float64
        Lvplsw::Int
        Qref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a renewable energy generator/converter model, this model corresponds to REGCA1 in PSSE

# Arguments
- `Tg::Float64`: Converter time constant (s), validation range: `(0, nothing)`
- `Rrpwr::Float64`: Low Voltage Power Logic (LVPL) ramp rate limit (pu/s), validation range: `(0, nothing)`
- `Brkpt::Float64`: LVPL characteristic voltage 2 (pu), validation range: `(0, nothing)`
- `Zerox::Float64`: LVPL characteristic voltage 1 (pu), validation range: `(0, nothing)`
- `Lvpl1::Float64`: LVPL gain (pu), validation range: `(0, nothing)`
- `Volim::Float64`: Voltage limit for high voltage reactive current management (pu), validation range: `(0, nothing)`
- `Lvpnt1::Float64`: High voltage point for low voltage active current management (pu), validation range: `(0, nothing)`
- `Lvpnt0::Float64`: Low voltage point for low voltage active current management (pu), validation range: `(0, nothing)`
- `Iolim::Float64`: Current limit (pu) for high voltage reactive current management (specified as a negative value), validation range: `(nothing, 0)`
- `Tfltr::Float64`: Voltage filter time constant for low voltage active current management (s), validation range: `(0, nothing)`
- `Khv::Float64`: Overvoltage compensation gain used in the high voltage reactive current management, validation range: `(0, nothing)`
- `Iqrmax::Float64`: Upper limit on rate of change for reactive current (pu/s), validation range: `(0, nothing)`
- `Iqrmin::Float64`: Lower limit on rate of change for reactive current (pu/s), validation range: `(0, nothing)`
- `Accel::Float64`: Acceleration factor, validation range: `(0, 1)`
- `Lvplsw::Int`: Low voltage power logic (LVPL) switch. (0: LVPL not present, 1: LVPL present), validation range: `(0, 1)`
- `Qref::Float64`: Initial machine reactive power from power flow, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:	Ip: Converter lag for Ipcmd,	Iq: Converter lag for Iqcmd,	Vmeas: Voltage filter for low voltage active current management
- `n_states::Int`: REGCA1 has 3 states
"""
mutable struct REGCA1 <: Converter
    "Converter time constant (s)"
    Tg::Float64
    "Low Voltage Power Logic (LVPL) ramp rate limit (pu/s)"
    Rrpwr::Float64
    "LVPL characteristic voltage 2 (pu)"
    Brkpt::Float64
    "LVPL characteristic voltage 1 (pu)"
    Zerox::Float64
    "LVPL gain (pu)"
    Lvpl1::Float64
    "Voltage limit for high voltage reactive current management (pu)"
    Volim::Float64
    "High voltage point for low voltage active current management (pu)"
    Lvpnt1::Float64
    "Low voltage point for low voltage active current management (pu)"
    Lvpnt0::Float64
    "Current limit (pu) for high voltage reactive current management (specified as a negative value)"
    Iolim::Float64
    "Voltage filter time constant for low voltage active current management (s)"
    Tfltr::Float64
    "Overvoltage compensation gain used in the high voltage reactive current management"
    Khv::Float64
    "Upper limit on rate of change for reactive current (pu/s)"
    Iqrmax::Float64
    "Lower limit on rate of change for reactive current (pu/s)"
    Iqrmin::Float64
    "Acceleration factor"
    Accel::Float64
    "Low voltage power logic (LVPL) switch. (0: LVPL not present, 1: LVPL present)"
    Lvplsw::Int
    "Initial machine reactive power from power flow"
    Qref::Float64
    ext::Dict{String, Any}
    "The states are:	Ip: Converter lag for Ipcmd,	Iq: Converter lag for Iqcmd,	Vmeas: Voltage filter for low voltage active current management"
    states::Vector{Symbol}
    "REGCA1 has 3 states"
    n_states::Int
end

function REGCA1(Tg, Rrpwr, Brkpt, Zerox, Lvpl1, Volim, Lvpnt1, Lvpnt0, Iolim, Tfltr, Khv, Iqrmax, Iqrmin, Accel, Lvplsw, Qref=1.0, ext=Dict{String, Any}(), )
    REGCA1(Tg, Rrpwr, Brkpt, Zerox, Lvpl1, Volim, Lvpnt1, Lvpnt0, Iolim, Tfltr, Khv, Iqrmax, Iqrmin, Accel, Lvplsw, Qref, ext, [:Ip, :Iq, :Vmeas], 3, )
end

function REGCA1(; Tg, Rrpwr, Brkpt, Zerox, Lvpl1, Volim, Lvpnt1, Lvpnt0, Iolim, Tfltr, Khv, Iqrmax, Iqrmin, Accel, Lvplsw, Qref=1.0, ext=Dict{String, Any}(), states=[:Ip, :Iq, :Vmeas], n_states=3, )
    REGCA1(Tg, Rrpwr, Brkpt, Zerox, Lvpl1, Volim, Lvpnt1, Lvpnt0, Iolim, Tfltr, Khv, Iqrmax, Iqrmin, Accel, Lvplsw, Qref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function REGCA1(::Nothing)
    REGCA1(;
        Tg=0,
        Rrpwr=0,
        Brkpt=0,
        Zerox=0,
        Lvpl1=0,
        Volim=0,
        Lvpnt1=0,
        Lvpnt0=0,
        Iolim=0,
        Tfltr=0,
        Khv=0,
        Iqrmax=0,
        Iqrmin=0,
        Accel=0,
        Lvplsw=0,
        Qref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`REGCA1`](@ref) `Tg`."""
get_Tg(value::REGCA1) = value.Tg
"""Get [`REGCA1`](@ref) `Rrpwr`."""
get_Rrpwr(value::REGCA1) = value.Rrpwr
"""Get [`REGCA1`](@ref) `Brkpt`."""
get_Brkpt(value::REGCA1) = value.Brkpt
"""Get [`REGCA1`](@ref) `Zerox`."""
get_Zerox(value::REGCA1) = value.Zerox
"""Get [`REGCA1`](@ref) `Lvpl1`."""
get_Lvpl1(value::REGCA1) = value.Lvpl1
"""Get [`REGCA1`](@ref) `Volim`."""
get_Volim(value::REGCA1) = value.Volim
"""Get [`REGCA1`](@ref) `Lvpnt1`."""
get_Lvpnt1(value::REGCA1) = value.Lvpnt1
"""Get [`REGCA1`](@ref) `Lvpnt0`."""
get_Lvpnt0(value::REGCA1) = value.Lvpnt0
"""Get [`REGCA1`](@ref) `Iolim`."""
get_Iolim(value::REGCA1) = value.Iolim
"""Get [`REGCA1`](@ref) `Tfltr`."""
get_Tfltr(value::REGCA1) = value.Tfltr
"""Get [`REGCA1`](@ref) `Khv`."""
get_Khv(value::REGCA1) = value.Khv
"""Get [`REGCA1`](@ref) `Iqrmax`."""
get_Iqrmax(value::REGCA1) = value.Iqrmax
"""Get [`REGCA1`](@ref) `Iqrmin`."""
get_Iqrmin(value::REGCA1) = value.Iqrmin
"""Get [`REGCA1`](@ref) `Accel`."""
get_Accel(value::REGCA1) = value.Accel
"""Get [`REGCA1`](@ref) `Lvplsw`."""
get_Lvplsw(value::REGCA1) = value.Lvplsw
"""Get [`REGCA1`](@ref) `Qref`."""
get_Qref(value::REGCA1) = value.Qref
"""Get [`REGCA1`](@ref) `ext`."""
get_ext(value::REGCA1) = value.ext
"""Get [`REGCA1`](@ref) `states`."""
get_states(value::REGCA1) = value.states
"""Get [`REGCA1`](@ref) `n_states`."""
get_n_states(value::REGCA1) = value.n_states

"""Set [`REGCA1`](@ref) `Tg`."""
set_Tg!(value::REGCA1, val) = value.Tg = val
"""Set [`REGCA1`](@ref) `Rrpwr`."""
set_Rrpwr!(value::REGCA1, val) = value.Rrpwr = val
"""Set [`REGCA1`](@ref) `Brkpt`."""
set_Brkpt!(value::REGCA1, val) = value.Brkpt = val
"""Set [`REGCA1`](@ref) `Zerox`."""
set_Zerox!(value::REGCA1, val) = value.Zerox = val
"""Set [`REGCA1`](@ref) `Lvpl1`."""
set_Lvpl1!(value::REGCA1, val) = value.Lvpl1 = val
"""Set [`REGCA1`](@ref) `Volim`."""
set_Volim!(value::REGCA1, val) = value.Volim = val
"""Set [`REGCA1`](@ref) `Lvpnt1`."""
set_Lvpnt1!(value::REGCA1, val) = value.Lvpnt1 = val
"""Set [`REGCA1`](@ref) `Lvpnt0`."""
set_Lvpnt0!(value::REGCA1, val) = value.Lvpnt0 = val
"""Set [`REGCA1`](@ref) `Iolim`."""
set_Iolim!(value::REGCA1, val) = value.Iolim = val
"""Set [`REGCA1`](@ref) `Tfltr`."""
set_Tfltr!(value::REGCA1, val) = value.Tfltr = val
"""Set [`REGCA1`](@ref) `Khv`."""
set_Khv!(value::REGCA1, val) = value.Khv = val
"""Set [`REGCA1`](@ref) `Iqrmax`."""
set_Iqrmax!(value::REGCA1, val) = value.Iqrmax = val
"""Set [`REGCA1`](@ref) `Iqrmin`."""
set_Iqrmin!(value::REGCA1, val) = value.Iqrmin = val
"""Set [`REGCA1`](@ref) `Accel`."""
set_Accel!(value::REGCA1, val) = value.Accel = val
"""Set [`REGCA1`](@ref) `Lvplsw`."""
set_Lvplsw!(value::REGCA1, val) = value.Lvplsw = val
"""Set [`REGCA1`](@ref) `Qref`."""
set_Qref!(value::REGCA1, val) = value.Qref = val
"""Set [`REGCA1`](@ref) `ext`."""
set_ext!(value::REGCA1, val) = value.ext = val

