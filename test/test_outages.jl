@testset "Test outages" begin
    sys = create_system_with_outages()
    gens = collect(get_components(ThermalStandard, sys))
    gen1 = gens[1]
    gen2 = gens[2]
    @test length(get_supplemental_attributes(Outage, sys)) == 4
    forced_outages =
        collect(get_supplemental_attributes(GeometricDistributionForcedOutage, sys))
    @test length(forced_outages) == 2
    @test get_supplemental_attribute(sys, IS.get_id(forced_outages[1])) ==
          forced_outages[1]
    planned_outages = collect(get_supplemental_attributes(PlannedOutage, sys))
    @test length(planned_outages) == 2
    @test get_supplemental_attribute(sys, IS.get_id(planned_outages[1])) ==
          planned_outages[1]

    geos = get_supplemental_attributes(GeographicInfo, sys)
    for geo in geos
        @test length(get_associated_components(sys, geo)) == 2
        @test length(
            get_associated_components(sys, geo; component_type = ThermalStandard),
        ) == 1
    end

    associated_components = get_associated_components(sys, GeographicInfo)
    @test length(associated_components) == 4
    @test Set([typeof(x) for x in associated_components]) == Set([ACBus, ThermalStandard])

    associated_components =
        get_associated_components(sys, GeographicInfo; component_type = ThermalGen)
    @test length(associated_components) == 2

    for gen in (gen1, gen2)
        for type in (GeometricDistributionForcedOutage, PlannedOutage, GeographicInfo)
            attributes = get_supplemental_attributes(type, gen)
            @test length(attributes) == 1
            uuid = IS.get_id(attributes[1])
            get_supplemental_attribute(sys, uuid)
            get_supplemental_attribute(gen, uuid)
            @test get_supplemental_attribute(gen, uuid) ==
                  get_supplemental_attribute(sys, uuid)
        end
    end

    @test length(
        get_supplemental_attributes(
            x -> get_mean_time_to_recovery(x) == 2.0,
            GeometricDistributionForcedOutage,
            sys,
        ),
    ) == 1
    @test length(
        get_supplemental_attributes(
            x -> get_mean_time_to_recovery(x) == 2.0,
            GeometricDistributionForcedOutage,
            gen1,
        ),
    ) == 0
    @test length(
        get_supplemental_attributes(
            x -> get_mean_time_to_recovery(x) == 2.0,
            GeometricDistributionForcedOutage,
            gen2,
        ),
    ) == 1
    @test length(
        get_supplemental_attributes(x -> get_outage_schedule(x) == "1", PlannedOutage, sys),
    ) == 1
    @test length(
        get_supplemental_attributes(
            x -> get_outage_schedule(x) == "1",
            PlannedOutage,
            gen1,
        ),
    ) == 1
    @test length(
        get_supplemental_attributes(
            x -> get_outage_schedule(x) == "1",
            PlannedOutage,
            gen2,
        ),
    ) == 0
    planned_outages = collect(get_supplemental_attributes(PlannedOutage, gen2))
    @test !isempty(planned_outages)
    for outage in planned_outages
        ts_keys = get_time_series_keys(outage)
        @test !isempty(ts_keys)
        for key in ts_keys
            remove_time_series!(sys, key.time_series_type, outage, key.name)
        end
        @test isempty(get_time_series_keys(outage))
    end
end

@testset "Test get_component_supplemental_attribute_pairs" begin
    sys = create_system_with_outages()
    # This function is properly tested in InfrastructureSystems.
    for (gen, outage) in get_component_supplemental_attribute_pairs(
        ThermalStandard,
        GeometricDistributionForcedOutage,
        sys,
    )
        @test gen isa ThermalStandard
        @test outage isa GeometricDistributionForcedOutage
    end
end

@testset "Test get_supplemental_attributes with component type" begin
    # the create_system_with_outages function creates a system with only ThermalStandard
    # components, so we need a different system for this test.
    c_sys5_bat = PSB.build_system(PSITestSystems, "c_sys5_bat")
    renewables = collect(get_components(PSY.RenewableDispatch, c_sys5_bat))
    thermals = collect(get_components(PSY.ThermalStandard, c_sys5_bat))

    attr1 = IS.TestSupplemental(; value = 1.0)
    attr2 = IS.TestSupplemental(; value = 2.0)
    geo_attr1 = IS.GeographicInfo()
    geo_attr2 = IS.GeographicInfo(;
        geo_json = Dict{String, Any}("type" => "Point", "coordinates" => [3.0, 4.0]),
    )

    comp_to_attributes = Dict{PSY.Component, Vector{IS.SupplementalAttribute}}(
        renewables[1] => [geo_attr1],
        renewables[2] => [geo_attr1, attr1],
        thermals[1] => [geo_attr2],
        thermals[2] => [geo_attr2, attr2],
        thermals[3] => [geo_attr1],
    )
    for (comp, attrs) in comp_to_attributes
        for attr in attrs
            add_supplemental_attribute!(c_sys5_bat, comp, attr)
        end
    end

    renewable_attrs =
        get_associated_supplemental_attributes(c_sys5_bat, PSY.RenewableDispatch)
    @test length(renewable_attrs) == 2 && geo_attr1 in renewable_attrs &&
          attr1 in renewable_attrs

    thermal_attrs = get_associated_supplemental_attributes(c_sys5_bat, PSY.ThermalStandard)
    @test length(thermal_attrs) == 3 && geo_attr2 in thermal_attrs &&
          attr2 in thermal_attrs && geo_attr1 in thermal_attrs

    thermal_geo_attrs = get_associated_supplemental_attributes(
        c_sys5_bat,
        PSY.ThermalStandard;
        attribute_type = IS.GeographicInfo,
    )
    @test length(thermal_geo_attrs) == 2 && geo_attr1 in thermal_geo_attrs &&
          geo_attr2 in thermal_geo_attrs
end

@testset "Test monitored_components on Outage subtypes" begin
    sys = create_system_with_outages()
    gens = collect(get_components(ThermalStandard, sys))
    gen1, gen2 = gens[1], gens[2]
    uuid1 = IS.get_id(gen1)
    uuid2 = IS.get_id(gen2)

    # Default is empty for all three concrete types
    @test isempty(
        get_monitored_components(
            GeometricDistributionForcedOutage(;
                mean_time_to_recovery = 1.0, outage_transition_probability = 0.5,
            ),
        ),
    )
    @test isempty(get_monitored_components(PlannedOutage(; outage_schedule = "x")))
    @test isempty(get_monitored_components(FixedForcedOutage(; outage_status = 0.0)))

    # Construct with UUIDs
    fo_uuid = GeometricDistributionForcedOutage(;
        mean_time_to_recovery = 1.0,
        outage_transition_probability = 0.5,
        monitored_components = [uuid1, uuid2],
    )
    @test get_monitored_components(fo_uuid) == Set([uuid1, uuid2])

    # Construct with Device references
    fo_dev = GeometricDistributionForcedOutage(;
        mean_time_to_recovery = 1.0,
        outage_transition_probability = 0.5,
        monitored_components = [gen1, gen2],
    )
    @test get_monitored_components(fo_dev) == Set([uuid1, uuid2])

    # Construct with the FlattenIteratorWrapper returned by get_components
    fo_iter = GeometricDistributionForcedOutage(;
        mean_time_to_recovery = 1.0,
        outage_transition_probability = 0.5,
        monitored_components = get_components(ThermalStandard, sys),
    )
    @test get_monitored_components(fo_iter) == Set(IS.get_id.(gens))

    # Construction silently dedups duplicate UUIDs
    fo_dup = GeometricDistributionForcedOutage(;
        mean_time_to_recovery = 1.0,
        outage_transition_probability = 0.5,
        monitored_components = [uuid1, uuid1, uuid2],
    )
    @test get_monitored_components(fo_dup) == Set([uuid1, uuid2])

    # Same for PlannedOutage and FixedForcedOutage
    po = PlannedOutage(; outage_schedule = "1", monitored_components = [gen1])
    @test get_monitored_components(po) == Set([uuid1])
    ff = FixedForcedOutage(; outage_status = 1.0, monitored_components = [uuid2])
    @test get_monitored_components(ff) == Set([uuid2])

    # set_monitored_components! accepts UUID and Device iterables
    o = FixedForcedOutage(; outage_status = 0.0)
    set_monitored_components!(o, [uuid1])
    @test get_monitored_components(o) == Set([uuid1])
    set_monitored_components!(o, [gen2])
    @test get_monitored_components(o) == Set([uuid2])
    set_monitored_components!(o, Int[])
    @test isempty(get_monitored_components(o))
    # set_ also accepts a FlattenIteratorWrapper from get_components
    set_monitored_components!(o, get_components(ThermalStandard, sys))
    @test get_monitored_components(o) == Set(IS.get_id.(gens))
    set_monitored_components!(o, Int[])

    # add_monitored_component! with single UUID or Device, including dedup
    add_monitored_component!(o, uuid1)
    add_monitored_component!(o, gen2)
    @test get_monitored_components(o) == Set([uuid1, uuid2])
    add_monitored_component!(o, gen1)  # duplicate, should no-op
    @test get_monitored_components(o) == Set([uuid1, uuid2])
    @test length(get_monitored_components(o)) == 2

    # add_monitored_components! with iterables: Vector, generator, FlattenIteratorWrapper
    o2 = FixedForcedOutage(; outage_status = 0.0)
    add_monitored_components!(o2, [uuid1, gen2])  # mixed UUID + Device
    @test get_monitored_components(o2) == Set([uuid1, uuid2])
    add_monitored_components!(o2, (g for g in gens[1:2]))  # generator, all already present
    @test get_monitored_components(o2) == Set([uuid1, uuid2])
    o3 = FixedForcedOutage(; outage_status = 0.0)
    add_monitored_components!(o3, get_components(ThermalStandard, sys))
    @test get_monitored_components(o3) == Set(IS.get_id.(gens))

    # remove_monitored_component! with single UUID or Device
    remove_monitored_component!(o, uuid1)
    @test get_monitored_components(o) == Set([uuid2])
    remove_monitored_component!(o, gen2)
    @test isempty(get_monitored_components(o))
    # Removing absent UUID is a no-op
    remove_monitored_component!(o, uuid1)
    @test isempty(get_monitored_components(o))

    # remove_monitored_components! with an iterable
    remove_monitored_components!(o3, get_components(ThermalStandard, sys))
    @test isempty(get_monitored_components(o3))

    # Validation under runchecks=true: a bogus UUID at attach time raises
    bogus_id = 999_999_999
    bad_outage = FixedForcedOutage(;
        outage_status = 0.0,
        monitored_components = [bogus_id],
    )
    @test_throws ArgumentError add_supplemental_attribute!(sys, gen1, bad_outage)

    # Validation under runchecks=false: same attach succeeds silently
    sys_nocheck = create_system_with_outages()
    set_runchecks!(sys_nocheck, false)
    gen_nc = first(get_components(ThermalStandard, sys_nocheck))
    bad_outage2 = FixedForcedOutage(;
        outage_status = 0.0,
        monitored_components = [bogus_id],
    )
    add_supplemental_attribute!(sys_nocheck, gen_nc, bad_outage2)
    @test bogus_id in get_monitored_components(bad_outage2)

    # A non-Device UUID is rejected under runchecks=true
    sys2 = create_system_with_outages()
    bus = first(get_components(ACBus, sys2))
    bus_uuid = IS.get_id(bus)
    bad_kind = FixedForcedOutage(;
        outage_status = 0.0,
        monitored_components = [bus_uuid],
    )
    gen_for_attach = first(get_components(ThermalStandard, sys2))
    @test_throws ArgumentError add_supplemental_attribute!(sys2, gen_for_attach, bad_kind)
end

@testset "Test JSON round-trip of monitored_components" begin
    sys = create_system_with_outages()
    gens = collect(get_components(ThermalStandard, sys))
    # Tag each existing outage with a non-empty monitored_components list so the
    # field has values to round-trip.
    for outage in get_supplemental_attributes(Outage, sys)
        set_monitored_components!(outage, gens)
    end

    sys2 = roundtrip_system(sys)

    # Every outage must come back with the same monitored UUIDs (set semantics —
    # order is not preserved), and each UUID must still resolve to a Device in
    # the new system.
    # The rebuilt system's ids, not the original's: a load mints fresh component ids, so the
    # original `gens` ids do not carry over. What must hold is that each outage still points
    # at the same *set of components*, resolvable in the system it came back in.
    expected_uuids = Set(IS.get_id.(collect(get_components(ThermalStandard, sys2))))
    outages2 = collect(get_supplemental_attributes(Outage, sys2))
    @test length(outages2) == 4
    for outage in outages2
        uuids = get_monitored_components(outage)
        @test uuids isa Set{Int}
        @test uuids == expected_uuids
        for uuid in uuids
            comp = IS.get_component(sys2, uuid)
            @test comp isa ThermalStandard
        end
    end

    # Default (empty) monitored_components also round-trips without error.
    sys_empty = create_system_with_outages()
    sys_empty2 = roundtrip_system(sys_empty)
    for outage in get_supplemental_attributes(Outage, sys_empty2)
        @test isempty(get_monitored_components(outage))
    end
end

@testset "Test remove_supplemental_attributes! by type" begin
    sys = create_system_with_outages()
    # Verify initial state
    @test length(get_supplemental_attributes(GeometricDistributionForcedOutage, sys)) == 2
    @test length(get_supplemental_attributes(PlannedOutage, sys)) == 2
    @test length(get_supplemental_attributes(GeographicInfo, sys)) == 2

    # Remove all GeometricDistributionForcedOutage attributes
    remove_supplemental_attributes!(GeometricDistributionForcedOutage, sys)
    @test length(get_supplemental_attributes(GeometricDistributionForcedOutage, sys)) == 0
    # Other types should be unaffected
    @test length(get_supplemental_attributes(PlannedOutage, sys)) == 2
    @test length(get_supplemental_attributes(GeographicInfo, sys)) == 2

    # Remove all PlannedOutage attributes
    remove_supplemental_attributes!(PlannedOutage, sys)
    @test length(get_supplemental_attributes(PlannedOutage, sys)) == 0
    @test length(get_supplemental_attributes(GeographicInfo, sys)) == 2

    # Remove all GeographicInfo attributes
    remove_supplemental_attributes!(GeographicInfo, sys)
    @test length(get_supplemental_attributes(GeographicInfo, sys)) == 0
end

@testset "Test time series on supplemental attributes" begin
    sys = create_system_with_outages()
    gens = collect(get_components(ThermalStandard, sys))
    gen1, gen2 = gens[1], gens[2]
    fo1 = only(get_supplemental_attributes(GeometricDistributionForcedOutage, gen1))
    fo2 = only(get_supplemental_attributes(GeometricDistributionForcedOutage, gen2))
    po1 = only(get_supplemental_attributes(PlannedOutage, gen1))
    po2 = only(get_supplemental_attributes(PlannedOutage, gen2))
    geo1 = only(get_supplemental_attributes(GeographicInfo, gen1))

    # The fixture attaches one SingleTimeSeries to each outage: name "ts_i", data i:i+23,
    # hourly from 2020-01-01T00:00:00.
    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    resolution = Dates.Hour(1)
    dates = collect(initial_time:resolution:(initial_time + Dates.Hour(23)))
    for (i, outage) in enumerate((fo1, fo2, po1, po2))
        name = "ts_$(i)"
        @test supports_time_series(outage)
        @test has_time_series(outage)
        @test has_time_series(outage, SingleTimeSeries)
        @test has_time_series(outage, SingleTimeSeries, name)
        @test !has_time_series(outage, Deterministic)
        ts = get_time_series(SingleTimeSeries, outage, name)
        @test ts isa SingleTimeSeries
        @test get_name(ts) == name
        @test get_time_series_values(SingleTimeSeries, outage, name) == collect(i:(i + 23))
        timestamps = get_time_series_timestamps(SingleTimeSeries, outage, name)
        @test timestamps == dates
        ta = get_time_series_array(SingleTimeSeries, outage, name)
        @test TimeSeries.values(ta) == collect(i:(i + 23))
        @test TimeSeries.timestamp(ta) == dates
        # Windowed read.
        @test get_time_series_values(
            SingleTimeSeries,
            outage,
            name;
            start_time = initial_time + Dates.Hour(2),
            len = 3,
        ) == collect((i + 2):(i + 4))
        # Read through the key.
        key = only(get_time_series_keys(outage))
        @test key.name == name
        @test key.time_series_type === SingleTimeSeries
        ts_by_key = get_time_series(outage, key)
        @test get_name(ts_by_key) == name
        @test TimeSeries.values(get_data(ts_by_key)) == collect(i:(i + 23))
    end

    # Ownership is per attribute: a generator does not see its attributes' series and vice
    # versa.
    @test !has_time_series(gen1, SingleTimeSeries, "ts_1")
    @test !has_time_series(fo1, SingleTimeSeries, "ts_2")

    # GeographicInfo opts out of time series (the SupplementalAttribute default), even though
    # it is attached to the system.
    @test !supports_time_series(geo1)
    @test !has_time_series(geo1)
    @test_throws ArgumentError add_time_series!(
        sys,
        geo1,
        SingleTimeSeries(; name = "nope", data = TimeSeries.TimeArray(dates, ones(24))),
    )

    counts = get_time_series_counts(sys)
    @test counts.supplemental_attributes_with_time_series == 4
    static_table = get_static_time_series_summary_table(sys)
    attr_rows =
        static_table[string.(static_table.owner_category) .== "SupplementalAttribute", :]
    @test size(attr_rows, 1) == 4
    @test Set(attr_rows.owner_type) ==
          Set(["GeometricDistributionForcedOutage", "PlannedOutage"])
    @test Set(attr_rows.name) == Set(["ts_1", "ts_2", "ts_3", "ts_4"])

    # Add a SingleTimeSeries directly (outside a transaction), with feature tags.
    ta_low = TimeSeries.TimeArray(dates, collect(100.0:123.0))
    key_low = add_time_series!(
        sys,
        fo1,
        SingleTimeSeries(; name = "extra", data = ta_low);
        scenario = "low",
    )
    @test key_low isa IS.TimeSeriesKey
    ta_high = TimeSeries.TimeArray(dates, collect(200.0:223.0))
    add_time_series!(
        sys,
        fo1,
        SingleTimeSeries(; name = "extra", data = ta_high);
        scenario = "high",
    )
    @test has_time_series(fo1, SingleTimeSeries, "extra"; scenario = "low")
    @test has_time_series(fo1, SingleTimeSeries, "extra"; scenario = "high")
    @test get_time_series_values(SingleTimeSeries, fo1, "extra"; scenario = "low") ==
          collect(100.0:123.0)
    @test get_time_series_values(SingleTimeSeries, fo1, "extra"; scenario = "high") ==
          collect(200.0:223.0)
    @test get_time_series(fo1, key_low) isa SingleTimeSeries
    # Without a feature the name is ambiguous.
    @test_throws ArgumentError get_time_series_values(SingleTimeSeries, fo1, "extra")
    @test length(get_time_series_keys(fo1)) == 3
    @test get_time_series_counts(sys).static_time_series_count ==
          counts.static_time_series_count + 2

    # Add a Deterministic forecast that matches the system's existing forecast parameters.
    forecast_initial = get_forecast_initial_timestamp(sys)
    forecast_interval = get_forecast_interval(sys)
    horizon_count =
        Int(Dates.Millisecond(get_forecast_horizon(sys)) / Dates.Millisecond(resolution))
    window1 = collect(1.0:horizon_count)
    window2 = collect((1.0 + horizon_count):(2 * horizon_count))
    forecast = Deterministic(;
        name = "outage_forecast",
        data = SortedDict(
            forecast_initial => window1,
            forecast_initial + forecast_interval => window2,
        ),
        resolution = resolution,
    )
    add_time_series!(sys, fo2, forecast)
    @test has_time_series(fo2, Deterministic)
    @test has_time_series(fo2, Deterministic, "outage_forecast")
    @test get_time_series_values(Deterministic, fo2, "outage_forecast") == window1
    @test get_time_series_values(
        Deterministic,
        fo2,
        "outage_forecast";
        start_time = forecast_initial + forecast_interval,
    ) == window2
    @test get_time_series_counts(sys).forecast_count == counts.forecast_count + 1
    forecast_table = get_forecast_summary_table(sys)
    attr_forecast_rows =
        forecast_table[
            string.(forecast_table.owner_category) .== "SupplementalAttribute",
            :,
        ]
    @test size(attr_forecast_rows, 1) == 1
    @test only(attr_forecast_rows.owner_type) == "GeometricDistributionForcedOutage"
    @test only(attr_forecast_rows.name) == "outage_forecast"

    # The same time series added to several attributes at once.
    ta_shared = TimeSeries.TimeArray(dates, collect(1.0:24.0))
    add_time_series!(
        sys,
        (fo1, fo2, po1),
        SingleTimeSeries(; name = "shared", data = ta_shared),
    )
    for attr in (fo1, fo2, po1)
        @test get_time_series_values(SingleTimeSeries, attr, "shared") == collect(1.0:24.0)
    end
    @test !has_time_series(po2, SingleTimeSeries, "shared")

    # Copy every series from one attribute to another.
    @test length(get_time_series_keys(po2)) == 1
    copy_time_series!(po2, po1)
    @test has_time_series(po2, SingleTimeSeries, "ts_3")
    @test has_time_series(po2, SingleTimeSeries, "shared")
    @test get_time_series_values(SingleTimeSeries, po2, "ts_3") ==
          get_time_series_values(SingleTimeSeries, po1, "ts_3")
    @test length(get_time_series_keys(po2)) == 3

    # An attribute that is not attached to a system cannot own time series.
    detached = PlannedOutage(; outage_schedule = "detached")
    @test !has_time_series(detached)
    @test_throws ArgumentError add_time_series!(
        sys,
        detached,
        SingleTimeSeries(; name = "nope", data = ta_low),
    )

    # Removal by name (with feature disambiguation) and by type.
    remove_time_series!(sys, SingleTimeSeries, fo1, "extra"; scenario = "high")
    @test !has_time_series(fo1, SingleTimeSeries, "extra"; scenario = "high")
    @test has_time_series(fo1, SingleTimeSeries, "extra"; scenario = "low")
    # Bulk removal by type is scoped to component owners in IS; attribute-owned series are
    # deliberately left untouched and must be removed per attribute.
    remove_time_series!(sys, Deterministic)
    @test has_time_series(fo2, Deterministic, "outage_forecast")
    @test get_time_series_counts(sys).forecast_count == 1
    remove_time_series!(sys, Deterministic, fo2, "outage_forecast")
    @test !has_time_series(fo2, Deterministic)
    @test has_time_series(fo2, SingleTimeSeries)
    @test get_time_series_counts(sys).forecast_count == 0
end

@testset "Test removing a supplemental attribute removes its time series" begin
    sys = create_system_with_outages()
    gens = collect(get_components(ThermalStandard, sys))
    gen1 = gens[1]
    po = only(get_supplemental_attributes(PlannedOutage, gen1))
    @test has_time_series(po)
    before = get_time_series_counts(sys)
    remove_supplemental_attribute!(sys, gen1, po)
    @test isempty(get_supplemental_attributes(PlannedOutage, gen1))
    @test !has_time_series(po)
    after = get_time_series_counts(sys)
    @test after.supplemental_attributes_with_time_series ==
          before.supplemental_attributes_with_time_series - 1
    @test after.static_time_series_count == before.static_time_series_count - 1
end

@testset "Test serialization of time series on supplemental attributes" begin
    sys = create_system_with_outages()

    # Identify an outage by its distinguishing field, since ids are reassigned on load.
    outage_tag(o::PlannedOutage) = (PlannedOutage, get_outage_schedule(o))
    outage_tag(o::GeometricDistributionForcedOutage) =
        (GeometricDistributionForcedOutage, get_mean_time_to_recovery(o))
    function outage_series(s)
        return Dict(
            outage_tag(o) => Dict(
                k.name => get_time_series_values(k.time_series_type, o, k.name) for
                k in get_time_series_keys(o)
            ) for o in get_supplemental_attributes(Outage, s)
        )
    end

    expected = outage_series(sys)
    @test length(expected) == 4
    sys2 = roundtrip_system(sys)
    @test length(get_supplemental_attributes(Outage, sys2)) == 4
    @test get_time_series_counts(sys2).supplemental_attributes_with_time_series ==
          get_time_series_counts(sys).supplemental_attributes_with_time_series
    actual = outage_series(sys2)
    @test Set(keys(actual)) == Set(keys(expected))
    # Export re-keys attribute-owned series in the sidecar to the document ids and import
    # presets each attribute's id to its document id, so every series comes back on the
    # attribute that owned it.
    @test actual == expected
    # A second round trip must hold too: the imported attributes now carry document ids,
    # which export re-keys again.
    sys3 = roundtrip_system(sys2)
    @test outage_series(sys3) == expected
end

@testset "Test time series on components and attributes with colliding ids" begin
    # Components and supplemental attributes draw ids from independent streams, so the same
    # number identifies one of each. Build a system where every outage's id equals the id of
    # a generator that supports time series, and attach each outage to a *different*
    # generator than the one sharing its id, so any owner confusion in the store would be
    # visible.
    sys = System(100.0)
    bus = ACBus(nothing)
    bus.name = "bus"
    bus.number = 1
    bus.bustype = ACBusTypes.REF
    add_component!(sys, bus)
    n = 4
    gens = ThermalStandard[]
    for i in 1:n
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen$(i)"
        add_component!(sys, gen)
        push!(gens, gen)
    end
    # The bus took component id 1; burn attribute id 1 on a PlannedOutage so the forced
    # outages below take ids 2..(n+1), which are the generators' ids.
    add_supplemental_attribute!(sys, gens[1], PlannedOutage(; outage_schedule = "filler"))
    outages = GeometricDistributionForcedOutage[]
    for i in 1:n
        outage = GeometricDistributionForcedOutage(;
            mean_time_to_recovery = Float64(i),
            outage_transition_probability = 0.5,
        )
        # Attach to the next generator, cyclically, not the one sharing its id.
        add_supplemental_attribute!(sys, gens[mod1(i + 1, n)], outage)
        push!(outages, outage)
    end
    gen_ids = IS.get_id.(gens)
    outage_ids = IS.get_id.(outages)
    @test gen_ids == outage_ids
    @test length(Set(gen_ids)) == n
    for (gen, outage) in zip(gens, outages)
        @test IS.get_component(sys, IS.get_id(gen)) === gen
        @test get_supplemental_attribute(sys, IS.get_id(outage)) === outage
        @test outage ∉ get_supplemental_attributes(GeometricDistributionForcedOutage, gen)
    end

    # Same name, same shape, different values on every owner; components and attributes
    # sharing an id get values that differ from each other.
    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    resolution = Dates.Hour(1)
    dates = collect(initial_time:resolution:(initial_time + Dates.Hour(23)))
    gen_values(id) = collect(100.0 * id .+ (0:23))
    outage_values(id) = collect(-100.0 * id .- (0:23))
    name = "data"
    for gen in gens
        ta = TimeSeries.TimeArray(dates, gen_values(IS.get_id(gen)))
        add_time_series!(sys, gen, SingleTimeSeries(; name = name, data = ta))
    end
    for outage in outages
        ta = TimeSeries.TimeArray(dates, outage_values(IS.get_id(outage)))
        add_time_series!(sys, outage, SingleTimeSeries(; name = name, data = ta))
    end
    # Forecasts too, same name on both owner kinds.
    fname = "forecast"
    horizon = 3
    gen_forecast(id) = SortedDict(
        initial_time => collect(1000.0 * id .+ (1:horizon)),
        initial_time + Dates.Hour(1) => collect(1000.0 * id .+ (11:(10 + horizon))),
    )
    outage_forecast(id) = SortedDict(
        initial_time => collect(-1000.0 * id .- (1:horizon)),
        initial_time + Dates.Hour(1) => collect(-1000.0 * id .- (11:(10 + horizon))),
    )
    for gen in gens
        data = gen_forecast(IS.get_id(gen))
        add_time_series!(
            sys,
            gen,
            Deterministic(; name = fname, data = data, resolution = resolution),
        )
    end
    for outage in outages
        data = outage_forecast(IS.get_id(outage))
        add_time_series!(
            sys,
            outage,
            Deterministic(; name = fname, data = data, resolution = resolution),
        )
    end

    counts = get_time_series_counts(sys)
    @test counts.components_with_time_series == n
    @test counts.supplemental_attributes_with_time_series == n
    @test counts.static_time_series_count == 2n
    @test counts.forecast_count == 2n

    # Every owner reads back exactly its own data.
    for gen in gens
        id = IS.get_id(gen)
        @test length(get_time_series_keys(gen)) == 2
        @test get_time_series_values(SingleTimeSeries, gen, name) == gen_values(id)
        @test TimeSeries.values(get_data(get_time_series(SingleTimeSeries, gen, name))) ==
              gen_values(id)
        @test get_time_series_values(Deterministic, gen, fname) ==
              gen_forecast(id)[initial_time]
        @test get_time_series_values(
            Deterministic,
            gen,
            fname;
            start_time = initial_time + Dates.Hour(1),
        ) == gen_forecast(id)[initial_time + Dates.Hour(1)]
    end
    for outage in outages
        id = IS.get_id(outage)
        @test length(get_time_series_keys(outage)) == 2
        @test get_time_series_values(SingleTimeSeries, outage, name) == outage_values(id)
        @test TimeSeries.values(
            get_data(get_time_series(SingleTimeSeries, outage, name)),
        ) ==
              outage_values(id)
        @test get_time_series_values(Deterministic, outage, fname) ==
              outage_forecast(id)[initial_time]
        @test get_time_series_values(
            Deterministic,
            outage,
            fname;
            start_time = initial_time + Dates.Hour(1),
        ) == outage_forecast(id)[initial_time + Dates.Hour(1)]
        # And never the data of the component sharing its id.
        @test get_time_series_values(SingleTimeSeries, outage, name) != gen_values(id)
        @test get_time_series_values(Deterministic, outage, fname) !=
              gen_forecast(id)[initial_time]
    end

    # The same holds after a to_file/from_file round trip, where components keep their ids
    # and attributes take the document's ids: every owner still reads back only its own
    # data, and attributes that share an id with a generator still do not see its series.
    sys2 = roundtrip_system(sys)
    gens2 = [get_component(ThermalStandard, sys2, get_name(g)) for g in gens]
    outages2 = [
        only(
            get_supplemental_attributes(
                x -> get_mean_time_to_recovery(x) == get_mean_time_to_recovery(o),
                GeometricDistributionForcedOutage,
                sys2,
            ),
        ) for o in outages
    ]
    @test IS.get_id.(gens2) == gen_ids
    counts2 = get_time_series_counts(sys2)
    @test counts2.components_with_time_series == n
    @test counts2.supplemental_attributes_with_time_series == n
    @test counts2.static_time_series_count == 2n
    @test counts2.forecast_count == 2n
    for (gen, gen2) in zip(gens, gens2)
        id = IS.get_id(gen)
        @test length(get_time_series_keys(gen2)) == 2
        @test get_time_series_values(SingleTimeSeries, gen2, name) == gen_values(id)
        @test get_time_series_values(Deterministic, gen2, fname) ==
              gen_forecast(id)[initial_time]
        @test get_time_series_values(
            Deterministic,
            gen2,
            fname;
            start_time = initial_time + Dates.Hour(1),
        ) == gen_forecast(id)[initial_time + Dates.Hour(1)]
    end
    for (outage, outage2) in zip(outages, outages2)
        id = IS.get_id(outage)
        @test length(get_time_series_keys(outage2)) == 2
        @test get_time_series_values(SingleTimeSeries, outage2, name) == outage_values(id)
        @test get_time_series_values(Deterministic, outage2, fname) ==
              outage_forecast(id)[initial_time]
        @test get_time_series_values(
            Deterministic,
            outage2,
            fname;
            start_time = initial_time + Dates.Hour(1),
        ) == outage_forecast(id)[initial_time + Dates.Hour(1)]
        # The imported attribute is attached to the same generator as before.
        @test length(get_associated_components(sys2, outage2)) == 1
        @test get_name(only(get_associated_components(sys2, outage2))) ==
              get_name(only(get_associated_components(sys, outage)))
    end

    # Removing one owner's series leaves the id-sharing owner's series intact, both ways.
    remove_time_series!(sys, SingleTimeSeries, gens[1], name)
    @test !has_time_series(gens[1], SingleTimeSeries, name)
    @test has_time_series(outages[1], SingleTimeSeries, name)
    @test get_time_series_values(SingleTimeSeries, outages[1], name) ==
          outage_values(IS.get_id(outages[1]))
    remove_time_series!(sys, Deterministic, outages[2], fname)
    @test !has_time_series(outages[2], Deterministic, fname)
    @test has_time_series(gens[2], Deterministic, fname)
    @test get_time_series_values(Deterministic, gens[2], fname) ==
          gen_forecast(IS.get_id(gens[2]))[initial_time]
    counts = get_time_series_counts(sys)
    @test counts.static_time_series_count == 2n - 1
    @test counts.forecast_count == 2n - 1

    # Removing an attribute drops only its series; the generator sharing its id keeps its own.
    remove_supplemental_attribute!(sys, gens[mod1(4, n)], outages[3])
    @test !has_time_series(outages[3])
    @test has_time_series(gens[3], SingleTimeSeries, name)
    @test get_time_series_values(SingleTimeSeries, gens[3], name) ==
          gen_values(IS.get_id(gens[3]))
    @test has_time_series(gens[3], Deterministic, fname)
    counts = get_time_series_counts(sys)
    @test counts.supplemental_attributes_with_time_series == n - 1
    @test counts.components_with_time_series == n
end
