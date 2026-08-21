# PO (OpenAPI model) → PSY cost/curve conversion: one recursive `convert_cost` overloaded
# across every PO cost/curve type. Unmapped variants error rather than yielding a placeholder.
#
# PO structs are `OpenAPI.jl`-generated kwarg structs, not PSY components, so they are read
# with dot access — the "getters, not dot access" rule does not apply to them.

"""Unwrap any `OpenAPI.jl` oneOf wrapper, whose sole `value` field holds the resolved
variant chosen by the document's discriminator."""
convert_cost(w::OpenAPI.OneOfAPIModel) = convert_cost(w.value)

"""A required PO field read as `nothing` is malformed input."""
_require(::Nothing, context::AbstractString) =
    error("convert_cost: $context is required and missing")
_require(x, ::AbstractString) = x

"""
Call `f` with the unit marker the document string `s` names.

Higher-order rather than marker-returning: the marker is a type parameter of
`CostCurve`/`FuelCurve`, so returning it from a runtime string would hand the caller a
`Union{NaturalUnit, DeviceBaseUnit}` and make the construction dynamic. Calling `f` inside each
branch specializes the whole construction on one concrete marker.
"""
_with_power_units(::Any, ::Nothing) =
    error("convert_cost: power_units is required and missing")
function _with_power_units(f, s::AbstractString)
    s == "NATURAL_UNITS" && return f(NaturalUnit())
    s == "COMPONENT_BASE" && return f(DeviceBaseUnit())
    error(
        "convert_cost: unmapped power_units \"$s\" — expected one of " *
        "NATURAL_UNITS, COMPONENT_BASE",
    )
end

# ── FunctionData ────────────────────────────────────────────────────────────────

convert_cost(fd::PC.LinearFunctionData) =
    LinearFunctionData(fd.proportional_term, fd.constant_term)
convert_cost(fd::PC.QuadraticFunctionData) =
    QuadraticFunctionData(fd.quadratic_term, fd.proportional_term, fd.constant_term)
# `points` is generated as a bare `Vector`, so converting once restores inference for the loop.
function convert_cost(fd::PC.PiecewiseLinearData)
    points = convert(Vector{PC.XYCoords}, fd.points)
    return PiecewiseLinearData([(x = p.x, y = p.y) for p in points])
end
convert_cost(fd::PC.PiecewiseStepData) = PiecewiseStepData(fd.x_coords, fd.y_coords)
convert_cost(fd) = error("convert_cost: unmapped FunctionData variant $(typeof(fd))")

# ── ValueCurve ──────────────────────────────────────────────────────────────────

convert_cost(vc::PC.InputOutputCurve) =
    InputOutputCurve(convert_cost(vc.function_data), vc.input_at_zero)
convert_cost(vc::PC.IncrementalCurve) =
    IncrementalCurve(convert_cost(vc.function_data), vc.initial_input, vc.input_at_zero)
convert_cost(vc::PC.AverageRateCurve) =
    AverageRateCurve(convert_cost(vc.function_data), vc.initial_input, vc.input_at_zero)

# ── vom_cost / startup_fuel_offtake: always a LINEAR InputOutputCurve ──────────

_as_linear_curve(curve::InputOutputCurve{LinearFunctionData}) = curve
_as_linear_curve(curve) = error(
    "convert_cost: vom_cost must be a LINEAR InputOutputCurve, got " *
    "InputOutputCurve{$(typeof(get_function_data(curve)))}",
)

_vom_cost(::Nothing) = LinearCurve(0.0)
_vom_cost(io::PC.InputOutputCurve) = _as_linear_curve(convert_cost(io))

# ── fuel_cost: a bare number, or (unimplemented) a time-series reference ──────

convert_cost(v::Real) = Float64(v)
convert_cost(v::AbstractString) = error(
    "convert_cost: a String variant (\"$v\") — a time-series reference — is not implemented",
)

# ── ProductionVariableCostCurve: CostCurve / FuelCurve ─────────────────────────

function convert_cost(c::PC.CostCurve)
    value_curve = convert_cost(_require(c.value_curve, "CostCurve.value_curve"))
    vom_cost = _vom_cost(c.vom_cost)
    return _with_power_units(c.power_units) do units
        CostCurve(; value_curve = value_curve, power_units = units, vom_cost = vom_cost)
    end
end

function convert_cost(f::PC.FuelCurve)
    value_curve = convert_cost(_require(f.value_curve, "FuelCurve.value_curve"))
    fuel_cost = convert_cost(_require(f.fuel_cost, "FuelCurve.fuel_cost"))
    vom_cost = _vom_cost(f.vom_cost)
    return _with_power_units(f.power_units) do units
        FuelCurve(;
            value_curve = value_curve,
            power_units = units,
            fuel_cost = fuel_cost,
            vom_cost = vom_cost,
        )
    end
end

_optional_cost_curve(::Nothing) = zero(CostCurve)
_optional_cost_curve(c::PC.CostCurve) = convert_cost(c)

# ── start_up: a bare number, or a multi-stage / charge-discharge breakdown ────

convert_cost(s::PC.StartUpStages) = (hot = s.hot, warm = s.warm, cold = s.cold)

convert_cost(s::PC.StorageCostStartUpOneOf) = (charge = s.charge, discharge = s.discharge)

# ── Operation-cost containers emitted by the parser ──────────────────────────

function convert_cost(po::PC.ThermalGenerationCost)
    return ThermalGenerationCost(;
        variable = convert_cost(_require(po.variable, "ThermalGenerationCost.variable")),
        fixed = po.fixed,
        start_up = convert_cost(_require(po.start_up, "ThermalGenerationCost.start_up")),
        shut_down = po.shut_down,
    )
end

function convert_cost(po::PC.RenewableGenerationCost)
    return RenewableGenerationCost(;
        variable = convert_cost(_require(po.variable, "RenewableGenerationCost.variable")),
        curtailment_cost = _optional_cost_curve(po.curtailment_cost),
        fixed = po.fixed,
    )
end

function convert_cost(po::PC.HydroGenerationCost)
    return HydroGenerationCost(;
        variable = convert_cost(_require(po.variable, "HydroGenerationCost.variable")),
        fixed = po.fixed,
    )
end

function convert_cost(po::PC.LoadCost)
    return LoadCost(;
        variable = convert_cost(_require(po.variable, "LoadCost.variable")),
        fixed = po.fixed,
    )
end

"""
Static market bid. The document's `ancillary_service_offers` ids resolve to `Service`
objects only after every service is imported, so this conversion leaves the vector empty;
`_load_market_bid_service_offers!` fills it in a document-level pass.
"""
function convert_cost(po::PC.MarketBidCost)
    return MarketBidCost(;
        no_load_cost = convert_cost(
            _require(po.no_load_cost, "MarketBidCost.no_load_cost"),
        ),
        start_up = convert_cost(_require(po.start_up, "MarketBidCost.start_up")),
        shut_down = convert_cost(_require(po.shut_down, "MarketBidCost.shut_down")),
        incremental_offer_curves = convert_cost(
            _require(po.incremental_offer_curves, "MarketBidCost.incremental_offer_curves"),
        ),
        decremental_offer_curves = convert_cost(
            _require(po.decremental_offer_curves, "MarketBidCost.decremental_offer_curves"),
        ),
    )
end

function convert_cost(po::PC.HydroReservoirCost)
    return HydroReservoirCost(;
        level_shortage_cost = po.level_shortage_cost,
        level_surplus_cost = po.level_surplus_cost,
        spillage_cost = po.spillage_cost,
    )
end

function convert_cost(po::PC.StorageCost)
    return StorageCost(;
        charge_variable_cost = _optional_cost_curve(po.charge_variable_cost),
        discharge_variable_cost = _optional_cost_curve(po.discharge_variable_cost),
        fixed = po.fixed,
        start_up = convert_cost(_require(po.start_up, "StorageCost.start_up")),
        shut_down = po.shut_down,
        energy_shortage_cost = po.energy_shortage_cost,
        energy_surplus_cost = po.energy_surplus_cost,
    )
end

# ── Operating Reserve Demand Curve ─────────────────────────────────────────────
# A reserve's `variable` is never a FuelCurve; PSY stores `CostCurve{PiecewiseIncrementalCurve}`.

_as_piecewise_incremental(cost::CostCurve{PiecewiseIncrementalCurve}) = cost
_as_piecewise_incremental(cost::CostCurve) = error(
    "convert_cost: a reserve demand curve must be a PiecewiseIncrementalCurve CostCurve, " *
    "got CostCurve{$(typeof(get_value_curve(cost)))}",
)

"""Convert a reserve's `variable` field; `nothing` means no demand curve is defined."""
convert_reserve_variable(::Nothing) = ZERO_OFFER_CURVE
convert_reserve_variable(po::PC.CostCurve) = _as_piecewise_incremental(convert_cost(po))
