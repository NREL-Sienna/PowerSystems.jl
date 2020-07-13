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

include(joinpath(BASE_DIR, "test", "data_5bus_pu.jl"))
include(joinpath(BASE_DIR, "test", "data_14bus_pu.jl"))

nodes_5 = nodes5()
nodes_14 = nodes14()
c_sys14() = System(
    nodes_14,
    thermal_generators14(nodes_14),
    loads14(nodes_14),
    branches14(nodes_14),
    nothing,
    100.0,
    nothing,
    nothing,
);

c_sys5_re() = System(
    nodes_5,
    vcat(thermal_generators5(nodes_5), renewable_generators5(nodes_5)),
    loads5(nodes_5),
    nothing,
    nothing,
    100.0,
    nothing,
    nothing,
)

@testset begin
    # This is a negative test. The data passed for sys5_re is known to be infeasible.
    @test_logs(
        (:error, "The powerflow solver returned convergence = false"),
        match_mode = :any,
        @test !solve_powerflow!(c_sys5_re(), finite_diff = true)
    )
    #Compare results between finite diff methods and Jacobian method
    res_finite_diff = solve_powerflow(c_sys14(), finite_diff = true)
    res_jacobian = solve_powerflow(c_sys14())
    @test LinearAlgebra.norm(
        res_finite_diff["bus_results"].Vm - res_jacobian["bus_results"].Vm,
    ) <= 1e-6
    @test solve_powerflow!(c_sys14(), finite_diff = true, method = :newton)

    sys = c_sys14()
    branch = first(get_components(Line, sys))
    dyn_branch = DynamicBranch(branch)
    add_component!(sys, dyn_branch)
    @test dyn_pf = solve_powerflow!(sys)
    dyn_pf = solve_powerflow(sys)
    @test LinearAlgebra.norm(dyn_pf["bus_results"].Vm - res_jacobian["bus_results"].Vm) <=
          1e-6
end
