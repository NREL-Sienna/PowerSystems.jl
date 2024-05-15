#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct CSVGN1 <: DynamicInjection
        name::String
        K::Float64
        T1::Float64
        T2::Float64
        T3::Float64
        T4::Float64
        T5::Float64
        Rmin::Float64
        Vmax::Float64
        Vmin::Float64
        CBase::Float64
        base_power::Float64
        ext::Dict{String, Any}
        R_th::Float64
        X_th::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of static shunt compensator: CSVGN1 in PSSE

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `K::Float64`: Gain in pu, validation range: `(0, nothing)`
- `T1::Float64`: Time constant in s, validation range: `(0, nothing)`
- `T2::Float64`: Time constant in s, validation range: `(0, nothing)`
- `T3::Float64`: Time constant in s, validation range: `(eps(), nothing)`
- `T4::Float64`: Time constant in s, validation range: `(0, nothing)`
- `T5::Float64`: Time constant in s, validation range: `(0, nothing)`
- `Rmin::Float64`: Reactor minimum Mvar, validation range: `(0, nothing)`
- `Vmax::Float64`: Maximum voltage in pu, validation range: `(0, nothing)`
- `Vmin::Float64`: Minimum voltage in pu, validation range: `(0, nothing)`
- `CBase::Float64`: Capacitor Mvar, validation range: `(0, nothing)`
- `base_power::Float64`: Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`., validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `R_th::Float64`: Source Thevenin resistance
- `X_th::Float64`: Source Thevenin reactance
- `states::Vector{Symbol}`: The states are:
	thy: thyristor,
	vr1: regulator output 1,
	vr2: regulator output 2
- `n_states::Int`: CSVGN1 has 3 states
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct CSVGN1 <: DynamicInjection
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Gain in pu"
    K::Float64
    "Time constant in s"
    T1::Float64
    "Time constant in s"
    T2::Float64
    "Time constant in s"
    T3::Float64
    "Time constant in s"
    T4::Float64
    "Time constant in s"
    T5::Float64
    "Reactor minimum Mvar"
    Rmin::Float64
    "Maximum voltage in pu"
    Vmax::Float64
    "Minimum voltage in pu"
    Vmin::Float64
    "Capacitor Mvar"
    CBase::Float64
    "Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`."
    base_power::Float64
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "Source Thevenin resistance"
    R_th::Float64
    "Source Thevenin reactance"
    X_th::Float64
    "The states are:
	thy: thyristor,
	vr1: regulator output 1,
	vr2: regulator output 2"
    states::Vector{Symbol}
    "CSVGN1 has 3 states"
    n_states::Int
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function CSVGN1(name, K, T1, T2, T3, T4, T5, Rmin, Vmax, Vmin, CBase, base_power, ext=Dict{String, Any}(), )
    CSVGN1(name, K, T1, T2, T3, T4, T5, Rmin, Vmax, Vmin, CBase, base_power, ext, 0.0, 0.0, [:thy, :vr1, :vr2], 3, InfrastructureSystemsInternal(), )
end

function CSVGN1(; name, K, T1, T2, T3, T4, T5, Rmin, Vmax, Vmin, CBase, base_power, ext=Dict{String, Any}(), R_th=0.0, X_th=0.0, states=[:thy, :vr1, :vr2], n_states=3, internal=InfrastructureSystemsInternal(), )
    CSVGN1(name, K, T1, T2, T3, T4, T5, Rmin, Vmax, Vmin, CBase, base_power, ext, R_th, X_th, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function CSVGN1(::Nothing)
    CSVGN1(;
        name="init",
        K=0,
        T1=0,
        T2=0,
        T3=0,
        T4=0,
        T5=0,
        Rmin=0,
        Vmax=0,
        Vmin=0,
        CBase=0,
        base_power=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`CSVGN1`](@ref) `name`."""
get_name(value::CSVGN1) = value.name
"""Get [`CSVGN1`](@ref) `K`."""
get_K(value::CSVGN1) = value.K
"""Get [`CSVGN1`](@ref) `T1`."""
get_T1(value::CSVGN1) = value.T1
"""Get [`CSVGN1`](@ref) `T2`."""
get_T2(value::CSVGN1) = value.T2
"""Get [`CSVGN1`](@ref) `T3`."""
get_T3(value::CSVGN1) = value.T3
"""Get [`CSVGN1`](@ref) `T4`."""
get_T4(value::CSVGN1) = value.T4
"""Get [`CSVGN1`](@ref) `T5`."""
get_T5(value::CSVGN1) = value.T5
"""Get [`CSVGN1`](@ref) `Rmin`."""
get_Rmin(value::CSVGN1) = value.Rmin
"""Get [`CSVGN1`](@ref) `Vmax`."""
get_Vmax(value::CSVGN1) = value.Vmax
"""Get [`CSVGN1`](@ref) `Vmin`."""
get_Vmin(value::CSVGN1) = value.Vmin
"""Get [`CSVGN1`](@ref) `CBase`."""
get_CBase(value::CSVGN1) = value.CBase
"""Get [`CSVGN1`](@ref) `base_power`."""
get_base_power(value::CSVGN1) = value.base_power
"""Get [`CSVGN1`](@ref) `ext`."""
get_ext(value::CSVGN1) = value.ext
"""Get [`CSVGN1`](@ref) `R_th`."""
get_R_th(value::CSVGN1) = value.R_th
"""Get [`CSVGN1`](@ref) `X_th`."""
get_X_th(value::CSVGN1) = value.X_th
"""Get [`CSVGN1`](@ref) `states`."""
get_states(value::CSVGN1) = value.states
"""Get [`CSVGN1`](@ref) `n_states`."""
get_n_states(value::CSVGN1) = value.n_states
"""Get [`CSVGN1`](@ref) `internal`."""
get_internal(value::CSVGN1) = value.internal

"""Set [`CSVGN1`](@ref) `K`."""
set_K!(value::CSVGN1, val) = value.K = val
"""Set [`CSVGN1`](@ref) `T1`."""
set_T1!(value::CSVGN1, val) = value.T1 = val
"""Set [`CSVGN1`](@ref) `T2`."""
set_T2!(value::CSVGN1, val) = value.T2 = val
"""Set [`CSVGN1`](@ref) `T3`."""
set_T3!(value::CSVGN1, val) = value.T3 = val
"""Set [`CSVGN1`](@ref) `T4`."""
set_T4!(value::CSVGN1, val) = value.T4 = val
"""Set [`CSVGN1`](@ref) `T5`."""
set_T5!(value::CSVGN1, val) = value.T5 = val
"""Set [`CSVGN1`](@ref) `Rmin`."""
set_Rmin!(value::CSVGN1, val) = value.Rmin = val
"""Set [`CSVGN1`](@ref) `Vmax`."""
set_Vmax!(value::CSVGN1, val) = value.Vmax = val
"""Set [`CSVGN1`](@ref) `Vmin`."""
set_Vmin!(value::CSVGN1, val) = value.Vmin = val
"""Set [`CSVGN1`](@ref) `CBase`."""
set_CBase!(value::CSVGN1, val) = value.CBase = val
"""Set [`CSVGN1`](@ref) `base_power`."""
set_base_power!(value::CSVGN1, val) = value.base_power = val
"""Set [`CSVGN1`](@ref) `ext`."""
set_ext!(value::CSVGN1, val) = value.ext = val
"""Set [`CSVGN1`](@ref) `R_th`."""
set_R_th!(value::CSVGN1, val) = value.R_th = val
"""Set [`CSVGN1`](@ref) `X_th`."""
set_X_th!(value::CSVGN1, val) = value.X_th = val
