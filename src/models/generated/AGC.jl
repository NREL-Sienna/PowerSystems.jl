#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AGC <: Service
        name::String
        bias::Float64
        K_p::Float64
        K_i::Float64
        K_d::Float64
        delta_t::Float64
        area::Union{Nothing, Area}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `bias::Float64`
- `K_p::Float64`: PID Proportional Constant
- `K_i::Float64`: PID Integral Constant
- `K_d::Float64`: PID Derrivative Constant
- `delta_t::Float64`: PID Discretization period [Seconds]
- `area::Union{Nothing, Area}`: the area controlled by the AGC
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AGC <: Service
    name::String
    bias::Float64
    "PID Proportional Constant"
    K_p::Float64
    "PID Integral Constant"
    K_i::Float64
    "PID Derrivative Constant"
    K_d::Float64
    "PID Discretization period [Seconds]"
    delta_t::Float64
    "the area controlled by the AGC"
    area::Union{Nothing, Area}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AGC(name, bias, K_p, K_i, K_d, delta_t, area=nothing, ext=Dict{String, Any}(), )
    AGC(name, bias, K_p, K_i, K_d, delta_t, area, ext, InfrastructureSystemsInternal(), )
end

function AGC(; name, bias, K_p, K_i, K_d, delta_t, area=nothing, ext=Dict{String, Any}(), )
    AGC(name, bias, K_p, K_i, K_d, delta_t, area, ext, )
end

# Constructor for demo purposes; non-functional.
function AGC(::Nothing)
    AGC(;
        name="init",
        bias=0.0,
        K_p=0.0,
        K_i=0.0,
        K_d=0.0,
        delta_t=0.0,
        area=Area(nothing),
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::AGC) = value.name
"""Get AGC bias."""
get_bias(value::AGC) = value.bias
"""Get AGC K_p."""
get_K_p(value::AGC) = value.K_p
"""Get AGC K_i."""
get_K_i(value::AGC) = value.K_i
"""Get AGC K_d."""
get_K_d(value::AGC) = value.K_d
"""Get AGC delta_t."""
get_delta_t(value::AGC) = value.delta_t
"""Get AGC area."""
get_area(value::AGC) = value.area
"""Get AGC ext."""
get_ext(value::AGC) = value.ext
"""Get AGC internal."""
get_internal(value::AGC) = value.internal
