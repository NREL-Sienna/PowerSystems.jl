
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
        nodes_5,
        thermal_generators5(nodes_5),
        loads5(nodes_5),
        nothing,
        nothing,
        100.0,
        nothing,
        nothing;
        runchecks = checksys,
    )
    clear_components!(sys5)

    sys5b = System(
        nodes_5,
        thermal_generators5(nodes_5),
        loads5(nodes_5),
        nothing,
        battery5(nodes_5),
        100.0,
        nothing,
        nothing;
        runchecks = checksys,
    )
    clear_components!(sys5b)

    # GitHub issue #234 - fix forecasts5 in data file, use new format
    #_sys5b = PowerSystems._System(nodes_5, thermal_generators5(nodes_5), loads5(nodes_5), nothing, battery5(nodes_5),
    #                              100.0, forecasts5, nothing, nothing)
    #sys5b = System(_sys5b)

    sys5bh = System(
        nodes_5,
        vcat(thermal_generators5(nodes_5), hydro_generators5(nodes_5)),
        loads5(nodes_5),
        branches5(nodes_5),
        battery5(nodes_5),
        100.0,
        nothing,
        nothing;
        runchecks = checksys,
    )
    clear_components!(sys5bh)

    sys5bh = System(;
        buses = nodes_5,
        generators = vcat(thermal_generators5(nodes_5), hydro_generators5(nodes_5)),
        loads = loads5(nodes_5),
        branches = branches5(nodes_5),
        storage = battery5(nodes_5),
        basepower = 100.0,
        services = nothing,
        annex = nothing,
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
        nodes_14,
        thermal_generators14(nodes_14),
        loads14(nodes_14),
        nothing,
        battery14(nodes_14),
        100.0,
        nothing,
        nothing;
        runchecks = checksys,
    )
    clear_components!(sys14b)
    sys14b = PowerSystems.System(
        nodes_14,
        thermal_generators14(nodes_14),
        loads14(nodes_14),
        branches14(nodes_14),
        battery14(nodes_14),
        100.0,
        nothing,
        nothing;
        runchecks = checksys,
    )
    clear_components!(sys14b)
end

@testset "Test System constructor from Matpower" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
end

@testset "Test accessor functions of PowerSystems auto-generated types" begin
    # If this test fails because a type doesn't have a constructor that takes nothing,
    # it's because not all fields in that type are defined in power_system_structs.json
    # with nullable values. Consider adding them so that this "demo-constructor" works.
    # If that isn't appropriate for this type, add it to types_to_skip below.

    types_to_skip = (System,)
    for ps_type in IS.get_all_concrete_subtypes(PowerSystemType)
        ps_type in types_to_skip && continue
        obj = ps_type(nothing)
        for (field_name, field_type) in zip(fieldnames(ps_type), fieldtypes(ps_type))
            func = getfield(PowerSystems, Symbol("get_" * string(field_name)))
            val = func(obj)
            @test val isa field_type
        end
    end
end

@testset "Test component conversion" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    l = get_component(Line, sys, "4")
    PSY.convert_component!(MonitoredLine, l, sys)
    @test isnothing(get_component(Line, sys, "4"))
    @test get_name(get_component(MonitoredLine, sys, "4")) == "4"
    @test_throws ErrorException convert_component!(
        Line,
        get_component(MonitoredLine, sys, "4"),
        sys,
    )
    convert_component!(Line, get_component(MonitoredLine, sys, "4"), sys, force = true)
    @test isnothing(get_component(MonitoredLine, sys, "4"))
end
