# Standalone exercise of `load_supplemental_attribute_associations!`/
# `load_time_series_associations!` (`src/openapi/sqlite_load.jl`), independent of
# `from_openapi(::Type{System}, doc)` — that entry point does not call these yet.
#
# `PowerCoreOpenAPIModels.document_from_json` validates referential integrity on its own
# (every `entity_id`/`attribute_id`/`owner_id` must name a row declared *somewhere* in the
# document) before this file's loaders ever run, so every document below is built on top of
# `make_openapi_test_doc()` (common.jl's shared fixture: Area=1, LoadZone=2, bus1=3, bus2=4,
# Arc=5, gen1=6, load1=7, spin_up reserve=8, shunt1=9) rather than a from-scratch minimal
# document — that keeps every id used here declared, while this file's own System/refs are
# still built directly (not via `from_openapi(System, doc)`), so it runs standalone.

"""A System/refs pair with bus1(3), bus2(4), gen1(6), and the spin_up reserve(8) — the
subset of `make_openapi_test_doc()`'s components these tests attach attributes/time series
to or use for service membership — registered under the SAME ids the document declares."""
function _sqlite_load_fixture()
    sys = System(100.0)
    refs = PSY.OpenAPIRefs("NATURAL_UNITS", 100.0)

    bus1 = ACBus(;
        number = 1, name = "bus1", available = true, bustype = ACBusTypes.REF,
        angle = 0.0, magnitude = 1.0, voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 138.0,
    )
    add_component!(sys, bus1)
    refs[3] = bus1

    bus2 = ACBus(;
        number = 2, name = "bus2", available = true, bustype = ACBusTypes.PQ,
        angle = 0.0, magnitude = 1.0, voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 138.0,
    )
    add_component!(sys, bus2)
    refs[4] = bus2

    gen = ThermalStandard(nothing)
    gen.bus = bus2
    gen.name = "gen1"
    add_component!(sys, gen)
    refs[6] = gen

    reserve = OnlineReserve{ReserveUp}(nothing)
    reserve.name = "spin_up"
    add_component!(sys, reserve)
    refs[8] = reserve

    return (sys = sys, refs = refs, bus1 = bus1, bus2 = bus2, gen = gen, reserve = reserve)
end

"""`make_openapi_test_doc()` with `supplemental_attributes`/`_associations`/
`service_associations`/`time_series_associations` overridden — every id these tests
reference (including the `entity_id = 100`-style attribute ids) must be declared under one
of those four, or `document_from_json` rejects the document before this file's loaders run
at all. `plant_associations`/`combined_cycle_associations` are always emptied: none of
these tests exercises a plant-family attribute."""
function _sqlite_load_doc(;
    supplemental_attributes = [],
    associations = [],
    service_associations = [],
    ts_rows = [],
)
    raw = make_openapi_test_doc()
    raw["supplemental_attributes"] = supplemental_attributes
    raw["supplemental_attribute_associations"] = associations
    raw["plant_associations"] = []
    raw["combined_cycle_associations"] = []
    raw["service_associations"] = service_associations
    raw["time_series_associations"] = ts_rows
    if !isempty(ts_rows)
        raw["time_series_storage_file"] = "sqlite_load_test_storage.h5"
    end
    return to_test_document(raw)
end

"""A real HDF5 sidecar holding one `SingleTimeSeries`; returns
`(path, uuid, values, resolution, initial_timestamp)`."""
function _sqlite_load_sidecar(dir)
    timestamps = [
        Dates.DateTime(2024, 1, 1, 0),
        Dates.DateTime(2024, 1, 1, 1),
        Dates.DateTime(2024, 1, 1, 2),
    ]
    values = [0.5, 0.6, 0.7]
    ta = TimeSeries.TimeArray(timestamps, values)
    series = SingleTimeSeries(; name = "max_active_power", data = ta)
    path = joinpath(dir, "sqlite_load_test_storage.h5")
    storage = IS.Hdf5TimeSeriesStorage(true; filename = path)
    IS.serialize_time_series!(storage, series)
    return (
        path = path,
        uuid = string(IS.get_uuid(series)),
        values = values,
        resolution = Dates.Hour(1),
        initial_timestamp = timestamps[1],
    )
end

function _sqlite_load_ts_row(; uuid, owner_id, owner_category)
    return Dict{String, Any}(
        "id" => 1,
        "time_series_uuid" => uuid,
        "time_series_type" => "SingleTimeSeries",
        "initial_timestamp" => "2024-01-01T00:00:00+00:00",
        "resolution" => "PT3600S",
        "length" => 3,
        "name" => "max_active_power",
        "owner_id" => owner_id,
        "owner_type" => "irrelevant-for-this-test",
        "owner_category" => owner_category,
        "features" => [],
        "scaling_factor_multiplier" => "get_max_active_power",
        "metadata_uuid" => "11111111-1111-1111-1111-111111111111",
    )
end

@testset "load_supplemental_attribute_associations!: shared attribute is one object" begin
    f = _sqlite_load_fixture()

    geo_po = PSY.PC.GeographicInfo(;
        id = 100,
        geo_json = Dict{String, Any}("type" => "Point", "coordinates" => [1.0, 2.0]),
    )
    doc = _sqlite_load_doc(;
        supplemental_attributes = [openapi_raw(geo_po)],
        associations = [
            Dict{String, Any}(
                "attribute_id" => 100, "entity_id" => 3,
                "attribute_type" => "GeographicInfo",
            ),
            Dict{String, Any}(
                "attribute_id" => 100, "entity_id" => 4,
                "attribute_type" => "GeographicInfo",
            ),
        ],
    )

    PSY.load_supplemental_attribute_associations!(f.sys, f.refs, doc)

    attrs1 = collect(get_supplemental_attributes(GeographicInfo, f.bus1))
    attrs2 = collect(get_supplemental_attributes(GeographicInfo, f.bus2))
    @test length(attrs1) == 1
    @test length(attrs2) == 1
    @test only(attrs1) === only(attrs2)

    # 1: the newly-built attribute is now resolvable by document id, exactly like a
    # component from the dependency-ordered component pass.
    @test PSY.resolve_uuid(f.refs, 100) == IS.get_uuid(only(attrs1))

    # 2 at the SQLite level: two rows (one per component), one distinct attribute_uuid.
    mgr = f.sys.data.supplemental_attribute_manager
    @test IS.get_num_attributes(mgr.associations) == 1
    summary = IS.get_attribute_summary_table(mgr.associations)
    row = only(filter(r -> r.attribute_type == "GeographicInfo", eachrow(summary)))
    @test row.component_type == "ACBus"
    @test row.count == 2
end

@testset "load_supplemental_attribute_associations!: service membership, no SQLite row" begin
    f = _sqlite_load_fixture()

    doc = _sqlite_load_doc(;
        service_associations = [
            Dict{String, Any}("service_id" => 8, "entity_id" => 6),
        ],
    )

    PSY.load_supplemental_attribute_associations!(f.sys, f.refs, doc)

    @test has_service(f.gen, f.reserve)
    # No supplemental-attribute association resulted: a Service is a Component.
    mgr = f.sys.data.supplemental_attribute_manager
    @test IS.get_num_attributes(mgr.associations) == 0
end

@testset "load_supplemental_attribute_associations!: loud errors" begin
    geo_po = PSY.PC.GeographicInfo(;
        id = 100,
        geo_json = Dict{String, Any}("type" => "Point", "coordinates" => [1.0, 2.0]),
    )

    # Unresolved entity_id: id=7 (load1) is a real component id in the document, but this
    # file's own `refs` never registered it — a `refs`/document mismatch, not a malformed
    # document, and exactly the case `document_from_json`'s own validation cannot catch.
    f = _sqlite_load_fixture()
    doc = _sqlite_load_doc(;
        supplemental_attributes = [openapi_raw(geo_po)],
        associations = [
            Dict{String, Any}(
                "attribute_id" => 100, "entity_id" => 7,
                "attribute_type" => "GeographicInfo",
            ),
        ],
    )
    @test_throws ErrorException PSY.load_supplemental_attribute_associations!(
        f.sys, f.refs, doc,
    )

    # An unresolved attribute_id (naming a component, or nothing at all) is no longer
    # reachable at the loader: `attribute_id` only ever means a supplemental attribute now
    # that service membership has its own table, so `document_from_json`'s own validation
    # (checked against the same `supplemental_attributes` list the loader indexes) rejects
    # it before a document with one can even be constructed.

    # attribute_type mismatch: declares "EmissionsData" but the row builds a GeographicInfo,
    # falls to IS's enum constructor
    f = _sqlite_load_fixture()
    doc = _sqlite_load_doc(;
        supplemental_attributes = [openapi_raw(geo_po)],
        associations = [
            Dict{String, Any}(
                "attribute_id" => 100, "entity_id" => 3,
                "attribute_type" => "EmissionsData",
            ),
        ],
    )
    @test_throws MethodError PSY.load_supplemental_attribute_associations!(
        f.sys, f.refs, doc,
    )

    # Missing attribute_type: `document_from_json` itself requires the field on every
    # association row (it resolves each raw `supplemental_attributes` dict's own type from
    # it), so this can only be reached by mutating an already-valid document's row in
    # place, bypassing that layer entirely.
    f = _sqlite_load_fixture()
    doc = _sqlite_load_doc(;
        supplemental_attributes = [openapi_raw(geo_po)],
        associations = [
            Dict{String, Any}(
                "attribute_id" => 100, "entity_id" => 3,
                "attribute_type" => "GeographicInfo",
            ),
        ],
    )
    doc.supplemental_attribute_associations[1].attribute_type = nothing
    @test_throws ErrorException PSY.load_supplemental_attribute_associations!(
        f.sys, f.refs, doc,
    )
end

@testset "load_time_series_associations!: Component owner" begin
    mktempdir() do dir
        sidecar = _sqlite_load_sidecar(dir)
        f = _sqlite_load_fixture()

        doc = _sqlite_load_doc(;
            ts_rows = [
                _sqlite_load_ts_row(;
                    uuid = sidecar.uuid, owner_id = 6, owner_category = "Component",
                ),
            ],
        )
        PSY.load_time_series_associations!(f.sys, f.refs, doc, sidecar.path)

        ts = get_time_series(SingleTimeSeries, f.gen, "max_active_power")
        @test TimeSeries.values(get_data(ts)) == sidecar.values
        @test get_resolution(ts) == sidecar.resolution
    end
end

@testset "load_time_series_associations!: SupplementalAttribute owner" begin
    mktempdir() do dir
        sidecar = _sqlite_load_sidecar(dir)
        f = _sqlite_load_fixture()

        # An `Outage` is the one `SupplementalAttribute` family that opts into
        # `supports_time_series` (`src/outages.jl`); `GeographicInfo` does not, and would
        # fail with an unrelated "does not support time series" `ArgumentError` regardless
        # of this loader.
        outage_po = PSY.PO.FixedForcedOutage(;
            id = 100, outage_status = 1.0, monitored_components = nothing,
        )
        attr_doc = _sqlite_load_doc(;
            supplemental_attributes = [openapi_raw(outage_po)],
            associations = [
                Dict{String, Any}(
                    "attribute_id" => 100, "entity_id" => 3,
                    "attribute_type" => "FixedForcedOutage",
                ),
            ],
        )
        PSY.load_supplemental_attribute_associations!(f.sys, f.refs, attr_doc)
        attribute = only(get_supplemental_attributes(FixedForcedOutage, f.bus1))

        # The gap import_document.jl's own `_attach_time_series!` still errors on
        # (owner_category=SupplementalAttribute): this loader closes it.
        # `supplemental_attributes`/`associations` are repeated here only so
        # `document_from_json` sees id=100 declared and typed — required at the document
        # layer regardless of what this loader itself reads.
        ts_doc = _sqlite_load_doc(;
            supplemental_attributes = [openapi_raw(outage_po)],
            associations = [
                Dict{String, Any}(
                    "attribute_id" => 100, "entity_id" => 3,
                    "attribute_type" => "FixedForcedOutage",
                ),
            ],
            ts_rows = [
                _sqlite_load_ts_row(;
                    uuid = sidecar.uuid, owner_id = 100,
                    owner_category = "SupplementalAttribute",
                ),
            ],
        )
        PSY.load_time_series_associations!(f.sys, f.refs, ts_doc, sidecar.path)

        ts = get_time_series(SingleTimeSeries, attribute, "max_active_power")
        @test TimeSeries.values(get_data(ts)) == sidecar.values

        store = f.sys.data.time_series_manager.metadata_store
        @test length(collect(IS.list_metadata(store, attribute))) == 1
    end
end

@testset "load_time_series_associations!: loud errors" begin
    mktempdir() do dir
        sidecar = _sqlite_load_sidecar(dir)

        # Unresolved owner_id: id=7 (load1) is a real component id in the document, but this
        # file's own `refs` never registered it.
        f = _sqlite_load_fixture()
        doc = _sqlite_load_doc(;
            ts_rows = [
                _sqlite_load_ts_row(;
                    uuid = sidecar.uuid, owner_id = 7, owner_category = "Component",
                ),
            ],
        )
        @test_throws ErrorException PSY.load_time_series_associations!(
            f.sys, f.refs, doc, sidecar.path,
        )

        # owner_category mismatch: owner_id=3 (bus1) resolves to a Component, not an
        # attribute.
        f = _sqlite_load_fixture()
        doc = _sqlite_load_doc(;
            ts_rows = [
                _sqlite_load_ts_row(;
                    uuid = sidecar.uuid, owner_id = 3,
                    owner_category = "SupplementalAttribute",
                ),
            ],
        )
        @test_throws ErrorException PSY.load_time_series_associations!(
            f.sys, f.refs, doc, sidecar.path,
        )

        # Associations present but no storage path given.
        f = _sqlite_load_fixture()
        doc = _sqlite_load_doc(;
            ts_rows = [
                _sqlite_load_ts_row(;
                    uuid = sidecar.uuid, owner_id = 3, owner_category = "Component",
                ),
            ],
        )
        @test_throws ErrorException PSY.load_time_series_associations!(
            f.sys, f.refs, doc, nothing,
        )
    end
end
