#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PriorityOutputCurrentLimiter <: OutputCurrentLimiter
        I_max::Float64
        ϕ_I::Float64
        ext::Dict{String, Any}
    end

Parameters of Priority-Based Current Controller Limiter. Regulates the magnitude of the inverter output current and prioritizes a specific angle for the resultant current signal

# Arguments
- `I_max::Float64`: Maximum limit on current controller input current (device base), validation range: `(0, nothing)`
- `ϕ_I::Float64`: Pre-defined angle (measured against the d-axis) for I_ref once limit I_max is hit, validation range: `(-1.571, 1.571)`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
"""
mutable struct PriorityOutputCurrentLimiter <: OutputCurrentLimiter
    "Maximum limit on current controller input current (device base)"
    I_max::Float64
    "Pre-defined angle (measured against the d-axis) for I_ref once limit I_max is hit"
    ϕ_I::Float64
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
end


function PriorityOutputCurrentLimiter(; I_max, ϕ_I, ext=Dict{String, Any}(), )
    PriorityOutputCurrentLimiter(I_max, ϕ_I, ext, )
end

# Constructor for demo purposes; non-functional.
function PriorityOutputCurrentLimiter(::Nothing)
    PriorityOutputCurrentLimiter(;
        I_max=0,
        ϕ_I=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PriorityOutputCurrentLimiter`](@ref) `I_max`."""
get_I_max(value::PriorityOutputCurrentLimiter) = value.I_max
"""Get [`PriorityOutputCurrentLimiter`](@ref) `ϕ_I`."""
get_ϕ_I(value::PriorityOutputCurrentLimiter) = value.ϕ_I
"""Get [`PriorityOutputCurrentLimiter`](@ref) `ext`."""
get_ext(value::PriorityOutputCurrentLimiter) = value.ext

"""Set [`PriorityOutputCurrentLimiter`](@ref) `I_max`."""
set_I_max!(value::PriorityOutputCurrentLimiter, val) = value.I_max = val
"""Set [`PriorityOutputCurrentLimiter`](@ref) `ϕ_I`."""
set_ϕ_I!(value::PriorityOutputCurrentLimiter, val) = value.ϕ_I = val
"""Set [`PriorityOutputCurrentLimiter`](@ref) `ext`."""
set_ext!(value::PriorityOutputCurrentLimiter, val) = value.ext = val
