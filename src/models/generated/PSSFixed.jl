#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PSSFixed <: PSS
        V_pss::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a PSS that returns a fixed voltage to add to the reference for the AVR

# Arguments
- `V_pss::Float64`: Fixed voltage stabilization signal, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int`: PSSFixed has no states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PSSFixed <: PSS
    "Fixed voltage stabilization signal"
    V_pss::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    "PSSFixed has no states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PSSFixed(V_pss, ext=Dict{String, Any}(), )
    PSSFixed(V_pss, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function PSSFixed(; V_pss, ext=Dict{String, Any}(), )
    PSSFixed(V_pss, ext, )
end

# Constructor for demo purposes; non-functional.
function PSSFixed(::Nothing)
    PSSFixed(;
        V_pss=0,
        ext=Dict{String, Any}(),
    )
end

"""Get PSSFixed V_pss."""
get_V_pss(value::PSSFixed) = value.V_pss
"""Get PSSFixed ext."""
get_ext(value::PSSFixed) = value.ext
"""Get PSSFixed states."""
get_states(value::PSSFixed) = value.states
"""Get PSSFixed n_states."""
get_n_states(value::PSSFixed) = value.n_states
"""Get PSSFixed internal."""
get_internal(value::PSSFixed) = value.internal

"""Set PSSFixed V_pss."""
set_V_pss!(value::PSSFixed, val::Float64) = value.V_pss = val
"""Set PSSFixed ext."""
set_ext!(value::PSSFixed, val::Dict{String, Any}) = value.ext = val
"""Set PSSFixed states."""
set_states!(value::PSSFixed, val::Vector{Symbol}) = value.states = val
"""Set PSSFixed n_states."""
set_n_states!(value::PSSFixed, val::Int) = value.n_states = val
"""Set PSSFixed internal."""
set_internal!(value::PSSFixed, val::InfrastructureSystemsInternal) = value.internal = val
