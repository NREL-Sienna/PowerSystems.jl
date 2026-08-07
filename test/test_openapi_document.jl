# Document-level OpenAPI import path. A small synthetic document exercises the
# dependency-ordered component pass, reserve membership, time series ingestion against a
# real HDF5 sidecar, ledger round-trip, and every loud-error path — not the full RTS
# fixture (too slow for this file; that is the controller's integration script).

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

        # DEVICE_MVAR (PSS/E RAW native) divides by the document's system base
        # (100 MVA) to land on PSY's SYSTEM_BASE pu storage: -50 MVAr / 100 MVA.
        shunt = get_component(FixedAdmittance, sys, "shunt1")
        @test get_bus(shunt) === bus2
        @test get_Y(shunt) == Complex(0.0, -0.5)

        # Reserve device membership, from a service-membership row in the unified
        # `supplemental_attribute_associations` table (D10).
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

        # Unresolved entity_id on a service-membership row: attribute_id (8) resolves to
        # the real "spin_up" reserve, but no component exists under entity_id 999.
        doc = make_openapi_test_doc()
        doc["supplemental_attribute_associations"] = [
            Dict{String, Any}(
                "attribute_id" => 8, "entity_id" => 999,
                "attribute_type" => "OnlineReserve",
            ),
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

        # Time series owner_category=SupplementalAttribute: documented gap, not implemented.
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
    emissions = PSY.from_openapi(EmissionsData, emissions_po)
    @test get_pollutant(emissions) == PollutantType.CO2
    @test get_basis(emissions) == EmissionBasis.FUEL_INPUT
    @test get_mass_unit(emissions) == MassUnit.LB
    @test get_energy_unit(emissions) == EnergyUnit.MMBTU

    outage_po = PSY.PO.GeometricDistributionForcedOutage(;
        id = 3, mean_time_to_recovery = 480, outage_transition_probability = 0.001,
        monitored_components = [1],
    )
    outage = PSY.from_openapi(GeometricDistributionForcedOutage, outage_po, refs)
    @test get_mean_time_to_recovery(outage) == 480.0
    @test get_monitored_components(outage) == Set([IS.get_uuid(bus)])

    fixed_po = PSY.PO.FixedForcedOutage(;
        id = 4,
        outage_status = 1.0,
        monitored_components = nothing,
    )
    fixed = PSY.from_openapi(FixedForcedOutage, fixed_po, refs)
    @test PSY.get_outage_status(fixed) == 1.0
    @test get_monitored_components(fixed) == Set{Base.UUID}()

    planned_po = PSY.PO.PlannedOutage(;
        id = 5, outage_schedule = "maintenance_2024", monitored_components = [1],
    )
    planned = PSY.from_openapi(PlannedOutage, planned_po, refs)
    @test get_outage_schedule(planned) == "maintenance_2024"

    plant_po = PSY.PO.ThermalPowerPlant(; id = 6, name = "plant1")
    plant = PSY.from_openapi(ThermalPowerPlant, plant_po)
    @test get_name(plant) == "plant1"

    hydro_plant =
        PSY.from_openapi(HydroPowerPlant, PSY.PO.HydroPowerPlant(; id = 7, name = "hp1"))
    @test get_name(hydro_plant) == "hp1"

    renewable_plant =
        PSY.from_openapi(
            RenewablePowerPlant,
            PSY.PO.RenewablePowerPlant(; id = 8, name = "rp1"),
        )
    @test get_name(renewable_plant) == "rp1"

    cc_block_po = PSY.PO.CombinedCycleBlock(;
        id = 9, name = "cc1", configuration = "SingleShaftCombustionSteam",
        heat_recovery_to_steam_factor = 0.5,
    )
    cc_block = PSY.from_openapi(CombinedCycleBlock, cc_block_po)
    @test get_configuration(cc_block) ==
          CombinedCycleConfiguration.SingleShaftCombustionSteam
    @test get_heat_recovery_to_steam_factor(cc_block) == 0.5

    cc_frac_po =
        PSY.PO.CombinedCycleFractional(; id = 10, name = "cc2", configuration = "Other")
    cc_frac = PSY.from_openapi(CombinedCycleFractional, cc_frac_po)
    @test get_configuration(cc_frac) == CombinedCycleConfiguration.Other

    geo_po = PSY.PC.GeographicInfo(;
        id = 11,
        geo_json = Dict{String, Any}("type" => "Point", "coordinates" => [1.0, 2.0]),
    )
    geo = PSY.from_openapi(GeographicInfo, geo_po)
    @test get_geo_json(geo)["type"] == "Point"

    # The PO layer's own OpenAPI-generated enum validation rejects an unmapped
    # pollutant before construction even completes (mirrors the reserve-direction
    # test in test_openapi_converters.jl) — the converter's own table errors loudly
    # too, exercised directly since a real PO struct can never carry a value outside
    # its own enum whitelist.
    @test_throws Exception PSY.PO.EmissionsData(;
        id = 12, name = "bad", pollutant = "BOGUS",
        emission_rate = emissions_po.emission_rate, basis = "FUEL_INPUT",
        mass_unit = "LB", energy_unit = "MMBTU",
    )
    @test_throws ErrorException PSY._enum_from_string(
        PSY.POLLUTANTTYPE_FROM_STRING, "BOGUS", "pollutant",
    )
end
