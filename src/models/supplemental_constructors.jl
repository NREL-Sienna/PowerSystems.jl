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
    activepower::Float64,
    maxactivepower::Float64,
    power_factor::Float64,
)
    maxreactivepower = maxactivepower * sin(acos(power_factor))
    reactivepower = activepower * sin(acos(power_factor))
    return PowerLoad(
        name,
        available,
        bus,
        model,
        activepower,
        reactivepower,
        maxactivepower,
        maxreactivepower,
    )
end

function PowerLoadPF(::Nothing)
    return PowerLoadPF("init", true, Bus(nothing), nothing, 0.0, 0.0, 1.0)
end

"""Accepts angle_limits as a Float64."""
function Line(
    name,
    available::Bool,
    activepower_flow::Float64,
    reactivepower_flow::Float64,
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
        activepower_flow,
        reactivepower_flow,
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
    voltagelimits,
    basevoltage,
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
        voltagelimits,
        basevoltage,
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
    forecasts,
    internal,
)
    return StaticReserve(
        name,
        collect(contributingdevices),
        timeframe,
        requirement,
        forecasts,
        internal,
    )
end
