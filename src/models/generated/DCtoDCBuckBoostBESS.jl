#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct DCtoDCBuckBoostBESS <: DCSource
        rated_voltage::Float64
        rated_current::Float64
        V_bat::Float64
        R_bat::Float64
        L_ind::Float64
        C_1::Float64
        C_2::Float64
        kp1::Float64
        ki1::Float64
        kp2::Float64
        ki2::Float64
        Il_lim::MinMax
        Vdc_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters for the DC-side with a Battery Energy Storage System from paper at https://ieeexplore.ieee.org/document/91665756

# Arguments
- `rated_voltage::Float64`: rated voltage, validation range: `(0, nothing)`
- `rated_current::Float64`: rated current, validation range: `(0, nothing)`
- `V_bat::Float64`: battery voltage, validation range: `(0, nothing)`
- `R_bat::Float64`: battery resistance, validation range: `(0, nothing)`
- `L_ind::Float64`: DC/DC inductance, validation range: `(0, nothing)`
- `C_1::Float64`: DC-link side capacitor, validation range: `(0, nothing)`
- `C_2::Float64`: Battery side capacitor, validation range: `(0, nothing)`
- `kp1::Float64`: DC-DC current controller proportional gain, validation range: `(0, nothing)`
- `ki1::Float64`: DC-DC current controller first integral gain, validation range: `(0, nothing)`
- `kp2::Float64`: DC-DC duty-cycle controller proportional gain, validation range: `(0, nothing)`
- `ki2::Float64`: DC-DC duty-cycle controller integral gain, validation range: `(0, nothing)`
- `Il_lim::MinMax`: Limit on inductor current for DC-DC controller
- `Vdc_ref::Float64`: Reference DC-Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ZeroOrderBESS model are:
	v_in: Voltage at battery bank terminals,
	v_dc: DC-link voltage,
	I_l: DC-side inductor current,
	ν: DC-DC first integrator state,
	ζ: DC-DC second integrator controller
- `n_states::Int`: DCtoDCBuckBoostBESS has 5 states
"""
mutable struct DCtoDCBuckBoostBESS <: DCSource
    "rated voltage"
    rated_voltage::Float64
    "rated current"
    rated_current::Float64
    "battery voltage"
    V_bat::Float64
    "battery resistance"
    R_bat::Float64
    "DC/DC inductance"
    L_ind::Float64
    "DC-link side capacitor"
    C_1::Float64
    "Battery side capacitor"
    C_2::Float64
    "DC-DC current controller proportional gain"
    kp1::Float64
    "DC-DC current controller first integral gain"
    ki1::Float64
    "DC-DC duty-cycle controller proportional gain"
    kp2::Float64
    "DC-DC duty-cycle controller integral gain"
    ki2::Float64
    "Limit on inductor current for DC-DC controller"
    Il_lim::MinMax
    "Reference DC-Voltage Set-point"
    Vdc_ref::Float64
    ext::Dict{String, Any}
    "The states of the ZeroOrderBESS model are:
	v_in: Voltage at battery bank terminals,
	v_dc: DC-link voltage,
	I_l: DC-side inductor current,
	ν: DC-DC first integrator state,
	ζ: DC-DC second integrator controller"
    states::Vector{Symbol}
    "DCtoDCBuckBoostBESS has 5 states"
    n_states::Int
end

function DCtoDCBuckBoostBESS(rated_voltage, rated_current, V_bat, R_bat, L_ind, C_1, C_2, kp1, ki1, kp2, ki2, Il_lim, Vdc_ref=1.1, ext=Dict{String, Any}(), )
    DCtoDCBuckBoostBESS(rated_voltage, rated_current, V_bat, R_bat, L_ind, C_1, C_2, kp1, ki1, kp2, ki2, Il_lim, Vdc_ref, ext, [:v_in, :v_dc, :I_l, :ν, :ζ], 5, )
end

function DCtoDCBuckBoostBESS(; rated_voltage, rated_current, V_bat, R_bat, L_ind, C_1, C_2, kp1, ki1, kp2, ki2, Il_lim, Vdc_ref=1.1, ext=Dict{String, Any}(), states=[:v_in, :v_dc, :I_l, :ν, :ζ], n_states=5, )
    DCtoDCBuckBoostBESS(rated_voltage, rated_current, V_bat, R_bat, L_ind, C_1, C_2, kp1, ki1, kp2, ki2, Il_lim, Vdc_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function DCtoDCBuckBoostBESS(::Nothing)
    DCtoDCBuckBoostBESS(;
        rated_voltage=0,
        rated_current=0,
        V_bat=0,
        R_bat=0,
        L_ind=0,
        C_1=0,
        C_2=0,
        kp1=0,
        ki1=0,
        kp2=0,
        ki2=0,
        Il_lim=(min=0.0, max=0.0),
        Vdc_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`DCtoDCBuckBoostBESS`](@ref) `rated_voltage`."""
get_rated_voltage(value::DCtoDCBuckBoostBESS) = value.rated_voltage
"""Get [`DCtoDCBuckBoostBESS`](@ref) `rated_current`."""
get_rated_current(value::DCtoDCBuckBoostBESS) = value.rated_current
"""Get [`DCtoDCBuckBoostBESS`](@ref) `V_bat`."""
get_V_bat(value::DCtoDCBuckBoostBESS) = value.V_bat
"""Get [`DCtoDCBuckBoostBESS`](@ref) `R_bat`."""
get_R_bat(value::DCtoDCBuckBoostBESS) = value.R_bat
"""Get [`DCtoDCBuckBoostBESS`](@ref) `L_ind`."""
get_L_ind(value::DCtoDCBuckBoostBESS) = value.L_ind
"""Get [`DCtoDCBuckBoostBESS`](@ref) `C_1`."""
get_C_1(value::DCtoDCBuckBoostBESS) = value.C_1
"""Get [`DCtoDCBuckBoostBESS`](@ref) `C_2`."""
get_C_2(value::DCtoDCBuckBoostBESS) = value.C_2
"""Get [`DCtoDCBuckBoostBESS`](@ref) `kp1`."""
get_kp1(value::DCtoDCBuckBoostBESS) = value.kp1
"""Get [`DCtoDCBuckBoostBESS`](@ref) `ki1`."""
get_ki1(value::DCtoDCBuckBoostBESS) = value.ki1
"""Get [`DCtoDCBuckBoostBESS`](@ref) `kp2`."""
get_kp2(value::DCtoDCBuckBoostBESS) = value.kp2
"""Get [`DCtoDCBuckBoostBESS`](@ref) `ki2`."""
get_ki2(value::DCtoDCBuckBoostBESS) = value.ki2
"""Get [`DCtoDCBuckBoostBESS`](@ref) `Il_lim`."""
get_Il_lim(value::DCtoDCBuckBoostBESS) = value.Il_lim
"""Get [`DCtoDCBuckBoostBESS`](@ref) `Vdc_ref`."""
get_Vdc_ref(value::DCtoDCBuckBoostBESS) = value.Vdc_ref
"""Get [`DCtoDCBuckBoostBESS`](@ref) `ext`."""
get_ext(value::DCtoDCBuckBoostBESS) = value.ext
"""Get [`DCtoDCBuckBoostBESS`](@ref) `states`."""
get_states(value::DCtoDCBuckBoostBESS) = value.states
"""Get [`DCtoDCBuckBoostBESS`](@ref) `n_states`."""
get_n_states(value::DCtoDCBuckBoostBESS) = value.n_states

"""Set [`DCtoDCBuckBoostBESS`](@ref) `rated_voltage`."""
set_rated_voltage!(value::DCtoDCBuckBoostBESS, val) = value.rated_voltage = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `rated_current`."""
set_rated_current!(value::DCtoDCBuckBoostBESS, val) = value.rated_current = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `V_bat`."""
set_V_bat!(value::DCtoDCBuckBoostBESS, val) = value.V_bat = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `R_bat`."""
set_R_bat!(value::DCtoDCBuckBoostBESS, val) = value.R_bat = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `L_ind`."""
set_L_ind!(value::DCtoDCBuckBoostBESS, val) = value.L_ind = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `C_1`."""
set_C_1!(value::DCtoDCBuckBoostBESS, val) = value.C_1 = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `C_2`."""
set_C_2!(value::DCtoDCBuckBoostBESS, val) = value.C_2 = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `kp1`."""
set_kp1!(value::DCtoDCBuckBoostBESS, val) = value.kp1 = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `ki1`."""
set_ki1!(value::DCtoDCBuckBoostBESS, val) = value.ki1 = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `kp2`."""
set_kp2!(value::DCtoDCBuckBoostBESS, val) = value.kp2 = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `ki2`."""
set_ki2!(value::DCtoDCBuckBoostBESS, val) = value.ki2 = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `Il_lim`."""
set_Il_lim!(value::DCtoDCBuckBoostBESS, val) = value.Il_lim = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `Vdc_ref`."""
set_Vdc_ref!(value::DCtoDCBuckBoostBESS, val) = value.Vdc_ref = val
"""Set [`DCtoDCBuckBoostBESS`](@ref) `ext`."""
set_ext!(value::DCtoDCBuckBoostBESS, val) = value.ext = val
