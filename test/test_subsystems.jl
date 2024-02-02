function create_system_with_test_subsystems()
    sys = PSB.build_system(
        PSITestSystems,
        "c_sys5_uc";
        add_forecasts = false,
        time_series_read_only = true,
    )

    components = collect(get_components(ThermalStandard, sys))
    @test length(components) >= 5

    subsystems = String[]
    for i in 1:3
        name = "subsystem_$i"
        add_subsystem!(sys, name)
        push!(subsystems, name)
    end

    add_component_to_subsystem!(sys, subsystems[1], components[1])
    add_component_to_subsystem!(sys, subsystems[1], components[2])
    add_component_to_subsystem!(sys, subsystems[2], components[2])
    add_component_to_subsystem!(sys, subsystems[2], components[3])
    add_component_to_subsystem!(sys, subsystems[3], components[3])
    add_component_to_subsystem!(sys, subsystems[3], components[4])
    return (sys, components)
end

@testset "Test get subsystems and components" begin
    sys, components = create_system_with_test_subsystems()
    @test sort!(collect(get_subsystems(sys))) ==
          ["subsystem_1", "subsystem_2", "subsystem_3"]
    @test has_component(sys, "subsystem_1", components[1])
    @test has_component(sys, "subsystem_1", components[2])
    @test has_component(sys, "subsystem_2", components[2])
    @test has_component(sys, "subsystem_2", components[3])
    @test has_component(sys, "subsystem_3", components[3])
    @test has_component(sys, "subsystem_3", components[4])
    @test !has_component(sys, "subsystem_3", components[5])
    @test sort!(get_name.(get_subsystem_components(sys, "subsystem_2"))) ==
          sort!([get_name(components[2]), get_name(components[3])])
    @test get_assigned_subsystems(sys, components[1]) == ["subsystem_1"]
    @test is_assigned_to_subsystem(sys, components[1])
    @test !is_assigned_to_subsystem(sys, components[5])
    @test is_assigned_to_subsystem(sys, components[1], "subsystem_1")
    @test !is_assigned_to_subsystem(sys, components[5], "subsystem_1")
    @test_throws ArgumentError add_subsystem!(sys, "subsystem_1")
end

@testset "Test get_components" begin
    sys, components = create_system_with_test_subsystems()
    @test length(
        get_components(ThermalStandard, sys; subsystem_name = "subsystem_1"),
    ) == 2
    name = get_name(components[1])
    @test collect(
        get_components(
            x -> x.name == name,
            ThermalStandard,
            sys;
            subsystem_name = "subsystem_1",
        ),
    )[1].name == name
end

@testset "Test subsystem after remove_component" begin
    sys, components = create_system_with_test_subsystems()
    remove_component!(sys, components[3])
    @test !has_component(sys, "subsystem_2", components[3])
    @test !has_component(sys, "subsystem_3", components[3])
    @test has_component(sys, "subsystem_2", components[2])
    @test has_component(sys, "subsystem_3", components[4])
end

@testset "Test removal of subsystem" begin
    sys, components = create_system_with_test_subsystems()
    remove_subsystem!(sys, "subsystem_2")
    @test sort!(collect(get_subsystems(sys))) == ["subsystem_1", "subsystem_3"]
    @test get_assigned_subsystems(sys, components[2]) == ["subsystem_1"]
    @test_throws ArgumentError remove_subsystem!(sys, "subsystem_2")
end

@testset "Test removal of subsystem component" begin
    sys, components = create_system_with_test_subsystems()
    remove_component_from_subsystem!(sys, "subsystem_2", components[2])
    @test get_name.(get_subsystem_components(sys, "subsystem_2")) ==
          [get_name(components[3])]
    @test_throws ArgumentError remove_component_from_subsystem!(
        sys,
        "subsystem_2",
        components[2],
    )
end

@testset "Test addition of component to invalid subsystem" begin
    sys, components = create_system_with_test_subsystems()
    @test_throws ArgumentError add_component_to_subsystem!(sys, "invalid", components[1])
end

@testset "Test addition of duplicate component to subsystem" begin
    sys, components = create_system_with_test_subsystems()
    @test_throws ArgumentError add_component_to_subsystem!(
        sys,
        "subsystem_1",
        components[1],
    )
end

@testset "Test addition of non-system component" begin
    sys, components = create_system_with_test_subsystems()
    remove_component!(sys, components[1])
    @test_throws ArgumentError add_component_to_subsystem!(
        sys,
        "subsystem_1",
        components[1],
    )
end

@testset "Test invalid subsystem count" begin
    sys = PSB.build_system(
        PSITestSystems,
        "c_sys5_uc";
        add_forecasts = false,
        time_series_read_only = true,
    )
    num_buses = length(get_components(Bus, sys))
    for i in 1:num_buses
        add_subsystem!(sys, "subsystem_$i")
    end
    @test_throws "cannot exceed the number of buses" add_subsystem!(sys, "subsystem")
end

@testset "Test valid subsystem" begin
    sys = create_system_with_subsystems()
    check_components(sys)
end

@testset "Test inconsistent component-subsystem membership" begin
    sys, components = create_system_with_test_subsystems()
    @test_throws IS.InvalidValue check_components(sys)
end

@testset "Test mismatch component-topological membership" begin
    sys = create_system_with_subsystems()
    add_subsystem!(sys, "incomplete_subsystem")
    gen = first(get_components(ThermalStandard, sys))
    bus = get_bus(gen)
    remove_component_from_subsystem!(sys, "subsystem_1", bus)
    add_component_to_subsystem!(sys, "incomplete_subsystem", bus)
    @test_throws IS.InvalidValue PSY._check_topological_consistency(sys, gen)
end

@testset "Test mismatch branch-arc membership" begin
    sys = create_system_with_subsystems()
    add_subsystem!(sys, "incomplete_subsystem")
    branch = first(get_components(Branch, sys))
    arc = get_arc(branch)
    remove_component_from_subsystem!(sys, "subsystem_1", arc)
    add_component_to_subsystem!(sys, "incomplete_subsystem", arc)
    @test_throws IS.InvalidValue PSY._check_branch_consistency(sys, branch)
end

@testset "Test service-contributing-device consistency" begin
    sys = create_system_with_subsystems()
    add_subsystem!(sys, "incomplete_subsystem")
    device = nothing
    service = nothing
    for dev in get_components(Device, sys)
        services = get_services(dev)
        if !isempty(services)
            device = dev
            service = first(services)
            break
        end
    end
    @test !isnothing(device) && !isnothing(service)

    remove_component_from_subsystem!(sys, "subsystem_1", device)
    add_subsystem!(sys, "subsystem_2")
    add_component_to_subsystem!(sys, "subsystem_2", device)

    @test_throws IS.InvalidValue PSY._check_device_service_consistency(sys, device)
end

@testset "Test subsystems with HybridSystem" begin
    sys = PSB.build_system(PSB.PSITestSystems, "test_RTS_GMLC_sys_with_hybrid")
    h_sys = first(get_components(HybridSystem, sys))
    subcomponents = collect(get_subcomponents(h_sys))

    subsystem_name = "subsystem_1"
    add_subsystem!(sys, subsystem_name)
    add_component_to_subsystem!(sys, subsystem_name, h_sys)
    # Ensure that subcomponents get added automatically.
    for subcomponent in subcomponents
        @test is_assigned_to_subsystem(sys, subcomponent, subsystem_name)
    end

    remove_component_from_subsystem!(sys, subsystem_name, subcomponents[1])
    @test_throws IS.InvalidValue PSY._check_subcomponent_consistency(sys, h_sys)

    add_component_to_subsystem!(sys, subsystem_name, subcomponents[1])
    remove_component_from_subsystem!(sys, subsystem_name, h_sys)
    # Ensure that subcomponents get removed automatically.
    for subcomponent in subcomponents
        @test !is_assigned_to_subsystem(sys, subcomponent, subsystem_name)
    end
end

@testset "Test subsystems with RegulationDevice" begin
    sys = create_system_with_regulation_device()
    rd = first(get_components(RegulationDevice, sys))

    subsystem_name = "subsystem_1"
    add_subsystem!(sys, subsystem_name)
    add_component_to_subsystem!(sys, subsystem_name, rd)
    # Ensure that its device gets added automatically.
    @test is_assigned_to_subsystem(sys, rd.device, subsystem_name)

    remove_component_from_subsystem!(sys, subsystem_name, rd.device)
    @test_throws IS.InvalidValue PSY._check_subcomponent_consistency(sys, rd)

    add_component_to_subsystem!(sys, subsystem_name, rd.device)
    remove_component_from_subsystem!(sys, subsystem_name, rd)
    # Ensure that its device gets removed automatically.
    @test !is_assigned_to_subsystem(sys, rd.device, subsystem_name)
end
