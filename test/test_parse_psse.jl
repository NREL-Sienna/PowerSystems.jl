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
    sys = build_system(PSYTestSystems, "psse_240_parsing_sys") # current/imedance_power read in natural units during parsing
    @test get_current_active_power(get_component(StandardLoad, sys, "load10021")) == 2.2371
    @test get_impedance_reactive_power(get_component(StandardLoad, sys, "load10021")) ==
          5.83546
    sys2 = build_system(PSYTestSystems, "psse_Benchmark_4ger_33_2015_sys")  # Constant_active/reactive_power read in pu during parsing
    @test get_constant_active_power(get_component(StandardLoad, sys2, "load71")) == 9.67
    @test get_constant_reactive_power(get_component(StandardLoad, sys2, "load71")) == 1.0

    @info "Testing Generator Parsing"
    @test get_status(get_component(ThermalStandard, sys, "generator-2438-ND")) == 0
    @test get_available(get_component(ThermalStandard, sys, "generator-2438-ND")) == 0
    @test get_status(get_component(ThermalStandard, sys, "generator-2438-EG")) == 1
    @test get_available(get_component(ThermalStandard, sys, "generator-2438-EG")) == 1

    sys3 = build_system(PSSEParsingTestSystems, "psse_ACTIVSg2000_sys")
    sys4 = build_system(PSSEParsingTestSystems, "pti_frankenstein_70_sys")

    base_dir = string(dirname(@__FILE__))
    file_dir = joinpath(base_dir, "test_data", "5circuit_3w.raw")
    sys5 = System(file_dir)

    @info "Testing Three-Winding Transformer Parsing"

    @test isnothing(get_component(Transformer3W, sys3, "1"))

    @test get_available(
        get_component(Transformer3W, sys4, "FAV PLACE 07-FAV SPOT 06-FAV SPOT 03-i_1"),
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
    @test get_available(get_component(SwitchedAdmittance, sys3, "1030-9")) == false
    @test only(get_Y_increase(get_component(SwitchedAdmittance, sys3, "3147-42"))).im ==
          0.35
    @test get_admittance_limits(get_component(SwitchedAdmittance, sys3, "3147-42")).min ==
          1.03
    @test only(get_number_of_steps(get_component(SwitchedAdmittance, sys3, "7075-119"))) ==
          1
    @test only(get_Y_increase(get_component(SwitchedAdmittance, sys3, "7075-119"))).im ==
          3.425

    @test get_available(get_component(SwitchedAdmittance, sys4, "1005-2")) == true
    @test get_Y(get_component(SwitchedAdmittance, sys4, "1005-2")) == 0.06im
    @test get_admittance_limits(get_component(SwitchedAdmittance, sys4, "1005-2")).max ==
          1.045
    @test only(get_Y_increase(get_component(SwitchedAdmittance, sys4, "1005-2"))).im == 0.06

    @test length(get_components(SwitchedAdmittance, sys4)) == 2
    @test get_available(get_component(SwitchedAdmittance, sys4, "1003-1")) == true
    @test get_Y(get_component(SwitchedAdmittance, sys4, "1003-1")) == 0.038im
    @test get_admittance_limits(get_component(SwitchedAdmittance, sys4, "1003-1")).min ==
          0.95

    @info "Testing VSC Parser"
    vsc = only(get_components(TwoTerminalVSCLine, sys4))
    @test get_active_power_flow(vsc) == -0.2
    @test get_dc_setpoint_to(vsc) == -20.0

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
        control_mode = 1,
        max_shunt_current = 9999.0,
        reactive_power_required = 100.0,
        voltage_setpoint = 1.0,
    )
    add_component!(sys, facts_1)

    facts = only(get_components(FACTSControlDevice, sys))
    @test get_available(facts) == true
    @test get_voltage_setpoint(facts) == 1.0
    @test get_max_shunt_current(facts) == 9999.0
    @test get_reactive_power_required(facts) > 0
    @test get_control_mode(facts) == FACTSOperationModes.NML
end

@testset "PSSE Switches & Breakers Parsing" begin
    sys = build_system(PSSEParsingTestSystems, "pti_case24_sys")
    line1 = first(get_components(Line, sys))
    sw_1 = DiscreteControlledACBranch(;
        name = "SWITCH 1",
        available = true,
        arc = line1.arc,
        active_power_flow = 0.0,
        reactive_power_flow = 0.0,
        r = 0.0,
        x = line1.x,
        rating = line1.rating,
        discrete_branch_type = 0,
        branch_status = 1,
    )
    add_component!(sys, sw_1)
    line2 = get_component(Line, sys, "15-16-i_1")
    br_1 = DiscreteControlledACBranch(;
        name = "BREAKER 1",
        available = true,
        arc = line2.arc,
        active_power_flow = 0.0,
        reactive_power_flow = 0.0,
        r = 0.0,
        x = line2.x,
        rating = line2.rating,
        discrete_branch_type = 1,
        branch_status = 1,
    )
    add_component!(sys, br_1)
    line3 = get_component(Line, sys, "20-23-i_1")
    otr_1 = DiscreteControlledACBranch(;
        name = "OTHER 1",
        available = true,
        arc = line3.arc,
        active_power_flow = 0.0,
        reactive_power_flow = 0.0,
        r = line3.r,
        x = line3.x,
        rating = line3.rating,
        discrete_branch_type = 2,
        branch_status = 1,
    )
    add_component!(sys, otr_1)

    switch = get_component(DiscreteControlledACBranch, sys, "SWITCH 1")
    breaker = get_component(DiscreteControlledACBranch, sys, "BREAKER 1")
    other = get_component(DiscreteControlledACBranch, sys, "OTHER 1")

    @test get_available(switch) == true
    @test get_available(breaker) == true
    @test get_available(other) == true

    @test get_discrete_branch_type(switch) == DiscreteControlledBranchType.SWITCH
    @test get_discrete_branch_type(breaker) == DiscreteControlledBranchType.BREAKER

    @test get_branch_status(switch) == DiscreteControlledBranchStatus.CLOSED
    @test get_branch_status(other) == DiscreteControlledBranchStatus.CLOSED
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
