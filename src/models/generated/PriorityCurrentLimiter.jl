#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PriorityCurrentLimiter <: InverterLimiter
        I_max::Float64
        ϕ_I::Float64
        ext::Dict{String, Any}
    end

Parameters of Priority-Based Current Controller Limiter

# Arguments
- `I_max::Float64`: Maximum limit on current controller input current (device base), validation range: `(0, nothing)`
- `ϕ_I::Float64`: Pre-defined angle (measured against the d-axis) for Iref once limit is hit, validation range: `(-1.571, 1.571)`
- `ext::Dict{String, Any}`
"""
mutable struct PriorityCurrentLimiter <: InverterLimiter
    "Maximum limit on current controller input current (device base)"
    I_max::Float64
    "Pre-defined angle (measured against the d-axis) for Iref once limit is hit"
    ϕ_I::Float64
    ext::Dict{String, Any}
end


function PriorityCurrentLimiter(; I_max, ϕ_I, ext=Dict{String, Any}(), )
    PriorityCurrentLimiter(I_max, ϕ_I, ext, )
end

# Constructor for demo purposes; non-functional.
function PriorityCurrentLimiter(::Nothing)
    PriorityCurrentLimiter(;
        I_max=0,
        ϕ_I=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PriorityCurrentLimiter`](@ref) `I_max`."""
get_I_max(value::PriorityCurrentLimiter) = value.I_max
"""Get [`PriorityCurrentLimiter`](@ref) `ϕ_I`."""
get_ϕ_I(value::PriorityCurrentLimiter) = value.ϕ_I
"""Get [`PriorityCurrentLimiter`](@ref) `ext`."""
get_ext(value::PriorityCurrentLimiter) = value.ext

"""Set [`PriorityCurrentLimiter`](@ref) `I_max`."""
set_I_max!(value::PriorityCurrentLimiter, val) = value.I_max = val
"""Set [`PriorityCurrentLimiter`](@ref) `ϕ_I`."""
set_ϕ_I!(value::PriorityCurrentLimiter, val) = value.ϕ_I = val
"""Set [`PriorityCurrentLimiter`](@ref) `ext`."""
set_ext!(value::PriorityCurrentLimiter, val) = value.ext = val
