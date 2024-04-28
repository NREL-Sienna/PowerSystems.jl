@testset "Test outages" begin
    sys = create_system_with_outages()
    gens = collect(get_components(ThermalStandard, sys))
    gen1 = gens[1]
    gen2 = gens[2]
    @test length(get_supplemental_attributes(Outage, sys)) == 4
    forced_outages =
        collect(get_supplemental_attributes(GeometricDistributionForcedOutage, sys))
    @test length(forced_outages) == 2
    @test get_supplemental_attribute(sys, IS.get_uuid(forced_outages[1])) ==
          forced_outages[1]
    planned_outages = collect(get_supplemental_attributes(PlannedOutage, sys))
    @test length(planned_outages) == 2
    @test get_supplemental_attribute(sys, IS.get_uuid(planned_outages[1])) ==
          planned_outages[1]

    geos = get_supplemental_attributes(GeographicInfo, sys)
    for geo in geos
        @test length(get_components(sys, geo)) == 2
    end

    for gen in (gen1, gen2)
        for type in (GeometricDistributionForcedOutage, PlannedOutage, GeographicInfo)
            attributes = list_supplemental_attributes(type, gen)
            @test length(attributes) == 1
            uuid = IS.get_uuid(attributes[1])
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
        list_supplemental_attributes(
            x -> get_mean_time_to_recovery(x) == 2.0,
            GeometricDistributionForcedOutage,
            gen1,
        ),
    ) == 0
    @test length(
        list_supplemental_attributes(
            x -> get_mean_time_to_recovery(x) == 2.0,
            GeometricDistributionForcedOutage,
            gen2,
        ),
    ) == 1
    @test length(
        get_supplemental_attributes(x -> get_outage_schedule(x) == "1", PlannedOutage, sys),
    ) == 1
    @test length(
        list_supplemental_attributes(
            x -> get_outage_schedule(x) == "1",
            PlannedOutage,
            gen1,
        ),
    ) == 1
    @test length(
        list_supplemental_attributes(
            x -> get_outage_schedule(x) == "1",
            PlannedOutage,
            gen2,
        ),
    ) == 0
end
