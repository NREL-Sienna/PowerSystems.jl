#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ZeroOrderBESS <: DCSource
        rated_voltage::Float64
        rated_current::Float64
        battery_voltage::Float64
        battery_resistance::Float64
        dc_dc_inductor::Float64
        dc_link_capacitance::Float64
        fs::Float64
        kpv::Float64
        kiv::Float64
        kpi::Float64
        kii::Float64
        Vdc_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters for the DC-side with a Battery Energy Storage System from paper at https://arxiv.org/abs/2007.11776

# Arguments
- `rated_voltage::Float64`: rated voltage, validation range: `(0, nothing)`
- `rated_current::Float64`: rated current, validation range: `(0, nothing)`
- `battery_voltage::Float64`: battery voltage, validation range: `(0, nothing)`
- `battery_resistance::Float64`: battery_resistance, validation range: `(0, nothing)`
- `dc_dc_inductor::Float64`: DC/DC inductance, validation range: `(0, nothing)`
- `dc_link_capacitance::Float64`: DC-link capacitor, validation range: `(0, nothing)`
- `fs::Float64`: DC/DC converter switching frequency, validation range: `(0, nothing)`
- `kpv::Float64`: voltage controller proportional gain, validation range: `(0, nothing)`
- `kiv::Float64`: voltage controller integral gain, validation range: `(0, nothing)`
- `kpi::Float64`: current controller proportional gain, validation range: `(0, nothing)`
- `kii::Float64`: current controller integral gain, validation range: `(0, nothing)`
- `Vdc_ref::Float64`: Reference DC-Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ZeroOrderBESS model are:
	v_dc: DC-link votlage,
	i_b: Battery current,
	 ν: integrator state of the voltage controller,
	 ζ: integrator state of the PI current controller
- `n_states::Int`: ZeroOrderBESS has 4 states
"""
mutable struct ZeroOrderBESS <: DCSource
    "rated voltage"
    rated_voltage::Float64
    "rated current"
    rated_current::Float64
    "battery voltage"
    battery_voltage::Float64
    "battery_resistance"
    battery_resistance::Float64
    "DC/DC inductance"
    dc_dc_inductor::Float64
    "DC-link capacitor"
    dc_link_capacitance::Float64
    "DC/DC converter switching frequency"
    fs::Float64
    "voltage controller proportional gain"
    kpv::Float64
    "voltage controller integral gain"
    kiv::Float64
    "current controller proportional gain"
    kpi::Float64
    "current controller integral gain"
    kii::Float64
    "Reference DC-Voltage Set-point"
    Vdc_ref::Float64
    ext::Dict{String, Any}
    "The states of the ZeroOrderBESS model are:
	v_dc: DC-link votlage,
	i_b: Battery current,
	 ν: integrator state of the voltage controller,
	 ζ: integrator state of the PI current controller"
    states::Vector{Symbol}
    "ZeroOrderBESS has 4 states"
    n_states::Int
end

function ZeroOrderBESS(rated_voltage, rated_current, battery_voltage, battery_resistance, dc_dc_inductor, dc_link_capacitance, fs, kpv, kiv, kpi, kii, Vdc_ref=1.1, ext=Dict{String, Any}(), )
    ZeroOrderBESS(rated_voltage, rated_current, battery_voltage, battery_resistance, dc_dc_inductor, dc_link_capacitance, fs, kpv, kiv, kpi, kii, Vdc_ref, ext, [:v_dc, :i_b, :ν, :ζ], 4, )
end

function ZeroOrderBESS(; rated_voltage, rated_current, battery_voltage, battery_resistance, dc_dc_inductor, dc_link_capacitance, fs, kpv, kiv, kpi, kii, Vdc_ref=1.1, ext=Dict{String, Any}(), states=[:v_dc, :i_b, :ν, :ζ], n_states=4, )
    ZeroOrderBESS(rated_voltage, rated_current, battery_voltage, battery_resistance, dc_dc_inductor, dc_link_capacitance, fs, kpv, kiv, kpi, kii, Vdc_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ZeroOrderBESS(::Nothing)
    ZeroOrderBESS(;
        rated_voltage=0,
        rated_current=0,
        battery_voltage=0,
        battery_resistance=0,
        dc_dc_inductor=0,
        dc_link_capacitance=0,
        fs=0,
        kpv=0,
        kiv=0,
        kpi=0,
        kii=0,
        Vdc_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ZeroOrderBESS`](@ref) `rated_voltage`."""
get_rated_voltage(value::ZeroOrderBESS) = value.rated_voltage
"""Get [`ZeroOrderBESS`](@ref) `rated_current`."""
get_rated_current(value::ZeroOrderBESS) = value.rated_current
"""Get [`ZeroOrderBESS`](@ref) `battery_voltage`."""
get_battery_voltage(value::ZeroOrderBESS) = value.battery_voltage
"""Get [`ZeroOrderBESS`](@ref) `battery_resistance`."""
get_battery_resistance(value::ZeroOrderBESS) = value.battery_resistance
"""Get [`ZeroOrderBESS`](@ref) `dc_dc_inductor`."""
get_dc_dc_inductor(value::ZeroOrderBESS) = value.dc_dc_inductor
"""Get [`ZeroOrderBESS`](@ref) `dc_link_capacitance`."""
get_dc_link_capacitance(value::ZeroOrderBESS) = value.dc_link_capacitance
"""Get [`ZeroOrderBESS`](@ref) `fs`."""
get_fs(value::ZeroOrderBESS) = value.fs
"""Get [`ZeroOrderBESS`](@ref) `kpv`."""
get_kpv(value::ZeroOrderBESS) = value.kpv
"""Get [`ZeroOrderBESS`](@ref) `kiv`."""
get_kiv(value::ZeroOrderBESS) = value.kiv
"""Get [`ZeroOrderBESS`](@ref) `kpi`."""
get_kpi(value::ZeroOrderBESS) = value.kpi
"""Get [`ZeroOrderBESS`](@ref) `kii`."""
get_kii(value::ZeroOrderBESS) = value.kii
"""Get [`ZeroOrderBESS`](@ref) `Vdc_ref`."""
get_Vdc_ref(value::ZeroOrderBESS) = value.Vdc_ref
"""Get [`ZeroOrderBESS`](@ref) `ext`."""
get_ext(value::ZeroOrderBESS) = value.ext
"""Get [`ZeroOrderBESS`](@ref) `states`."""
get_states(value::ZeroOrderBESS) = value.states
"""Get [`ZeroOrderBESS`](@ref) `n_states`."""
get_n_states(value::ZeroOrderBESS) = value.n_states

"""Set [`ZeroOrderBESS`](@ref) `rated_voltage`."""
set_rated_voltage!(value::ZeroOrderBESS, val) = value.rated_voltage = val
"""Set [`ZeroOrderBESS`](@ref) `rated_current`."""
set_rated_current!(value::ZeroOrderBESS, val) = value.rated_current = val
"""Set [`ZeroOrderBESS`](@ref) `battery_voltage`."""
set_battery_voltage!(value::ZeroOrderBESS, val) = value.battery_voltage = val
"""Set [`ZeroOrderBESS`](@ref) `battery_resistance`."""
set_battery_resistance!(value::ZeroOrderBESS, val) = value.battery_resistance = val
"""Set [`ZeroOrderBESS`](@ref) `dc_dc_inductor`."""
set_dc_dc_inductor!(value::ZeroOrderBESS, val) = value.dc_dc_inductor = val
"""Set [`ZeroOrderBESS`](@ref) `dc_link_capacitance`."""
set_dc_link_capacitance!(value::ZeroOrderBESS, val) = value.dc_link_capacitance = val
"""Set [`ZeroOrderBESS`](@ref) `fs`."""
set_fs!(value::ZeroOrderBESS, val) = value.fs = val
"""Set [`ZeroOrderBESS`](@ref) `kpv`."""
set_kpv!(value::ZeroOrderBESS, val) = value.kpv = val
"""Set [`ZeroOrderBESS`](@ref) `kiv`."""
set_kiv!(value::ZeroOrderBESS, val) = value.kiv = val
"""Set [`ZeroOrderBESS`](@ref) `kpi`."""
set_kpi!(value::ZeroOrderBESS, val) = value.kpi = val
"""Set [`ZeroOrderBESS`](@ref) `kii`."""
set_kii!(value::ZeroOrderBESS, val) = value.kii = val
"""Set [`ZeroOrderBESS`](@ref) `Vdc_ref`."""
set_Vdc_ref!(value::ZeroOrderBESS, val) = value.Vdc_ref = val
"""Set [`ZeroOrderBESS`](@ref) `ext`."""
set_ext!(value::ZeroOrderBESS, val) = value.ext = val
