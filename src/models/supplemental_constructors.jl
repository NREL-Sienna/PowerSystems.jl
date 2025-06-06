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
function DiscreteControlledACBranch(
    name,
    available,
    arc,
    active_power_flow,
    reactive_power_flow,
    r,
    x,
    rating,
    discrete_branch_type::String,
    branch_status::String,
    ext = Dict{String, Any}(),
    internal = InfrastructureSystemsInternal(),
)
    return DiscreteControlledACBranch(
        name,
        available,
        arc,
        active_power_flow,
        reactive_power_flow,
        r,
        x,
        rating,
        get_enum_value(DiscreteControlledBranchType, discrete_branch_type),
        get_enum_value(DiscreteControlledBranchStatus, branch_status),
        ext,
        internal,
    )
end

"""Allows construction of FACT Devices with control modes."""
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

"""Allows construction of a EnergyReservoirStorage without the specification of a cost."""
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

"""Allows construction of a Transformer2W without the specification of base voltages."""
function Transformer2W(
    name,
    available,
    active_power_flow,
    reactive_power_flow,
    arc,
    r,
    x,
    primary_shunt,
    rating,
    base_power,
    rating_b = nothing,
    rating_c = nothing,
    services = Device[],
    ext = Dict{String, Any}(),
)
    Transformer2W(
        name,
        available,
        active_power_flow,
        reactive_power_flow,
        arc,
        r,
        x,
        primary_shunt,
        rating,
        base_power;
        base_voltage_primary = nothing,
        base_voltage_secondary = nothing,
        rating_b,
        rating_c,
        services,
        ext,
        InfrastructureSystemsInternal(),
    )
end

"""Allows construction of a TapTransformer without the specification of base voltages."""
function TapTransformer(
    name,
    available,
    active_power_flow,
    reactive_power_flow,
    arc,
    r,
    x,
    primary_shunt,
    tap,
    rating,
    base_power,
    rating_b = nothing,
    rating_c = nothing,
    services = Device[],
    ext = Dict{String, Any}(),
)
    TapTransformer(
        name,
        available,
        active_power_flow,
        reactive_power_flow,
        arc,
        r,
        x,
        primary_shunt,
        tap,
        rating,
        base_power;
        base_voltage_primary = nothing,
        base_voltage_secondary = nothing,
        rating_b,
        rating_c,
        services,
        ext,
        InfrastructureSystemsInternal(),
    )
end

"""Allows construction of a PhaseShiftingTransformer without the specification of base voltages."""
function PhaseShiftingTransformer(
    name,
    available,
    active_power_flow,
    reactive_power_flow,
    arc,
    r,
    x,
    primary_shunt,
    tap,
    α,
    rating,
    base_power,
    rating_b = nothing,
    rating_c = nothing,
    phase_angle_limits = (min = -3.1416, max = 3.1416),
    services = Device[],
    ext = Dict{String, Any}(),
)
    PhaseShiftingTransformer(
        name,
        available,
        active_power_flow,
        reactive_power_flow,
        arc,
        r,
        x,
        primary_shunt,
        tap,
        α,
        rating,
        base_power;
        base_voltage_primary = nothing,
        base_voltage_secondary = nothing,
        rating_b,
        rating_c,
        phase_angle_limits,
        services,
        ext,
        InfrastructureSystemsInternal(),
    )
end
