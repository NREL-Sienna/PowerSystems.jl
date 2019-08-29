import NLsolve

result = [2.32551,
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
-0.280381]

include(joinpath(BASE_DIR,"data/data_14bus_pu.jl"))
c_sys14 = System(nodes14, thermal_generators14, loads14, branches14, nothing, 100.0, nothing, nothing, nothing);

include(joinpath(BASE_DIR,"data/data_5bus_pu.jl"))
c_sys5_re = System(nodes5, vcat(thermal_generators5, renewable_generators5), loads5,
                nothing, nothing,  100.0, nothing, nothing, nothing)


import NLsolve
@testset begin
    pf!, x0 = make_pf(c_sys14);
    res = NLsolve.nlsolve(pf!, x0)
    @test res.zero ≈ result rtol=1e-3

    # @solve_powerflow!(c_sys14, method = :newton)
    # @test_throws PowerSystems.DataFormatError @solve_powerflow!(c_sys5_re)
end
