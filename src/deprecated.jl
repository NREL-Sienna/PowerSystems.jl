# BEGIN 2.0.0  deprecations
Base.@deprecate convert_component!(
    linetype::Type{MonitoredLine},
    line::Line,
    sys::System;
    kwargs...,
) convert_component!(sys, line, linetype; kwargs...)
Base.@deprecate convert_component!(
    linetype::Type{Line},
    line::MonitoredLine,
    sys::System;
    kwargs...,
) convert_component!(sys, line, linetype; kwargs...)

# BEGIN 4.0.0  deprecations
export TwoTerminalHVDCLine

"""
Deprecated method for TwoTerminalHVDCLine
"""
Base.@deprecate function TwoTerminalHVDCLine(
    name,
    available,
    active_power_flow,
    arc,
    active_power_limits_from,
    active_power_limits_to,
    reactive_power_limits_from,
    reactive_power_limits_to,
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}},
    services,
    ext,
    internal,
)
    new_loss = LinearCurve(loss.l0, loss.l1)
    TwoTerminalGenericHVDCLine(
        name,
        available,
        active_power_flow,
        arc,
        active_power_limits_from,
        active_power_limits_to,
        reactive_power_limits_from,
        reactive_power_limits_to,
        new_loss,
        services,
        ext,
        internal,
    )
end

"""
Deprecated method for TwoTerminalHVDCLine
"""
Base.@deprecate function TwoTerminalHVDCLine(
    name,
    available,
    active_power_flow,
    arc,
    active_power_limits_from,
    active_power_limits_to,
    reactive_power_limits_from,
    reactive_power_limits_to,
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}},
    services = Device[],
    ext = Dict{String, Any}(),
)
    new_loss = LinearCurve(loss.l0, loss.l1)
    TwoTerminalGenericHVDCLine(
        name,
        available,
        active_power_flow,
        arc,
        active_power_limits_from,
        active_power_limits_to,
        reactive_power_limits_from,
        reactive_power_limits_to,
        new_loss,
        services,
        ext,
        InfrastructureSystemsInternal(),
    )
end

"""
Deprecated method for TwoTerminalHVDCLine
"""
Base.@deprecate function TwoTerminalHVDCLine(
    name,
    available,
    active_power_flow,
    arc,
    active_power_limits_from,
    active_power_limits_to,
    reactive_power_limits_from,
    reactive_power_limits_to,
    loss::Union{LinearCurve, PiecewiseIncrementalCurve},
    services = Device[],
    ext = Dict{String, Any}(),
)
    return TwoTerminalGenericHVDCLine(
        name,
        available,
        active_power_flow,
        arc,
        active_power_limits_from,
        active_power_limits_to,
        reactive_power_limits_from,
        reactive_power_limits_to,
        loss,
        services,
        ext,
        InfrastructureSystemsInternal(),
    )
end

"""
Deprecated method for TwoTerminalHVDCLine
"""
Base.@deprecate function TwoTerminalHVDCLine(
    name,
    available,
    active_power_flow,
    arc,
    active_power_limits_from,
    active_power_limits_to,
    reactive_power_limits_from,
    reactive_power_limits_to,
    loss = LinearCurve(0.0),
    services = Device[],
    ext = Dict{String, Any}(),
)
    TwoTerminalGenericHVDCLine(
        name,
        available,
        active_power_flow,
        arc,
        active_power_limits_from,
        active_power_limits_to,
        reactive_power_limits_from,
        reactive_power_limits_to,
        loss,
        services,
        ext,
        InfrastructureSystemsInternal(),
    )
end

"""
Deprecated method for TwoTerminalHVDCLine
"""
Base.@deprecate function TwoTerminalHVDCLine(;
    name,
    available,
    active_power_flow,
    arc,
    active_power_limits_from,
    active_power_limits_to,
    reactive_power_limits_from,
    reactive_power_limits_to,
    loss = LinearCurve(0.0),
    services = Device[],
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
)
    TwoTerminalGenericHVDCLine(
        name,
        available,
        active_power_flow,
        arc,
        active_power_limits_from,
        active_power_limits_to,
        reactive_power_limits_from,
        reactive_power_limits_to,
        loss,
        services,
        ext,
        internal,
    )
end
