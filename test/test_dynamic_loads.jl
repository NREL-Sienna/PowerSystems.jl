@testset "Induction Motor" begin
    #valid (non-default) A and B
    im = SingleCageInductionMachine(
        name = "init",
        R_s = 0.0,
        R_r = 0.018,
        X_ls = 0.1,
        X_lr = 0.18,
        X_m = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.0,
        base_power = 100.0,
    )
    @test im isa PowerSystems.Component

    #invalid A, B or C
    @test_throws ErrorException SingleCageInductionMachine(
        name = "init",
        R_s = 0.0,
        R_r = 0.018,
        X_ls = 0.1,
        X_lr = 0.18,
        X_m = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.9,
        base_power = 100.0,
    )

    sys = System(100.0)
    bus = Bus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    add_component!(sys, static_load)
    add_component!(sys, im, static_load)
    IMs = collect(get_components(SingleCageInductionMachine, sys))
    @test length(IMs) == 1

    im = SimplifiedSingleCageInductionMachine(
        name = "init",
        R_s = 0.0,
        R_r = 0.018,
        X_ls = 0.1,
        X_lr = 0.18,
        X_m = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.0,
        base_power = 100.0,
    )
    @test im isa PowerSystems.Component

    #invalid A, B or C
    @test_throws ErrorException SimplifiedSingleCageInductionMachine(
        name = "init",
        R_s = 0.0,
        R_r = 0.018,
        X_ls = 0.1,
        X_lr = 0.18,
        X_m = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.9,
        base_power = 100.0,
    )

    sys = System(100.0)
    bus = Bus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    add_component!(sys, static_load)
    add_component!(sys, im, static_load)
    IMs = collect(get_components(SimplifiedSingleCageInductionMachine, sys))
    @test length(IMs) == 1
end
