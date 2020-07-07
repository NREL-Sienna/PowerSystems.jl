#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct GasTG <: TurbineGov
        R::Float64
        T1::Float64
        T2::Float64
        T3::Float64
        AT::Float64
        Kt::Float64
        V_lim::Tuple{Float64, Float64}
        D_turb::Float64
        Load_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of Gas Turbine-Governor. GAST in PSSE and GAST_PTI in PowerWorld.

# Arguments
- `R::Float64`: Speed droop parameter, validation range: (&quot;eps()&quot;, nothing)
- `T1::Float64`: Governor time constant in s, validation range: (&quot;eps()&quot;, nothing)
- `T2::Float64`: Combustion chamber time constant, validation range: (&quot;eps()&quot;, nothing)
- `T3::Float64`: Load limit time constant (exhaust gas measurement time), validation range: (&quot;eps()&quot;, nothing)
- `AT::Float64`: Ambient temperature load limit, validation range: (0, nothing)
- `Kt::Float64`: Load limit feedback gain, validation range: (0, nothing)
- `V_lim::Tuple{Float64, Float64}`: Operational control limits on fuel valve opening (V_min, V_max)
- `D_turb::Float64`: Speed damping coefficient of gas turbine rotor, validation range: (0, nothing)
- `Load_ref::Float64`: Reference Load Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the GAST model are:
	x_g1: Fuel valve opening,
	x_g2: Fuel flow,
	x_g3: Exhaust temperature load
- `n_states::Int64`: GasTG has 3 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GasTG <: TurbineGov
    "Speed droop parameter"
    R::Float64
    "Governor time constant in s"
    T1::Float64
    "Combustion chamber time constant"
    T2::Float64
    "Load limit time constant (exhaust gas measurement time)"
    T3::Float64
    "Ambient temperature load limit"
    AT::Float64
    "Load limit feedback gain"
    Kt::Float64
    "Operational control limits on fuel valve opening (V_min, V_max)"
    V_lim::Tuple{Float64, Float64}
    "Speed damping coefficient of gas turbine rotor"
    D_turb::Float64
    "Reference Load Set-point"
    Load_ref::Float64
    ext::Dict{String, Any}
    "The states of the GAST model are:
	x_g1: Fuel valve opening,
	x_g2: Fuel flow,
	x_g3: Exhaust temperature load"
    states::Vector{Symbol}
    "GasTG has 3 states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GasTG(R, T1, T2, T3, AT, Kt, V_lim, D_turb, Load_ref=1.0, ext=Dict{String, Any}(), )
    GasTG(R, T1, T2, T3, AT, Kt, V_lim, D_turb, Load_ref, ext, [:x_g1, :x_g2, :x_g3], 3, InfrastructureSystemsInternal(), )
end

function GasTG(; R, T1, T2, T3, AT, Kt, V_lim, D_turb, Load_ref=1.0, ext=Dict{String, Any}(), )
    GasTG(R, T1, T2, T3, AT, Kt, V_lim, D_turb, Load_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function GasTG(::Nothing)
    GasTG(;
        R=0,
        T1=0,
        T2=0,
        T3=0,
        AT=0,
        Kt=0,
        V_lim=(0.0, 0.0),
        D_turb=0,
        Load_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get GasTG R."""
get_R(value::GasTG) = value.R
"""Get GasTG T1."""
get_T1(value::GasTG) = value.T1
"""Get GasTG T2."""
get_T2(value::GasTG) = value.T2
"""Get GasTG T3."""
get_T3(value::GasTG) = value.T3
"""Get GasTG AT."""
get_AT(value::GasTG) = value.AT
"""Get GasTG Kt."""
get_Kt(value::GasTG) = value.Kt
"""Get GasTG V_lim."""
get_V_lim(value::GasTG) = value.V_lim
"""Get GasTG D_turb."""
get_D_turb(value::GasTG) = value.D_turb
"""Get GasTG Load_ref."""
get_Load_ref(value::GasTG) = value.Load_ref
"""Get GasTG ext."""
get_ext(value::GasTG) = value.ext
"""Get GasTG states."""
get_states(value::GasTG) = value.states
"""Get GasTG n_states."""
get_n_states(value::GasTG) = value.n_states
"""Get GasTG internal."""
get_internal(value::GasTG) = value.internal

"""Set GasTG R."""
set_R!(value::GasTG, val::Float64) = value.R = val
"""Set GasTG T1."""
set_T1!(value::GasTG, val::Float64) = value.T1 = val
"""Set GasTG T2."""
set_T2!(value::GasTG, val::Float64) = value.T2 = val
"""Set GasTG T3."""
set_T3!(value::GasTG, val::Float64) = value.T3 = val
"""Set GasTG AT."""
set_AT!(value::GasTG, val::Float64) = value.AT = val
"""Set GasTG Kt."""
set_Kt!(value::GasTG, val::Float64) = value.Kt = val
"""Set GasTG V_lim."""
set_V_lim!(value::GasTG, val::Tuple{Float64, Float64}) = value.V_lim = val
"""Set GasTG D_turb."""
set_D_turb!(value::GasTG, val::Float64) = value.D_turb = val
"""Set GasTG Load_ref."""
set_Load_ref!(value::GasTG, val::Float64) = value.Load_ref = val
"""Set GasTG ext."""
set_ext!(value::GasTG, val::Dict{String, Any}) = value.ext = val
"""Set GasTG states."""
set_states!(value::GasTG, val::Vector{Symbol}) = value.states = val
"""Set GasTG n_states."""
set_n_states!(value::GasTG, val::Int64) = value.n_states = val
"""Set GasTG internal."""
set_internal!(value::GasTG, val::InfrastructureSystemsInternal) = value.internal = val
