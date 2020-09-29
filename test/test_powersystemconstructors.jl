
include(joinpath(BASE_DIR, "test", "data_5bus_pu.jl"))
include(joinpath(BASE_DIR, "test", "data_14bus_pu.jl"))

checksys = false

@testset "Test System constructors from .jl files" begin
    tPowerSystem = System(nothing)
    nodes_5 = nodes5()
    nodes_14 = nodes14()

    for i in nodes_5
        nodes_5[i].angle = deg2rad(nodes_5[i].angle)
    end

    # Components with forecasts cannot be added to multiple systems, so clear them on each
    # test.

    sys5 = System(
        100.0,
        nodes_5,
        thermal_generators5(nodes_5),
        loads5(nodes_5);
        runchecks = checksys,
    )
    clear_components!(sys5)

    sys5b = System(
        100.0,
        nodes_5,
        thermal_generators5(nodes_5),
        loads5(nodes_5),
        battery5(nodes_5);
        runchecks = checksys,
    )
    clear_components!(sys5b)

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys5b = PowerSystems._System(nodes_5, thermal_generators5(nodes_5), loads5(nodes_5), nothing, battery5(nodes_5),
    #                              100.0, forecasts5, nothing, nothing)
    #sys5b = System(_sys5b)

    sys5bh = System(
        100.0,
        nodes_5,
        thermal_generators5(nodes_5),
        hydro_generators5(nodes_5),
        loads5(nodes_5),
        branches5(nodes_5),
        battery5(nodes_5);
        runchecks = checksys,
    )
    clear_components!(sys5bh)

    # Test Data for 14 Bus

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys14 = PowerSystems._System(nodes_14, thermal_generators14, loads14, nothing, nothing,
    #                            100.0, Dict{Symbol,Vector{<:Forecast}}(),nothing,nothing)
    #sys14 = System(_sys14)

    for i in nodes_14
        nodes_14[i].angle = deg2rad(nodes_14[i].angle)
    end

    sys14b = PowerSystems.System(
        100.0,
        nodes_14,
        thermal_generators14(nodes_14),
        loads14(nodes_14),
        battery14(nodes_14);
        runchecks = checksys,
    )
    clear_components!(sys14b)
    sys14b = PowerSystems.System(
        100.0,
        nodes_14,
        thermal_generators14(nodes_14),
        loads14(nodes_14),
        branches14(nodes_14),
        battery14(nodes_14);
        runchecks = checksys,
    )
    clear_components!(sys14b)
end

@testset "Test System constructor from Matpower" begin
    # Include a System kwarg to make sure it doesn't get forwarded to PM functions.
    sys = System(joinpath(MATPOWER_DIR, "case5_re.m"); runchecks = true)
end

@testset "Test accessor functions of PowerSystems auto-generated types" begin
    # If this test fails because a type doesn't have a constructor that takes nothing,
    # it's because not all fields in that type are defined in power_system_structs.json
    # with nullable values. Consider adding them so that this "demo-constructor" works.
    # If that isn't appropriate for this type, add it to types_to_skip below.

    types_to_skip = (System, TestDevice, TestRenDevice)
    for ps_type in IS.get_all_concrete_subtypes(Component)
        ps_type in types_to_skip && continue
        obj = ps_type(nothing)
        for (field_name, field_type) in zip(fieldnames(ps_type), fieldtypes(ps_type))
            if field_name === :name || field_name === :forecasts
                func = getfield(InfrastructureSystems, Symbol("get_" * string(field_name)))
                _func! = getfield(
                    InfrastructureSystems,
                    Symbol("set_" * string(field_name) * "!"),
                )
            else
                func = getfield(PowerSystems, Symbol("get_" * string(field_name)))
                _func! = getfield(PowerSystems, Symbol("set_" * string(field_name) * "!"))
            end
            val = func(obj)
            _func!(obj, val)
            @test val isa field_type
            #Test set function for different cases
            if typeof(val) == Float64 || typeof(val) == Int
                if !isnan(val)
                    aux = val + 1
                    _func!(obj, aux)
                    @test func(obj) == aux
                end
            elseif typeof(val) == String
                aux = val * "1"
                _func!(obj, aux)
                @test func(obj) == aux
            elseif typeof(val) == Bool
                aux = !val
                _func!(obj, aux)
                @test func(obj) == aux
            end
        end
    end
end

@testset "Test component conversion" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    l = get_component(Line, sys, "4")
    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    dates = collect(initial_time:Dates.Hour(1):Dates.DateTime("2020-01-01T23:00:00"))
    data = collect(1:24)
    ta = TimeSeries.TimeArray(dates, data, [get_name(l)])
    label = "active_power_flow"
    forecast = Deterministic(label, ta)
    add_forecast!(sys, l, forecast)
    @test get_forecast(Deterministic, l, initial_time, label) isa Deterministic
    PSY.convert_component!(MonitoredLine, l, sys)
    @test isnothing(get_component(Line, sys, "4"))
    mline = get_component(MonitoredLine, sys, "4")
    @test !isnothing(mline)
    @test get_name(mline) == "4"
    @test get_forecast(Deterministic, mline, initial_time, label) isa Deterministic
    @test_throws ErrorException convert_component!(
        Line,
        get_component(MonitoredLine, sys, "4"),
        sys,
    )
    convert_component!(Line, get_component(MonitoredLine, sys, "4"), sys, force = true)
    line = get_component(Line, sys, "4")
    @test !isnothing(mline)
    @test get_forecast(Deterministic, line, initial_time, label) isa Deterministic
end
