# Hand-written (not generated): the shared PO (OpenAPI model) → PSY cost/curve converter.
# One recursive `convert_cost` overloaded across every PO cost/curve type, plus the reserve
# ORDC PO.OnlineReserve/OfflineReserve.variable reuses. Every unmapped PO variant errors
# loudly naming the type — no fabricated `ThermalGenerationCost(nothing)`-style placeholders.
#
# PO fields are accessed with dot notation throughout (`po.value_curve`, `po.function_data`),
# matching the OpenAPI model convention — PO structs are `OpenAPI.jl`-generated kwarg structs,
# not PSY component types, so the "getters, not dot access" rule does not apply to them.
#
# `PC`/`PO` are the `PowerCoreOpenAPIModels`/`PowerOperationsOpenAPIModels` aliases set up
# in `src/PowerSystems.jl`. Several PO fields are "oneOf" wrapper structs (`.value` holds
# the concrete resolved instance, chosen by the document's discriminator field at deserialize
# time) — `convert_cost` has one unwrapping method per such wrapper so callers never need to
# spell `.value` themselves.

"""Required-field guard: dispatches on `Nothing` vs. anything else, per style (no
`isnothing(x) && ...` guards) — a required PO field read as `nothing` is malformed input."""
_require(::Nothing, context::AbstractString) =
    error("convert_cost: $context is required and missing")
_require(x, ::AbstractString) = x

_power_units_marker(::Nothing) =
    error("convert_cost: power_units is required and missing")
function _power_units_marker(s::AbstractString)
    s == "NATURAL_UNITS" && return NaturalUnit()
    s == "DEVICE_BASE" && return DeviceBaseUnit()
    error(
        "convert_cost: unmapped power_units \"$s\" — expected one of " *
        "NATURAL_UNITS, DEVICE_BASE",
    )
end

# ── FunctionData ────────────────────────────────────────────────────────────────

convert_cost(fd::PC.LinearFunctionData) =
    LinearFunctionData(fd.proportional_term, fd.constant_term)
convert_cost(fd::PC.QuadraticFunctionData) =
    QuadraticFunctionData(fd.quadratic_term, fd.proportional_term, fd.constant_term)
# `PiecewiseLinearData.points` is generated as a bare `Vector` (the element type is dropped
# from `Vector{XYCoords}`), so converting once restores inference for the per-point loop —
# this one scales with curve segments rather than components.
function convert_cost(fd::PC.PiecewiseLinearData)
    points = convert(Vector{PC.XYCoords}, fd.points)
    return PiecewiseLinearData([(x = p.x, y = p.y) for p in points])
end
convert_cost(fd::PC.PiecewiseStepData) = PiecewiseStepData(fd.x_coords, fd.y_coords)
convert_cost(fd) = error("convert_cost: unmapped FunctionData variant $(typeof(fd))")

# oneOf FunctionData wrappers: unwrap to the concrete variant above.
convert_cost(w::PC.InputOutputCurveFunctionData) = convert_cost(w.value)
convert_cost(w::PC.IncrementalCurveFunctionData) = convert_cost(w.value)
# The bare (context-free) FunctionData wrapper — used e.g. by HydroReservoir.head_to_volume_factor.
convert_cost(w::PC.FunctionData) = convert_cost(w.value)

# ── ValueCurve ──────────────────────────────────────────────────────────────────

convert_cost(vc::PC.InputOutputCurve) =
    InputOutputCurve(convert_cost(vc.function_data), vc.input_at_zero)
convert_cost(vc::PC.IncrementalCurve) =
    IncrementalCurve(convert_cost(vc.function_data), vc.initial_input, vc.input_at_zero)
convert_cost(vc::PC.AverageRateCurve) =
    AverageRateCurve(convert_cost(vc.function_data), vc.initial_input, vc.input_at_zero)

# oneOf ValueCurve wrapper: unwrap to the concrete variant above.
convert_cost(w::PC.ValueCurve) = convert_cost(w.value)

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
convert_cost(w::PC.FuelCurveFuelCost) = convert_cost(w.value)

# ── ProductionVariableCostCurve: CostCurve / FuelCurve ─────────────────────────

function convert_cost(c::PC.CostCurve)
    return CostCurve(;
        value_curve = convert_cost(_require(c.value_curve, "CostCurve.value_curve")),
        power_units = _power_units_marker(c.power_units),
        vom_cost = _vom_cost(c.vom_cost),
    )
end

function convert_cost(f::PC.FuelCurve)
    return FuelCurve(;
        value_curve = convert_cost(_require(f.value_curve, "FuelCurve.value_curve")),
        power_units = _power_units_marker(f.power_units),
        fuel_cost = convert_cost(_require(f.fuel_cost, "FuelCurve.fuel_cost")),
        vom_cost = _vom_cost(f.vom_cost),
    )
end

# oneOf ProductionVariableCostCurve wrapper: unwrap to the concrete variant above.
convert_cost(w::PC.ProductionVariableCostCurve) = convert_cost(w.value)

_optional_cost_curve(::Nothing) = zero(CostCurve)
_optional_cost_curve(c::PC.CostCurve) = convert_cost(c)

# ── start_up: a bare number, or a multi-stage / charge-discharge breakdown ────

convert_cost(s::PC.StartUpStages) = (hot = s.hot, warm = s.warm, cold = s.cold)
convert_cost(w::PC.ThermalGenerationCostStartUp) = convert_cost(w.value)

convert_cost(s::PC.StorageCostStartUpOneOf) = (charge = s.charge, discharge = s.discharge)
convert_cost(w::PC.StorageCostStartUp) = convert_cost(w.value)

# ── Per-component `operation_cost` oneOf wrappers ────────────────────────────
# Each component whose `operation_cost` is a oneOf gets its own generated wrapper named
# `<Component>OperationCost`, holding the resolved variant in `.value`. One unwrap method per
# wrapper, matching how the Core oneOf wrappers above are handled — a wrapper with no method
# falls through to the loud `unmapped FunctionData variant` error rather than being guessed at.

convert_cost(w::PO.ThermalStandardOperationCost) = convert_cost(w.value)
convert_cost(w::PO.ThermalMultiStartOperationCost) = convert_cost(w.value)
convert_cost(w::PO.RenewableDispatchOperationCost) = convert_cost(w.value)
convert_cost(w::PO.HydroDispatchOperationCost) = convert_cost(w.value)
convert_cost(w::PO.EnergyReservoirStorageOperationCost) = convert_cost(w.value)
convert_cost(w::PO.InterruptiblePowerLoadOperationCost) = convert_cost(w.value)

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

# ── Reserve Operating Reserve Demand Curve ─────────────────────────────────────
# PO.OnlineReserve/OfflineReserve.variable::Union{Nothing, PC.CostCurve} (never a FuelCurve —
# reserves are not fuel-priced); PSY stores `CostCurve{PiecewiseIncrementalCurve, U}`, with the
# `ZERO_OFFER_CURVE` sentinel for "no demand curve" (`nothing` in the document).

_as_piecewise_incremental(cost::CostCurve{PiecewiseIncrementalCurve}) = cost
_as_piecewise_incremental(cost::CostCurve) = error(
    "convert_cost: a reserve demand curve must be a PiecewiseIncrementalCurve CostCurve, " *
    "got CostCurve{$(typeof(get_value_curve(cost)))}",
)

"""Convert a reserve's PO `variable` (Operating Reserve Demand Curve) field: `nothing` means
no curve is defined and maps to `ZERO_OFFER_CURVE`; a present curve must reduce to
`CostCurve{PiecewiseIncrementalCurve}`."""
convert_reserve_variable(::Nothing) = ZERO_OFFER_CURVE
convert_reserve_variable(po::PC.CostCurve) = _as_piecewise_incremental(convert_cost(po))
