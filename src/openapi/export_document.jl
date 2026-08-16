# Hand-written (not generated): the document-level OpenAPI export path. Mirrors
# src/openapi/import_document.jl's structure in reverse: same `DOCUMENT_PLAN` type enumeration,
# same supplemental-attribute / service-membership / time-series machinery, inverted.
#
# Export (`to_openapi(sys; ...)`) assembles a `PowerCoreOpenAPIModels.SystemDocument`. Writing
# it to disk is `write_document`'s job, driven by `to_file` in src/openapi/file_io.jl.

# ── Supplemental attribute reverse converters ───────────────────────────────────
# Dispatches on the PSY attribute's concrete type rather than a runtime string → function
# table: export already knows the type. Only the emitted `attribute_type` string, read by
# `add_supplemental_attribute!` on the way back in, is derived from it.
#
# Same shape as the generated component exporters: `to_openapi(attr, refs)`, with the id
# read back via `component_id(refs, attr)` — the attribute walk registers each attribute
# under its document id before converting, exactly as the import direction does in
# sqlite_load.jl. None of these embed unit-converted fields, so unlike the per-component
# exporters they take no unit-system argument.

"""Resolve monitored-component ids (an `Outage`'s own storage) to document ids.
Empty means no association and reverses to `nothing`, the inverse of
`_monitored_component_uuids`'s own `nothing` -> empty-vector default.

An `Outage` stores the monitored components' IS ids, and `_export_id!` gives every component
that has an id of its own that same id in the document, so this is the identity on ids. It
still resolves each one through `refs` rather than passing it straight through: an id naming
something the document does not carry would otherwise be written as a dangling reference,
and only the reader would find out."""
function _monitored_component_ids(refs::OpenAPIRefs, ids)
    if isempty(ids)
        return nothing
    end
    document_ids = Int[]
    for id in ids
        refs[Int(id)]  # errors when the document carries no such component
        push!(document_ids, Int(id))
    end
    return document_ids
end

function to_openapi(attr::EmissionsData, refs::OpenAPIRefs)
    return PO.EmissionsData(;
        id = component_id(refs, attr),
        name = get_name(attr),
        pollutant = string(get_pollutant(attr)),
        emission_rate = PC.ValueCurve(convert_cost_to_openapi(get_emission_rate(attr))),
        basis = string(get_basis(attr)),
        start_up_adder = get_start_up_adder(attr),
        mass_unit = string(get_mass_unit(attr)),
        energy_unit = string(get_energy_unit(attr)),
        gwp = get_gwp(attr),
        available = get_available(attr),
    )
end

function to_openapi(outage::GeometricDistributionForcedOutage, refs::OpenAPIRefs)
    return PO.GeometricDistributionForcedOutage(;
        id = component_id(refs, outage),
        mean_time_to_recovery = Int(round(get_mean_time_to_recovery(outage))),
        outage_transition_probability = get_outage_transition_probability(outage),
        monitored_components = _monitored_component_ids(
            refs, get_monitored_components(outage),
        ),
    )
end

function to_openapi(outage::PlannedOutage, refs::OpenAPIRefs)
    return PO.PlannedOutage(;
        id = component_id(refs, outage),
        outage_schedule = get_outage_schedule(outage),
        monitored_components = _monitored_component_ids(
            refs, get_monitored_components(outage),
        ),
    )
end

function to_openapi(outage::FixedForcedOutage, refs::OpenAPIRefs)
    return PO.FixedForcedOutage(;
        id = component_id(refs, outage),
        outage_status = get_outage_status(outage),
        monitored_components = _monitored_component_ids(
            refs, get_monitored_components(outage),
        ),
    )
end

to_openapi(plant::ThermalPowerPlant, refs::OpenAPIRefs) =
    PO.ThermalPowerPlant(; id = component_id(refs, plant), name = get_name(plant))
to_openapi(plant::HydroPowerPlant, refs::OpenAPIRefs) =
    PO.HydroPowerPlant(; id = component_id(refs, plant), name = get_name(plant))
to_openapi(plant::RenewablePowerPlant, refs::OpenAPIRefs) =
    PO.RenewablePowerPlant(; id = component_id(refs, plant), name = get_name(plant))

function to_openapi(block::CombinedCycleBlock, refs::OpenAPIRefs)
    return PO.CombinedCycleBlock(;
        id = component_id(refs, block),
        name = get_name(block),
        configuration = string(get_configuration(block)),
        heat_recovery_to_steam_factor = get_heat_recovery_to_steam_factor(block),
    )
end

function to_openapi(frac::CombinedCycleFractional, refs::OpenAPIRefs)
    return PO.CombinedCycleFractional(;
        id = component_id(refs, frac),
        name = get_name(frac),
        configuration = string(get_configuration(frac)),
    )
end

# The InfrastructureSystems-owned attributes: IS holds the field mapping and takes the id
# directly, so these resolve it from `refs` and delegate.
to_openapi(geo::GeographicInfo, refs::OpenAPIRefs) =
    to_openapi(geo, component_id(refs, geo))
to_openapi(ds::DataSource, refs::OpenAPIRefs) =
    to_openapi(ds, component_id(refs, ds))

function to_openapi(attr::ImpedanceCorrectionData, refs::OpenAPIRefs)
    return PO.ImpedanceCorrectionData(;
        id = component_id(refs, attr),
        table_number = get_table_number(attr),
        impedance_correction_curve = convert_cost_to_openapi(
            get_impedance_correction_curve(attr),
        ),
        transformer_winding = string(get_transformer_winding(attr)),
        transformer_control_mode = string(get_transformer_control_mode(attr)),
    )
end

# ── component `ext` ──────────────────────────────────────────────────────────────
# Written through to `doc.ext[component_id]` verbatim, the reverse of `_merge_doc_ext!` in
# import_document.jl. `ext` is producer-side passthrough: PowerSystems stores it and never
# reads it, so it is neither validated nor mapped onto fields in either direction.
#
# `Arc`/`TransformerCircuit`/`TransmissionInterface` carry no `ext` field at all — nothing to
# write, so those overloads are no-ops rather than an error about a missing getter.

_export_ext!(::PC.SystemDocument, ::Int, ::Arc) = nothing
_export_ext!(::PC.SystemDocument, ::Int, ::TransformerCircuit) = nothing
_export_ext!(::PC.SystemDocument, ::Int, ::TransmissionInterface) = nothing

function _export_ext!(doc::PC.SystemDocument, id::Int, component)
    PC.set_ext!(doc, id, get_ext(component))
    return nothing
end

# ── unexportable components ─────────────────────────────────────────────────────

"""
Warn, naming each type and how many of it, when `sys` holds components no converter covers.

Those components are omitted from the document. This is accepted for now since dynamics is
deferred, so no dynamic type has a converter and a dynamics-bearing system cannot round-trip
through a document — but it is reported on every export rather than left silent, so a consumer
of the document knows what is not in it.

Warns rather than errors: blocking would make the document unusable as a cache format for
systems that carry dynamics, and dynamics is not going to production on this line yet. When a
converter is added to [`DOCUMENT_PLAN`](@ref), its type drops out of this warning automatically.
"""
function warn_unexportable_components(sys::System)
    counts = Dict{String, Int}()
    for component in get_components(Component, sys)
        if !is_document_exportable(component)
            name = string(nameof(typeof(component)))
            counts[name] = get(counts, name, 0) + 1
        end
    end
    isempty(counts) && return nothing
    listed = join(("$k ($(counts[k]))" for k in sort(collect(keys(counts)))), ", ")
    @warn "to_openapi: omitting component type(s) with no OpenAPI converter — they will not " *
          "be in the document and will not survive a round trip: $listed"
    return nothing
end

# ── unit_system resolution ──────────────────────────────────────────────────────

"""Resolve the `unit_system` kwarg to `(document_unit_system_string, ledger_or_nothing)`.
`:original` reads the round-trip ledger (`load_ledger` itself raises when absent);
`:device_base`/`:natural_units` force that convention explicitly and require no ledger."""
function _resolve_export_unit_system(sys::System, unit_system::Symbol)
    if unit_system === :original
        ledger = load_ledger(sys)
        return String(ledger["unit_system"]), ledger
    elseif unit_system === :device_base
        return "DEVICE_BASE", nothing
    elseif unit_system === :natural_units
        return "NATURAL_UNITS", nothing
    else
        error(
            "to_openapi(sys; unit_system=$unit_system): unmapped — expected :original, " *
            ":device_base, or :natural_units",
        )
    end
end

# ── id assignment ────────────────────────────────────────────────────────────────
# Builds an `OpenAPIRefs` and populates it via `refs[id] = component`, walking components in
# `DOCUMENT_PLAN` order (buses before the branches that reference them, etc. — the same order
# import uses; export does not need the ordering for resolution, since ids already exist or are
# assigned fresh, but keeping it identical simplifies testing and mirrors import 1:1).
#
# A component's document id IS its IS component id. That keeps the document and the
# InfraStore sidecar consistent by construction: the sidecar's catalog keys every series by
# component id, and import resolves a series' owner by looking that id up as a document id.
# Assigning document ids independently — as the ledger used to, reproducing them from a
# previous document — made the two disagree for any System not built by `from_openapi`, so a
# hand-built System carrying time series could not be exported at all.
#
# The ledger no longer carries ids for this reason; it survives only for `unit_system`. A
# `from_openapi`-built System reproduces its original document ids anyway, since import sets
# each component's id to its document id.
#
# `TransformerCircuit` has no id of its own (`_has_own_id` false — it is embedded in its
# owning transformer), so it draws from a counter that starts above every component id.

"""
The subcomponents a `HybridSystem` owns.

`add_component!(sys, hybrid)` moves them out of the System's own enumeration, so a
`get_components` walk never sees them — but the hybrid exports each one by id, so they have
to be registered and converted as components in their own right or the reference dangles.
All four subcomponent types are planned before `HybridSystem`, so they are registered by the
time the hybrid is converted.
"""
_hybrid_subcomponents(sys::System) = (
    sub for hybrid in get_components(HybridSystem, sys) for
    sub in get_subcomponents(hybrid)
)

"""Enumerate the live instances of a `DOCUMENT_PLAN` type. `TransformerCircuit` is a
`DeviceParameter` embedded in its owning transformer, never a standalone System component,
so it enumerates through the owners — both `TwoWindingTransformer` (one circuit) and
`ThreeWindingTransformer` (three, via `get_circuits`). `HybridSystem` subcomponents are
owned rather than embedded, but are equally invisible to `get_components`, so they are
folded back in per type."""
_plan_components(sys::System, ::Type{T}) where {T} = Iterators.flatten((
    get_components(T, sys),
    (sub for sub in _hybrid_subcomponents(sys) if sub isa T),
))
function _plan_components(sys::System, ::Type{TransformerCircuit})
    two_winding = (get_circuit(twt) for twt in get_components(TwoWindingTransformer, sys))
    three_winding = (
        c for t3w in get_components(ThreeWindingTransformer, sys) for
        c in get_circuits(t3w)
    )
    return Iterators.flatten((two_winding, three_winding))
end

"""The component's own id, or the next fresh one for a `TransformerCircuit`, which has
none (`_has_own_id` false)."""
function _export_id!(next_id::Base.RefValue{Int}, component)
    _has_own_id(component) && return IS.get_id(component)
    fresh = next_id[]
    next_id[] += 1
    return fresh
end

function _build_export_refs(sys::System, unit_system_string::AbstractString)
    refs = OpenAPIRefs(unit_system_string, get_base_power(sys))
    # Above every component id, so the ids minted for embedded circuits cannot collide with
    # one. Computed before the walk rather than tracked during it, since a circuit can be
    # reached before the component whose id would have raised the mark.
    highest = 0
    for (_po_type, psy_type, _key, _addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            _has_own_id(c) && (highest = max(highest, IS.get_id(c)))
        end
    end
    next_id = Ref(highest + 1)
    for (_po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            refs[_export_id!(next_id, c)] = c
        end
    end
    return refs
end

# ── component pass ───────────────────────────────────────────────────────────────

"""
Convert every component in [`DOCUMENT_PLAN`](@ref) order and add it to `doc`.

`add_component!` buckets by the PO type's own name and keeps each bucket concretely typed, so
the document's `components` map needs no key bookkeeping here.
"""
function _export_components!(
    doc::PC.SystemDocument,
    refs::OpenAPIRefs,
    sys::System,
    val::IS.AbstractUnitSystem,
)
    for (_po_type, psy_type, key, addable) in DOCUMENT_PLAN
        for c in _plan_components(sys, psy_type)
            PC.add_component!(doc, to_openapi(c, refs, val))
            _export_ext!(doc, component_id(refs, c), c)
        end
    end
    return nothing
end

# ── service membership (reverse of the service-membership branch in
# _attach_supplemental_attribute_associations!) ───────────────────────────────────
# Service membership is a row in its own `ServiceAssociation` table: `service_id` and
# `entity_id` both name components, so no `attribute_type` discriminator is needed.

function _export_service_associations(refs::OpenAPIRefs, sys::System)
    rows = PO.ServiceAssociation[]
    for device in get_components(Device, sys)
        supports_services(device) || continue
        for service in get_services(device)
            push!(
                rows,
                PO.ServiceAssociation(;
                    service_id = component_id(refs, service),
                    entity_id = component_id(refs, device),
                ),
            )
        end
    end
    for group in get_components(GroupReserve, sys)
        for contributing in get_contributing_services(group)
            push!(
                rows,
                PO.ServiceAssociation(;
                    service_id = component_id(refs, group),
                    entity_id = component_id(refs, contributing),
                ),
            )
        end
    end
    # `AGC.reserves` is the same membership shape as `GroupReserve.contributing_services`
    # above: no schema field on either side, carried by these rows instead.
    for agc in get_components(AGC, sys)
        for reserve in get_reserves(agc)
            push!(
                rows,
                PO.ServiceAssociation(;
                    service_id = component_id(refs, agc),
                    entity_id = component_id(refs, reserve),
                ),
            )
        end
    end
    return rows
end

# ── supplemental attributes (reverse of _attach_supplemental_attribute_associations!) ──

# A plant-family attribute (`ThermalPowerPlant`, `HydroPowerPlant`, `RenewablePowerPlant`,
# `CombinedCycleFractional`, `CombinedCycleBlock`) gets both a plain
# `SupplementalAttributeAssociation` row (for type resolution, like any other attribute) and
# an additional `PlantAssociation`/`CombinedCycleAssociation` row recording the group: the
# reverse of the plant-family `_attach_attribute!` dispatch on import. A plain attribute
# (`EmissionsData`, `GeographicInfo`, the `Outage` types) gets no group row at all, which is
# why this dispatches on the attribute type rather than on some separate "has a group" flag.
# `_group_indices` is used rather than the public reverse-map getters, which build a whole
# dict per call and would make this walk quadratic.
_group_association!(::Vector, ::Vector, ::SupplementalAttribute, ::Any, ::Int, ::Int) =
    nothing
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::ThermalPowerPlant,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(plant_rows, get_shaft_map(attr), entity, attr_id, entity_id)
    return nothing
end
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::HydroPowerPlant,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(plant_rows, get_penstock_map(attr), entity, attr_id, entity_id)
    return nothing
end
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::RenewablePowerPlant,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(plant_rows, get_pcc_map(attr), entity, attr_id, entity_id)
    return nothing
end
function _group_association!(
    plant_rows::Vector{PO.PlantAssociation},
    ::Vector,
    attr::CombinedCycleFractional,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    _push_plant_association!(
        plant_rows,
        get_operation_exclusion_map(attr),
        entity,
        attr_id,
        entity_id,
    )
    return nothing
end

"""Push a `PlantAssociation` row for `entity`'s single group in `group_map`, or nothing when
it holds none — the shape `group_index` takes in the document."""
function _push_plant_association!(
    plant_rows,
    group_map,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    indices = _group_indices(group_map, IS.get_id(entity))
    isempty(indices) && return nothing
    push!(
        plant_rows,
        PO.PlantAssociation(;
            plant_id = attr_id,
            entity_id = entity_id,
            group_index = only(indices),
        ),
    )
    return nothing
end

"""A CT/CA can feed more than one HRSG, but IS attaches a `CombinedCycleBlock` to a component
once regardless — so only the lowest HRSG number is representable per association row. Known
limitation: no index survived a document at all before the plant-attribute feature was added."""
function _group_association!(
    ::Vector,
    cc_rows::Vector{PO.CombinedCycleAssociation},
    attr::CombinedCycleBlock,
    entity,
    attr_id::Int,
    entity_id::Int,
)
    uuid = IS.get_id(entity)
    ct_hrsgs = _group_indices(get_hrsg_ct_map(attr), uuid)
    if !isempty(ct_hrsgs)
        push!(
            cc_rows,
            PO.CombinedCycleAssociation(;
                plant_id = attr_id,
                entity_id = entity_id,
                role = "CT",
                hrsg_index = first(ct_hrsgs),
            ),
        )
        return nothing
    end
    ca_hrsgs = _group_indices(get_hrsg_ca_map(attr), uuid)
    if !isempty(ca_hrsgs)
        push!(
            cc_rows,
            PO.CombinedCycleAssociation(;
                plant_id = attr_id,
                entity_id = entity_id,
                role = "CA",
                hrsg_index = first(ca_hrsgs),
            ),
        )
    end
    return nothing
end

"""
Emit the attribute rows and their associations, drawing attribute ids from `doc`'s counter.

Ids come from the document's single counter, not a private one: SiennaGridDB's `entities` table
keys a row by id without its type, so an id must mean exactly one thing across components *and*
supplemental attributes. Sharing the counter is what makes that true by construction — a
private counter here previously handed out attribute id 1 alongside component id 1.

Each attribute is registered into `refs` under its id before conversion, so
`to_openapi(attr, refs)` reads its own id back via `component_id` exactly like the generated
component exporters — and so `refs` covers attributes the same way the import direction's
does after `load_supplemental_attribute_associations!`.
"""
function _export_supplemental_attributes(
    sorted_refs,
    refs::OpenAPIRefs,
    doc::PC.SystemDocument,
)
    attribute_rows = Any[]
    association_rows = PC.SupplementalAttributeAssociation[]
    plant_association_rows = PO.PlantAssociation[]
    combined_cycle_association_rows = PO.CombinedCycleAssociation[]
    attr_ids = Dict{Int, Int}()
    for (entity_id, entity) in sorted_refs
        _has_own_id(entity) || continue
        for attr in get_supplemental_attributes(entity)
            attr_uuid = IS.get_id(attr)
            attr_id = get!(attr_ids, attr_uuid) do
                id = PC.next_id!(doc)
                refs[id] = attr
                push!(attribute_rows, to_openapi(attr, refs))
                return id
            end
            push!(
                association_rows,
                PC.SupplementalAttributeAssociation(;
                    attribute_id = attr_id,
                    entity_id = entity_id,
                    attribute_type = string(nameof(typeof(attr))),
                ),
            )
            _group_association!(
                plant_association_rows,
                combined_cycle_association_rows,
                attr,
                entity,
                attr_id,
                entity_id,
            )
        end
    end
    return attribute_rows,
    association_rows,
    plant_association_rows,
    combined_cycle_association_rows
end

# ── time series ────────────────────────────────────────────────────────────────
#
# The mirror of import's store adoption: the System's InfraStore *is* the sidecar, so export
# serializes it rather than walking series and emitting a metadata row each. The catalog it
# writes keys every series by (owner id, name, type, resolution/interval, features) — the
# same tuple `TimeSeriesAssociation` carries — so no `time_series_associations` rows are
# emitted. PowerTableDataParser writes its documents the same way.
#
# The catalog's owner ids are IS component ids, while the document's ids come from
# `_export_id!`. `_check_time_series_ids_match` below refuses to write a pair whose ids
# disagree, since the result would be a document whose sidecar no importer could resolve.

"""
Error when a supplemental attribute owns time series, which export cannot represent.

Component-owned series need no check: a component's document id is its IS component id, so
the sidecar catalog's owner ids and the document's ids agree by construction. Attribute
document ids are assigned fresh from the document counter instead, so an attribute's catalog
rows could never resolve on the way back in. Nothing this package produces hits it today —
no producer attaches series to an attribute — and supporting it means teaching export to
reproduce attribute ids too, so it errors rather than writing a pair that reads back short.
"""
function _check_time_series_ids_match(sorted_refs)
    for (_doc_id, entity) in sorted_refs
        entity isa SupplementalAttribute || continue
        IS.supports_time_series(entity) || continue
        has_time_series(entity) || continue
        error(
            "to_openapi: $(summary(entity)) carries time series, which is not supported " *
            "on export — attribute document ids are assigned fresh rather than reproduced, " *
            "so the sidecar catalog could not be resolved on import",
        )
    end
    return nothing
end

"""ISO 8601 duration, the reverse of `_parse_iso8601_seconds` (src/openapi/import_document.jl)."""
_iso8601_duration(period::Dates.Period) =
    string("PT", Dates.value(Dates.Second(period)), "S")

"""ISO 8601 duration for an optional period; `nothing` passes through."""
_iso8601_or_nothing(::Nothing) = nothing
_iso8601_or_nothing(p::Dates.Period) = _iso8601_duration(p)

"""The document's `unit_system` spelling for a series' declared basis.

`nothing` stays `nothing` — unspecified is not `NATURAL_UNITS`, and asserting a basis nobody
declared would be worse than omitting the field. `SU` has no document spelling: the schemas
carry no system-base option, since per-unit data historically on the system base records that
base in the component's own `base_power` and rides as `DEVICE_BASE`."""
_document_unit_system(::Nothing) = nothing
_document_unit_system(::NaturalUnit) = "NATURAL_UNITS"
_document_unit_system(::DeviceBaseUnit) = "DEVICE_BASE"
_document_unit_system(::SystemBaseUnit) = error(
    "to_openapi: a time series declares the system-base unit system, which the document " *
    "cannot express — the schemas offer NATURAL_UNITS and DEVICE_BASE only",
)

"""`features` as the document's array-of-single-entry-objects, from the key's own dict."""
function _document_features(key)
    return [
        Dict(String(k) => PC.FeatureValue(v)) for (k, v) in IS.get_features(key)
    ]
end

"""Forecast shape columns — `(horizon, interval, window_count)` — or all three `nothing` for a
static series, which has no forecast axis."""
_forecast_columns(::IS.StaticTimeSeriesKey) = (nothing, nothing, nothing)
_forecast_columns(key::IS.ForecastKey) = (
    _iso8601_or_nothing(IS.get_horizon(key)),
    _iso8601_or_nothing(IS.get_interval(key)),
    IS.get_count(key),
)

"""`length` column: a static series' own length. A forecast's shape is described by
horizon/interval/window_count instead, so it carries none."""
_document_length(key::IS.StaticTimeSeriesKey) = IS.get_length(key)
_document_length(::IS.ForecastKey) = nothing

"""
One `TimeSeriesAssociation` row for `key` on `entity`.

Identity and shape come off the key; `units`, `quantity_type` and `unit_system` are declared
on the series itself, so the series is read to reach them.

Two optional columns are deliberately omitted. `element_type` is derived from the stored
array's layout and InfraStore owns that derivation — duplicating it here would be a second
source of truth for exactly the thing the schema says the writing package derives, and
IS exposes no accessor for it. `application_data` is a package-owned payload PowerSystems
does not set.
"""
function _time_series_row(doc::PC.SystemDocument, entity, entity_id::Int, key)
    ts = get_time_series(entity, key)
    horizon, interval, window_count = _forecast_columns(key)
    return PC.TimeSeriesAssociation(;
        id = PC.next_id!(doc),
        time_series_type = string(nameof(IS.get_time_series_type(key))),
        initial_timestamp = TimeZones.ZonedDateTime(
            IS.get_initial_timestamp(key), TimeZones.TimeZone("UTC"),
        ),
        resolution = _iso8601_duration(IS.get_resolution(key)),
        horizon = horizon,
        interval = interval,
        window_count = window_count,
        length = _document_length(key),
        name = IS.get_name(key),
        owner_id = entity_id,
        owner_type = string(nameof(typeof(entity))),
        owner_category = _owner_category(entity),
        features = _document_features(key),
        units = IS.get_units(ts),
        # The document spells this `quantity_type`; IS and InfraStore spell the same field
        # `quantity_kind`. One of the two names should win; until then this is the bridge.
        quantity_type = IS.get_quantity_kind(ts),
        unit_system = _document_unit_system(IS.get_unit_system(ts)),
    )
end

_owner_category(::SupplementalAttribute) = "SupplementalAttribute"
_owner_category(::Any) = "Component"

"""
Write the System's time series to `time_series_storage_path` and describe them in the
document.

Both halves matter and neither is redundant: the sidecar holds the values, and the document
lists one row per series so a consumer can see what a bundle contains — and in what units, on
what basis — without opening the store. The row is an index into the sidecar, keyed the way
the sidecar keys its own catalog: `(owner id, name, type, resolution/interval, features)`.
"""
function _export_all_time_series(
    doc::PC.SystemDocument,
    sys::System,
    sorted_refs,
    time_series_storage_path,
)
    rows = PC.TimeSeriesAssociation[]
    store = sys.data.time_series_manager.data_store
    # Counted, not `isempty(store)`: one store holds the supplemental attribute associations
    # as well, so a System with attributes and no series has a non-empty store and would
    # otherwise demand a sidecar it has nothing to put in.
    IS.get_num_time_series(store) == 0 && return rows
    isnothing(time_series_storage_path) && error(
        "to_openapi: $(IS.get_num_time_series(store)) time series are attached but no " *
        "time_series_storage_path was given — cannot write the sidecar",
    )
    _check_time_series_ids_match(sorted_refs)
    for (entity_id, entity) in sorted_refs
        _has_own_id(entity) || continue
        IS.supports_time_series(entity) || continue
        has_time_series(entity) || continue
        for key in get_time_series_keys(entity)
            push!(rows, _time_series_row(doc, entity, entity_id, key))
        end
    end
    IS.serialize(store, String(time_series_storage_path))
    return rows
end

# ── document-level entry point ──────────────────────────────────────────────────

"""
$(TYPEDSIGNATURES)

Build a `PowerCoreOpenAPIModels.SystemDocument` from `sys`, the reverse of
`from_openapi(::Type{System}, doc)`.

Returns the typed container, not JSON: writing it to disk belongs to
`PowerCoreOpenAPIModels.write_document`, which [`to_file`](@ref) drives. Every id in the result
— components and supplemental attributes alike — comes from the document's single counter, since
consumers key a row by id without its type.

`unit_system`: `:original` (default) reproduces the document `sys` was read from — requires an
OpenAPI round-trip ledger (`from_openapi`-built `System`s carry one; [`load_ledger`](@ref)
raises when absent). `:device_base`/`:natural_units` force that convention explicitly and need
no ledger, so a `System` built directly via `add_component!` is exportable too.

Walks components in [`DOCUMENT_PLAN`](@ref) order (symmetry with import, not a resolution
requirement — every id already exists or is assigned fresh before it is ever read). Emits
`PO.Line.base_power` (and the equivalent on every system-base-denormalized type) as
`get_base_power(sys)` exactly — not reconstructed.

Component `ext` is written through verbatim to `doc.ext`. Errors loudly rather than silently
dropping data: a time series with no `time_series_storage_path` given, or an unmapped
`scaling_factor_multiplier` function.
"""
function to_openapi(
    sys::System;
    unit_system::Symbol = :original,
    time_series_storage_path = nothing,
)
    warn_unexportable_components(sys)
    unit_system_string, _ledger = _resolve_export_unit_system(sys, unit_system)
    refs = _build_export_refs(sys, unit_system_string)
    val = _unit_val(unit_system_string)

    doc = PC.SystemDocument(
        get_base_power(sys);
        unit_system = unit_system_string,
        name = get_name(sys),
        description = get_description(sys),
        frequency = sys.frequency,
        time_series_storage_file = _sidecar_basename(time_series_storage_path),
    )
    # Component ids are already assigned (from the ledger or fresh); tell the document so its
    # counter continues past them instead of reissuing one to a supplemental attribute.
    _reserve_component_ids!(doc, refs)

    _export_components!(doc, refs, sys, val)
    _export_market_bid_service_offers!(doc, refs)
    # One id-ordered snapshot of the registry, shared by both document-order-sensitive
    # walks below rather than each re-collecting and re-sorting it.
    sorted_refs = sort(collect(refs.by_id); by = first)
    supplemental_attributes,
    supplemental_attribute_associations,
    plant_associations,
    combined_cycle_associations = _export_supplemental_attributes(sorted_refs, refs, doc)
    append!(doc.supplemental_attributes, supplemental_attributes)
    append!(doc.supplemental_attribute_associations, supplemental_attribute_associations)
    append!(doc.plant_associations, plant_associations)
    append!(doc.combined_cycle_associations, combined_cycle_associations)
    append!(doc.service_associations, _export_service_associations(refs, sys))
    append!(
        doc.time_series_associations,
        _export_all_time_series(doc, sys, sorted_refs, time_series_storage_path),
    )

    PC.validate_document(doc)
    return doc
end

_sidecar_basename(::Nothing) = nothing
_sidecar_basename(path) = basename(String(path))

"""
Fill each exported `MarketBidCost`'s `ancillary_service_offers` with the ids of the offered
services. Runs after `_export_components!` so every service already has an id;
`convert_cost_to_openapi(::MarketBidCost)` exports the list empty because the per-cost
converter has no id registry.
"""
function _export_market_bid_service_offers!(doc::PC.SystemDocument, refs::OpenAPIRefs)
    for po_components in values(doc.components), po in po_components
        hasproperty(po, :operation_cost) || continue
        po_cost = po.operation_cost
        po_cost isa PC.MarketBidCost || continue
        component = refs.by_id[Int(po.id)]
        offers = get_ancillary_service_offers(get_operation_cost(component))
        isempty(offers) && continue
        po_cost.ancillary_service_offers =
            Int64[refs.id_by_component[service] for service in offers]
    end
    return nothing
end

function _reserve_component_ids!(doc::PC.SystemDocument, refs::OpenAPIRefs)
    if isempty(refs.by_id)
        return nothing
    end
    PC.reserve_ids!(doc, maximum(keys(refs.by_id)))
    return nothing
end
