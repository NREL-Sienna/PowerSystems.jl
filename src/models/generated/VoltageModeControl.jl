#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct VoltageModeControl <: InnerControl
        kpv::Float64
        kiv::Float64
        kffv::Float64
        rv::Float64
        lv::Float64
        kpc::Float64
        kic::Float64
        kffi::Float64
        ωad::Float64
        kad::Float64
        I_lim_type::Float64
        I_max::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of an inner loop current control PID using virtual impedance based on D'Arco, Suul and Fosso.
"A Virtual Synchronous Machine implementation for distributed control of power converters in SmartGrids."
Electric Power Systems Research 122 (2015) 180–197.

# Arguments
- `kpv::Float64`: voltage controller proportional gain, validation range: `(0, nothing)`
- `kiv::Float64`: voltage controller integral gain, validation range: `(0, nothing)`
- `kffv::Float64`: Binary variable to enable feed-forward gain of voltage., validation range: `(0, nothing)`
- `rv::Float64`: virtual resistance, validation range: `(0, nothing)`
- `lv::Float64`: virtual inductance, validation range: `(0, nothing)`
- `kpc::Float64`: current controller proportional gain, validation range: `(0, nothing)`
- `kic::Float64`: current controller integral gain, validation range: `(0, nothing)`
- `kffi::Float64`: Binary variable to enable feed-forward gain of current, validation range: `(0, nothing)`
- `ωad::Float64`: active damping filter cutoff frequency (rad/sec), validation range: `(0, nothing)`
- `kad::Float64`: active damping gain, validation range: `(0, nothing)`
- `I_lim_type::Float64`: Set current limiting method: 0.0 - none, 1.0 - instananeous, 2.0 - magnitude, validation range: `(0, 2)`
- `I_max::Float64`: Allowed current., validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the VoltageModeControl model are:
	ξd_ic: d-axis integrator state of the PI voltage controller,
	ξq_ic: q-axis integrator state of the PI voltage controller,
	γd_ic: d-axis integrator state of the PI current controller,
	γq_ic: q-axis integrator state of the PI current controller,
	ϕd_ic: d-axis low-pass filter of active damping,
	ϕq_ic: q-axis low-pass filter of active damping
- `n_states::Int`: VoltageModeControl has 6 states
"""
mutable struct VoltageModeControl <: InnerControl
    "voltage controller proportional gain"
    kpv::Float64
    "voltage controller integral gain"
    kiv::Float64
    "Binary variable to enable feed-forward gain of voltage."
    kffv::Float64
    "virtual resistance"
    rv::Float64
    "virtual inductance"
    lv::Float64
    "current controller proportional gain"
    kpc::Float64
    "current controller integral gain"
    kic::Float64
    "Binary variable to enable feed-forward gain of current"
    kffi::Float64
    "active damping filter cutoff frequency (rad/sec)"
    ωad::Float64
    "active damping gain"
    kad::Float64
    "Set current limiting method: 0.0 - none, 1.0 - instananeous, 2.0 - magnitude"
    I_lim_type::Float64
    "Allowed current."
    I_max::Float64
    ext::Dict{String, Any}
    "The states of the VoltageModeControl model are:
	ξd_ic: d-axis integrator state of the PI voltage controller,
	ξq_ic: q-axis integrator state of the PI voltage controller,
	γd_ic: d-axis integrator state of the PI current controller,
	γq_ic: q-axis integrator state of the PI current controller,
	ϕd_ic: d-axis low-pass filter of active damping,
	ϕq_ic: q-axis low-pass filter of active damping"
    states::Vector{Symbol}
    "VoltageModeControl has 6 states"
    n_states::Int
end

function VoltageModeControl(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, I_lim_type=0.0, I_max=10.0, ext=Dict{String, Any}(), )
    VoltageModeControl(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, I_lim_type, I_max, ext, [:ξd_ic, :ξq_ic, :γd_ic, :γq_ic, :ϕd_ic, :ϕq_ic], 6, )
end

function VoltageModeControl(; kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, I_lim_type=0.0, I_max=10.0, ext=Dict{String, Any}(), states=[:ξd_ic, :ξq_ic, :γd_ic, :γq_ic, :ϕd_ic, :ϕq_ic], n_states=6, )
    VoltageModeControl(kpv, kiv, kffv, rv, lv, kpc, kic, kffi, ωad, kad, I_lim_type, I_max, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function VoltageModeControl(::Nothing)
    VoltageModeControl(;
        kpv=0,
        kiv=0,
        kffv=0,
        rv=0,
        lv=0,
        kpc=0,
        kic=0,
        kffi=0,
        ωad=0,
        kad=0,
        I_lim_type=0,
        I_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`VoltageModeControl`](@ref) `kpv`."""
get_kpv(value::VoltageModeControl) = value.kpv
"""Get [`VoltageModeControl`](@ref) `kiv`."""
get_kiv(value::VoltageModeControl) = value.kiv
"""Get [`VoltageModeControl`](@ref) `kffv`."""
get_kffv(value::VoltageModeControl) = value.kffv
"""Get [`VoltageModeControl`](@ref) `rv`."""
get_rv(value::VoltageModeControl) = value.rv
"""Get [`VoltageModeControl`](@ref) `lv`."""
get_lv(value::VoltageModeControl) = value.lv
"""Get [`VoltageModeControl`](@ref) `kpc`."""
get_kpc(value::VoltageModeControl) = value.kpc
"""Get [`VoltageModeControl`](@ref) `kic`."""
get_kic(value::VoltageModeControl) = value.kic
"""Get [`VoltageModeControl`](@ref) `kffi`."""
get_kffi(value::VoltageModeControl) = value.kffi
"""Get [`VoltageModeControl`](@ref) `ωad`."""
get_ωad(value::VoltageModeControl) = value.ωad
"""Get [`VoltageModeControl`](@ref) `kad`."""
get_kad(value::VoltageModeControl) = value.kad
"""Get [`VoltageModeControl`](@ref) `I_lim_type`."""
get_I_lim_type(value::VoltageModeControl) = value.I_lim_type
"""Get [`VoltageModeControl`](@ref) `I_max`."""
get_I_max(value::VoltageModeControl) = value.I_max
"""Get [`VoltageModeControl`](@ref) `ext`."""
get_ext(value::VoltageModeControl) = value.ext
"""Get [`VoltageModeControl`](@ref) `states`."""
get_states(value::VoltageModeControl) = value.states
"""Get [`VoltageModeControl`](@ref) `n_states`."""
get_n_states(value::VoltageModeControl) = value.n_states

"""Set [`VoltageModeControl`](@ref) `kpv`."""
set_kpv!(value::VoltageModeControl, val) = value.kpv = val
"""Set [`VoltageModeControl`](@ref) `kiv`."""
set_kiv!(value::VoltageModeControl, val) = value.kiv = val
"""Set [`VoltageModeControl`](@ref) `kffv`."""
set_kffv!(value::VoltageModeControl, val) = value.kffv = val
"""Set [`VoltageModeControl`](@ref) `rv`."""
set_rv!(value::VoltageModeControl, val) = value.rv = val
"""Set [`VoltageModeControl`](@ref) `lv`."""
set_lv!(value::VoltageModeControl, val) = value.lv = val
"""Set [`VoltageModeControl`](@ref) `kpc`."""
set_kpc!(value::VoltageModeControl, val) = value.kpc = val
"""Set [`VoltageModeControl`](@ref) `kic`."""
set_kic!(value::VoltageModeControl, val) = value.kic = val
"""Set [`VoltageModeControl`](@ref) `kffi`."""
set_kffi!(value::VoltageModeControl, val) = value.kffi = val
"""Set [`VoltageModeControl`](@ref) `ωad`."""
set_ωad!(value::VoltageModeControl, val) = value.ωad = val
"""Set [`VoltageModeControl`](@ref) `kad`."""
set_kad!(value::VoltageModeControl, val) = value.kad = val
"""Set [`VoltageModeControl`](@ref) `I_lim_type`."""
set_I_lim_type!(value::VoltageModeControl, val) = value.I_lim_type = val
"""Set [`VoltageModeControl`](@ref) `I_max`."""
set_I_max!(value::VoltageModeControl, val) = value.I_max = val
"""Set [`VoltageModeControl`](@ref) `ext`."""
set_ext!(value::VoltageModeControl, val) = value.ext = val
