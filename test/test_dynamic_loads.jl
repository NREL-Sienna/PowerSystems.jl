@testset "Induction Motor" begin
    #valid (non-default) A and B
    im = SingleCageInductionMachine(;
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
    bus = ACBus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    static_load.bus = bus
    add_component!(sys, static_load)
    add_component!(sys, im, static_load)
    IMs = collect(get_components(SingleCageInductionMachine, sys))
    @test length(IMs) == 1

    im = SimplifiedSingleCageInductionMachine(;
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
    bus = ACBus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    static_load.bus = bus
    add_component!(sys, static_load)
    add_component!(sys, im, static_load)
    IMs = collect(get_components(SimplifiedSingleCageInductionMachine, sys))
    @test length(IMs) == 1
end

@testset "Active Constant Power Load Model" begin
    #valid model
    al = ActiveConstantPowerLoad(;
        name = "init",
        r_load = 70.0,
        c_dc = 2040e-6,
        rf = 0.1,
        lf = 2.3e-3,
        cf = 8.8e-6,
        rg = 0.03,
        lg = 0.93e-3,
        kp_pll = 0.4,
        ki_pll = 4.69,
        kpv = 0.5,
        kiv = 150.0,
        kpc = 15.0,
        kic = 30000.0,
        base_power = 100.0,
    )
    @test al isa PowerSystems.Component

    sys = System(100.0)
    bus = ACBus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    static_load.bus = bus
    add_component!(sys, static_load)
    add_component!(sys, al, static_load)
    ALs = collect(get_components(ActiveConstantPowerLoad, sys))
    @test length(ALs) == 1
end

@testset "Dynamic Exponential Load Model" begin
    #valid model
    al = DynamicExponentialLoad(;
        name = "init",
        a = 1.0,
        b = 1.0,
        α = 1.2,
        β = 1.2,
        T_p = 3.0,
        T_q = 3.0,
    )
    @test al isa PowerSystems.Component

    sys = System(100.0)
    bus = ACBus(nothing)
    add_component!(sys, bus)
    static_load = PowerLoad(nothing)
    static_load.bus = bus
    add_component!(sys, static_load)
    add_component!(sys, al, static_load)
    ALs = collect(get_components(DynamicExponentialLoad, sys))
    @test length(ALs) == 1
end
