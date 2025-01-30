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
    sys4 = build_system(PSSEParsingTestSystems, "pti_frankenstein_70_sys")

    base_dir = string(dirname(@__FILE__))
    file_dir = joinpath(base_dir, "test_data", "5circuit_3w.raw")
    sys5 = System(file_dir)

    @info "Testing  Three-Winding Transformer Parsing"
    @test isnothing(get_component(Transformer3W, sys3, "1"))
    @test get_available(
        get_component(Transformer3W, sys5, "FAV SPOT 01-FAV SPOT 02-FAV SPOT 03-i_A"),
    ) == false
    @test length(get_components(Transformer3W, sys5)) == 5

    @info "Testing Switched Shunt Parsing"
    @test get_available(get_component(SwitchedAdmittance, sys3, "1030_9")) == false
    @test get_available(get_component(SwitchedAdmittance, sys4, "1003_1")) == true

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
