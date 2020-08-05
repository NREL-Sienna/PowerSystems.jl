#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AGC <: Service
        name::String
        available::Bool
        bias::Float64
        K_p::Float64
        K_i::Float64
        K_d::Float64
        delta_t::Float64
        area::Union{Nothing, Area}
        initial_ace::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bias::Float64`
- `K_p::Float64`: PID Proportional Constant
- `K_i::Float64`: PID Integral Constant
- `K_d::Float64`: PID Derrivative Constant
- `delta_t::Float64`: PID Discretization period [Seconds]
- `area::Union{Nothing, Area}`: the area controlled by the AGC
- `initial_ace::Float64`: PID Discretization period [Seconds]
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AGC <: Service
    name::String
    available::Bool
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
    "PID Discretization period [Seconds]"
    initial_ace::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AGC(name, available, bias, K_p, K_i, K_d, delta_t, area=nothing, initial_ace=0.0, ext=Dict{String, Any}(), )
    AGC(name, available, bias, K_p, K_i, K_d, delta_t, area, initial_ace, ext, InfrastructureSystemsInternal(), )
end

function AGC(; name, available, bias, K_p, K_i, K_d, delta_t, area=nothing, initial_ace=0.0, ext=Dict{String, Any}(), )
    AGC(name, available, bias, K_p, K_i, K_d, delta_t, area, initial_ace, ext, )
end

# Constructor for demo purposes; non-functional.
function AGC(::Nothing)
    AGC(;
        name="init",
        available=false,
        bias=0.0,
        K_p=0.0,
        K_i=0.0,
        K_d=0.0,
        delta_t=0.0,
        area=Area(nothing),
        initial_ace=0.0,
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::AGC) = value.name
"""Get AGC available."""
get_available(value::AGC) = value.available
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
"""Get AGC initial_ace."""
get_initial_ace(value::AGC) = value.initial_ace
"""Get AGC ext."""
get_ext(value::AGC) = value.ext
"""Get AGC internal."""
get_internal(value::AGC) = value.internal


InfrastructureSystems.set_name!(value::AGC, val) = value.name = val
"""Set AGC available."""
set_available!(value::AGC, val) = value.available = val
"""Set AGC bias."""
set_bias!(value::AGC, val) = value.bias = val
"""Set AGC K_p."""
set_K_p!(value::AGC, val) = value.K_p = val
"""Set AGC K_i."""
set_K_i!(value::AGC, val) = value.K_i = val
"""Set AGC K_d."""
set_K_d!(value::AGC, val) = value.K_d = val
"""Set AGC delta_t."""
set_delta_t!(value::AGC, val) = value.delta_t = val
"""Set AGC area."""
set_area!(value::AGC, val) = value.area = val
"""Set AGC initial_ace."""
set_initial_ace!(value::AGC, val) = value.initial_ace = val
"""Set AGC ext."""
set_ext!(value::AGC, val) = value.ext = val
"""Set AGC internal."""
set_internal!(value::AGC, val) = value.internal = val
