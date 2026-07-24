using Test
using PowerSystems

@testset "Substation supplemental attribute" begin
    @testset "Construction and accessors" begin
        substation = Substation(;
            name = "TESTSUB",
            number = 42,
            grounding_resistance = 0.25,
        )
        @test get_name(substation) == "TESTSUB"
        @test get_number(substation) == 42
        @test get_grounding_resistance(substation) == 0.25

        default_sgr = Substation(; name = "DEFAULTSUB", number = 1)
        @test get_grounding_resistance(default_sgr) == 0.1
    end

    @testset "Association to buses and switching devices" begin
        sys = System(100.0)

        bus1 = ACBus(nothing)
        bus1.name = "bus1"
        bus1.number = 1
        bus1.bustype = ACBusTypes.REF
        add_component!(sys, bus1)

        bus2 = ACBus(nothing)
        bus2.name = "bus2"
        bus2.number = 2
        add_component!(sys, bus2)

        arc = Arc(bus1, bus2)
        add_component!(sys, arc)

        device = DiscreteControlledACBranch(nothing)
        device.name = "swd1"
        device.arc = arc
        device.x = 0.0001
        add_component!(sys, device)

        substation = Substation(; name = "TESTSUB", number = 7)
        add_supplemental_attribute!(sys, bus1, substation)
        add_supplemental_attribute!(sys, bus2, substation)
        add_supplemental_attribute!(sys, device, substation)

        @test has_supplemental_attributes(bus1)
        @test has_supplemental_attributes(device)

        attrs = collect(get_supplemental_attributes(Substation, sys))
        @test length(attrs) == 1
        @test get_name(only(attrs)) == "TESTSUB"

        bus_attrs = collect(get_supplemental_attributes(bus1))
        @test get_number(only(bus_attrs)) == 7
    end

    @testset "Serialization round trip" begin
        sys = System(100.0)
        bus1 = ACBus(nothing)
        bus1.name = "bus1"
        bus1.number = 1
        bus1.bustype = ACBusTypes.REF
        add_component!(sys, bus1)

        substation = Substation(;
            name = "SERSUB",
            number = 3,
            grounding_resistance = 0.5,
        )
        add_supplemental_attribute!(sys, bus1, substation)

        mktempdir() do tmp
            json_path = joinpath(tmp, "sys_substation.json")
            to_json(sys, json_path; force = true)
            sys2 = System(json_path)
            attr = only(collect(get_supplemental_attributes(Substation, sys2)))
            @test get_name(attr) == "SERSUB"
            @test get_number(attr) == 3
            @test get_grounding_resistance(attr) == 0.5
            bus1_loaded = get_component(ACBus, sys2, "bus1")
            @test has_supplemental_attributes(bus1_loaded)
        end
    end
end

@testset "DiscreteControlledACBranch normal_branch_status" begin
    device = DiscreteControlledACBranch(nothing)
    @test get_normal_branch_status(device) == DiscreteControlledBranchStatus.CLOSED

    set_normal_branch_status!(device, DiscreteControlledBranchStatus.OPEN)
    @test get_normal_branch_status(device) == DiscreteControlledBranchStatus.OPEN

    bus_from = ACBus(nothing)
    bus_from.name = "nb1"
    bus_from.number = 11
    bus_to = ACBus(nothing)
    bus_to.name = "nb2"
    bus_to.number = 12
    kwarg_device = DiscreteControlledACBranch(;
        name = "swd_kwargs",
        available = true,
        active_power_flow = 0.0,
        reactive_power_flow = 0.0,
        arc = Arc(bus_from, bus_to),
        r = 0.0,
        x = 0.0001,
        rating = 10.0,
        normal_branch_status = DiscreteControlledBranchStatus.OPEN,
    )
    @test get_normal_branch_status(kwarg_device) == DiscreteControlledBranchStatus.OPEN
end
