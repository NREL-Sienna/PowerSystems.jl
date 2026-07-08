# BEGIN 4.0.0  deprecations
export TwoTerminalHVDCLine

"""
Deprecated method for the old TwoTerminalHVDCLine that returns the new TwoTerminalGenericHVDCLine.
This constructor is used for some backward compatibility and will be removed in a future version.
"""
function TwoTerminalHVDCLine(
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
    @warn(
        "The TwoTerminalHVDCLine constructor is deprecated. Use TwoTerminalGenericHVDCLine instead. \
         This constructor will be removed in a future version.",)
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
Deprecated method for the old TwoTerminalHVDCLine that returns the new [`TwoTerminalGenericHVDCLine`](@ref).
This constructor is used for some backward compatibility and will be removed in a future version.
"""
function TwoTerminalHVDCLine(
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
    @warn(
        "The TwoTerminalHVDCLine constructor is deprecated. Use TwoTerminalGenericHVDCLine instead. \
         This constructor will be removed in a future version.",)
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
Deprecated method for the old TwoTerminalHVDCLine that returns the new [`TwoTerminalGenericHVDCLine`](@ref).
This constructor is used for some backward compatibility and will be removed in a future version.
"""
function TwoTerminalHVDCLine(
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
    @warn(
        "The TwoTerminalHVDCLine constructor is deprecated. Use TwoTerminalGenericHVDCLine instead. \
         This constructor will be removed in a future version.",)
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
Deprecated method for the old TwoTerminalHVDCLine that returns the new [`TwoTerminalGenericHVDCLine`](@ref).
This constructor is used for some backward compatibility and will be removed in a future version.
"""
function TwoTerminalHVDCLine(
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
    @warn(
        "The TwoTerminalHVDCLine constructor is deprecated. Use TwoTerminalGenericHVDCLine instead. \
         This constructor will be removed in a future version.",)
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
Deprecated method for the old TwoTerminalHVDCLine that returns the new [`TwoTerminalGenericHVDCLine`](@ref).
This constructor is used for some backward compatibility and will be removed in a future version.
"""
function TwoTerminalHVDCLine(;
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
    @warn(
        "The TwoTerminalHVDCLine constructor is deprecated. Use TwoTerminalGenericHVDCLine instead. \
         This constructor will be removed in a future version.",)
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

# BEGIN 5.x deprecations: TwoTerminalVSCLine Bool control accessors -> control-mode enums
#
# PSY <= 5.11 modeled VSC converter control with four `Bool` fields
# (`dc_voltage_control_*`, `ac_voltage_control_*`). They were replaced by the richer
# `dc_control_*::VSCDCControlModes` / `ac_control_*::VSCACControlModes` enums (the latter
# adds the `DC_VOLTAGE_DROOP` mode). The accessor shims below map the pre-5.x `Bool`
# getters onto the enums; a `Bool` only distinguishes the two voltage-control values and
# cannot express `DC_VOLTAGE_DROOP`. The pre-5.x keyword constructor cannot be shimmed:
# Julia forbids overwriting the generated keyword constructor during precompilation, so
# callers must move to the `*_control_*` enum keywords.

"""
Deprecated. Use [`get_dc_control_from`](@ref); returns `true` when the `from` converter
regulates DC voltage (`VSCDCControlModes.DC_VOLTAGE`).
"""
function get_dc_voltage_control_from(value::TwoTerminalVSCLine)
    @warn "`get_dc_voltage_control_from` deprecated; use `get_dc_control_from`." maxlog = 1
    return get_dc_control_from(value) == VSCDCControlModes.DC_VOLTAGE
end

"""
Deprecated. Use [`get_dc_control_to`](@ref); returns `true` when the `to` converter
regulates DC voltage (`VSCDCControlModes.DC_VOLTAGE`).
"""
function get_dc_voltage_control_to(value::TwoTerminalVSCLine)
    @warn "`get_dc_voltage_control_to` deprecated; use `get_dc_control_to`." maxlog = 1
    return get_dc_control_to(value) == VSCDCControlModes.DC_VOLTAGE
end

"""
Deprecated. Use [`get_ac_control_from`](@ref); returns `true` when the `from` converter
regulates AC voltage (`VSCACControlModes.AC_VOLTAGE`).
"""
function get_ac_voltage_control_from(value::TwoTerminalVSCLine)
    @warn "`get_ac_voltage_control_from` deprecated; use `get_ac_control_from`." maxlog = 1
    return get_ac_control_from(value) == VSCACControlModes.AC_VOLTAGE
end

"""
Deprecated. Use [`get_ac_control_to`](@ref); returns `true` when the `to` converter
regulates AC voltage (`VSCACControlModes.AC_VOLTAGE`).
"""
function get_ac_voltage_control_to(value::TwoTerminalVSCLine)
    @warn "`get_ac_voltage_control_to` deprecated; use `get_ac_control_to`." maxlog = 1
    return get_ac_control_to(value) == VSCACControlModes.AC_VOLTAGE
end

# Deserialization migration: a system serialized by PSY <= 5.11 stores the four pre-5.x `Bool`
# control flags and none of the enum fields. Map the Bool flags onto the `*_control_*` enums so an
# old system round-trips without silently defaulting every converter to `DC_VOLTAGE`. A `Bool`
# cannot express `DC_VOLTAGE_DROOP`, but pre-5.x data never had droop, so the mapping is exact.
# Enums serialize as their scoped-value string (e.g. "DC_VOLTAGE"), which is what the generic
# component deserializer expects for these fields.
function IS.deserialize(
    ::Type{TwoTerminalVSCLine},
    data::Dict,
    component_cache::Dict,
)
    if haskey(data, "dc_voltage_control_from") && !haskey(data, "dc_control_from")
        data = copy(data)
        data["dc_control_from"] =
            data["dc_voltage_control_from"] ? "DC_VOLTAGE" : "DC_POWER"
        data["dc_control_to"] = data["dc_voltage_control_to"] ? "DC_VOLTAGE" : "DC_POWER"
        data["ac_control_from"] =
            data["ac_voltage_control_from"] ? "AC_VOLTAGE" : "AC_REACTIVE_POWER"
        data["ac_control_to"] =
            data["ac_voltage_control_to"] ? "AC_VOLTAGE" : "AC_REACTIVE_POWER"
    end
    return invoke(
        IS.deserialize,
        Tuple{Type{<:_CONTAINS_SHOULD_ENCODE}, Dict, Dict},
        TwoTerminalVSCLine,
        data,
        component_cache,
    )
end
