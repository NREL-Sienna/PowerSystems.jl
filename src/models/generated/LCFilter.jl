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
- `states::Vector{Symbol}`: The states of the LCFilter model are:
	ir_filter: Real current out of the filter,
	ii_filter: Imaginary current out of the filter
- `n_states::Int64`: LCFilter has two states
"""
mutable struct LCFilter <: Filter
    "filter inductance"
    lf::Float64
    "filter resistance"
    rf::Float64
    "filter capacitance"
    cf::Float64
    ext::Dict{String, Any}
    "The states of the LCFilter model are:
	ir_filter: Real current out of the filter,
	ii_filter: Imaginary current out of the filter"
    states::Vector{Symbol}
    "LCFilter has two states"
    n_states::Int64
end

function LCFilter(lf, rf, cf, ext=Dict{String, Any}(), )
    LCFilter(lf, rf, cf, ext, [:ir_filter, :ii_filter], 2, )
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

"""Set LCFilter lf."""
set_lf!(value::LCFilter, val::Float64) = value.lf = val
"""Set LCFilter rf."""
set_rf!(value::LCFilter, val::Float64) = value.rf = val
"""Set LCFilter cf."""
set_cf!(value::LCFilter, val::Float64) = value.cf = val
"""Set LCFilter ext."""
set_ext!(value::LCFilter, val::Dict{String, Any}) = value.ext = val
"""Set LCFilter states."""
set_states!(value::LCFilter, val::Vector{Symbol}) = value.states = val
"""Set LCFilter n_states."""
set_n_states!(value::LCFilter, val::Int64) = value.n_states = val
