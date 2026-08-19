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
            @test haskey(get_ext(g), "r")
            @test haskey(get_ext(g), "x")
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
    mp_sys = build_system(MatpowerTestSystems, "matpower_case24_sys")
    @test get_active_power(get_component(PowerLoad, mp_sys, "bus14")) == 1.94
    @test get_max_reactive_power(get_component(PowerLoad, mp_sys, "bus14")) == 0.39
    @test get_conformity(get_component(PowerLoad, mp_sys, "bus14")) ==
          LoadConformity.CONFORMING

    sys = build_system(PSYTestSystems, "psse_240_parsing_sys") # current/imedance_power read in natural units during parsing
    @test get_current_active_power(get_component(StandardLoad, sys, "load10021")) == 2.2371
    @test get_impedance_reactive_power(get_component(StandardLoad, sys, "load10021")) ==
          -5.83546
    @test get_conformity(get_component(StandardLoad, sys, "load10021")) ==
          LoadConformity.CONFORMING

    sys2 = build_system(PSYTestSystems, "psse_Benchmark_4ger_33_2015_sys")  # Constant_active/reactive_power read in pu during parsing
    @test get_constant_active_power(get_component(StandardLoad, sys2, "load71")) == 9.67
    @test get_constant_reactive_power(get_component(StandardLoad, sys2, "load71")) == 1.0
    @test get_conformity(get_component(StandardLoad, sys2, "load71")) ==
          LoadConformity.CONFORMING

    @info "Testing ZIP Load Parsing"
    wecc_sys = build_system(PSYTestSystems, "psse_240_parsing_sys")
    test_load1 = get_component(StandardLoad, wecc_sys, "load24091")
    impedance_q = get_impedance_reactive_power(test_load1)
    # Negative for capacitive loads
    @test impedance_q < 0
    @test isapprox(impedance_q, -0.75; atol = 1e-4)

    test_load2 = get_component(StandardLoad, wecc_sys, "load10031")
    impedance_q = get_impedance_reactive_power(test_load2)
    # Positive for inductance loads
    @test impedance_q > 0
    @test isapprox(impedance_q, 3.873; atol = 1e-3)

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
    @test haskey(
        get_ext(get_component(Transformer2W, sys3, "DALLAS 1 3-DALLAS 1 0-i_1")),
        "psse_name",
    )
    @test get_available(
        get_component(Transformer3W, sys4, "FAV PLACE 07-FAV SPOT 06-FAV SPOT 03-i_1"),
    ) == true
    tw3s = get_components(Transformer3W, sys4)
    @test length(tw3s) == 1
    tw3 = only(tw3s)
    @test isapprox(get_b(tw3), 0.0036144)
    @test get_primary_turns_ratio(tw3) == 1.5
    @test get_rating(tw3) == 0.0

    @test get_available(
        get_component(Transformer3W, sys5, "FAV SPOT 01-FAV SPOT 02-FAV SPOT 03-i_A"),
    ) == false

    @test get_r_primary(
        get_component(Transformer3W, sys5, "FAV SPOT 01-FAV SPOT 02-FAV SPOT 03-i_C"),
    ) == 0.00225
    @test haskey(
        get_ext(
            get_component(Transformer3W, sys5, "FAV SPOT 01-FAV SPOT 02-FAV SPOT 03-i_C"),
        ),
        "psse_name",
    )

    @test length(get_components(Transformer3W, sys5)) == 5

    @info "Testing Phase Shifting Three-Winding Transformer Parsing"
    sys_pst3w = build_system(PSSEParsingTestSystems, "pti_case14_with_pst3w_sys")

    pst3w_1, pst3w_2 = sort(
        collect(get_components(PhaseShiftingTransformer3W, sys_pst3w)),
        by = get_name,
    )

    @test get_available(pst3w_1) == true
    @test get_available(pst3w_2) == true

    @test isapprox(get_α_primary(pst3w_1), -0.5236; atol = 1e-4)
    @test isapprox(get_α_secondary(pst3w_1), 2.6179; atol = 1e-4)
    @test isapprox(get_α_tertiary(pst3w_1), -1.3962; atol = 1e-4)

    @test isapprox(get_α_primary(pst3w_2), 1.0471; atol = 1e-4)
    @test isapprox(get_α_secondary(pst3w_2), 0.0; atol = 1e-4)
    @test isapprox(get_α_tertiary(pst3w_2), -2.0943; atol = 1e-4)

    @test length(get_components(PhaseShiftingTransformer3W, sys_pst3w)) == 2

    @info "Testing Switched Shunt Parsing"
    @test get_available(get_component(SwitchedAdmittance, sys3, "1030-9")) == false
    @test only(
        get_Y_increase(get_component(SwitchedAdmittance, sys3, "3147-42")),
    ).im ==
          0.35
    @test get_admittance_limits(
        get_component(SwitchedAdmittance, sys3, "3147-42"),
    ).min ==
          1.03
    @test only(
        get_number_of_steps(
            get_component(SwitchedAdmittance, sys3, "7075-119"),
        ),
    ) ==
          1
    @test only(
        get_Y_increase(get_component(SwitchedAdmittance, sys3, "7075-119")),
    ).im ==
          3.425

    @test get_available(get_component(SwitchedAdmittance, sys4, "1005-2")) ==
          true
    @test get_Y(get_component(SwitchedAdmittance, sys4, "1005-2")) == 0.06im
    @test get_admittance_limits(
        get_component(SwitchedAdmittance, sys4, "1005-2"),
    ).max ==
          1.045
    @test only(
        get_Y_increase(get_component(SwitchedAdmittance, sys4, "1005-2")),
    ).im == 0.06

    @test length(get_components(SwitchedAdmittance, sys4)) == 2
    @test get_available(get_component(SwitchedAdmittance, sys4, "1003-1")) ==
          true
    @test get_Y(get_component(SwitchedAdmittance, sys4, "1003-1")) == 0.038im
    @test get_admittance_limits(
        get_component(SwitchedAdmittance, sys4, "1003-1"),
    ).min ==
          0.95

    @info "Testing VSC Parser"
    vsc = only(get_components(TwoTerminalVSCLine, sys4))
    @test get_active_power_flow(vsc) == -0.2
    @test get_dc_setpoint_to(vsc) == -0.2
    # VSC control state is stored in first-class fields (no `ext`): DC base voltage and the
    # AC-voltage-control remote regulation per terminal.
    @test isempty(get_ext(vsc))
    @test get_rated_dc_voltage(vsc) > 0.0
    @test get_remote_bus_control_from(vsc) isa Int
    @test get_rmpct_from(vsc) >= 0.0

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

@testset "PSSE FACTS Shunt Round-Trip Parsing" begin
    sys = build_system(PSSEParsingTestSystems, "pti_facts_shunt_sys")
    fd = only(get_components(FACTSControlDevice, sys))
    @test get_max_shunt_current(fd) == 60.0
    @test get(get_ext(fd), "IMX", nothing) == 50.0
    @test get_regulated_bus_number(fd) == 3
    @test get_voltage_setpoint(fd) == 1.02
    @test get_reactive_power_required(fd) == 0.0
    @test get(get_ext(fd), "RMPCT", nothing) == 95.0
    @test get_shunt_control_type(fd) == FACTSShuntControlType.STATCOM
end

@testset "PSSE Generators as Synchronous Condensers" begin
    sys = build_system(PSSEParsingTestSystems, "pti_case11_with_synchronous_condensers_sys")
    sc_gen1 = collect(get_components(SynchronousCondenser, sys))[1]

    @test !hasproperty(sc_gen1, :active_power)
    @test get_rating(sc_gen1) >= 0.0
    @test get_reactive_power(sc_gen1) != 0.0
    @test get_available(sc_gen1) == true
    @test get_bustype(get_bus(sc_gen1)) == ACBusTypes.PV
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

@testset "PSSE default branch name counter" begin
    sys = build_system(PSSEParsingTestSystems, "pti_case24_sys")
    buses = collect(get_components(ACBus, sys))
    bus_f = buses[1]
    bus_t = buses[2]

    branch_pair_counts = Dict{Tuple{String, String}, Int}()
    d1 = Dict{String, Any}("source_id" => Any["transformer", 1, 2, 0, " 1", 0])
    d2 = Dict{String, Any}("source_id" => Any["transformer", 1, 2, 0, "1 ", 0])

    n1 =
        PowerSystems._get_pm_branch_name_with_counter!(d1, bus_f, bus_t, branch_pair_counts)
    n2 =
        PowerSystems._get_pm_branch_name_with_counter!(d2, bus_f, bus_t, branch_pair_counts)

    @test n1 != n2
    @test endswith(n1, "-i_1")
    @test endswith(n2, "-i_2")
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

@testset "PSSE Impedance Correction Table Parsing" begin
    base_dir = string(dirname(@__FILE__))
    file_dir = joinpath(base_dir, "test_data", "modified_14bus_system.raw")
    sys = System(file_dir)

    tr2w_1 = get_component(Transformer2W, sys, "BUS 110-BUS 109-i_1")
    suppl_attr_tr2w_1 = only(get_supplemental_attributes(tr2w_1))
    @test get_table_number(suppl_attr_tr2w_1) == 3
    @test get_points(get_impedance_correction_curve(suppl_attr_tr2w_1))[1] ==
          (x = -24.1, y = 1.27)
    @test get_points(get_impedance_correction_curve(suppl_attr_tr2w_1))[end] ==
          (x = 24.1, y = 1.27)
    @test get_transformer_winding(suppl_attr_tr2w_1) == WindingCategory.TR2W_WINDING
    @test get_transformer_control_mode(suppl_attr_tr2w_1) ==
          ImpedanceCorrectionTransformerControlMode.PHASE_SHIFT_ANGLE

    tr2w_2 = get_component(Transformer2W, sys, "BUS 109-BUS 104-i_1")
    suppl_attr_tr2w_2 = only(get_supplemental_attributes(tr2w_2))
    @test get_table_number(suppl_attr_tr2w_2) == 4
    @test get_points(get_impedance_correction_curve(suppl_attr_tr2w_2))[1] ==
          (x = 0.88, y = 1.093)
    @test get_points(get_impedance_correction_curve(suppl_attr_tr2w_2))[end] ==
          (x = 1.17, y = 0.916)
    @test get_transformer_winding(suppl_attr_tr2w_2) == WindingCategory.TR2W_WINDING
    @test get_transformer_control_mode(suppl_attr_tr2w_2) ==
          ImpedanceCorrectionTransformerControlMode.TAP_RATIO

    tr2w_3 = get_component(Transformer2W, sys, "BUS 106-BUS 105-i_1")
    suppl_attr_tr2w_3 = only(get_supplemental_attributes(tr2w_3))
    @test get_table_number(suppl_attr_tr2w_3) == 7
    @test get_points(get_impedance_correction_curve(suppl_attr_tr2w_3))[1] ==
          (x = -45.0, y = 2.073)
    @test get_points(get_impedance_correction_curve(suppl_attr_tr2w_3))[end] ==
          (x = 45.0, y = 2.073)
    @test get_transformer_winding(suppl_attr_tr2w_3) == WindingCategory.TR2W_WINDING
    @test get_transformer_control_mode(suppl_attr_tr2w_3) ==
          ImpedanceCorrectionTransformerControlMode.PHASE_SHIFT_ANGLE

    tr3w_1 = get_component(Transformer3W, sys, "BUS 109-BUS 104-BUS 107-i_1")
    suppl_attr_tr3w_1 = collect(get_supplemental_attributes(tr3w_1))

    filtered_tertiary_tr3w_1 = only(
        filter(
            x -> get_transformer_winding(x) == WindingCategory.TERTIARY_WINDING,
            suppl_attr_tr3w_1,
        ),
    )
    @test get_table_number(filtered_tertiary_tr3w_1) == 4
    @test get_points(get_impedance_correction_curve(filtered_tertiary_tr3w_1))[1] ==
          (x = 0.88, y = 1.093)
    @test get_points(get_impedance_correction_curve(filtered_tertiary_tr3w_1))[end] ==
          (x = 1.17, y = 0.916)
    @test get_transformer_control_mode(filtered_tertiary_tr3w_1) ==
          ImpedanceCorrectionTransformerControlMode.TAP_RATIO

    filtered_secondary_tr3w_2 = only(
        filter(
            x -> get_transformer_winding(x) == WindingCategory.SECONDARY_WINDING,
            suppl_attr_tr3w_1,
        ),
    )
    @test get_table_number(filtered_secondary_tr3w_2) == 8
    @test get_points(get_impedance_correction_curve(filtered_secondary_tr3w_2))[1] ==
          (x = -60.0, y = 1.5718)
    @test get_points(get_impedance_correction_curve(filtered_secondary_tr3w_2))[end] ==
          (x = 60.0, y = 1.5718)
    @test get_transformer_control_mode(filtered_secondary_tr3w_2) ==
          ImpedanceCorrectionTransformerControlMode.PHASE_SHIFT_ANGLE

    tr3w_2 = get_component(Transformer3W, sys, "BUS 113-BUS 110-BUS 114-i_1")
    suppl_attr_tr3w_2 = collect(get_supplemental_attributes(tr3w_2))

    filtered_primary_tr3w_2 = only(
        filter(
            x -> get_transformer_winding(x) == WindingCategory.PRIMARY_WINDING,
            suppl_attr_tr3w_2,
        ),
    )
    @test get_table_number(filtered_primary_tr3w_2) == 9
    @test get_points(get_impedance_correction_curve(filtered_primary_tr3w_2))[1] ==
          (x = -40.0, y = 1.4)
    @test get_points(get_impedance_correction_curve(filtered_primary_tr3w_2))[end] ==
          (x = 40.0, y = 1.4)
    @test get_transformer_control_mode(filtered_primary_tr3w_2) ==
          ImpedanceCorrectionTransformerControlMode.PHASE_SHIFT_ANGLE
end

@testset "PSSE System Serialization/Desearialization" begin
    original_sys =
        build_system(PSSEParsingTestSystems, "pti_case30_sys"; force_build = true)
    serialize_sys_path = joinpath(tempdir(), "test_system.json")
    to_json(original_sys, serialize_sys_path; force = true)
    deserialized_sys = System(serialize_sys_path)

    @test get_base_power(original_sys) == get_base_power(deserialized_sys)
    @test get_frequency(original_sys) == get_frequency(deserialized_sys)
    @test get_num_components(original_sys) ==
          get_num_components(deserialized_sys)

    gen1_names = sort(get_name.(get_components(ThermalStandard, original_sys)))
    gen2_names = sort(get_name.(get_components(ThermalStandard, deserialized_sys)))
    @test gen1_names == gen2_names

    sa1_y = get_Y.(get_components(SwitchedAdmittance, original_sys))
    sa2_y = get_Y.(get_components(SwitchedAdmittance, deserialized_sys))
    @test sa1_y == sa2_y

    @test IS.compare_values(original_sys, deserialized_sys)
end

@testset "PSSE transformer tap position correction testing" begin
    sys = build_system(
        PSSEParsingTestSystems,
        "psse_14_tap_correction_test_system";
        force_build = true,
    )
    #test 2W correction matches PSSE
    trf = get_component(TapTransformer, sys, "BUS 104-BUS 107-i_1")
    tap = get_tap(trf)
    @test isapprox(tap, 0.979937; atol = 1e-6)

    #test 3W correction matches PSSE
    trf_3w = get_component(Transformer3W, sys, "BUS 109-BUS 104-BUS 107-i_1")
    tap1 = get_primary_turns_ratio(trf_3w)
    tap2 = get_secondary_turns_ratio(trf_3w)
    tap3 = get_tertiary_turns_ratio(trf_3w)
    @test isapprox(tap1, 0.98750; atol = 1e-6)
    @test isapprox(tap2, 0.97500; atol = 1e-6)
    @test isapprox(tap3, 0.96250; atol = 1e-6)

    sys2 = build_system(
        PSSEParsingTestSystems,
        "pti_case8_voltage_winding_correction_sys";
        force_build = true,
    )
    trf_3w_v = get_component(Transformer3W, sys2, "NODE F-NODE G-NODE D-i_1")
    @test get_available_primary(trf_3w_v) == true
    @test get_available_secondary(trf_3w_v) == true
    @test get_available_tertiary(trf_3w_v) == true

    #test 3W correction matches PSSE
    tap1 = get_primary_turns_ratio(trf_3w_v)
    tap2 = get_secondary_turns_ratio(trf_3w_v)
    tap3 = get_tertiary_turns_ratio(trf_3w_v)
    @test isapprox(tap1, 0.988; atol = 1e-6)
    @test isapprox(tap2, 0.9807518; atol = 1e-6)
    @test isapprox(tap3, 0.992; atol = 1e-6)

    sys3 = build_system(
        PSSEParsingTestSystems,
        "pti_case10_voltage_winding_correction_sys";
        force_build = true,
    )

    trf_3w_v1 = get_component(Transformer3W, sys3, "BUS 108-BUS 110-BUS 109-i_1")
    tap1 = get_primary_turns_ratio(trf_3w_v1)
    tap2 = get_secondary_turns_ratio(trf_3w_v1)
    tap3 = get_tertiary_turns_ratio(trf_3w_v1)
    @test isapprox(tap1, 1.05; atol = 1e-6)
    @test isapprox(tap2, 0.956; atol = 1e-6)
    @test isapprox(tap3, 0.95625; atol = 1e-6)

    trf_3w_v2 = get_component(Transformer3W, sys3, "BUS 104-BUS 109-BUS 111-i_1")
    tap1 = get_primary_turns_ratio(trf_3w_v2)
    tap2 = get_secondary_turns_ratio(trf_3w_v2)
    tap3 = get_tertiary_turns_ratio(trf_3w_v2)
    @test isapprox(tap1, 1.0; atol = 1e-6)
    @test isapprox(tap2, 1.0; atol = 1e-6)
    @test isapprox(tap3, 1.0; atol = 1e-6)

    trf_3w_v3 = get_component(Transformer3W, sys3, "BUS 102-BUS 104-BUS 103-i_1")
    tap1 = get_primary_turns_ratio(trf_3w_v3)
    tap2 = get_secondary_turns_ratio(trf_3w_v3)
    tap3 = get_tertiary_turns_ratio(trf_3w_v3)
    @test isapprox(tap1, 1.0250; atol = 1e-6)
    @test isapprox(tap2, 0.9256; atol = 1e-6)
    @test isapprox(tap3, 0.9150; atol = 1e-6)
end

@testset "PSSE TapTransformer controllability fields (#1684)" begin
    # Voltage-controlling LTC on winding 1: COD1=1, CONT1=2, RMA1/RMI1=1.1/0.9,
    # VMA1/VMI1=1.04/1.02, NTP1=17. The same fields must parse identically from v33 and v35.
    for sys_name in (
        "psse_controlled_tap_v33_test_system",
        "psse_controlled_tap_v35_test_system",
    )
        sys = build_system(PSSEParsingTestSystems, sys_name; force_build = true)
        trf = only(get_components(TapTransformer, sys))
        @test get_control_objective(trf) == TransformerControlObjective.VOLTAGE
        # RMI1/RMA1 bound winding 1; WINDV2 = 1.0 ⇒ tap-ratio band is (0.9, 1.1).
        @test get_tap_limits(trf) == (min = 0.9, max = 1.1)
        @test get_number_of_tap_positions(trf) == 17
        # CONT1 = 2 ⇒ regulates bus 2.
        @test get_regulated_bus_number(trf) == 2
        # Setpoint is the midpoint of the [VMI1, VMA1] band.
        @test get_voltage_setpoint(trf) ≈ (1.04 + 1.02) / 2
    end
end

@testset "PSSE isolated bus handling (unavailable vs topologically isolated)" begin
    sys = @test_logs (:error,) min_level = Logging.Error match_mode = :any build_system(
        PSSEParsingTestSystems,
        "isolated_bus_test_system";
        force_build = true,
    )
    @test length(get_components(x -> get_available(x), ACBus, sys)) == 2   #Bus 1 and 2
    @test length(get_components(x -> get_available(x), StandardLoad, sys)) == 1 # Load at Bus 2
    @test length(get_components(x -> get_available(x), SwitchedAdmittance, sys)) == 0
    @test length(get_components(x -> get_available(x), Generator, sys)) == 2  #Gens at Bus 1 and 2
    @test length(get_components(x -> get_available(x), Branch, sys)) == 1
    @test length(get_components(x -> get_available(x), TapTransformer, sys)) == 0

    @test length(get_components(x -> get_bustype(x) == ACBusTypes.ISOLATED, ACBus, sys)) ==
          14
    @test length(get_components(x -> get_bustype(x) == ACBusTypes.REF, ACBus, sys)) == 1
    @test length(get_components(x -> get_bustype(x) == ACBusTypes.PV, ACBus, sys)) == 1
    @test length(get_components(x -> get_bustype(x) == ACBusTypes.PQ, ACBus, sys)) == 0
end

@testset "Test PSSE interruptible loads parsing" begin
    sys = build_system(
        PSSEParsingTestSystems,
        "pti_case14_with_interruptible_loads_sys";
        force_build = true,
    )
    all_isl = collect(get_components(InterruptibleStandardLoad, sys))
    sort!(all_isl, by = get_name)
    isl = first(all_isl)  # should be named "load10LD"
    @test length(all_isl) == 4
    @test get_available(isl) == true
    @test isl isa InterruptibleStandardLoad
    @test get_constant_active_power(isl) == 0.11485
    @test get_max_active_power(isl) == 0.11485
end

@testset "PSSE v35 load distributed generation as RenewableNonDispatch" begin
    sys = build_system(PSSEParsingTestSystems, "pti_v35_dgen_sys"; force_build = true)
    load_at(bus) =
        only(get_components(l -> get_number(get_bus(l)) == bus, StandardLoad, sys))
    dgen_at(bus) =
        only(get_components(g -> get_number(get_bus(g)) == bus, RenewableNonDispatch, sys))

    # Loads carry the gross demand.
    @test get_constant_active_power(load_at(2)) ≈ 1.0     # 100 MW
    @test get_constant_reactive_power(load_at(2)) ≈ 0.25  # 25 Mvar
    @test get_constant_active_power(load_at(3)) ≈ 0.5     # 50 MW
    @test get_constant_reactive_power(load_at(3)) ≈ 0.1   # 10 Mvar

    # DGENM = 1: the distributed generation is available.
    dgen2 = dgen_at(2)
    @test get_available(dgen2)
    @test get_active_power(dgen2) ≈ 0.2     # 20 MW
    @test get_reactive_power(dgen2) ≈ 0.05  # 5 Mvar

    # DGENM = 0: present but unavailable.
    dgen3 = dgen_at(3)
    @test !get_available(dgen3)
    @test get_active_power(dgen3) ≈ 0.15    # 15 MW
    @test get_reactive_power(dgen3) ≈ 0.03  # 3 Mvar

    # Net injection at each bus still matches the PSS(R)E netting.
    net_p(bus) =
        get_constant_active_power(load_at(bus)) -
        (get_available(dgen_at(bus)) ? get_active_power(dgen_at(bus)) : 0.0)
    @test net_p(2) ≈ 0.8
    @test net_p(3) ≈ 0.5
end

@testset "Test conversion zero impedance branch to switch" begin
    sys = build_system(
        PSSEParsingTestSystems,
        "psse_14_zero_impedance_branch_test_system";
        force_build = true,
    )
    @test length(get_components(DiscreteControlledACBranch, sys)) == 3
    @test length(
        get_components(x -> get_r(x) == get_x(x) == 0.0, DiscreteControlledACBranch, sys),
    ) == 1
end

@testset "Test threshold setting for zero impedance 3WT winding" begin
    sys = build_system(
        PSSEParsingTestSystems,
        "psse_4_zero_impedance_3wt_test_system";
        force_build = true,
    )
    trf_3w = collect(get_components(Transformer3W, sys))[1]
    @test get_available(trf_3w) == true
    @test get_available_tertiary(trf_3w) == true
    @test get_x_tertiary(trf_3w) == 1e-4
end

@testset "Test GeoJSON RFC 7946 Compliance" begin
    # Test that GeographicInfo uses proper GeoJSON Point format
    # According to RFC 7946, section 3.1.2, a Point should have:
    # {"type": "Point", "coordinates": [longitude, latitude]}

    # Create a simple test using the common.jl helper
    sys = System(100.0)
    bus1 = ACBus(;
        number = 1,
        name = "test_bus",
        available = true,
        bustype = ACBusTypes.REF,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 230.0,
    )
    add_component!(sys, bus1)

    # Create GeographicInfo with proper GeoJSON format
    geo = IS.GeographicInfo(;
        geo_json = Dict("type" => "Point", "coordinates" => [-105.0, 40.0]),
    )

    add_supplemental_attribute!(sys, bus1, geo)

    # Retrieve and verify the GeoJSON format
    geo_attrs = get_supplemental_attributes(IS.GeographicInfo, sys)
    @test length(geo_attrs) == 1

    retrieved_geo = first(geo_attrs)
    geo_json = IS.get_geo_json(retrieved_geo)

    # Verify RFC 7946 compliance
    @test haskey(geo_json, "type")
    @test geo_json["type"] == "Point"
    @test haskey(geo_json, "coordinates")
    @test isa(geo_json["coordinates"], Vector)
    @test length(geo_json["coordinates"]) == 2
    @test geo_json["coordinates"][1] == -105.0  # longitude
    @test geo_json["coordinates"][2] == 40.0    # latitude

    # Verify old format is NOT present
    @test !haskey(geo_json, "x")
    @test !haskey(geo_json, "y")
end

# Minimal branch dict for get_branch_type_psse unit tests.
function _psse_branch_dict(;
    br_r = 0.01, br_x = 0.1, transformer = true, tap = 1.0,
    shift = 0.0, COD1 = 0,
)
    return Dict{String, Any}(
        "br_r" => br_r,
        "br_x" => br_x,
        "transformer" => transformer,
        "tap" => tap,
        "shift" => shift,
        "COD1" => COD1,
    )
end

@testset "Branch-type tolerance normalizations" begin
    # Non-transformer → Line
    d = _psse_branch_dict(; transformer = false, tap = 0.0, shift = 0.0)
    @test PowerSystems.get_branch_type_psse(d) == Line

    # Exact-zero impedance, non-transformer → DiscreteControlledACBranch
    d = _psse_branch_dict(; br_r = 0.0, br_x = 0.0, transformer = false, tap = 0.0)
    @test PowerSystems.get_branch_type_psse(d) == DiscreteControlledACBranch

    # Transformer with zero impedance must NOT become DiscreteControlledACBranch
    d = _psse_branch_dict(; br_r = 0.0, br_x = 0.0, transformer = true, tap = 0.0)
    @test PowerSystems.get_branch_type_psse(d) != DiscreteControlledACBranch

    # Non-controllable (COD1=0) TapTransformer with tap well away from 1.0 → TapTransformer
    d = _psse_branch_dict(; tap = 1.05, COD1 = 0)
    @test PowerSystems.get_branch_type_psse(d) == TapTransformer

    # Non-controllable TapTransformer with tap inside IDENTITY_TAP_TOL → Transformer2W
    d = _psse_branch_dict(; tap = 1.0 + PowerSystems.IDENTITY_TAP_TOL / 2, COD1 = 0)
    @test PowerSystems.get_branch_type_psse(d) == Transformer2W

    # Controllable (COD1=1) TapTransformer whose current tap is near 1.0 must NOT be demoted
    d = _psse_branch_dict(; tap = 1.0 + PowerSystems.IDENTITY_TAP_TOL / 2, COD1 = 1)
    @test PowerSystems.get_branch_type_psse(d) == TapTransformer

    # Tap == 0.0 (identity alias) with no control → Transformer2W
    d = _psse_branch_dict(; tap = 0.0, COD1 = 0)
    @test PowerSystems.get_branch_type_psse(d) == Transformer2W

    # PST with shift well outside zero tolerance → PhaseShiftingTransformer
    d = _psse_branch_dict(; tap = 1.0, shift = 0.5, COD1 = 3)
    @test PowerSystems.get_branch_type_psse(d) == PhaseShiftingTransformer

    # Non-alpha-controllable (COD1=0) PST with near-zero shift and identity tap → Transformer2W
    d = _psse_branch_dict(;
        tap = 1.0,
        shift = PowerSystems.ZERO_ANGLE_SHIFT_TOL / 2,
        COD1 = 0,
    )
    @test PowerSystems.get_branch_type_psse(d) == Transformer2W

    # Non-alpha-controllable PST with near-zero shift but non-identity tap → TapTransformer
    d = _psse_branch_dict(;
        tap = 1.05,
        shift = PowerSystems.ZERO_ANGLE_SHIFT_TOL / 2,
        COD1 = 0,
    )
    @test PowerSystems.get_branch_type_psse(d) == TapTransformer

    # Alpha-controllable (COD1=3) PST with near-zero shift must NOT be demoted
    d = _psse_branch_dict(;
        tap = 1.0,
        shift = PowerSystems.ZERO_ANGLE_SHIFT_TOL / 2,
        COD1 = 3,
    )
    @test PowerSystems.get_branch_type_psse(d) == PhaseShiftingTransformer

    # Explicit UNDEFINED winding-group path
    d = _psse_branch_dict(; tap = 1.0, shift = π / 12, COD1 = 0)
    @test PowerSystems.get_branch_type_psse(d) == PhaseShiftingTransformer

    # UNDEFINED group + near-zero shift + tap-controllable (COD1=1) + identity tap →
    # must NOT be demoted to Transformer2W; the tap-control capability keeps it as
    # TapTransformer.
    d = _psse_branch_dict(;
        tap = 1.0,
        shift = PowerSystems.ZERO_ANGLE_SHIFT_TOL / 2,
        COD1 = 1,
    )
    @test PowerSystems.get_branch_type_psse(d) == TapTransformer
end

@testset "make_branch TapTransformer override fills missing group_number" begin
    bus_f = ACBus(;
        number = 1,
        name = "bus_f",
        available = true,
        bustype = ACBusTypes.PQ,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 230.0,
    )
    bus_t = ACBus(;
        number = 2,
        name = "bus_t",
        available = true,
        bustype = ACBusTypes.PQ,
        angle = 0.0,
        magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1),
        base_voltage = 230.0,
    )

    d = Dict{String, Any}(
        "transformer" => true,
        "tap" => 1.05,
        "shift" => 0.0,
        "br_status" => 1,
        "br_r" => 0.01,
        "br_x" => 0.05,
        "g_fr" => 0.0,
        "b_fr" => 0.0,
        "rate_a" => 100.0,
        "rate_b" => 100.0,
        "rate_c" => 100.0,
        "base_power" => 100.0,
        "base_voltage_from" => 230.0,
        "base_voltage_to" => 230.0,
    )

    value = PowerSystems.make_branch(
        "xfr_1",
        d,
        bus_f,
        bus_t,
        "pti";
        branch_type_override = TapTransformer,
    )

    @test value isa TapTransformer
    @test haskey(d, "group_number")
    @test d["group_number"] == WindingGroupNumber.GROUP_0
end

@testset "PSSE ISW area-slack bus assignment" begin
    # Benchmark_4ger_33_2015.RAW AREA DATA: area 1 (LEFT) ISW=1 -> bus 1 (raw IDE=2,
    # PV) is promoted to SLACK; area 2 (RIGHT) ISW=3 -> bus 3 (raw IDE=3, REF) is left
    # as REF since it is already the area's own swing bus.
    sys =
        build_system(PSYTestSystems, "psse_Benchmark_4ger_33_2015_sys"; force_build = true)
    bus1 = only(get_components(x -> get_number(x) == 1, ACBus, sys))
    bus3 = only(get_components(x -> get_number(x) == 3, ACBus, sys))
    @test get_bustype(bus1) == ACBusTypes.SLACK
    @test get_bustype(bus3) == ACBusTypes.REF

    # Fixture: area 1 ISW=7 targets a PQ bus (malformed, warn, no SLACK); area 2 ISW=0
    # (untouched); area 3 ISW=999 targets a nonexistent bus (malformed, warn).
    sys2 = @test_logs(
        (:warn, r"ISW=7"),
        (:warn, r"ISW=999"),
        match_mode = :any,
        build_system(
            PSSEParsingTestSystems,
            "pti_area_slack_variants_sys";
            force_build = true,
        ),
    )
    bus7 = only(get_components(x -> get_number(x) == 7, ACBus, sys2))
    @test get_bustype(bus7) == ACBusTypes.PQ
    @test isempty(get_components(x -> get_bustype(x) == ACBusTypes.SLACK, ACBus, sys2))

    # Inter-area Transfer records become first-class AreaInterchange components.
    transfer = only(get_components(AreaInterchange, sys2))
    @test get_name(get_from_area(transfer)) == "1"
    @test get_name(get_to_area(transfer)) == "2"
    @test get_active_power_flow(transfer) == 50.0

    # End-to-end persistence: SLACK survives a to_json/System round trip.
    tmpdir = mktempdir()
    path = joinpath(tmpdir, "benchmark_4ger_slack_roundtrip.json")
    to_json(sys, path; force = true)
    sys_reloaded = System(path)
    bus1_reloaded = only(get_components(x -> get_number(x) == 1, ACBus, sys_reloaded))
    @test get_bustype(bus1_reloaded) == ACBusTypes.SLACK
end

@testset "PSSE v35 populated SUBSTATION section parses" begin
    # A v35 raw whose SUBSTATION section carries a node sub-block; the node-breaker
    # section must be inert for the AC bus-branch model.
    sys = build_system(PSSEParsingTestSystems, "pti_v35_substation_sys")
    @test length(get_components(ACBus, sys)) == 3
    @test length(get_components(Generator, sys)) == 2
    @test length(get_components(ElectricLoad, sys)) == 1
    @test length(get_components(ACBranch, sys)) == 2
end

@testset "PSSE two-terminal DC resistance per-unit base" begin
    # RDC is a DC-circuit resistance in ohms; its per-unit base is the DC voltage VSCHD,
    # not the AC commutating base EBASR. Fixture: RDC=5 ohm, VSCHD=400 kV, EBASR=200 kV,
    # SBASE=100 MVA -> r = 5 / (400^2 / 100) = 0.003125 pu (the AC base would give 0.0125).
    sys = build_system(PSSEParsingTestSystems, "pti_v35_two_terminal_dc_sys")
    lcc = only(get_components(TwoTerminalLCCLine, sys))
    rdc_ohms = 5.0
    vschd_kv = 400.0
    ebasr_kv = 200.0
    sbase = get_base_power(sys)
    @test isapprox(get_r(lcc), rdc_ohms / (vschd_kv^2 / sbase))
    @test isapprox(get_r(lcc), 0.003125)
    @test !isapprox(get_r(lcc), rdc_ohms / (ebasr_kv^2 / sbase))
    @test get_scheduled_dc_voltage(lcc) == vschd_kv
end

@testset "PSSE v33 switched shunt blocks start out of service" begin
    # v33 SWITCHED SHUNT records have no per-block status field: BINIT already carries the
    # total in-service admittance (parsed into `Y`), so every block must start at zero
    # regardless of MODSW. Counting blocks as in-service would double-count them.
    sys = build_system(PSSEParsingTestSystems, "psse_ACTIVSg2000_sys")
    shunts = collect(get_components(SwitchedAdmittance, sys))
    @test !isempty(shunts)
    for shunt in shunts
        @test get_initial_status(shunt) == zeros(Int, length(get_Y_increase(shunt)))
    end

    # Bus 2127 is the only MODSW=3 record in the raw; it was the case that previously got
    # an all-ones initial status.
    shunt_2127 = get_component(SwitchedAdmittance, sys, "2127-25")
    @test !isnothing(shunt_2127)
    @test get_ext(shunt_2127)["MODSW"] == 3
    @test get_number_of_steps(shunt_2127) == [1]
    @test get_initial_status(shunt_2127) == [0]
end
