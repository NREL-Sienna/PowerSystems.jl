# Document-level OpenAPI import path. A small synthetic document exercises the
# dependency-ordered component pass, reserve membership, time series ingestion against a
# real HDF5 sidecar, ledger round-trip, and every loud-error path.

# The shared document fixture lives in common.jl (`make_openapi_test_doc`,
# `openapi_raw`), also used by test_openapi_export.jl.

"""Build a real HDF5 sidecar holding one `SingleTimeSeries` and return
`(storage_path, time_series_uuid, values, resolution, initial_timestamp)`."""
function _openapi_test_sidecar(dir)
    timestamps = [
        Dates.DateTime(2024, 1, 1, 0),
        Dates.DateTime(2024, 1, 1, 1),
        Dates.DateTime(2024, 1, 1, 2),
    ]
    values = [0.5, 0.6, 0.7]
    ta = TimeSeries.TimeArray(timestamps, values)
    series = SingleTimeSeries(; name = "max_active_power", data = ta)
    path = joinpath(dir, "doc_time_series_storage.h5")
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

function _ts_association_row(; uuid, owner_id = 7, owner_category = "Component",
    time_series_type = "SingleTimeSeries",
    scaling_factor_multiplier = "get_max_active_power",
    horizon = nothing, interval = nothing, window_count = nothing,
    percentiles = nothing, scenario_count = nothing)
    return Dict{String, Any}(
        "id" => 1,
        "time_series_uuid" => uuid,
        "time_series_type" => time_series_type,
        "initial_timestamp" => "2024-01-01T00:00:00+00:00",
        "resolution" => "PT3600S",
        "horizon" => horizon,
        "interval" => interval,
        "window_count" => window_count,
        "length" => 3,
        "name" => "max_active_power",
        "owner_id" => owner_id,
        "owner_type" => "PowerLoad",
        "owner_category" => owner_category,
        "features" => [],
        "scaling_factor_multiplier" => scaling_factor_multiplier,
        "metadata_uuid" => "11111111-1111-1111-1111-111111111111",
        "percentiles" => percentiles,
        "scenario_count" => scenario_count,
    )
end

@testset "from_openapi(System, doc): end-to-end synthetic document" begin
    mktempdir() do dir
        sidecar = _openapi_test_sidecar(dir)
        doc = make_openapi_test_doc()
        doc["time_series_associations"] = [_ts_association_row(; uuid = sidecar.uuid)]
        # A document that declares time series must also name its sidecar; the kwarg only
        # says where to find it.
        doc["time_series_storage_file"] = basename(sidecar.path)

        sys = PSY.from_openapi(
            System, to_test_document(doc); time_series_storage_path = sidecar.path,
        )

        # Component counts.
        @test length(collect(get_components(Area, sys))) == 1
        @test length(collect(get_components(LoadZone, sys))) == 1
        @test length(collect(get_components(ACBus, sys))) == 2
        @test length(collect(get_components(Arc, sys))) == 1
        @test length(collect(get_components(ThermalStandard, sys))) == 1
        @test length(collect(get_components(PowerLoad, sys))) == 1
        @test length(collect(get_components(OnlineReserve, sys))) == 1
        @test length(collect(get_components(FixedAdmittance, sys))) == 1

        # A resolved reference: bus2's area/load_zone are the actual objects, not copies.
        bus2 = get_component(ACBus, sys, "bus2")
        @test get_name(get_area(bus2)) == "area1"
        @test get_name(get_load_zone(bus2)) == "lz1"

        # DEVICE_MVAR divides by the document's system base
        # (100 MVA) to land on PSY's SYSTEM_BASE pu storage: -50 MVAr / 100 MVA.
        shunt = get_component(FixedAdmittance, sys, "shunt1")
        @test get_bus(shunt) === bus2
        @test get_Y(shunt) == Complex(0.0, -0.5)

        # Reserve device membership, from a service_associations row.
        gen = get_component(ThermalStandard, sys, "gen1")
        reserve = get_component(OnlineReserve, sys, "spin_up")
        @test has_service(gen, reserve)

        # Time series, read back from the HDF5 sidecar.
        load = get_component(PowerLoad, sys, "load1")
        ts = get_time_series(SingleTimeSeries, load, "max_active_power")
        @test get_resolution(ts) == sidecar.resolution
        @test TimeSeries.values(get_data(ts)) == sidecar.values
        @test first(TimeSeries.timestamp(get_data(ts))) == sidecar.initial_timestamp
        @test IS.get_scaling_factor_multiplier(ts) === get_max_active_power

        # Ledger round-trip.
        @test PSY.has_ledger(sys)
        ledger = PSY.load_ledger(sys)
        @test ledger["unit_system"] == "NATURAL_UNITS"
        @test ledger["id_to_uuid"]["6"] == string(IS.get_uuid(gen))
    end
end

@testset "from_openapi(System, doc): loud errors" begin
    mktempdir() do dir
        sidecar = _openapi_test_sidecar(dir)

        # Unconverted component type: no from_openapi registered for "FooBarType".
        doc = make_openapi_test_doc()
        doc["components"]["FooBarType"] = [Dict{String, Any}("id" => 999)]
        @test_throws DocumentError PSY.from_openapi(System, to_test_document(doc))

        # Unresolved entity_id on a service-membership row: service_id (8) resolves to
        # the real "spin_up" reserve, but no component exists under entity_id 999.
        doc = make_openapi_test_doc()
        doc["service_associations"] = [
            Dict{String, Any}("service_id" => 8, "entity_id" => 999),
        ]
        @test_throws DocumentError PSY.from_openapi(System, to_test_document(doc))

        # Time series declared in a well-formed document, but no storage path passed: the
        # document names its sidecar, so the missing kwarg is the only defect.
        doc = make_openapi_test_doc()
        doc["time_series_associations"] = [_ts_association_row(; uuid = sidecar.uuid)]
        doc["time_series_storage_file"] = basename(sidecar.path)
        @test_throws DocumentError PSY.from_openapi(System, to_test_document(doc))

        # `Probabilistic` is a real PSY time-series type the document does not carry — it
        # needs a percentile-identity field the schema has no home for. A document naming
        # it must error rather than import a series with its percentiles invented.
        doc = make_openapi_test_doc()
        doc["time_series_associations"] = [
            _ts_association_row(;
                uuid = sidecar.uuid, time_series_type = "Probabilistic",
                horizon = "PT10800S", interval = "PT3600S", window_count = 3,
            ),
        ]
        doc["time_series_storage_file"] = basename(sidecar.path)
        @test_throws DocumentError PSY.from_openapi(
            System, to_test_document(doc); time_series_storage_path = sidecar.path,
        )

        # Unmapped scaling_factor_multiplier.
        doc = make_openapi_test_doc()
        doc["time_series_associations"] = [
            _ts_association_row(;
                uuid = sidecar.uuid,
                scaling_factor_multiplier = "get_bogus",
            ),
        ]
        doc["time_series_storage_file"] = basename(sidecar.path)
        @test_throws DocumentError PSY.from_openapi(
            System, to_test_document(doc); time_series_storage_path = sidecar.path,
        )

        # A declared owner_category must match what owner_id actually resolves to. Id 7 is a
        # Component here, so claiming SupplementalAttribute is a malformed document, not an
        # unimplemented case — SupplementalAttribute owners are supported (see sqlite_load.jl).
        doc = make_openapi_test_doc()
        doc["time_series_associations"] = [
            _ts_association_row(;
                uuid = sidecar.uuid,
                owner_category = "SupplementalAttribute",
            ),
        ]
        doc["time_series_storage_file"] = basename(sidecar.path)
        @test_throws DocumentError PSY.from_openapi(
            System, to_test_document(doc); time_series_storage_path = sidecar.path,
        )

        # Unmapped attribute_type: the association resolves to a real row, but no
        # converter is registered for the type it names.
        doc = make_openapi_test_doc()
        doc["supplemental_attributes"] =
            [Dict{String, Any}("id" => 1, "name" => "whatever")]
        doc["supplemental_attribute_associations"] = [
            Dict{String, Any}(
                "attribute_id" => 1, "entity_id" => 3, "attribute_type" => "BogusType",
            ),
        ]
        @test_throws DocumentError PSY.from_openapi(System, to_test_document(doc))

        # Association references an attribute_id with no matching row.
        doc = make_openapi_test_doc()
        doc["supplemental_attribute_associations"] = [
            Dict{String, Any}(
                "attribute_id" => 999, "entity_id" => 3,
                "attribute_type" => "GeographicInfo",
            ),
        ]
        @test_throws DocumentError PSY.from_openapi(System, to_test_document(doc))

        # Association references an unresolved entity_id.
        doc = make_openapi_test_doc()
        doc["supplemental_attributes"] =
            [openapi_raw(PSY.PC.GeographicInfo(; id = 1, geo_json = Dict{String, Any}()))]
        doc["supplemental_attribute_associations"] = [
            Dict{String, Any}(
                "attribute_id" => 1, "entity_id" => 999,
                "attribute_type" => "GeographicInfo",
            ),
        ]
        @test_throws DocumentError PSY.from_openapi(System, to_test_document(doc))
    end
end

@testset "from_openapi(System, doc): supplemental attribute real dispatch" begin
    doc = make_openapi_test_doc()
    geo_po = PSY.PC.GeographicInfo(;
        id = 100,
        geo_json = Dict{String, Any}("type" => "Point", "coordinates" => [1.0, 2.0]),
    )
    emissions_po = PSY.PO.EmissionsData(;
        id = 101, name = "gen1_CO2", pollutant = "CO2",
        emission_rate = PSY.PC.ValueCurve(
            PSY.PC.IncrementalCurve(;
                function_data = PSY.PC.IncrementalCurveFunctionData(
                    PSY.PC.LinearFunctionData(;
                        proportional_term = 0.0,
                        constant_term = 1.5,
                    ),
                ),
                initial_input = 0.0,
            ),
        ),
        basis = "FUEL_INPUT", start_up_adder = 0.0, mass_unit = "LB",
        energy_unit = "MMBTU", gwp = 1.0, available = true,
    )
    doc["supplemental_attributes"] = [openapi_raw(geo_po), openapi_raw(emissions_po)]
    doc["supplemental_attribute_associations"] = [
        Dict{String, Any}(
            "attribute_id" => 100,
            "entity_id" => 3,
            "attribute_type" => "GeographicInfo",
        ),
        Dict{String, Any}(
            "attribute_id" => 101,
            "entity_id" => 6,
            "attribute_type" => "EmissionsData",
        ),
    ]

    sys = PSY.from_openapi(System, to_test_document(doc))

    bus1 = get_component(ACBus, sys, "bus1")
    geo_attrs = get_supplemental_attributes(GeographicInfo, bus1)
    @test length(geo_attrs) == 1
    @test get_geo_json(only(geo_attrs))["type"] == "Point"

    gen = get_component(ThermalStandard, sys, "gen1")
    emissions_attrs = get_supplemental_attributes(EmissionsData, gen)
    @test length(emissions_attrs) == 1
    @test get_pollutant(only(emissions_attrs)) == PollutantType.CO2
end

@testset "OpenAPI supplemental attribute converters" begin
    refs = PSY.OpenAPIRefs("NATURAL_UNITS", 100.0)
    bus = ACBus(;
        number = 1, name = "bus1", available = true, bustype = ACBusTypes.REF,
        angle = 0.0, magnitude = 1.0, voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 138.0,
    )
    refs[1] = bus

    emissions_po = PSY.PO.EmissionsData(;
        id = 2, name = "gen1_CO2", pollutant = "CO2",
        emission_rate = PSY.PC.ValueCurve(
            PSY.PC.IncrementalCurve(;
                function_data = PSY.PC.IncrementalCurveFunctionData(
                    PSY.PC.LinearFunctionData(;
                        proportional_term = 0.0,
                        constant_term = 1.5,
                    ),
                ),
                initial_input = 0.0,
            ),
        ),
        basis = "FUEL_INPUT", start_up_adder = 0.0, mass_unit = "LB",
        energy_unit = "MMBTU", gwp = 1.0, available = true,
    )
    emissions = PSY.from_openapi(emissions_po, refs)
    @test get_pollutant(emissions) == PollutantType.CO2
    @test get_basis(emissions) == EmissionBasis.FUEL_INPUT
    @test get_mass_unit(emissions) == MassUnit.LB
    @test get_energy_unit(emissions) == EnergyUnit.MMBTU

    outage_po = PSY.PO.GeometricDistributionForcedOutage(;
        id = 3, mean_time_to_recovery = 480, outage_transition_probability = 0.001,
        monitored_components = [1],
    )
    outage = PSY.from_openapi(outage_po, refs)
    @test get_mean_time_to_recovery(outage) == 480.0
    @test get_monitored_components(outage) == Set([IS.get_uuid(bus)])

    fixed_po = PSY.PO.FixedForcedOutage(;
        id = 4,
        outage_status = 1.0,
        monitored_components = nothing,
    )
    fixed = PSY.from_openapi(fixed_po, refs)
    @test PSY.get_outage_status(fixed) == 1.0
    @test get_monitored_components(fixed) == Set{Base.UUID}()

    planned_po = PSY.PO.PlannedOutage(;
        id = 5, outage_schedule = "maintenance_2024", monitored_components = [1],
    )
    planned = PSY.from_openapi(planned_po, refs)
    @test get_outage_schedule(planned) == "maintenance_2024"

    plant_po = PSY.PO.ThermalPowerPlant(; id = 6, name = "plant1")
    plant = PSY.from_openapi(plant_po, refs)
    @test get_name(plant) == "plant1"

    hydro_plant =
        PSY.from_openapi(PSY.PO.HydroPowerPlant(; id = 7, name = "hp1"), refs)
    @test get_name(hydro_plant) == "hp1"

    renewable_plant =
        PSY.from_openapi(PSY.PO.RenewablePowerPlant(; id = 8, name = "rp1"), refs)
    @test get_name(renewable_plant) == "rp1"

    cc_block_po = PSY.PO.CombinedCycleBlock(;
        id = 9, name = "cc1", configuration = "SingleShaftCombustionSteam",
        heat_recovery_to_steam_factor = 0.5,
    )
    cc_block = PSY.from_openapi(cc_block_po, refs)
    @test get_configuration(cc_block) ==
          CombinedCycleConfiguration.SingleShaftCombustionSteam
    @test get_heat_recovery_to_steam_factor(cc_block) == 0.5

    cc_frac_po =
        PSY.PO.CombinedCycleFractional(; id = 10, name = "cc2", configuration = "Other")
    cc_frac = PSY.from_openapi(cc_frac_po, refs)
    @test get_configuration(cc_frac) == CombinedCycleConfiguration.Other

    geo_po = PSY.PC.GeographicInfo(;
        id = 11,
        geo_json = Dict{String, Any}("type" => "Point", "coordinates" => [1.0, 2.0]),
    )
    geo = PSY.from_openapi(geo_po, refs)
    @test get_geo_json(geo)["type"] == "Point"

    # The PO layer's own OpenAPI-generated enum validation rejects an unmapped
    # pollutant before construction even completes (mirrors the reserve-direction
    # test in test_openapi_converters.jl) — and the scoped-enum constructor the
    # converter uses errors loudly too, exercised directly since a real PO struct can
    # never carry a value outside its own enum whitelist.
    @test_throws Exception PSY.PO.EmissionsData(;
        id = 12, name = "bad", pollutant = "BOGUS",
        emission_rate = emissions_po.emission_rate, basis = "FUEL_INPUT",
        mass_unit = "LB", energy_unit = "MMBTU",
    )
    @test_throws Exception PollutantType("BOGUS")
end

@testset "MarketBidCost round trip: fields and ancillary service offer ids" begin
    sys = System(100.0)
    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    bus.bustype = ACBusTypes.REF
    add_component!(sys, bus)
    gen = ThermalStandard(nothing)
    gen.bus = bus
    gen.name = "gen1"
    add_component!(sys, gen)
    svc = OnlineReserve{ReserveUp}(;
        name = "RESERVE", available = true, time_frame = 10.0, requirement = 0.1)
    add_service!(sys, svc, [gen])

    mbc = MarketBidCost(;
        no_load_cost = LinearCurve(5.0),
        start_up = (hot = 100.0, warm = 200.0, cold = 300.0),
        shut_down = LinearCurve(2.0),
        incremental_offer_curves = make_market_bid_curve(
            [0.0, 50.0, 100.0], [10.0, 20.0], 0.0; power_units = IS.NaturalUnit(),
        ),
    )
    push!(get_ancillary_service_offers(mbc), svc)
    set_operation_cost!(gen, mbc)

    doc = to_openapi(sys; unit_system = :natural_units)
    sys2 = from_openapi(System, doc)

    gen2 = get_component(ThermalStandard, sys2, "gen1")
    mbc2 = get_operation_cost(gen2)
    @test mbc2 isa MarketBidCost
    @test get_no_load_cost(mbc2) == LinearCurve(5.0)
    @test get_start_up(mbc2) == (hot = 100.0, warm = 200.0, cold = 300.0)
    @test get_shut_down(mbc2) == LinearCurve(2.0)
    @test get_incremental_offer_curves(mbc2) == get_incremental_offer_curves(mbc)
    @test get_decremental_offer_curves(mbc2) == get_decremental_offer_curves(mbc)
    offers = get_ancillary_service_offers(mbc2)
    @test length(offers) == 1
    @test get_name(only(offers)) == "RESERVE"
    @test only(offers) === get_component(OnlineReserve{ReserveUp}, sys2, "RESERVE")
end

@testset "ThermalMultiStart round trip: multi-start fields and MarketBidCost" begin
    sys = System(100.0)
    bus = ACBus(nothing)
    bus.name = "bus1"
    bus.number = 1
    bus.bustype = ACBusTypes.REF
    add_component!(sys, bus)
    gen = ThermalMultiStart(nothing)
    gen.bus = bus
    gen.name = "ms1"
    gen.base_power = 50.0
    gen.active_power_limits = (min = 0.2, max = 1.0)
    gen.ramp_limits = (up = 0.1, down = 0.1)
    gen.power_trajectory = (startup = 0.3, shutdown = 0.25)
    gen.time_limits = (up = 2.0, down = 1.0)
    gen.start_time_limits = (hot = 2.0, warm = 4.0, cold = 8.0)
    gen.start_types = 3
    gen.must_run = true
    add_component!(sys, gen)
    svc = OnlineReserve{ReserveUp}(;
        name = "RESERVE", available = true, time_frame = 10.0, requirement = 0.1)
    add_service!(sys, svc, [gen])
    mbc = MarketBidCost(;
        incremental_offer_curves = make_market_bid_curve(
            [0.0, 25.0, 50.0], [12.0, 24.0], 0.0; power_units = IS.NaturalUnit(),
        ),
    )
    push!(get_ancillary_service_offers(mbc), svc)
    set_operation_cost!(gen, mbc)

    for unit_system in (:device_base, :natural_units)
        doc = to_openapi(sys; unit_system = unit_system)
        sys2 = from_openapi(System, doc)
        gen2 = get_component(ThermalMultiStart, sys2, "ms1")
        @test !isnothing(gen2)
        @test get_base_power(gen2) == 50.0
        @test get_active_power_limits(gen2, PSY.DU) == (min = 0.2, max = 1.0)
        @test get_ramp_limits(gen2, PSY.DU) == (up = 0.1, down = 0.1)
        @test get_power_trajectory(gen2, PSY.DU) == (startup = 0.3, shutdown = 0.25)
        @test get_time_limits(gen2) == (up = 2.0, down = 1.0)
        @test get_start_time_limits(gen2) == (hot = 2.0, warm = 4.0, cold = 8.0)
        @test get_start_types(gen2) == 3
        @test get_must_run(gen2)
        mbc2 = get_operation_cost(gen2)
        @test mbc2 isa MarketBidCost
        @test get_incremental_offer_curves(mbc2) == get_incremental_offer_curves(mbc)
        @test get_name(only(get_ancillary_service_offers(mbc2))) == "RESERVE"
    end
end

@testset "DOCUMENT_PLAN: converters match the declared pair" begin
    # `from_openapi` dispatches on the PO type, so `psy_type` no longer reaches the import
    # call and a mis-paired entry would go unnoticed at run time — `is_document_exportable`
    # is generated from it. Assert the pairing here instead: the converters exist in both
    # directions, and `from_openapi` on the `po_type` really does return the `psy_type`.
    #
    # A test rather than a load-time assertion on purpose: `generate_structs` runs inside
    # `PowerSystems`, so an assertion that fired on stale generated code would make the
    # module unloadable and take regeneration down with it.
    for (po_type, psy_type, key, _addable) in PSY.DOCUMENT_PLAN
        for units in (typeof(DU), typeof(NU))
            @test hasmethod(PSY.from_openapi, (po_type, PSY.OpenAPIRefs, units))
            @test hasmethod(PSY.to_openapi, (psy_type, PSY.OpenAPIRefs, units))
            returned = Base.return_types(
                PSY.from_openapi, (po_type, PSY.OpenAPIRefs, units),
            )
            @test length(returned) == 1
            @test only(returned) <: psy_type
        end
    end
end
