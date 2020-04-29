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
    end

Parameters of a LCL filter outside the converter

# Arguments
- `lf::Float64`: filter inductance, validation range: (0, nothing)
- `rf::Float64`: filter resistance, validation range: (0, nothing)
- `cf::Float64`: filter capacitance, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
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
end

function LCFilter(lf, rf, cf, ext=Dict{String, Any}(), )
    LCFilter(lf, rf, cf, ext, [:id_o, :iq_o], 4, )
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
