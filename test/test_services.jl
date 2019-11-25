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

    service = StaticReserve(nothing)
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
    static_reserve = StaticReserve(nothing)
    add_component!(sys, static_reserve)
    services = get_components(StaticReserve, sys)
    @test length(services) == 1
    @test iterate(services)[1] == static_reserve
end

@testset "Test add_service errors" begin
    sys = System(100)
    bus = Bus(nothing)
    service = StaticReserve(nothing)
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

    service = StaticReserve(nothing)
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

    service = StaticReserve(nothing)
    add_service!(sys, service, [gen])
    @test length(get_services(gen)) == 1

    remove_component!(sys, gen)
    @test length(get_services(gen)) == 0
end

@testset "Test clear_services" begin
    gen = ThermalStandard(nothing)
    service = StaticReserve(nothing)
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

    service = StaticReserve(nothing)
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

        service = StaticReserve(nothing)
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
    key1 = ServiceContributingDevicesKey((StaticReserve, get_name(services[1])))
    key2 = ServiceContributingDevicesKey((StaticReserve, get_name(services[2])))
    key3 = ServiceContributingDevicesKey((StaticReserve, get_name(services[3])))
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
