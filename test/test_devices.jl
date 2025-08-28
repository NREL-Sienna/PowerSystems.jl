@testset "Test special accessors" begin
    cdmsys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    th = first(get_components(ThermalStandard, cdmsys))
    re = first(get_components(RenewableDispatch, cdmsys))

    @test get_max_active_power(th) == get_active_power_limits(th).max
    @test get_max_active_power(re) <= get_rating(re)
    @test isa(get_max_reactive_power(re), Float64)

    @test_throws ArgumentError get_max_active_power(TestDevice("foo"))
    @test_throws ArgumentError get_max_active_power(TestRenDevice("foo"))
end

@testset "Test Remove Area with Interchanges" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    area1 = get_component(Area, sys, "1")
    area2 = get_component(Area, sys, "2")
    area3 = get_component(Area, sys, "3")
    area_interchange12 = AreaInterchange(;
        name = "interchange_a1_a2",
        available = true,
        active_power_flow = 0.0,
        from_area = area1,
        to_area = area2,
        flow_limits = (from_to = 100.0, to_from = 100.0),
    )
    area_interchange13 = AreaInterchange(;
        name = "interchange_a1_a3",
        available = true,
        active_power_flow = 0.0,
        from_area = area1,
        to_area = area3,
        flow_limits = (from_to = 100.0, to_from = 100.0),
    )
    add_component!(sys, area_interchange12)
    add_component!(sys, area_interchange13)
    @test_throws ArgumentError remove_component!(sys, area1)
    remove_component!(sys, area_interchange12)
    remove_component!(sys, area_interchange13)
    remove_component!(sys, area1)
    @test get_component(Area, sys, "1") === nothing
end

@testset "Test Shiftable Power Loads and Interruptible PowerLoads" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    buses = collect(get_components(ACBus, sys))
    add_component!(
        sys,
        InterruptiblePowerLoad(
            "IloadBus",
            true,
            buses[1],
            0.10,
            0.0,
            0.10,
            0.0,
            100.0,
            LoadCost(CostCurve(LinearCurve(150.0)), 2400.0),
        ),
    )
    add_component!(
        sys,
        ShiftablePowerLoad(
            "ShiftableLoadBus4",
            true,
            buses[2],
            0.10,
            (min = 0.03, max = 0.10),
            0.0,
            0.10,
            0.0,
            100.0,
            24,
            LoadCost(CostCurve(LinearCurve(150.0)), 2400.0),
        ),
    )
    dir_path = mktempdir()
    to_json(sys, joinpath(dir_path, "test_RTS_GMLC_sys.json"))
    sys2 = System(joinpath(dir_path, "test_RTS_GMLC_sys.json"))
    @test get_active_power(get_component(ShiftablePowerLoad, sys2, "ShiftableLoadBus4")) ==
          0.10
    @test get_active_power(get_component(InterruptiblePowerLoad, sys2, "IloadBus")) == 0.10
    @test get_active_power_limits(
        get_component(ShiftablePowerLoad, sys2, "ShiftableLoadBus4"),
    ).min == 0.03
    @test get_active_power_limits(
        get_component(ShiftablePowerLoad, sys2, "ShiftableLoadBus4"),
    ).max == 0.10
end

@testset "supports get active/reactive power" begin
    device_types = Type[PSY.StaticInjection]
    while !isempty(device_types)
        T = pop!(device_types)
        if !isabstracttype(T)
            instance = T(nothing)
            if PSY.supports_active_power(instance)
                @test hasmethod(PSY.get_active_power, Tuple{T})
                @test hasmethod(PSY.active_power_contribution_sign, Tuple{T})
            end
            # awkward carve-out here, for FACTSControlDevice.
            if PSY.supports_reactive_power(instance) && T != PSY.FACTSControlDevice
                @test hasmethod(PSY.get_reactive_power, Tuple{T})
                @test hasmethod(PSY.reactive_power_contribution_sign, Tuple{T})
            end
        end
        append!(device_types, subtypes(T))
    end
end
