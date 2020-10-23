"""Accepts rating as a Float64 and then creates a TwoPartCost."""
function TwoPartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return TwoPartCost(VariableCost(variable_cost), args...)
end

"""Accepts rating as a Float64 and then creates a ThreePartCost."""
function ThreePartCost(variable_cost::T, args...) where {T <: VarCostArgs}
    return ThreePartCost(VariableCost(variable_cost), args...)
end

# FIXME: This function name implies that will return a struct named `PowerLoadPF`
# i.e. `PowerLoadPF` is not a constructor
function PowerLoadPF(
    name::String,
    available::Bool,
    bus::Bus,
    model::Union{Nothing, LoadModels.LoadModel},
    active_power::Float64,
    max_active_power::Float64,
    power_factor::Float64,
    base_power::Float64,
)
    max_reactive_power = max_active_power * sin(acos(power_factor))
    reactive_power = active_power * sin(acos(power_factor))
    return PowerLoad(
        name,
        available,
        bus,
        model,
        active_power,
        reactive_power,
        base_power,
        max_active_power,
        max_reactive_power,
    )
end

function PowerLoadPF(::Nothing)
    return PowerLoadPF("init", true, Bus(nothing), nothing, 0.0, 0.0, 1.0, 100.0)
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
function Bus(
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
    return Bus(
        number,
        name,
        get_enum_value(BusTypes.BusType, bustype),
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
