checksys = false

@testset "Test System constructors from .jl files" begin
    tPowerSystem = System(nothing)
    nodes_5_nodes = nodes5()
    nodes_14_nodes = nodes14()

    for node in nodes_5_nodes
        node.angle = deg2rad(node.angle)
    end

    # Components with time_series cannot be added to multiple systems, so clear them on each
    # test.

    sys5 = System(
        100.0,
        nodes_5_nodes,
        thermal_generators5(nodes_5_nodes),
        loads5(nodes_5_nodes);
        runchecks = checksys,
    )
    clear_components!(sys5)

    sys5b = System(
        100.0,
        nodes_5_nodes,
        thermal_generators5(nodes_5_nodes),
        loads5(nodes_5_nodes),
        battery5(nodes_5_nodes);
        runchecks = checksys,
    )
    clear_components!(sys5b)

    sys5f = System(
        100.0,
        nodes_5_nodes,
        thermal_generators5(nodes_5_nodes),
        loads5(nodes_5_nodes),
        shiftable5(nodes_5_nodes);
        runchecks = checksys,
    )
    clear_components!(sys5f)

    # GitHub issue #234 - fix time_series5 in data file, use new format
    #_sys5b = PowerSystems._System(nodes_5, thermal_generators5(nodes_5), loads5(nodes_5), nothing, battery5(nodes_5),
    #                              100.0, time_series5, nothing, nothing)
    #sys5b = System(_sys5b)

    sys5bh = System(
        100.0,
        nodes_5_nodes,
        thermal_generators5(nodes_5_nodes),
        hydro_generators5(nodes_5_nodes),
        loads5(nodes_5_nodes),
        branches5(nodes_5_nodes),
        battery5(nodes_5_nodes);
        runchecks = checksys,
    )
    clear_components!(sys5bh)

    # Test Data for 14 Bus

    # GitHub issue #234 - fix time_series5 in data file, use new format
    #_sys14 = PowerSystems._System(nodes_14, thermal_generators14, loads14, nothing, nothing,
    #                            100.0, Dict{Symbol,Vector{<:TimeSeriesData}}(),nothing,nothing)
    #sys14 = System(_sys14)

    for node in nodes_14_nodes
        node.angle = deg2rad(node.angle)
    end

    sys14b = PowerSystems.System(
        100.0,
        nodes_14_nodes,
        thermal_generators14(nodes_14_nodes),
        loads14(nodes_14_nodes),
        battery14(nodes_14_nodes);
        runchecks = checksys,
    )
    clear_components!(sys14b)
    sys14b = PowerSystems.System(
        100.0,
        nodes_14_nodes,
        thermal_generators14(nodes_14_nodes),
        loads14(nodes_14_nodes),
        branches14(nodes_14_nodes),
        battery14(nodes_14_nodes);
        runchecks = checksys,
    )
    clear_components!(sys14b)
end

@testset "Test System constructor from Matpower" begin
    # Include a System kwarg to make sure it doesn't get forwarded to PM functions.
    kwarg_test =
        () -> begin
            sys = System(
                joinpath(BAD_DATA,
                    "case5_re.m");
                runchecks = true,
            )
        end
    @test_logs (:error,) min_level = Logging.Error match_mode = :any kwarg_test()
end

@testset "Test accessor functions of PowerSystems auto-generated types" begin
    # If this test fails because a type doesn't have a constructor that takes nothing,
    # it's because not all fields in that type are defined in power_system_structs.json
    # with nullable values. Consider adding them so that this "demo-constructor" works.
    # If that isn't appropriate for this type, add it to types_to_skip below.
    # You can also call test_accessors wherever an instance has been created.

    types_to_skip = (TestDevice, TestRenDevice, TestInjector, NonexistentComponent)
    types = vcat(
        IS.get_all_concrete_subtypes(Component),
        IS.get_all_concrete_subtypes(DynamicComponent),
        IS.get_all_concrete_subtypes(PowerSystems.ActivePowerControl),
        IS.get_all_concrete_subtypes(PowerSystems.ReactivePowerControl),
    )
    sort!(types; by = x -> string(x))
    for ps_type in types
        ps_type in types_to_skip && continue
        component = ps_type(nothing)
        test_accessors(component)
    end
end

@testset "Test required accessor functions of subtypes of Component " begin
    types = IS.get_all_concrete_subtypes(Component)
    types_to_skip = (TestDevice, TestRenDevice, NonexistentComponent, TestInjector)
    sort!(types; by = x -> string(x))
    for ps_type in types
        ps_type in types_to_skip && continue
        component = ps_type(nothing)
        @test get_name(component) isa String
        @test IS.get_internal(component) isa IS.InfrastructureSystemsInternal
    end
end

@testset "Test component conversion" begin
    test_line_conversion =
        () -> begin
            sys = System(joinpath(BAD_DATA, "case5_re.m"))
            l = get_component(Line, sys, "bus2-bus3-i_4")
            initial_time = Dates.DateTime("2020-01-01T00:00:00")
            dates = collect(
                initial_time:Dates.Hour(1):Dates.DateTime("2020-01-01T23:00:00"),
            )
            data = collect(1:24)
            ta = TimeSeries.TimeArray(dates, data, [get_name(l)])
            name = "active_power_flow"
            time_series = SingleTimeSeries(; name = name, data = ta)
            add_time_series!(sys, l, time_series)
            @test get_time_series(SingleTimeSeries, l, name) isa SingleTimeSeries
            PSY.convert_component!(sys, l, MonitoredLine)
            @test isnothing(get_component(Line, sys, "bus2-bus3-i_4"))
            mline = get_component(MonitoredLine, sys, "bus2-bus3-i_4")
            @test !isnothing(mline)
            @test get_name(mline) == "bus2-bus3-i_4"
            @test get_time_series(SingleTimeSeries, mline, name) isa SingleTimeSeries
            @test_throws ErrorException convert_component!(
                sys,
                get_component(MonitoredLine, sys, "bus2-bus3-i_4"),
                Line,
            )
            convert_component!(
                sys,
                get_component(MonitoredLine, sys, "bus2-bus3-i_4"),
                Line;
                force = true,
            )
            line = get_component(Line, sys, "bus2-bus3-i_4")
            @test !isnothing(mline)
            @test get_time_series(SingleTimeSeries, line, name) isa SingleTimeSeries
        end

    test_load_conversion =
        () -> begin
            sys = PSB.build_system(PSB.PSITestSystems, "c_sys5")
            component_name = "Bus2"
            ts_name = "max_active_power"
            old_component = get_component(PowerLoad, sys, component_name)
            dates = collect(
                Dates.DateTime("2020-01-01T00:00:00"):Dates.Hour(1):Dates.DateTime(
                    "2020-01-01T23:00:00",
                ),
            )
            data = collect(1:24)
            ta = TimeSeries.TimeArray(dates, data, [component_name])
            time_series = SingleTimeSeries(; name = ts_name, data = ta)
            add_time_series!(sys, old_component, time_series)
            @test get_time_series(SingleTimeSeries, old_component, ts_name) isa
                  SingleTimeSeries

            convert_component!(sys, old_component, StandardLoad)
            @test isnothing(get_component(typeof(old_component), sys, component_name))
            new_component = get_component(StandardLoad, sys, component_name)
            @test !isnothing(new_component)
            @test get_name(new_component) == component_name
            @test get_time_series(SingleTimeSeries, new_component, ts_name) isa
                  SingleTimeSeries
            # Conversion back is not implemented
        end

    @test_logs (:error,) min_level = Logging.Error match_mode = :any test_line_conversion()
    test_load_conversion()
end
