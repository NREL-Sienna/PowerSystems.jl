@testset "Test JSON serialization of RTS data with mutable time series" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys"; add_forecasts = false)
    # Add an AGC service to cover its special serialization.
    control_area = get_component(Area, sys, "1")
    AGC_service = PSY.AGC(
        name = "AGC_Area1",
        available = true,
        bias = 739.0,
        K_p = 2.5,
        K_i = 0.1,
        K_d = 0.0,
        delta_t = 4,
        area = control_area,
    )
    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    end_time = Dates.DateTime("2020-01-01T23:00:00")
    dates = collect(initial_time:Dates.Hour(1):end_time)
    data = collect(1:24)
    name = "active_power"
    contributing_devices = Vector{Device}()
    for g in get_components(
        ThermalStandard,
        sys,
        x -> (x.prime_mover ∈ [PrimeMovers.ST, PrimeMovers.CC, PrimeMovers.CT]),
    )
        if get_area(get_bus(g)) != control_area
            continue
        end
        ta = TimeSeries.TimeArray(dates, data, [Symbol(get_name(g))])
        time_series = IS.SingleTimeSeries(
            name = name,
            data = ta,
            scaling_factor_multiplier = get_active_power,
        )
        add_time_series!(sys, g, time_series)

        t = RegulationDevice(g, participation_factor = (up = 1.0, dn = 1.0), droop = 0.04)
        add_component!(sys, t)
        @test isnothing(get_component(ThermalStandard, sys, get_name(g)))
        push!(contributing_devices, t)
    end
    add_service!(sys, AGC_service, contributing_devices)

    sys2, result = validate_serialization(sys; time_series_read_only = false)
    @test result

    # Ensure the time_series attached to the ThermalStandard got deserialized.
    for rd in get_components(RegulationDevice, sys2)
        @test get_time_series(SingleTimeSeries, rd, name) isa SingleTimeSeries
    end

    clear_time_series!(sys2)
end

@testset "Test JSON serialization of RTS data with immutable time series" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    sys2, result = validate_serialization(sys; time_series_read_only = true)
    @test result
    @test_throws ErrorException clear_time_series!(sys2)
    # Full error checking is done in IS.
end

@testset "Test JSON serialization of matpower data" begin
    sys = PSB.build_system(PSB.MatPowerTestSystems, "matpower_case5_re_sys")

    # Add a Probabilistic time_series to get coverage serializing it.
    bus = Bus(nothing)
    bus.name = "Bus1234"
    add_component!(sys, bus)
    tg = RenewableFix(nothing)
    tg.bus = bus
    add_component!(sys, tg)
    # TODO 1.0
    #ts = PSY.Probabilistic("scalingfactor", Hour(1), DateTime("01-01-01"), [0.5, 0.5], 24)
    #add_time_series!(sys, tg, ts)

    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of ACTIVSg2000 data" begin
    sys = PSB.build_system(PSB.MatPowerTestSystems, "matpower_ACTIVSg2000_sys")
    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of dynamic inverter" begin
    sys = PSB.build_system(PSB.PSYTestSystems, "dynamic_inverter_sys")

    # Add a dynamic branch to test that code.
    branch = collect(get_components(Branch, sys))[1]
    dynamic_branch = DynamicBranch(branch)
    add_component!(sys, dynamic_branch)
    _, result = validate_serialization(sys)
    @test result

    test_accessors(dynamic_branch)
end

@testset "Test JSON serialization of StaticGroupReserve" begin
    sys = System(100.0)
    devices = []
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        # This prevents an error log message.
        bus.bustype = BusTypes.REF
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)
    end

    service = StaticReserve{ReserveDown}(nothing)
    add_service!(sys, service, devices)

    groupservice = StaticReserveGroup{ReserveDown}(nothing)
    add_service!(sys, groupservice)
    members = Vector{Service}()
    push!(members, service)
    set_contributing_services!(sys, groupservice, members)
    _, result = validate_serialization(sys)
    @test result
end

@testset "Test deepcopy of a system" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    sys2 = deepcopy(sys)
    clear_time_series!(sys2)
    @test !isempty(collect(get_time_series_multiple(sys)))
end

@testset "Test JSON serialization of MarketBidCost" begin
    sys = System(100.0)
    generators = [ThermalStandard(nothing), ThermalMultiStart(nothing)]
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        # This prevents an error log message.
        bus.bustype = BusTypes.REF
        add_component!(sys, bus)
        gen = generators[i]
        gen.bus = bus
        gen.name = "gen" * string(i)
        initial_time = Dates.DateTime("2020-01-01T00:00:00")
        end_time = Dates.DateTime("2020-01-01T23:00:00")
        dates = collect(initial_time:Dates.Hour(1):end_time)
        data = collect(1:24)
        market_bid = MarketBidCost(nothing)
        set_operation_cost!(gen, market_bid)
        add_component!(sys, gen)
        ta = TimeSeries.TimeArray(dates, data)
        time_series = IS.SingleTimeSeries(name = "variable_cost", data = ta)
        set_variable_cost!(sys, gen, time_series)
    end
    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of ReserveDemandCurve" begin
    sys = System(100.0)
    devices = []
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        # This prevents an error log message.
        bus.bustype = BusTypes.REF
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)
    end
    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    end_time = Dates.DateTime("2020-01-01T23:00:00")
    dates = collect(initial_time:Dates.Hour(1):end_time)
    data = collect(1:24)

    service = ReserveDemandCurve{ReserveDown}(nothing)
    add_service!(sys, service, devices)
    ta = TimeSeries.TimeArray(dates, data)
    time_series = IS.SingleTimeSeries(name = "variable_cost", data = ta)
    set_variable_cost!(sys, service, time_series)

    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of HybridSystem" begin
    sys = create_rts_system_with_hybrid_system(add_forecasts = true)
    h_sys = first(get_components(HybridSystem, sys))
    subcomponents = collect(get_subcomponents(h_sys))
    @test length(subcomponents) == 4
    sys2, result = validate_serialization(sys)
    @test result
    subcomponent = subcomponents[1]
    @test IS.get_masked_component(
        typeof(subcomponent),
        sys2.data,
        get_name(subcomponent),
    ) !== nothing
end

@testset "Test deserialization with new UUIDs" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    sys2, result = validate_serialization(sys; assign_new_uuids = true)
    @test result
    @test IS.get_uuid(sys) != IS.get_uuid(sys2)
    for component1 in get_components(Component, sys)
        component2 = get_component(typeof(component1), sys2, get_name(component1))
        @test IS.get_uuid(component1) != IS.get_uuid(component2)
    end
end
