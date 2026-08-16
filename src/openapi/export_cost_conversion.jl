# Hand-written (not generated): the reverse of src/openapi/cost_conversion.jl — PSY cost/curve
# types → PO (OpenAPI model) structs. One `convert_cost_to_openapi` overloaded per PSY
# cost/curve type, inverting every case `convert_cost` (src/openapi/cost_conversion.jl) handles.
#
# Dispatch mirrors the PSY type hierarchy directly (abstract `ValueCurve`/`FunctionData`
# supertypes, `AbstractReserve`) rather than an enumerated `isa`/`Union` chain — the same style
# already used throughout this package. PO structs are built with kwargs; oneOf wrappers
# (`PC.ValueCurve`, `PC.FunctionData`, `PC.ProductionVariableCostCurve`, ...) take their concrete
# value positionally, matching how `PowerOperationsOpenAPIModels`/`PowerCoreOpenAPIModels`
# generate them.

_power_units_to_string(::NaturalUnit, ::ProductionVariableCostCurve) = "NATURAL_UNITS"
_power_units_to_string(::DeviceBaseUnit, ::ProductionVariableCostCurve) = "DEVICE_BASE"

"""`CostCurve.power_units`/`FuelCurve.power_units` carry no system-base member — a curve whose
per-unit data is on the system base is expected to record that base in the owning component's
`base_power` and ride as `DEVICE_BASE`. This converter is handed the curve alone (see the
`convert_cost_to_openapi(get_operation_cost(gen))` call sites), so it can neither check that the
component's `base_power` really is the system base nor rescale the curve's x-coordinates by
`system_base / device_base` if it is not. Relabelling would silently corrupt magnitudes, so fail
loudly instead (psy6 rule)."""
function _power_units_to_string(::SystemBaseUnit, cost::ProductionVariableCostCurve)
    error(
        "cannot export $(typeof(cost)) with power_units = SystemBaseUnit(): the OpenAPI " *
        "power_units enum accepts only DEVICE_BASE and NATURAL_UNITS, and this converter " *
        "has no access to the owning component's base_power to rescale the curve. Rebuild " *
        "the curve on the component's own base (DeviceBaseUnit) or in natural units first.",
    )
end

# ── FunctionData ────────────────────────────────────────────────────────────────

function convert_cost_to_openapi(fd::LinearFunctionData)
    return PC.LinearFunctionData(;
        proportional_term = get_proportional_term(fd),
        constant_term = get_constant_term(fd),
    )
end

function convert_cost_to_openapi(fd::QuadraticFunctionData)
    return PC.QuadraticFunctionData(;
        quadratic_term = get_quadratic_term(fd),
        proportional_term = get_proportional_term(fd),
        constant_term = get_constant_term(fd),
    )
end

function convert_cost_to_openapi(fd::PiecewiseLinearData)
    return PC.PiecewiseLinearData(;
        points = [PC.XYCoords(; x = p.x, y = p.y) for p in get_points(fd)],
    )
end

function convert_cost_to_openapi(fd::PiecewiseStepData)
    return PC.PiecewiseStepData(; x_coords = get_x_coords(fd), y_coords = get_y_coords(fd))
end

# ── ValueCurve ──────────────────────────────────────────────────────────────────
# Returns the bare PO curve struct (not the `PC.ValueCurve` oneOf wrapper) — callers wrap it
# where the field's spec type is the wrapper (`CostCurve.value_curve`) and use it bare where
# the spec type is the concrete curve directly (`vom_cost`, `TwoTerminalLoss`).

function convert_cost_to_openapi(curve::InputOutputCurve)
    return PC.InputOutputCurve(;
        function_data = PC.InputOutputCurveFunctionData(
            convert_cost_to_openapi(get_function_data(curve)),
        ),
        input_at_zero = get_input_at_zero(curve),
    )
end

function convert_cost_to_openapi(curve::IncrementalCurve)
    return PC.IncrementalCurve(;
        function_data = PC.IncrementalCurveFunctionData(
            convert_cost_to_openapi(get_function_data(curve)),
        ),
        initial_input = get_initial_input(curve),
        input_at_zero = get_input_at_zero(curve),
    )
end

function convert_cost_to_openapi(curve::AverageRateCurve)
    return PC.AverageRateCurve(;
        function_data = PC.IncrementalCurveFunctionData(
            convert_cost_to_openapi(get_function_data(curve)),
        ),
        initial_input = get_initial_input(curve),
        input_at_zero = get_input_at_zero(curve),
    )
end

# ── vom_cost: always a LINEAR InputOutputCurve, or `nothing` for the zero sentinel ─────

"""`LinearCurve(0.0)` is the sentinel `_vom_cost` maps `nothing` to on import;
reverse it back to `nothing` rather than emitting a spurious zero-cost curve."""
function _vom_cost_to_openapi(curve::InputOutputCurve)
    if curve == LinearCurve(0.0)
        return nothing
    end
    return convert_cost_to_openapi(curve)
end

# ── fuel_cost: PSY always stores a bare Float64 (the AbstractString/time-series variant is
# not implemented on import, so it can never appear in a PSY component to reverse) ─────

_fuel_cost_to_openapi(v::Real) = PC.FuelCurveFuelCost(Float64(v))

# ── ProductionVariableCostCurve: CostCurve / FuelCurve ─────────────────────────

function convert_cost_to_openapi(cost::CostCurve)
    return PC.CostCurve(;
        power_units = _power_units_to_string(get_power_units(cost), cost),
        value_curve = PC.ValueCurve(convert_cost_to_openapi(get_value_curve(cost))),
        vom_cost = _vom_cost_to_openapi(get_vom_cost(cost)),
    )
end

function convert_cost_to_openapi(cost::FuelCurve)
    return PC.FuelCurve(;
        power_units = _power_units_to_string(get_power_units(cost), cost),
        value_curve = PC.ValueCurve(convert_cost_to_openapi(get_value_curve(cost))),
        fuel_cost = _fuel_cost_to_openapi(get_fuel_cost(cost)),
        vom_cost = _vom_cost_to_openapi(get_vom_cost(cost)),
    )
end

"""`zero(CostCurve)` is the sentinel `_optional_cost_curve` maps `nothing` to on import;
reverse it back to `nothing` (curtailment_cost, storage charge/discharge_variable_cost)."""
function _optional_cost_curve_to_openapi(cost::CostCurve)
    if cost == zero(CostCurve)
        return nothing
    end
    return convert_cost_to_openapi(cost)
end

# ── start_up: a bare number, or a multi-stage / charge-discharge breakdown ────

_thermal_start_up_to_openapi(x::Real) = PC.ThermalGenerationCostStartUp(Float64(x))
function _thermal_start_up_to_openapi(x::NamedTuple)
    return PC.ThermalGenerationCostStartUp(
        PC.StartUpStages(; hot = x.hot, warm = x.warm, cold = x.cold),
    )
end

_storage_start_up_to_openapi(x::Real) = PC.StorageCostStartUp(Float64(x))
function _storage_start_up_to_openapi(x::NamedTuple)
    return PC.StorageCostStartUp(
        PC.StorageCostStartUpOneOf(; charge = x.charge, discharge = x.discharge),
    )
end

# ── Operation-cost containers ─────────────────────────────────────────────────

function convert_cost_to_openapi(cost::ThermalGenerationCost)
    return PC.ThermalGenerationCost(;
        fixed = get_fixed(cost),
        shut_down = get_shut_down(cost),
        start_up = _thermal_start_up_to_openapi(get_start_up(cost)),
        variable = PC.ProductionVariableCostCurve(
            convert_cost_to_openapi(get_variable(cost)),
        ),
    )
end

function convert_cost_to_openapi(cost::RenewableGenerationCost)
    return PC.RenewableGenerationCost(;
        variable = convert_cost_to_openapi(get_variable(cost)),
        curtailment_cost = _optional_cost_curve_to_openapi(get_curtailment_cost(cost)),
        fixed = get_fixed(cost),
    )
end

function convert_cost_to_openapi(cost::HydroGenerationCost)
    return PC.HydroGenerationCost(;
        fixed = get_fixed(cost),
        variable = PC.ProductionVariableCostCurve(
            convert_cost_to_openapi(get_variable(cost)),
        ),
    )
end

function convert_cost_to_openapi(cost::LoadCost)
    return PC.LoadCost(;
        variable = convert_cost_to_openapi(get_variable(cost)),
        fixed = get_fixed(cost),
    )
end

"""
Static market bid. `ancillary_service_offers` holds `Service` objects but the document
stores component ids, and this converter has no id registry, so it exports the list empty;
`_export_market_bid_service_offers!` fills the ids in a document-level pass.
"""
function convert_cost_to_openapi(cost::MarketBidCost)
    start_up = get_start_up(cost)
    return PC.MarketBidCost(;
        no_load_cost = convert_cost_to_openapi(get_no_load_cost(cost)),
        start_up = PC.StartUpStages(;
            hot = start_up.hot,
            warm = start_up.warm,
            cold = start_up.cold,
        ),
        shut_down = convert_cost_to_openapi(get_shut_down(cost)),
        incremental_offer_curves = convert_cost_to_openapi(
            get_incremental_offer_curves(cost),
        ),
        decremental_offer_curves = convert_cost_to_openapi(
            get_decremental_offer_curves(cost),
        ),
        ancillary_service_offers = Int64[],
    )
end

function convert_cost_to_openapi(cost::HydroReservoirCost)
    return PC.HydroReservoirCost(;
        level_shortage_cost = get_level_shortage_cost(cost),
        level_surplus_cost = get_level_surplus_cost(cost),
        spillage_cost = get_spillage_cost(cost),
    )
end

function convert_cost_to_openapi(cost::StorageCost)
    return PC.StorageCost(;
        charge_variable_cost = _optional_cost_curve_to_openapi(
            get_charge_variable_cost(cost),
        ),
        discharge_variable_cost = _optional_cost_curve_to_openapi(
            get_discharge_variable_cost(cost),
        ),
        fixed = get_fixed(cost),
        shut_down = get_shut_down(cost),
        start_up = _storage_start_up_to_openapi(get_start_up(cost)),
        energy_shortage_cost = get_energy_shortage_cost(cost),
        energy_surplus_cost = get_energy_surplus_cost(cost),
    )
end

# ── Reserve Operating Reserve Demand Curve ─────────────────────────────────────

"""Convert a reserve's `variable` (Operating Reserve Demand Curve) to its PO representation:
`ZERO_OFFER_CURVE` (no curve defined, per `has_demand_curve`) maps to `nothing`; a present
curve reduces to `PC.CostCurve`. Reuses `has_demand_curve` rather than reimplementing the
zero-detection logic (`_is_zero_offer_curve`, models/reserves.jl)."""
function convert_reserve_variable_to_openapi(reserve::AbstractReserve)
    if !has_demand_curve(reserve)
        return nothing
    end
    return convert_cost_to_openapi(get_variable(reserve))
end
