@testset "PSSE Parsing" begin
    files = readdir(PSSE_RAW_DIR)
    if length(files) == 0
        error("No test files in the folder")
    end

    for f in files[1:1]
        @info "Parsing $f ..."
        pm_data = PowerSystems.PowerModelsData(joinpath(PSSE_RAW_DIR, f))
        @info "Successfully parsed $f to PowerModelsData"
        sys = System(pm_data)
        for g in get_components(Generator, sys)
            @test haskey(get_ext(g), "z_source")
        end
        @info "Successfully parsed $f to System struct"
    end

    # Test bad input
    pm_data = PowerSystems.PowerModelsData(joinpath(PSSE_RAW_DIR, files[1]))
    pm_data.data["bus"] = Dict{String, Any}()
    @test_throws PowerSystems.DataFormatError System(pm_data)
end

@testset "PSSE Component Parsing" begin
    @info "Testing Load Parsing"
    sys = build_system(PSYTestSystems, "psse_240_parsing_sys") # current/impedance_power read in natural units during parsing
    @test get_current_active_power(get_component(StandardLoad, sys, "load10021")) == 223.71
    @test get_impedance_reactive_power(get_component(StandardLoad, sys, "load10021")) ==
          583.546
    PSB.clear_serialized_systems("psse_Benchmark_4ger_33_2015_sys")
    sys2 = build_system(PSYTestSystems, "psse_Benchmark_4ger_33_2015_sys")  # Constant_active/reactive_power read in pu during parsing
    @test get_constant_active_power(get_component(StandardLoad, sys2, "load71")) == 9.67
    @test get_constant_reactive_power(get_component(StandardLoad, sys2, "load71")) == 1.0

    @info "Testing Generator Parsing"
    @test get_status(get_component(ThermalStandard, sys, "generator-2438-ND")) == 0
    @test get_available(get_component(ThermalStandard, sys, "generator-2438-ND")) == 0
    @test get_status(get_component(ThermalStandard, sys, "generator-2438-EG")) == 1
    @test get_available(get_component(ThermalStandard, sys, "generator-2438-EG")) == 1

    sys3 = build_system(PSSEParsingTestSystems, "psse_ACTIVSg2000_sys")
    sys4 = build_system(PSSEParsingTestSystems, "pti_frankenstein_20_sys")

    base_dir = string(dirname(@__FILE__))
    file_dir = joinpath(base_dir, "test_data", "5circuit_3w.raw")
    sys5 = System(file_dir)

    @info "Testing Three-Winding Transformer Parsing"

    @test isnothing(get_component(Transformer3W, sys3, "1"))

    @test get_available(
        get_component(Transformer3W, sys4, "FAV PLACE 07-FAV PLACE 05-FAV SPOT 03-i_1"),
    ) == true
    tw3s = get_components(Transformer3W, sys4)
    @test length(tw3s) == 1
    tw3 = only(tw3s)
    @test get_b(tw3) == 0.00251
    @test get_primary_turns_ratio(tw3) == 1.0
    @test get_rating(tw3) == 0.0

    @test get_available(
        get_component(Transformer3W, sys5, "FAV SPOT 01-FAV SPOT 02-FAV SPOT 03-i_A"),
    ) == false

    @test get_r_primary(
        get_component(Transformer3W, sys5, "FAV SPOT 01-FAV SPOT 02-FAV SPOT 03-i_C"),
    ) == 0.00225
    @test length(get_components(Transformer3W, sys5)) == 5

    @info "Testing Switched Shunt Parsing"
    @test get_available(get_component(SwitchedAdmittance, sys3, "1030_9")) == false
    @test only(get_Y_increase(get_component(SwitchedAdmittance, sys3, "3147_42"))).im == 35
    @test get_admittance_limits(get_component(SwitchedAdmittance, sys3, "3147_42")).min ==
          1.03
    @test only(get_number_of_steps(get_component(SwitchedAdmittance, sys3, "7075_119"))) ==
          1
    @test only(get_Y_increase(get_component(SwitchedAdmittance, sys3, "7075_119"))).im ==
          342.5

    @test get_available(get_component(SwitchedAdmittance, sys4, "1005_2")) == true
    @test get_Y(get_component(SwitchedAdmittance, sys4, "1005_2")) == 6im
    @test get_admittance_limits(get_component(SwitchedAdmittance, sys4, "1005_2")).max ==
          1.045
    @test only(get_Y_increase(get_component(SwitchedAdmittance, sys4, "1005_2"))).im == 6

    @test length(get_components(SwitchedAdmittance, sys4)) == 2
    @test get_available(get_component(SwitchedAdmittance, sys4, "1003_1")) == true
    @test get_Y(get_component(SwitchedAdmittance, sys4, "1003_1")) == 3.8im
    @test get_admittance_limits(get_component(SwitchedAdmittance, sys4, "1003_1")).min ==
          0.95

    # vsc_sys = build_system(PSSEParsingTestSystems, "pti_vsc_hvdc_test_sys")
    # @info "Testing VSC Parser"
    # vsc = only(get_components(TwoTerminalVSCLine, sys4))
    # @test get_active_power_flow(vsc) == -0.2
    # @test get_dc_setpoint_to(vsc) == -20.0

    @info "Testing Load Zone Formatter"
    PSB.clear_serialized_systems("psse_Benchmark_4ger_33_2015_sys")
    sys3 = build_system(
        PSYTestSystems,
        "psse_Benchmark_4ger_33_2015_sys";
        loadzone_name_formatter = x -> string(3 * x),
    )
    lz_original = only(get_components(LoadZone, sys2))
    lz_new = only(get_components(LoadZone, sys3))
    @test parse(Int, get_name(lz_new)) == 3 * parse(Int, get_name(lz_original))
end

@testset "PSSE FACTS Control Devices Parsing" begin
    sys = build_system(PSSEParsingTestSystems, "pti_case14_sys")
    bus2 = get_component(ACBus, sys, "Bus 2     HV")
    facts_1 = FACTSControlDevice(;
        name = "FACTS 1",
        available = true,
        bus = bus2,
        mode = 1,
        max_shunt_current = 9999.0,
        reactive_power_required = 100.0,
        voltage_setpoint = 1.0,
    )
    add_component!(sys, facts_1)

    facts = only(get_components(FACTSControlDevice, sys))
    @test get_available(facts) == true
    @test get_voltage_setpoint(facts) == 1.0
    @test get_max_shunt_current(facts) == 9999.0
    @test get_mode(facts) == 1
end

@testset "PSSE LCC Parsing" begin
    sys = build_system(PSSEParsingTestSystems, "pti_two_terminal_hvdc_test_sys")

    lccs = get_components(TwoTerminalLCCLine, sys)
    @test length(lccs) == 1
    lcc = only(lccs)
    @test get_transfer_setpoint(lcc) == 20.0
    @test get_active_power_flow(lcc) == 0.2
    @test isapprox(get_rectifier_delay_angle_limits(lcc).max, pi / 2)
    @test isapprox(get_inverter_extinction_angle_limits(lcc).max, pi / 2)
    @test get_power_mode(lcc)
end
