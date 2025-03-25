"""Accepts angle_limits as a Float64."""
function Line(
    name,
    available::Bool,
    active_power_flow::Float64,
    reactive_power_flow::Float64,
    arc::Arc,
    r,
    x,
    b,
    rating,
    angle_limits::Float64,
)
    return Line(
        name,
        available,
        active_power_flow,
        reactive_power_flow,
        arc::Arc,
        r,
        x,
        b,
        rating,
        (min = -angle_limits, max = angle_limits),
    )
end

"""Allows construction with bus type specified as a string for legacy code."""
function ACBus(
    number,
    name,
    bustype::String,
    angle,
    voltage,
    voltage_limits,
    base_voltage,
    area,
    load_zone;
    ext = Dict{String, Any}(),
)
    return ACBus(
        number,
        name,
        get_enum_value(ACBusTypes, bustype),
        angle,
        voltage,
        voltage_limits,
        base_voltage,
        area,
        load_zone,
        ext,
        InfrastructureSystemsInternal(),
    )
end

"""Allows construction with bus type specified as a string for legacy code."""
function FACTSControlDevice(
    name,
    available,
    bus,
    control_mode::String,
    voltage_setpoint,
    max_shunt_current,
    reactive_power_required,
    services = Device[],
    dynamic_injector = nothing,
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
)
    return FACTSControlDevice(
        name,
        available,
        bus,
        get_enum_value(FACTSOperationModes, control_mode),
        voltage_setpoint,
        max_shunt_current,
        reactive_power_required,
        services,
        dynamic_injector,
        ext,
        internal,
    )
end

"""Allows construction of a reserve from an iterator."""
function ConstantReserve(
    name,
    contributingdevices::IS.FlattenIteratorWrapper,
    timeframe,
    requirement,
    time_series,
    internal,
)
    return ConstantReserve(
        name,
        collect(contributingdevices),
        timeframe,
        requirement,
        time_series,
        internal,
    )
end

function InterruptibleLoad(
    name,
    available,
    bus,
    model,
    active_power,
    reactive_power,
    max_active_power,
    max_reactive_power,
    base_power,
    operation_cost,
    services = Device[],
    dynamic_injector = nothing,
    ext = Dict{String, Any}(),
)
    @warn(
        "The InterruptibleLoad constructor that accepts a model type has been removed and \\
  is no longer used. Calling this method will automatically create an InterruptiblePowerLoad"
    )
    InterruptiblePowerLoad(
        name,
        available,
        bus,
        active_power,
        reactive_power,
        max_active_power,
        max_reactive_power,
        base_power,
        operation_cost,
        services,
        dynamic_injector,
        ext,
        InfrastructureSystemsInternal(),
    )
end

function InterruptibleLoad(;
    name,
    available,
    bus,
    model,
    active_power,
    reactive_power,
    max_active_power,
    max_reactive_power,
    base_power,
    operation_cost,
    services = Device[],
    dynamic_injector = nothing,
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
)
    @warn(
        "The InterruptibleLoad constructor that accepts a model type has been removed and \\
  is no longer used. Calling this method will automatically create an InterruptiblePowerLoad"
    )
    InterruptiblePowerLoad(
        name,
        available,
        bus,
        active_power,
        reactive_power,
        max_active_power,
        max_reactive_power,
        base_power,
        operation_cost,
        services,
        dynamic_injector,
        ext,
        internal,
    )
end

function EnergyReservoirStorage(
    name::AbstractString,
    available::Bool,
    bus,
    prime_mover_type,
    storage_technology_type,
    storage_capacity,
    storage_level_limits,
    initial_storage_capacity_level,
    rating,
    active_power,
    input_active_power_limits,
    output_active_power_limits,
    efficiency,
    reactive_power,
    reactive_power_limits,
    base_power,
    ::Nothing,
    services = Device[],
    dynamic_injector = nothing,
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
)
    EnergyReservoirStorage(
        name,
        available,
        bus,
        prime_mover_type,
        storage_technology_type,
        storage_capacity,
        storage_level_limits,
        initial_storage_capacity_level,
        rating,
        active_power,
        input_active_power_limits,
        output_active_power_limits,
        efficiency,
        reactive_power,
        reactive_power_limits,
        base_power,
        StorageCost();
        services = services,
        dynamic_injector = dynamic_injector,
        ext = ext,
        internal = internal,
    )
end

"""
Deprecated method for TwoTerminalHVDCLine
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
