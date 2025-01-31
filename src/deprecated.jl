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
