#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ActiveConstantPowerLoad <: DynamicInjection
        name::String
        r_load::Float64
        c_dc::Float64
        rf::Float64
        lf::Float64
        cf::Float64
        rg::Float64
        lg::Float64
        kp_pll::Float64
        ki_pll::Float64
        kpv::Float64
        kiv::Float64
        kpc::Float64
        kic::Float64
        ext::Dict{String, Any}
        V_ref::Float64
        ω_ref::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of x-states active power load based on the paper Dynamic Stability of a Microgrid With an Active Load from N. Bottrell, M. Prodanovic and T. Green in IEEE Transactions on Power Electronics, 2013.

# Arguments
- `name::String`
- `r_load::Float64`: DC-side resistor, validation range: `(0, nothing)`
- `c_dc::Float64`: DC-side capacitor, validation range: `(0, nothing)`
- `rf::Float64`: Converter side filter resistance, validation range: `(0, nothing)`
- `lf::Float64`: Converter side filter inductance, validation range: `(0, nothing)`
- `cf::Float64`: AC Converter filter capacitance, validation range: `(0, nothing)`
- `rg::Float64`: Network side filter resistance, validation range: `(0, nothing)`
- `lg::Float64`: Network side filter inductance, validation range: `(0, nothing)`
- `kp_pll::Float64`: Proportional constant for PI-PLL block, validation range: `(0, nothing)`
- `ki_pll::Float64`: Integral constant for PI-PLL block, validation range: `(0, nothing)`
- `kpv::Float64`: Proportional constant for Voltage Control block, validation range: `(0, nothing)`
- `kiv::Float64`: Integral constant for Voltage Control block, validation range: `(0, nothing)`
- `kpc::Float64`: Proportional constant for Current Control block, validation range: `(0, nothing)`
- `kic::Float64`: Integral constant for Current Control block, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `V_ref::Float64`: Reference torque parameter
- `ω_ref::Float64`: Susceptance Initialization Corrector Term
- `states::Vector{Symbol}`: The states are:
	θ_pll: PLL deviation angle, 
	ϵ_pll: PLL integrator state, 
	η: DC-voltage controller integrator state, 
	γd: d-axis Current controller integrator state, 
	γq: q-axis Current controller integrator state, 
	ir_cnv: Real current out of the converter,
	ii_cnv: Imaginary current out of the converter,
	vr_filter: Real voltage at the filter's capacitor,
	vi_filter: Imaginary voltage at the filter's capacitor,
	ir_filter: Real current out of the filter,
	ii_filter: Imaginary current out of the filter
- `n_states::Int`: ActiveConstantPowerLoad has 11 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ActiveConstantPowerLoad <: DynamicInjection
    name::String
    "DC-side resistor"
    r_load::Float64
    "DC-side capacitor"
    c_dc::Float64
    "Converter side filter resistance"
    rf::Float64
    "Converter side filter inductance"
    lf::Float64
    "AC Converter filter capacitance"
    cf::Float64
    "Network side filter resistance"
    rg::Float64
    "Network side filter inductance"
    lg::Float64
    "Proportional constant for PI-PLL block"
    kp_pll::Float64
    "Integral constant for PI-PLL block"
    ki_pll::Float64
    "Proportional constant for Voltage Control block"
    kpv::Float64
    "Integral constant for Voltage Control block"
    kiv::Float64
    "Proportional constant for Current Control block"
    kpc::Float64
    "Integral constant for Current Control block"
    kic::Float64
    ext::Dict{String, Any}
    "Reference torque parameter"
    V_ref::Float64
    "Susceptance Initialization Corrector Term"
    ω_ref::Float64
    "The states are:
	θ_pll: PLL deviation angle, 
	ϵ_pll: PLL integrator state, 
	η: DC-voltage controller integrator state, 
	γd: d-axis Current controller integrator state, 
	γq: q-axis Current controller integrator state, 
	ir_cnv: Real current out of the converter,
	ii_cnv: Imaginary current out of the converter,
	vr_filter: Real voltage at the filter's capacitor,
	vi_filter: Imaginary voltage at the filter's capacitor,
	ir_filter: Real current out of the filter,
	ii_filter: Imaginary current out of the filter"
    states::Vector{Symbol}
    "ActiveConstantPowerLoad has 11 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ActiveConstantPowerLoad(name, r_load, c_dc, rf, lf, cf, rg, lg, kp_pll, ki_pll, kpv, kiv, kpc, kic, ext=Dict{String, Any}(), )
    ActiveConstantPowerLoad(name, r_load, c_dc, rf, lf, cf, rg, lg, kp_pll, ki_pll, kpv, kiv, kpc, kic, ext, 1.0, 1.0, [:θ_pll, ϵ_pll, :η, :γd, :γq, :ir_cnv, :ii_cnv, :vr_filter, :vi_filter, :ir_filter, :ii_filter], 11, InfrastructureSystemsInternal(), )
end

function ActiveConstantPowerLoad(; name, r_load, c_dc, rf, lf, cf, rg, lg, kp_pll, ki_pll, kpv, kiv, kpc, kic, ext=Dict{String, Any}(), V_ref=1.0, ω_ref=1.0, states=[:θ_pll, ϵ_pll, :η, :γd, :γq, :ir_cnv, :ii_cnv, :vr_filter, :vi_filter, :ir_filter, :ii_filter], n_states=11, internal=InfrastructureSystemsInternal(), )
    ActiveConstantPowerLoad(name, r_load, c_dc, rf, lf, cf, rg, lg, kp_pll, ki_pll, kpv, kiv, kpc, kic, ext, V_ref, ω_ref, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function ActiveConstantPowerLoad(::Nothing)
    ActiveConstantPowerLoad(;
        name="init",
        r_load=0,
        c_dc=0,
        rf=0,
        lf=0,
        cf=0,
        rg=0,
        lg=0,
        kp_pll=0,
        ki_pll=0,
        kpv=0,
        kiv=0,
        kpc=0,
        kic=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ActiveConstantPowerLoad`](@ref) `name`."""
get_name(value::ActiveConstantPowerLoad) = value.name
"""Get [`ActiveConstantPowerLoad`](@ref) `r_load`."""
get_r_load(value::ActiveConstantPowerLoad) = value.r_load
"""Get [`ActiveConstantPowerLoad`](@ref) `c_dc`."""
get_c_dc(value::ActiveConstantPowerLoad) = value.c_dc
"""Get [`ActiveConstantPowerLoad`](@ref) `rf`."""
get_rf(value::ActiveConstantPowerLoad) = value.rf
"""Get [`ActiveConstantPowerLoad`](@ref) `lf`."""
get_lf(value::ActiveConstantPowerLoad) = value.lf
"""Get [`ActiveConstantPowerLoad`](@ref) `cf`."""
get_cf(value::ActiveConstantPowerLoad) = value.cf
"""Get [`ActiveConstantPowerLoad`](@ref) `rg`."""
get_rg(value::ActiveConstantPowerLoad) = value.rg
"""Get [`ActiveConstantPowerLoad`](@ref) `lg`."""
get_lg(value::ActiveConstantPowerLoad) = value.lg
"""Get [`ActiveConstantPowerLoad`](@ref) `kp_pll`."""
get_kp_pll(value::ActiveConstantPowerLoad) = value.kp_pll
"""Get [`ActiveConstantPowerLoad`](@ref) `ki_pll`."""
get_ki_pll(value::ActiveConstantPowerLoad) = value.ki_pll
"""Get [`ActiveConstantPowerLoad`](@ref) `kpv`."""
get_kpv(value::ActiveConstantPowerLoad) = value.kpv
"""Get [`ActiveConstantPowerLoad`](@ref) `kiv`."""
get_kiv(value::ActiveConstantPowerLoad) = value.kiv
"""Get [`ActiveConstantPowerLoad`](@ref) `kpc`."""
get_kpc(value::ActiveConstantPowerLoad) = value.kpc
"""Get [`ActiveConstantPowerLoad`](@ref) `kic`."""
get_kic(value::ActiveConstantPowerLoad) = value.kic
"""Get [`ActiveConstantPowerLoad`](@ref) `ext`."""
get_ext(value::ActiveConstantPowerLoad) = value.ext
"""Get [`ActiveConstantPowerLoad`](@ref) `V_ref`."""
get_V_ref(value::ActiveConstantPowerLoad) = value.V_ref
"""Get [`ActiveConstantPowerLoad`](@ref) `ω_ref`."""
get_ω_ref(value::ActiveConstantPowerLoad) = value.ω_ref
"""Get [`ActiveConstantPowerLoad`](@ref) `states`."""
get_states(value::ActiveConstantPowerLoad) = value.states
"""Get [`ActiveConstantPowerLoad`](@ref) `n_states`."""
get_n_states(value::ActiveConstantPowerLoad) = value.n_states
"""Get [`ActiveConstantPowerLoad`](@ref) `internal`."""
get_internal(value::ActiveConstantPowerLoad) = value.internal

"""Set [`ActiveConstantPowerLoad`](@ref) `r_load`."""
set_r_load!(value::ActiveConstantPowerLoad, val) = value.r_load = val
"""Set [`ActiveConstantPowerLoad`](@ref) `c_dc`."""
set_c_dc!(value::ActiveConstantPowerLoad, val) = value.c_dc = val
"""Set [`ActiveConstantPowerLoad`](@ref) `rf`."""
set_rf!(value::ActiveConstantPowerLoad, val) = value.rf = val
"""Set [`ActiveConstantPowerLoad`](@ref) `lf`."""
set_lf!(value::ActiveConstantPowerLoad, val) = value.lf = val
"""Set [`ActiveConstantPowerLoad`](@ref) `cf`."""
set_cf!(value::ActiveConstantPowerLoad, val) = value.cf = val
"""Set [`ActiveConstantPowerLoad`](@ref) `rg`."""
set_rg!(value::ActiveConstantPowerLoad, val) = value.rg = val
"""Set [`ActiveConstantPowerLoad`](@ref) `lg`."""
set_lg!(value::ActiveConstantPowerLoad, val) = value.lg = val
"""Set [`ActiveConstantPowerLoad`](@ref) `kp_pll`."""
set_kp_pll!(value::ActiveConstantPowerLoad, val) = value.kp_pll = val
"""Set [`ActiveConstantPowerLoad`](@ref) `ki_pll`."""
set_ki_pll!(value::ActiveConstantPowerLoad, val) = value.ki_pll = val
"""Set [`ActiveConstantPowerLoad`](@ref) `kpv`."""
set_kpv!(value::ActiveConstantPowerLoad, val) = value.kpv = val
"""Set [`ActiveConstantPowerLoad`](@ref) `kiv`."""
set_kiv!(value::ActiveConstantPowerLoad, val) = value.kiv = val
"""Set [`ActiveConstantPowerLoad`](@ref) `kpc`."""
set_kpc!(value::ActiveConstantPowerLoad, val) = value.kpc = val
"""Set [`ActiveConstantPowerLoad`](@ref) `kic`."""
set_kic!(value::ActiveConstantPowerLoad, val) = value.kic = val
"""Set [`ActiveConstantPowerLoad`](@ref) `ext`."""
set_ext!(value::ActiveConstantPowerLoad, val) = value.ext = val
"""Set [`ActiveConstantPowerLoad`](@ref) `V_ref`."""
set_V_ref!(value::ActiveConstantPowerLoad, val) = value.V_ref = val
"""Set [`ActiveConstantPowerLoad`](@ref) `ω_ref`."""
set_ω_ref!(value::ActiveConstantPowerLoad, val) = value.ω_ref = val
