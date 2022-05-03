@testset "Induction Motor" begin
    #valid (non-default) A and B
    im = SingleCageInductionMachine(
        name = "init",
        Rs = 0.0,
        Rr = 0.018,
        Xs = 0.1,
        Xr = 0.18,
        Xm = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.0,
    )
    @test im isa PowerSystems.Component

    #invalid A, B or C
    @test_throws ErrorException SingleCageInductionMachine(
        name = "init",
        Rs = 0.0,
        Rr = 0.018,
        Xs = 0.1,
        Xr = 0.18,
        Xm = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.9,
    )

    sys = System(100)
    bus = Bus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    add_component!(sys, static_load)
    add_component!(sys, im, static_load)
    IMs = collect(get_components(SingleCageInductionMachine, sys))
    @test length(IMs) == 1

    im = SimplifiedSingleCageInductionMachine(
        name = "init",
        Rs = 0.0,
        Rr = 0.018,
        Xs = 0.1,
        Xr = 0.18,
        Xm = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.0,
    )
    @test im isa PowerSystems.Component

    #invalid A, B or C
    @test_throws ErrorException SimplifiedSingleCageInductionMachine(
        name = "init",
        Rs = 0.0,
        Rr = 0.018,
        Xs = 0.1,
        Xr = 0.18,
        Xm = 3.2,
        H = 0.5,
        A = 0.2,
        B = 0.9,
    )

    sys = System(100)
    bus = Bus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    add_component!(sys, static_load)
    add_component!(sys, im, static_load)
    IMs = collect(get_components(SimplifiedSingleCageInductionMachine, sys))
    @test length(IMs) == 1
end
