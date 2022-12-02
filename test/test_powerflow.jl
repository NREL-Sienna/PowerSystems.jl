result = [
    2.32551,
    -0.155293,
    0.469214,
    -0.0870457,
    0.271364,
    -0.222398,
    1.01423,
    -0.179009,
    1.01724,
    -0.152972,
    0.216039,
    -0.251637,
    1.05034,
    -0.231289,
    0.245388,
    -0.231289,
    1.03371,
    -0.258872,
    1.03256,
    -0.262519,
    1.04748,
    -0.259143,
    1.0535,
    -0.266484,
    1.04711,
    -0.267177,
    1.02131,
    -0.280381,
]

p_gen_matpower_3bus = [20.3512373930753, 100.0, 100.0]
q_gen_matpower_3bus = [45.516916781567232, 10.453799727283879, -31.992561631394636]

pf_sys5_re = PSB.build_system(PSB.PSITestSystems, "c_sys5_re"; add_forecasts = false)
remove_component!(Line, pf_sys5_re, "1")
remove_component!(Line, pf_sys5_re, "2")
br = get_component(Line, pf_sys5_re, "6")
set_x!(br, 20.0)
set_r!(br, 2.0)

@testset "Power Flow testing" begin
    # This is a negative test. The data passed for sys5_re is known to be infeasible.
    @test_logs(
        (:error, "The powerflow solver returned convergence = false"),
        match_mode = :any,
        @test !solve_powerflow!(pf_sys5_re; finite_diff = true)
    )
    #Compare results between finite diff methods and Jacobian method
    res_finite_diff = solve_powerflow(
        PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false);
        finite_diff = true,
    )
    res_jacobian = solve_powerflow(
        PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false),
    )
    @test LinearAlgebra.norm(
        res_finite_diff["bus_results"].Vm - res_jacobian["bus_results"].Vm,
    ) <= 1e-6
    @test solve_powerflow!(
        PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false),
        finite_diff = true,
        method = :newton,
    )

    sys = PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false)
    branch = first(get_components(Line, sys))
    dyn_branch = DynamicBranch(branch)
    add_component!(sys, dyn_branch)
    @test dyn_pf = solve_powerflow!(sys)
    dyn_pf = solve_powerflow(sys)
    @test LinearAlgebra.norm(dyn_pf["bus_results"].Vm - res_jacobian["bus_results"].Vm) <=
          1e-6

    sys = PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false)
    line = get_component(Line, sys, "Line4")
    set_available!(line, false)
    solve_powerflow!(sys)
    @test get_active_power_flow(line) == 0.0
    test_bus = get_component(Bus, sys, "Bus 4")
    @test isapprox(get_magnitude(test_bus), 1.002; atol = 1e-3)

    sys = PSB.build_system(PSB.PSITestSystems, "c_sys14"; add_forecasts = false)
    line = get_component(Line, sys, "Line4")
    set_available!(line, false)
    res = solve_powerflow(sys)
    @test res["flow_results"].P_from_to[4] == 0.0
    @test res["flow_results"].P_to_from[4] == 0.0

    sys = PSB.build_system(PSB.PSSETestSystems, "psse_240_case_renewable_sys")
    @test solve_powerflow!(sys)

    sys_3bus = PSB.build_system(PSB.PSSETestSystems, "psse_3bus_gen_cls_sys")
    bus_103 = get_component(Bus, sys_3bus, "BUS 3")
    fix_shunt = FixedAdmittance("FixAdm_Bus3", true, bus_103, 0.0 + 0.2im)
    add_component!(sys_3bus, fix_shunt)
    df = solve_powerflow(sys_3bus)
    @test isapprox(df["bus_results"].P_gen, p_gen_matpower_3bus, atol = 1e-4)
    @test isapprox(df["bus_results"].Q_gen, q_gen_matpower_3bus, atol = 1e-4)
end
