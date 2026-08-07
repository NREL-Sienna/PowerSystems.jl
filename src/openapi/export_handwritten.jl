# Hand-written (not generated): the reverse of src/openapi/import_handwritten.jl — PSY →
# PO for the types whose `from_openapi` had to be hand-written: abstract-typed references,
# fields with no device-level `base_power`, unclassifiable field kinds, a PSY/PO field-name
# mismatch, semantic (not unit) conversions, and the parametric reserves — see that file's
# header for the full reasoning per type, unchanged here.
#
# Reuses `_minmax_po*`/`_updown_po*`/`_fromto_po`/`_scale_optional_po` from
# export_generated_types.jl (included first) rather than redefining them.

# ── Reverse enum tables (inverted from the `<ENUM>_FROM_STRING` tables in
# import_handwritten.jl, same bijectivity argument as
# export_generated_types.jl). ──

const TRANSFORMERCONTROLOBJECTIVE_TO_STRING =
    _invert(TRANSFORMERCONTROLOBJECTIVE_FROM_STRING)
const TWOWINDINGTRANSFORMERSHUNTLOCATION_TO_STRING =
    _invert(TWOWINDINGTRANSFORMERSHUNTLOCATION_FROM_STRING)
const RESERVOIRDATATYPE_TO_STRING = _invert(RESERVOIRDATATYPE_FROM_STRING)
const STORAGETECH_TO_STRING = _invert(STORAGETECH_FROM_STRING)

# ── Arc ─────────────────────────────────────────────────────────────────────────
# No unit-converted fields; both unit-system methods identical (mirrors import).

function to_openapi(arc::Arc, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.Arc(;
        id = component_id(refs, arc),
        from_id = component_id(refs, get_from(arc)),
        to_id = component_id(refs, get_to(arc)),
    )
end

function to_openapi(arc::Arc, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(arc, refs, Val(:DEVICE_BASE))
end

# ── Area / LoadZone ─────────────────────────────────────────────────────────────
# peak_active_power/peak_reactive_power are fixed-natural (x-unit MW/MVAr) regardless of
# document unit_system (mirrors import — see import_handwritten.jl's header on this
# exact point) — multiply by `get_base_power(refs)` in BOTH methods. `load_response` has no
# `conversion_unit` and passes through unconverted in both.

function to_openapi(area::Area, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.Area(;
        id = component_id(refs, area),
        name = get_name(area),
        peak_active_power = get_peak_active_power(area, SU) * get_base_power(refs),
        peak_reactive_power = get_peak_reactive_power(area, SU) * get_base_power(refs),
        load_response = get_load_response(area),
        base_power = get_base_power(refs),
    )
end

function to_openapi(area::Area, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(area, refs, Val(:DEVICE_BASE))
end

function to_openapi(lz::LoadZone, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.LoadZone(;
        id = component_id(refs, lz),
        name = get_name(lz),
        peak_active_power = get_peak_active_power(lz, SU) * get_base_power(refs),
        peak_reactive_power = get_peak_reactive_power(lz, SU) * get_base_power(refs),
        base_power = get_base_power(refs),
    )
end

function to_openapi(lz::LoadZone, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(lz, refs, Val(:DEVICE_BASE))
end

# ── TransmissionInterface ───────────────────────────────────────────────────────
# `active_power_flow_limits` is fixed-natural (x-unit MW) regardless of document
# unit_system (mirrors import) — multiply by `get_base_power(refs)` in BOTH methods.
# `violation_penalty`/`direction_mapping` have no `conversion_unit` and pass through
# unconverted in both.

function to_openapi(tx::TransmissionInterface, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.TransmissionInterface(;
        id = component_id(refs, tx),
        name = get_name(tx),
        available = get_available(tx),
        active_power_flow_limits = _minmax_po_scaled(
            get_active_power_flow_limits(tx, SU),
            get_base_power(refs),
        ),
        violation_penalty = get_violation_penalty(tx),
        direction_mapping = get_direction_mapping(tx),
        base_power = get_base_power(refs),
    )
end

function to_openapi(tx::TransmissionInterface, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(tx, refs, Val(:DEVICE_BASE))
end

# ── Line ────────────────────────────────────────────────────────────────────────
# `r`/`x`/`b`/`g` are pu on system base already (identity in both methods). `rating`/
# `rating_b`/`rating_c`/`active_power_flow`/`reactive_power_flow` are pu on system base in PSY;
# `base_power` on export is `get_base_power(refs)` exactly — the document's per-line
# base_power is the denormalized system base, not reconstructed.

function to_openapi(line::Line, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.Line(;
        id = component_id(refs, line),
        name = get_name(line),
        available = get_available(line),
        active_power_flow = get_active_power_flow(line, SU),
        reactive_power_flow = get_reactive_power_flow(line, SU),
        arc = component_id(refs, get_arc(line)),
        r = get_r(line, SU),
        x = get_x(line, SU),
        base_power = get_base_power(refs),
        b = _fromto_po(get_b(line, SU)),
        rating = get_rating(line, SU),
        rating_b = get_rating_b(line, SU),
        rating_c = get_rating_c(line, SU),
        angle_limits = _minmax_po(get_angle_limits(line)),
        g = _fromto_po(get_g(line, SU)),
    )
end

function to_openapi(line::Line, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    sbp = get_base_power(refs)
    return PO.Line(;
        id = component_id(refs, line),
        name = get_name(line),
        available = get_available(line),
        active_power_flow = get_active_power_flow(line, SU) * sbp,
        reactive_power_flow = get_reactive_power_flow(line, SU) * sbp,
        arc = component_id(refs, get_arc(line)),
        r = get_r(line, SU),
        x = get_x(line, SU),
        base_power = sbp,
        b = _fromto_po(get_b(line, SU)),
        rating = get_rating(line, SU) * sbp,
        rating_b = _scale_optional_po(get_rating_b(line, SU), sbp),
        rating_c = _scale_optional_po(get_rating_c(line, SU), sbp),
        angle_limits = _minmax_po(get_angle_limits(line)),
        g = _fromto_po(get_g(line, SU)),
    )
end

# ── TransformerCircuit ──────────────────────────────────────────────────────────
# `r`/`x` are pu on the circuit's own `base_power` and identity in BOTH document unit systems
# (mirrors import — parameter_units is always emitted as "DEVICE_BASE", the only basis this
# pass implements on either side). `rating`/`rating_b`/`rating_c`/`active_power_flow`/
# `reactive_power_flow` scale by the circuit's own `base_power` under NATURAL_UNITS only.
# Reached only via its owning `TwoWindingTransformer`'s `to_openapi` — never a standalone
# System component (no `addable` entry of its own), so this method is called directly on the
# `TransformerCircuit` object the document walk already resolved to an id.

function to_openapi(circuit::TransformerCircuit, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.TransformerCircuit(;
        id = component_id(refs, circuit),
        available = get_available(circuit),
        arc = component_id(refs, get_arc(circuit)),
        tap = get_tap(circuit),
        alpha = get_α(circuit),
        parameter_units = "DEVICE_BASE",
        r = get_r(circuit, DU),
        x = get_x(circuit, DU),
        control_objective = TRANSFORMERCONTROLOBJECTIVE_TO_STRING[get_control_objective(
            circuit,
        )],
        regulated_bus_number = get_regulated_bus_number(circuit),
        control_limits = _minmax_po(get_control_limits(circuit)),
        controlled_quantity_limits = _minmax_po(get_controlled_quantity_limits(circuit)),
        number_of_tap_positions = get_number_of_tap_positions(circuit),
        rating = get_rating(circuit, DU),
        rating_b = get_rating_b(circuit, DU),
        rating_c = get_rating_c(circuit, DU),
        active_power_flow = get_active_power_flow(circuit, DU),
        reactive_power_flow = get_reactive_power_flow(circuit, DU),
        base_power = get_base_power(circuit),
        base_voltage_primary = get_base_voltage_primary(circuit),
        base_voltage_secondary = get_base_voltage_secondary(circuit),
    )
end

function to_openapi(circuit::TransformerCircuit, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    dbp = get_base_power(circuit)
    return PO.TransformerCircuit(;
        id = component_id(refs, circuit),
        available = get_available(circuit),
        arc = component_id(refs, get_arc(circuit)),
        tap = get_tap(circuit),
        alpha = get_α(circuit),
        parameter_units = "DEVICE_BASE",
        r = get_r(circuit, DU),
        x = get_x(circuit, DU),
        control_objective = TRANSFORMERCONTROLOBJECTIVE_TO_STRING[get_control_objective(
            circuit,
        )],
        regulated_bus_number = get_regulated_bus_number(circuit),
        control_limits = _minmax_po(get_control_limits(circuit)),
        controlled_quantity_limits = _minmax_po(get_controlled_quantity_limits(circuit)),
        number_of_tap_positions = get_number_of_tap_positions(circuit),
        rating = _scale_optional_po(get_rating(circuit, DU), dbp),
        rating_b = _scale_optional_po(get_rating_b(circuit, DU), dbp),
        rating_c = _scale_optional_po(get_rating_c(circuit, DU), dbp),
        active_power_flow = get_active_power_flow(circuit, DU) * dbp,
        reactive_power_flow = get_reactive_power_flow(circuit, DU) * dbp,
        base_power = dbp,
        base_voltage_primary = get_base_voltage_primary(circuit),
        base_voltage_secondary = get_base_voltage_secondary(circuit),
    )
end

# ── TwoWindingTransformer ───────────────────────────────────────────────────────
# `magnetizing_shunt` is pu on the circuit's `base_power` and identity in both document unit
# systems (mirrors import). Constructs the nested `PO.TransformerCircuit` inline via its own
# `to_openapi` method — the circuit is not looked up via `refs[id]`, matching how the import
# converter consumes an inline `po.circuit` rather than a reference (verified against
# import_handwritten.jl before assuming, per the task brief).

function to_openapi(xfmr::TwoWindingTransformer, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    circuit = get_circuit(xfmr)
    shunt = get_magnetizing_shunt(xfmr, DU)
    return PO.TwoWindingTransformer(;
        id = component_id(refs, xfmr),
        name = get_name(xfmr),
        circuit = component_id(refs, circuit),
        admittance_units = "DEVICE_BASE",
        magnetizing_shunt = _complex_number_po(shunt),
        shunt_location = TWOWINDINGTRANSFORMERSHUNTLOCATION_TO_STRING[get_shunt_location(
            xfmr,
        )],
    )
end

function to_openapi(xfmr::TwoWindingTransformer, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(xfmr, refs, Val(:DEVICE_BASE))
end

# ── ThreeWindingTransformer ──────────────────────────────────────────────────────
# Mirrors TwoWindingTransformer's `magnetizing_shunt` handling exactly. The pairwise
# impedances and their base powers are identity in DU (mirrors import); `parameter_units`/
# `admittance_units` are always emitted as "DEVICE_BASE", the only basis this pass
# implements on either side. `primary_circuit`/`secondary_circuit`/`tertiary_circuit`/
# `star_bus` resolve via `component_id`, not inline — the owning `TwoWindingTransformer`
# precedent for a nested `TransformerCircuit` is inline construction, but ThreeWindingTransformer's
# circuits are already registered as standalone document rows via `_plan_components`
# (export_document.jl), matching how import consumes them (`refs[po.primary_circuit]`).

const THREEWINDINGTRANSFORMERSHUNTLOCATION_TO_STRING =
    _invert(THREEWINDINGTRANSFORMERSHUNTLOCATION_FROM_STRING)

function to_openapi(xfmr::ThreeWindingTransformer, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    shunt = get_magnetizing_shunt(xfmr, DU)
    return PO.ThreeWindingTransformer(;
        id = component_id(refs, xfmr),
        name = get_name(xfmr),
        primary_circuit = component_id(refs, get_primary_circuit(xfmr)),
        secondary_circuit = component_id(refs, get_secondary_circuit(xfmr)),
        tertiary_circuit = component_id(refs, get_tertiary_circuit(xfmr)),
        star_bus = component_id(refs, get_star_bus(xfmr)),
        parameter_units = "DEVICE_BASE",
        r_12 = get_r_12(xfmr, DU),
        x_12 = get_x_12(xfmr, DU),
        r_23 = get_r_23(xfmr, DU),
        x_23 = get_x_23(xfmr, DU),
        r_31 = get_r_31(xfmr, DU),
        x_31 = get_x_31(xfmr, DU),
        base_power_12 = get_base_power_12(xfmr),
        base_power_23 = get_base_power_23(xfmr),
        base_power_31 = get_base_power_31(xfmr),
        admittance_units = "DEVICE_BASE",
        magnetizing_shunt = _complex_number_po(shunt),
        shunt_location = THREEWINDINGTRANSFORMERSHUNTLOCATION_TO_STRING[get_shunt_location(
            xfmr,
        )],
    )
end

function to_openapi(xfmr::ThreeWindingTransformer, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(xfmr, refs, Val(:DEVICE_BASE))
end

# ── FixedAdmittance ─────────────────────────────────────────────────────────────
# `Y` is stored in PSY as pu on the system base, but the wire enum has no system-base
# member: `ShuntAdmittanceUnitBasis` is `NATURAL_UNITS`/`DEVICE_MVAR` only, because a shunt
# has no device MVA rating of its own. Export therefore states `DEVICE_MVAR` — PSS/E RAW
# native, MVAr at unity voltage — and multiplies by the document-level system base, exactly
# inverting the `DEVICE_MVAR` division in `_fixed_admittance_pu`. Independent of what basis
# the document was originally imported from, mirroring TwoWindingTransformer's
# always-"DEVICE_BASE" export above.

function to_openapi(shunt::FixedAdmittance, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    y = get_Y(shunt) * get_base_power(refs)
    return PO.FixedAdmittance(;
        id = component_id(refs, shunt),
        name = get_name(shunt),
        available = get_available(shunt),
        bus = component_id(refs, get_bus(shunt)),
        admittance_units = "DEVICE_MVAR",
        Y = _complex_number_po(y),
    )
end

function to_openapi(shunt::FixedAdmittance, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(shunt, refs, Val(:DEVICE_BASE))
end

# ── TwoTerminalGenericHVDCLine ──────────────────────────────────────────────────
# No device base; power fields fall back to the document-level system base
# (`get_base_power(refs)`), same fallback reserves use. `loss` dispatches on PSY's two allowed
# `ValueCurve` shapes (`InputOutputCurve` for a linear loss, `IncrementalCurve` for a piecewise
# incremental one) — the import converter only implements the linear case, but PSY's own field
# type allows both (a `System` built directly, not round-tripped, may hold either), so export
# supports both rather than narrowing to what import currently reads.

_hvdc_loss_to_openapi(curve::Union{InputOutputCurve, IncrementalCurve}) =
    PC.TwoTerminalLoss(convert_cost_to_openapi(curve))

function to_openapi(
    hvdc::TwoTerminalGenericHVDCLine,
    refs::OpenAPIRefs,
    ::Val{:DEVICE_BASE},
)
    return PO.TwoTerminalGenericHVDCLine(;
        id = component_id(refs, hvdc),
        name = get_name(hvdc),
        available = get_available(hvdc),
        active_power_flow = get_active_power_flow(hvdc, SU),
        arc = component_id(refs, get_arc(hvdc)),
        active_power_limits_from = _minmax_po(get_active_power_limits_from(hvdc, SU)),
        active_power_limits_to = _minmax_po(get_active_power_limits_to(hvdc, SU)),
        reactive_power_limits_from = _minmax_po(get_reactive_power_limits_from(hvdc, SU)),
        reactive_power_limits_to = _minmax_po(get_reactive_power_limits_to(hvdc, SU)),
        loss = _hvdc_loss_to_openapi(get_loss(hvdc)),
        base_power = get_base_power(refs),
    )
end

function to_openapi(
    hvdc::TwoTerminalGenericHVDCLine,
    refs::OpenAPIRefs,
    ::Val{:NATURAL_UNITS},
)
    sbp = get_base_power(refs)
    return PO.TwoTerminalGenericHVDCLine(;
        id = component_id(refs, hvdc),
        name = get_name(hvdc),
        available = get_available(hvdc),
        active_power_flow = get_active_power_flow(hvdc, SU) * sbp,
        arc = component_id(refs, get_arc(hvdc)),
        active_power_limits_from = _minmax_po_scaled(
            get_active_power_limits_from(hvdc, SU),
            sbp,
        ),
        active_power_limits_to = _minmax_po_scaled(
            get_active_power_limits_to(hvdc, SU),
            sbp,
        ),
        reactive_power_limits_from =
        _minmax_po_scaled(get_reactive_power_limits_from(hvdc, SU), sbp),
        reactive_power_limits_to = _minmax_po_scaled(
            get_reactive_power_limits_to(hvdc, SU),
            sbp,
        ),
        loss = _hvdc_loss_to_openapi(get_loss(hvdc)),
        base_power = sbp,
    )
end

# ── HydroReservoir ──────────────────────────────────────────────────────────────
# No unit-converted fields; both unit-system methods identical (mirrors import).
# `initial_level`/`level_targets` are the one real conversion, inverting `_level_fraction`:
# fraction-of-`storage_level_limits.max` in PSY -> absolute in the document.
# `upstream_turbines`/`downstream_turbines`/`upstream_reservoirs`: PSY always holds a (possibly
# empty) vector; an empty vector reverses to `nothing` (the same absence `_hydro_units`/
# `_reservoir_devices` map `nothing` *to* on import — the natural inverse of that default).

function _level_absolute(::Nothing, ::Real)
    return nothing
end

function _level_absolute(fraction, max_level::Real)
    return fraction * max_level
end

function _hydro_unit_ids(refs::OpenAPIRefs, units::AbstractVector)
    if isempty(units)
        return nothing
    end
    return Int[component_id(refs, u) for u in units]
end

function to_openapi(res::HydroReservoir, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    limits = get_storage_level_limits(res)
    return PO.HydroReservoir(;
        id = component_id(refs, res),
        name = get_name(res),
        available = get_available(res),
        storage_level_limits = _minmax_po(limits),
        initial_level = _level_absolute(get_initial_level(res), limits.max),
        spillage_limits = _minmax_po_optional(get_spillage_limits(res)),
        inflow = get_inflow(res),
        outflow = get_outflow(res),
        level_targets = _level_absolute(get_level_targets(res), limits.max),
        intake_elevation = get_intake_elevation(res),
        head_to_volume_factor = PC.FunctionData(
            convert_cost_to_openapi(get_head_to_volume_factor(res)),
        ),
        upstream_turbines = _hydro_unit_ids(refs, get_upstream_turbines(res)),
        downstream_turbines = _hydro_unit_ids(refs, get_downstream_turbines(res)),
        upstream_reservoirs = _hydro_unit_ids(refs, get_upstream_reservoirs(res)),
        operation_cost = convert_cost_to_openapi(get_operation_cost(res)),
        evaporative_loss = get_evaporative_loss(res),
        level_data_type = RESERVOIRDATATYPE_TO_STRING[get_level_data_type(res)],
    )
end

function to_openapi(res::HydroReservoir, refs::OpenAPIRefs, ::Val{:NATURAL_UNITS})
    return to_openapi(res, refs, Val(:DEVICE_BASE))
end

# ── EnergyReservoirStorage ──────────────────────────────────────────────────────
# `storage_capacity` scales like any other device-base field even though it is an energy
# quantity (MWh), matching import's own rule for uniform division. `storage_level_limits`,
# `initial_storage_capacity_level`, `efficiency`, `conversion_factor`, `storage_target`,
# `self_discharge` are dimensionless and pass through in both methods. `energy_units` is always
# emitted as "MWH" (the only basis this pass implements on either side, per import's
# `_check_energy_units`).

function to_openapi(storage::EnergyReservoirStorage, refs::OpenAPIRefs, ::Val{:DEVICE_BASE})
    return PO.EnergyReservoirStorage(;
        id = component_id(refs, storage),
        name = get_name(storage),
        available = get_available(storage),
        bus = component_id(refs, get_bus(storage)),
        prime_mover_type = PRIMEMOVERS_TO_STRING[get_prime_mover_type(storage)],
        storage_technology_type = STORAGETECH_TO_STRING[get_storage_technology_type(
            storage,
        )],
        storage_capacity = get_storage_capacity(storage, DU),
        energy_units = "MWH",
        storage_level_limits = _minmax_po(get_storage_level_limits(storage)),
        initial_storage_capacity_level = get_initial_storage_capacity_level(storage),
        rating = get_rating(storage, DU),
        active_power = get_active_power(storage, DU),
        input_active_power_limits = _minmax_po(get_input_active_power_limits(storage, DU)),
        output_active_power_limits = _minmax_po(
            get_output_active_power_limits(storage, DU),
        ),
        efficiency = _inout_po(get_efficiency(storage)),
        reactive_power = get_reactive_power(storage, DU),
        reactive_power_limits = _minmax_po_optional(get_reactive_power_limits(storage, DU)),
        base_power = _get_base_power(storage),
        operation_cost = convert_cost_to_openapi(get_operation_cost(storage)),
        conversion_factor = get_conversion_factor(storage),
        storage_target = get_storage_target(storage),
        cycle_limits = get_cycle_limits(storage),
        ramp_limits = _updown_po_optional(get_ramp_limits(storage, DU)),
        self_discharge = get_self_discharge(storage),
        standing_loss = get_standing_loss(storage, DU),
    )
end

function to_openapi(
    storage::EnergyReservoirStorage,
    refs::OpenAPIRefs,
    ::Val{:NATURAL_UNITS},
)
    base = _get_base_power(storage)
    return PO.EnergyReservoirStorage(;
        id = component_id(refs, storage),
        name = get_name(storage),
        available = get_available(storage),
        bus = component_id(refs, get_bus(storage)),
        prime_mover_type = PRIMEMOVERS_TO_STRING[get_prime_mover_type(storage)],
        storage_technology_type = STORAGETECH_TO_STRING[get_storage_technology_type(
            storage,
        )],
        storage_capacity = get_storage_capacity(storage, DU) * base,
        energy_units = "MWH",
        storage_level_limits = _minmax_po(get_storage_level_limits(storage)),
        initial_storage_capacity_level = get_initial_storage_capacity_level(storage),
        rating = get_rating(storage, DU) * base,
        active_power = get_active_power(storage, DU) * base,
        input_active_power_limits =
        _minmax_po_scaled(get_input_active_power_limits(storage, DU), base),
        output_active_power_limits =
        _minmax_po_scaled(get_output_active_power_limits(storage, DU), base),
        efficiency = _inout_po(get_efficiency(storage)),
        reactive_power = get_reactive_power(storage, DU) * base,
        reactive_power_limits =
        _minmax_po_scaled_optional(get_reactive_power_limits(storage, DU), base),
        base_power = base,
        operation_cost = convert_cost_to_openapi(get_operation_cost(storage)),
        conversion_factor = get_conversion_factor(storage),
        storage_target = get_storage_target(storage),
        cycle_limits = get_cycle_limits(storage),
        ramp_limits = _updown_po_scaled_optional(get_ramp_limits(storage, DU), base),
        self_discharge = get_self_discharge(storage),
        standing_loss = get_standing_loss(storage, DU) * base,
    )
end

# ── Reserves: OnlineReserve, OfflineReserve, GroupReserve ───────────────────────
# `reserve_direction` resolves from the `T` type parameter through a literal table (the
# reverse of `RESERVE_DIRECTION`; direction is not a codegen case). `requirement` divides by /
# multiplies by the document-level `get_base_power(refs)` — a reserve has no device base of its
# own, same fallback `TwoTerminalGenericHVDCLine` uses. `variable` (the Operating Reserve
# Demand Curve) goes through `convert_reserve_variable_to_openapi` (already handles the
# `ZERO_OFFER_CURVE` → `nothing` default).

const RESERVE_DIRECTION_TO_STRING = _invert(RESERVE_DIRECTION)

function to_openapi(
    reserve::OnlineReserve{T, U},
    refs::OpenAPIRefs,
    ::Val{:DEVICE_BASE},
) where {T <: ReserveDirection, U}
    return PO.OnlineReserve(;
        id = component_id(refs, reserve),
        name = get_name(reserve),
        available = get_available(reserve),
        time_frame = get_time_frame(reserve),
        requirement = get_requirement(reserve, SU),
        variable = convert_reserve_variable_to_openapi(reserve),
        sustained_time = get_sustained_time(reserve),
        max_output_fraction = get_max_output_fraction(reserve),
        max_participation_factor = get_max_participation_factor(reserve),
        deployed_fraction = get_deployed_fraction(reserve),
        reserve_direction = RESERVE_DIRECTION_TO_STRING[T],
    )
end

function to_openapi(
    reserve::OnlineReserve{T, U},
    refs::OpenAPIRefs,
    ::Val{:NATURAL_UNITS},
) where {T <: ReserveDirection, U}
    return PO.OnlineReserve(;
        id = component_id(refs, reserve),
        name = get_name(reserve),
        available = get_available(reserve),
        time_frame = get_time_frame(reserve),
        requirement = get_requirement(reserve, SU) * get_base_power(refs),
        variable = convert_reserve_variable_to_openapi(reserve),
        sustained_time = get_sustained_time(reserve),
        max_output_fraction = get_max_output_fraction(reserve),
        max_participation_factor = get_max_participation_factor(reserve),
        deployed_fraction = get_deployed_fraction(reserve),
        reserve_direction = RESERVE_DIRECTION_TO_STRING[T],
    )
end

function to_openapi(
    reserve::OfflineReserve{U},
    refs::OpenAPIRefs,
    ::Val{:DEVICE_BASE},
) where {U}
    return PO.OfflineReserve(;
        id = component_id(refs, reserve),
        name = get_name(reserve),
        available = get_available(reserve),
        time_frame = get_time_frame(reserve),
        requirement = get_requirement(reserve, SU),
        variable = convert_reserve_variable_to_openapi(reserve),
        sustained_time = get_sustained_time(reserve),
        max_output_fraction = get_max_output_fraction(reserve),
        max_participation_factor = get_max_participation_factor(reserve),
        deployed_fraction = get_deployed_fraction(reserve),
    )
end

function to_openapi(
    reserve::OfflineReserve{U},
    refs::OpenAPIRefs,
    ::Val{:NATURAL_UNITS},
) where {U}
    return PO.OfflineReserve(;
        id = component_id(refs, reserve),
        name = get_name(reserve),
        available = get_available(reserve),
        time_frame = get_time_frame(reserve),
        requirement = get_requirement(reserve, SU) * get_base_power(refs),
        variable = convert_reserve_variable_to_openapi(reserve),
        sustained_time = get_sustained_time(reserve),
        max_output_fraction = get_max_output_fraction(reserve),
        max_participation_factor = get_max_participation_factor(reserve),
        deployed_fraction = get_deployed_fraction(reserve),
    )
end

function to_openapi(
    reserve::GroupReserve{T},
    refs::OpenAPIRefs,
    ::Val{:DEVICE_BASE},
) where {T <: ReserveDirection}
    return PO.GroupReserve(;
        id = component_id(refs, reserve),
        name = get_name(reserve),
        available = get_available(reserve),
        requirement = get_requirement(reserve, SU),
        reserve_direction = RESERVE_DIRECTION_TO_STRING[T],
    )
end

function to_openapi(
    reserve::GroupReserve{T},
    refs::OpenAPIRefs,
    ::Val{:NATURAL_UNITS},
) where {T <: ReserveDirection}
    return PO.GroupReserve(;
        id = component_id(refs, reserve),
        name = get_name(reserve),
        available = get_available(reserve),
        requirement = get_requirement(reserve, SU) * get_base_power(refs),
        reserve_direction = RESERVE_DIRECTION_TO_STRING[T],
    )
end
