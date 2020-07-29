
@testset "2-area, 11-bus, 4-generator benchmark system Parsing " begin
    ger4_raw_file = joinpath(PSSE_RAW_DIR, "Benchmark_4ger_33_2015.RAW")
    ger4_dyr_file = joinpath(PSSE_DYR_DIR, "Benchmark_4ger_33_2015.dyr")
    sys = System(ger4_raw_file, ger4_dyr_file)
    @test_throws PSY.DataFormatError System(ger4_raw_file, ger4_raw_file)
    @test_throws PSY.DataFormatError System(ger4_dyr_file, ger4_raw_file)
    dyn_injectors = get_components(DynamicInjection, sys)
    @test length(dyn_injectors) == 4
    for g in dyn_injectors
        m = PSY.get_machine(g)
        @test typeof(m) <: RoundRotorExponential
    end
end

@testset "GENCLS dyr parsing" begin
    threebus_raw_file = joinpath(PSSE_TEST_DIR, "ThreeBusNetwork.raw")
    gencls_dyr_file = joinpath(PSSE_TEST_DIR, "TestGENCLS.dyr")
    nogencls_dyr_file = joinpath(PSSE_TEST_DIR, "Test-NoCLS.dyr")
    sys_gencls = System(threebus_raw_file, gencls_dyr_file)
    sys_nogencls = System(threebus_raw_file, nogencls_dyr_file)

    #Check that generator at bus 102 (H = 0) is a Source, and not ThermalStandard.
    @test isnothing(get_component(ThermalStandard, sys_gencls, "generator-102-1"))
    @test typeof(get_component(StaticInjection, sys_gencls, "generator-102-1")) <: Source
    #Check that generator at bus 102 (not provided in dyr data) is a Source.
    @test isnothing(get_component(ThermalStandard, sys_nogencls, "generator-102-1"))
    @test typeof(get_component(StaticInjection, sys_nogencls, "generator-102-1")) <: Source

    #Check Parameters of GENROE raw file
    genroe_gen = get_component(DynamicInjection, sys_gencls, "generator-101-1")
    m = PSY.get_machine(genroe_gen)
    s = PSY.get_shaft(genroe_gen)
    @test typeof(m) <: RoundRotorExponential

    @test get_R(m) == 0.0
    @test get_Td0_p(m) == 8.0
    @test get_Td0_pp(m) == 0.03
    @test get_Tq0_p(m) == 0.4
    @test get_Tq0_pp(m) == 0.05
    @test get_Xd(m) == 1.8
    @test get_Xq(m) == 1.7
    @test get_Xd_p(m) == 0.3
    @test get_Xd_pp(m) == 0.25
    @test get_Xl(m) == 0.2
    @test get_H(s) == 6.5
    @test get_D(s) == 0.0

    #Check Parameters of other GENCLS file
    gencls_gen = get_component(DynamicInjection, sys_gencls, "generator-103-1")
    m = PSY.get_machine(gencls_gen)
    s = PSY.get_shaft(gencls_gen)
    @test typeof(m) <: BaseMachine

    @test get_R(m) == 0.0
    @test get_Xd_p(m) == 0.2
    @test get_H(s) == 3.1
    @test get_D(s) == 2.0

    #Check Parameters of other GENCLS file
    gencls_gen = get_component(DynamicInjection, sys_nogencls, "generator-103-1")
    m = PSY.get_machine(gencls_gen)
    s = PSY.get_shaft(gencls_gen)
    @test typeof(m) <: BaseMachine

    @test get_R(m) == 0.0
    @test get_Xd_p(m) == 0.2
    @test get_H(s) == 3.1
    @test get_D(s) == 2.0
end
