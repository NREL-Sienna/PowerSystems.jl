#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LCLFilter <: Filter
        lf::Float64
        rf::Float64
        cf::Float64
        lg::Float64
        rg::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of a LCL filter outside the converter, the states are in the grid's reference frame

# Arguments
- `lf::Float64`: Series inductance in p.u. of converter filter, validation range: (0, nothing)
- `rf::Float64`: Series resistance in p.u. of converter filter, validation range: (0, nothing)
- `cf::Float64`: Shunt capacitance in p.u. of converter filter, validation range: (0, nothing)
- `lg::Float64`: Series inductance in p.u. of converter filter to the grid, validation range: (0, nothing)
- `rg::Float64`: Series resistance in p.u. of converter filter to the grid, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
"""
mutable struct LCLFilter <: Filter
    "Series inductance in p.u. of converter filter"
    lf::Float64
    "Series resistance in p.u. of converter filter"
    rf::Float64
    "Shunt capacitance in p.u. of converter filter"
    cf::Float64
    "Series inductance in p.u. of converter filter to the grid"
    lg::Float64
    "Series resistance in p.u. of converter filter to the grid"
    rg::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
end

function LCLFilter(lf, rf, cf, lg, rg, ext=Dict{String, Any}(), )
    LCLFilter(lf, rf, cf, lg, rg, ext, [:ir_cnv, :ii_cnv, :vr_filter, :vi_filter, :ir_filter, :ii_filter], 6, )
end

function LCLFilter(; lf, rf, cf, lg, rg, ext=Dict{String, Any}(), )
    LCLFilter(lf, rf, cf, lg, rg, ext, )
end

# Constructor for demo purposes; non-functional.
function LCLFilter(::Nothing)
    LCLFilter(;
        lf=0,
        rf=0,
        cf=0,
        lg=0,
        rg=0,
        ext=Dict{String, Any}(),
    )
end

"""Get LCLFilter lf."""
get_lf(value::LCLFilter) = value.lf
"""Get LCLFilter rf."""
get_rf(value::LCLFilter) = value.rf
"""Get LCLFilter cf."""
get_cf(value::LCLFilter) = value.cf
"""Get LCLFilter lg."""
get_lg(value::LCLFilter) = value.lg
"""Get LCLFilter rg."""
get_rg(value::LCLFilter) = value.rg
"""Get LCLFilter ext."""
get_ext(value::LCLFilter) = value.ext
"""Get LCLFilter states."""
get_states(value::LCLFilter) = value.states
"""Get LCLFilter n_states."""
get_n_states(value::LCLFilter) = value.n_states

"""Set LCLFilter lf."""
set_lf!(value::LCLFilter, val) = value.lf = val
"""Set LCLFilter rf."""
set_rf!(value::LCLFilter, val) = value.rf = val
"""Set LCLFilter cf."""
set_cf!(value::LCLFilter, val) = value.cf = val
"""Set LCLFilter lg."""
set_lg!(value::LCLFilter, val) = value.lg = val
"""Set LCLFilter rg."""
set_rg!(value::LCLFilter, val) = value.rg = val
"""Set LCLFilter ext."""
set_ext!(value::LCLFilter, val) = value.ext = val
"""Set LCLFilter states."""
set_states!(value::LCLFilter, val) = value.states = val
"""Set LCLFilter n_states."""
set_n_states!(value::LCLFilter, val) = value.n_states = val
