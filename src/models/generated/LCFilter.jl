#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LCFilter <: Filter
        lf::Float64
        rf::Float64
        cf::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a LCL filter outside the converter

# Arguments
- `lf::Float64`: filter inductance
- `rf::Float64`: filter resistance
- `cf::Float64`: filter capacitance
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LCFilter <: Filter
    "filter inductance"
    lf::Float64
    "filter resistance"
    rf::Float64
    "filter capacitance"
    cf::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LCFilter(lf, rf, cf, ext=Dict{String, Any}(), )
    LCFilter(lf, rf, cf, ext, [:id_o, :iq_o], 4, InfrastructureSystemsInternal(), )
end

function LCFilter(; lf, rf, cf, ext=Dict{String, Any}(), )
    LCFilter(lf, rf, cf, ext, )
end

# Constructor for demo purposes; non-functional.
function LCFilter(::Nothing)
    LCFilter(;
        lf=0,
        rf=0,
        cf=0,
        ext=Dict{String, Any}(),
    )
end

"""Get LCFilter lf."""
get_lf(value::LCFilter) = value.lf
"""Get LCFilter rf."""
get_rf(value::LCFilter) = value.rf
"""Get LCFilter cf."""
get_cf(value::LCFilter) = value.cf
"""Get LCFilter ext."""
get_ext(value::LCFilter) = value.ext
"""Get LCFilter states."""
get_states(value::LCFilter) = value.states
"""Get LCFilter n_states."""
get_n_states(value::LCFilter) = value.n_states
"""Get LCFilter internal."""
get_internal(value::LCFilter) = value.internal
