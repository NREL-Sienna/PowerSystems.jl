@testset "Test add/remove services" begin
    sys = System(100)
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

    service = StaticReserve{ReserveDown}(nothing)
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

@testset "Test add_component Service" begin
    sys = System(100)
    static_reserve = StaticReserve{ReserveDown}(nothing)
    add_component!(sys, static_reserve)
    services = get_components(StaticReserve{ReserveDown}, sys)
    @test length(services) == 1
    @test iterate(services)[1] == static_reserve
end

@testset "Test add_service errors" begin
    sys = System(100)
    bus = Bus(nothing)
    service = StaticReserve{ReserveDown}(nothing)
    # Bus is not a Device.
    @test_throws ArgumentError add_service!(sys, service, [bus])

    gen = ThermalStandard(nothing)
    # gen is not in sys.
    @test_throws ArgumentError add_service!(sys, service, [bus])
end

@testset "Test remove service from device" begin
    sys = System(100)
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

@testset "Test remove device with service" begin
    sys = System(100)
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
    add_service!(gen, service)
    @test length(get_services(gen)) == 1

    remove_service!(gen, service)
    @test length(get_services(gen)) == 0
end

@testset "Test add device with service" begin
    sys = System(100)
    bus = Bus(nothing)
    bus.name = "bus1"
    bus.number = 1
    add_component!(sys, bus)

    gen = ThermalStandard(nothing)
    gen.bus = bus
    gen.name = "gen"

    service = StaticReserve{ReserveDown}(nothing)
    add_service!(gen, service)
    @test length(get_services(gen)) == 1

    @test_throws ArgumentError add_component!(sys, gen)
end

@testset "Test get_contributing_devices" begin
    sys = System(100)
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

    add_service!(devices[1], services[1])
    add_service!(devices[2], services[1])
    add_service!(devices[3], services[2])
    add_service!(devices[4], services[2])
    add_service!(devices[5], services[2])

    expected_contributing_devices1 = [devices[1], devices[2]]
    expected_contributing_devices2 = [devices[3], devices[4], devices[5]]

    contributing_devices1 = get_contributing_devices(sys, services[1])
    contributing_devices2 = get_contributing_devices(sys, services[2])

    # Order of contributing_devices isn't guaranteed, sort them to test.
    sort!(contributing_devices1, by = x -> get_name(x))
    sort!(contributing_devices2, by = x -> get_name(x))
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

    sort!(mapping[key1].contributing_devices, by = x -> get_name(x))
    sort!(mapping[key2].contributing_devices, by = x -> get_name(x))
    @test mapping[key1].contributing_devices == expected_contributing_devices1
    @test mapping[key2].contributing_devices == expected_contributing_devices2
end

@testset "Test get_component combinations" begin
    sys = System(100)
    reserves = (
        StaticReserve{ReserveUp}(nothing),
        StaticReserve{ReserveDown}(nothing),
        VariableReserve{ReserveUp}(nothing),
        VariableReserve{ReserveDown}(nothing),
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

    @test length(PSY.SERVICE_STRUCT_TYPES) == actual_count
end
