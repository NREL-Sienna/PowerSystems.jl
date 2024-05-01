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
    rate,
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
        rate,
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

"""Allows construction of a reserve from an iterator."""
function StaticReserve(
    name,
    contributingdevices::IS.FlattenIteratorWrapper,
    timeframe,
    requirement,
    time_series,
    internal,
)
    return StaticReserve(
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

function GenericBattery(
    name::AbstractString,
    available::Bool,
    bus,
    prime_mover_type,
    initial_energy,
    state_of_charge_limits,
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
    GenericBattery(
        name,
        available,
        bus,
        prime_mover_type,
        initial_energy,
        state_of_charge_limits,
        rating,
        active_power,
        input_active_power_limits,
        output_active_power_limits,
        efficiency,
        reactive_power,
        reactive_power_limits,
        base_power,
        StorageCost(),
        services,
        dynamic_injector,
        ext,
        internal,
    )
end
