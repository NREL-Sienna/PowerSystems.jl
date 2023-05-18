@testset "Test add/remove services" begin
    @testset "Case: $direction" for direction in [ReserveDown; ReserveUp; ReserveSymmetric]
        sys = System(100.0)
        devices = []
        for i in 1:2
            bus = Bus(nothing)
            bus.name = "bus" * string(i)
            bus.number = i
            add_component!(sys, bus)
            gen = ThermalStandard(nothing)
            gen.bus = bus
            gen.name = "gen" * string(i)
            add_component!(sys, gen)
            push!(devices, gen)
        end

        service = StaticReserve{direction}(nothing)
        add_service!(sys, service, devices)

        for device in devices
            services = get_services(device)
            @test length(services) == 1
            @test services[1] isa Service
            @test services[1] == service
        end

        services = collect(get_components(Service, sys))
        @test length(services) == 1
        @test services[1] == service

        remove_component!(sys, service)

        for device in devices
            @test length(get_services(device)) == 0
        end

        sys = System(100.0)
        devices = []
        for i in 1:2
            bus = Bus(nothing)
            bus.name = "bus" * string(i)
            bus.number = i
            add_component!(sys, bus)
            gen = ThermalStandard(nothing)
            gen.bus = bus
            gen.name = "gen" * string(i)
            add_component!(sys, gen)
            push!(devices, gen)
        end

        service = StaticReserve{direction}(nothing)
        add_component!(sys, service)
        test_device = get_component(ThermalStandard, sys, "gen1")
        add_service!(test_device, service, sys)
        @test PowerSystems.has_service(test_device, service)
    end
end

@testset "Test add_component Service" begin
    sys = System(100.0)
    static_reserve = StaticReserve{ReserveDown}(nothing)
    add_component!(sys, static_reserve)
    services = get_components(StaticReserve{ReserveDown}, sys)
    @test length(services) == 1
    @test iterate(services)[1] == static_reserve
end

@testset "Test add_service errors" begin
    sys = System(100.0)
    bus = Bus(nothing)
    service = StaticReserve{ReserveDown}(nothing)
    # Bus is not a Device.
    @test_throws ArgumentError add_service!(sys, service, [bus])

    gen = ThermalStandard(nothing)
    # gen is not in sys.
    @test_throws ArgumentError add_service!(sys, service, [bus])
end

@testset "Test remove service from device" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)
    gen = ThermalStandard(nothing)
    gen.bus = bus
    gen.name = "gen"
    add_component!(sys, gen)

    service = StaticReserve{ReserveDown}(nothing)
    add_service!(sys, service, [gen])
    @test length(get_services(gen)) == 1

    remove_service!(gen, service)
    @test length(get_services(gen)) == 0
end

@testset "Test has service" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)
    gen = ThermalStandard(nothing)
    gen.bus = bus
    gen.name = "gen"
    add_component!(sys, gen)

    service = StaticReserve{ReserveDown}(nothing)
    add_service!(sys, service, [gen])
    @test has_service(gen, service)
    @test has_service(gen, typeof(service))

    remove_service!(gen, service)
    @test !has_service(gen, service)
    @test !has_service(gen, typeof(service))
end

@testset "Test remove device with service" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)
    gen = ThermalStandard(nothing)
    gen.bus = bus
    gen.name = "gen"
    add_component!(sys, gen)

    service = StaticReserve{ReserveDown}(nothing)
    add_service!(sys, service, [gen])
    @test length(get_services(gen)) == 1

    remove_component!(sys, gen)
    @test length(get_services(gen)) == 0
end

@testset "Test clear_services" begin
    gen = ThermalStandard(nothing)
    service = StaticReserve{ReserveDown}(nothing)
    PSY.add_service_internal!(gen, service)
    @test length(get_services(gen)) == 1

    remove_service!(gen, service)
    @test length(get_services(gen)) == 0
end

@testset "Test add device with service" begin
    sys = System(100.0)
    bus = Bus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    gen = ThermalStandard(nothing)
    gen.bus = bus
    gen.name = "gen"

    service = StaticReserve{ReserveDown}(nothing)
    PSY.add_service_internal!(gen, service)
    @test length(get_services(gen)) == 1

    @test_throws ArgumentError add_component!(sys, gen)
end

@testset "Test get_contributing_devices" begin
    sys = System(100.0)
    devices = []
    services = []
    for i in 1:5
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)

        service = StaticReserve{ReserveUp}(nothing)
        service.name = "StaticReserve" * string(i)
        push!(services, service)
        add_component!(sys, service)
    end

    PSY.add_service_internal!(devices[1], services[1])
    PSY.add_service_internal!(devices[2], services[1])
    PSY.add_service_internal!(devices[3], services[2])
    PSY.add_service_internal!(devices[4], services[2])
    PSY.add_service_internal!(devices[5], services[2])

    expected_contributing_devices1 = [devices[1], devices[2]]
    expected_contributing_devices2 = [devices[3], devices[4], devices[5]]

    contributing_devices1 = get_contributing_devices(sys, services[1])
    contributing_devices2 = get_contributing_devices(sys, services[2])

    # Order of contributing_devices isn't guaranteed, sort them to test.
    sort!(contributing_devices1; by = x -> get_name(x))
    sort!(contributing_devices2; by = x -> get_name(x))
    @test contributing_devices1 == expected_contributing_devices1
    @test contributing_devices2 == expected_contributing_devices2

    mapping = get_contributing_device_mapping(sys)
    @test length(mapping) == length(services)
    key1 = ServiceContributingDevicesKey((StaticReserve{ReserveUp}, get_name(services[1])))
    key2 = ServiceContributingDevicesKey((StaticReserve{ReserveUp}, get_name(services[2])))
    key3 = ServiceContributingDevicesKey((StaticReserve{ReserveUp}, get_name(services[3])))
    @test haskey(mapping, key1)
    @test haskey(mapping, key2)
    @test haskey(mapping, key3)
    @test length(mapping[key1].contributing_devices) == 2
    @test length(mapping[key2].contributing_devices) == 3
    @test length(mapping[key3].contributing_devices) == 0

    sort!(mapping[key1].contributing_devices; by = x -> get_name(x))
    sort!(mapping[key2].contributing_devices; by = x -> get_name(x))
    @test mapping[key1].contributing_devices == expected_contributing_devices1
    @test mapping[key2].contributing_devices == expected_contributing_devices2
end

@testset "Test get_component combinations" begin
    sys = System(100.0)
    reserves = (
        StaticReserve{ReserveUp}(nothing),
        StaticReserve{ReserveDown}(nothing),
        VariableReserve{ReserveUp}(nothing),
        VariableReserve{ReserveDown}(nothing),
        ReserveDemandCurve{ReserveUp}(nothing),
        ReserveDemandCurve{ReserveDown}(nothing),
    )

    for reserve in reserves
        add_component!(sys, reserve)
    end

    @test length(get_components(Service, sys)) == length(reserves)
    @test length(get_components(Reserve, sys)) == length(reserves)
    @test length(get_components(StaticReserve, sys)) == 2
    @test length(get_components(VariableReserve, sys)) == 2
    @test length(get_components(StaticReserve{ReserveUp}, sys)) == 1
    @test length(get_components(StaticReserve{ReserveDown}, sys)) == 1
    @test length(get_components(VariableReserve{ReserveUp}, sys)) == 1
    @test length(get_components(VariableReserve{ReserveDown}, sys)) == 1
    @test length(get_components(ReserveDemandCurve{ReserveUp}, sys)) == 1
    @test length(get_components(ReserveDemandCurve{ReserveDown}, sys)) == 1
end

@testset "Test struct type collections" begin
    concrete_types = IS.get_all_concrete_subtypes(Service)
    reserve_types = InteractiveUtils.subtypes(Reserve)
    reserve_parametric_types = InteractiveUtils.subtypes(ReserveDirection)

    actual_count = length(concrete_types)
    for reserve in reserve_types
        for parametric in reserve_parametric_types
            actual_count += 1
        end
    end

    @test 13 == actual_count
end

@testset "Test AGC Device and Regulation Services" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    control_area = get_component(Area, sys, "1")
    AGC_service = PSY.AGC(;
        name = "AGC_Area1",
        available = true,
        bias = 739.0,
        K_p = 2.5,
        K_i = 0.1,
        K_d = 0.0,
        delta_t = 4,
        area = control_area,
    )
    contributing_devices = Vector{Device}()
    for g in get_components(
        x -> (x.prime_mover ∈ [PrimeMovers.ST, PrimeMovers.CC, PrimeMovers.CT]),
        ThermalStandard,
        sys,
    )
        if get_area(get_bus(g)) != control_area
            continue
        end
        t = RegulationDevice(g; participation_factor = (up = 1.0, dn = 1.0), droop = 0.04)
        add_component!(sys, t)
        push!(contributing_devices, t)
    end
    add_service!(sys, AGC_service, contributing_devices)

    for d in contributing_devices
        @test AGC_service ∈ get_services(d)
    end

    device_without_regulation =
        first(get_components(x -> get_area(get_bus(x)) == control_area, HydroGen, sys))
    @test_throws IS.ConflictingInputsError PSY.add_service_internal!(
        device_without_regulation,
        AGC_service,
    )

    device_outside_area_ = get_component(ThermalStandard, sys, "213_CT_1")
    device_outside_area = RegulationDevice(device_outside_area_)
    @test_throws IS.ConflictingInputsError PSY.add_service_internal!(
        device_outside_area,
        AGC_service,
    )

    @test_throws ArgumentError PSY.add_service_internal!(
        contributing_devices[1],
        AGC_service,
    )

    test_accessors(device_outside_area)
end

@testset "Test StaticReserveGroup" begin
    # create system
    sys = System(100.0)
    # add buses and generators
    devices = []
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)
    end

    # add StaticReserve
    service = StaticReserve{ReserveDown}(nothing)
    add_service!(sys, service, devices)

    # add StaticReserve
    groupservice = StaticReserveGroup{ReserveDown}(nothing)
    add_service!(sys, groupservice)

    # add StaticReserveGroup
    groupservices = collect(get_components(StaticReserveGroup, sys))
    # test if StaticReserveGroup was added
    @test length(groupservices) == 1
    @test groupservices[1] == groupservice

    # add contributing services
    expected_contributing_services = Vector{Service}()
    push!(expected_contributing_services, service)
    set_contributing_services!(sys, groupservice, expected_contributing_services)
    # get contributing services
    contributing_services = get_contributing_services(groupservice)

    # check if expected contributing services is iqual to contributing services
    sort!(contributing_services; by = x -> get_name(x))
    @test contributing_services == expected_contributing_services
end

@testset "Test StaticReserveGroup errors" begin
    sys = System(100.0)
    bus = Bus(nothing)
    groupservice = StaticReserveGroup{ReserveDown}(nothing)

    # Bus is not a Service.
    @test_throws MethodError set_contributing_services!(sys, groupservice, [bus])

    # Service not in System
    service = StaticReserve{ReserveDown}(nothing)
    contributing_services = Vector{Service}()
    push!(contributing_services, service)
    @test_throws ArgumentError add_service!(sys, groupservice, contributing_services)

    # Service in a StaticReserveGroup
    devices = []
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)
    end
    add_service!(sys, service, devices)
    add_service!(sys, groupservice, contributing_services)
    @test_throws ArgumentError remove_component!(sys, service)
end

@testset "Test ReserveNonSpinning" begin
    # create system
    sys = System(100.0)
    # add buses and generators
    devices = []
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)
    end

    # add StaticReserve
    service = StaticReserveNonSpinning(nothing)
    add_service!(sys, service, devices)

    for device in devices
        services = get_services(device)
        @test length(services) == 1
        @test services[1] isa Service
        @test services[1] == service
    end

    services = collect(get_components(Service, sys))
    @test length(services) == 1
    @test services[1] == service

    remove_component!(sys, service)

    for device in devices
        @test length(get_services(device)) == 0
    end
end

@testset "Test TransmissionInterface" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    lines = get_components(Line, sys)
end
