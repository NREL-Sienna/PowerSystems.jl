"""Accepts rating as a Float64 and then creates a TwoPartCost."""
function TwoPartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return TwoPartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a ThreePartCost."""
function ThreePartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return ThreePartCost(VariableCost(variable_cost), args...)
end

"""
Accepts a single `start_up` value to use as the `hot` value, with `warm` and `cold` set to
`0.0`.
"""
function MarketBidCost(
    no_load,
    start_up::Number,
    shut_down,
    variable = nothing,
    ancillary_services = Vector{Service}(),
)
    # Intended for use with generators that are not multi-start (e.g. ThermalStandard).
    # Operators use `hot` when they don’t have multiple stages.
    start_up_multi = (hot = start_up, warm = 0.0, cold = 0.0)
    return MarketBidCost(no_load, start_up_multi, shut_down, variable, ancillary_services)
end

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
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
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
        time_series_container,
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
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
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
        time_series_container,
        internal,
    )
end
