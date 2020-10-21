@testset "Hybrid System tests" begin
    include(joinpath(BASE_DIR, "test", "data_14bus_pu.jl"))
    nodes_14 = nodes14()
c_sys14() = System(
    100.0,
    nodes_14,
    thermal_generators14(nodes_14),
    loads14(nodes_14),
    branches14(nodes_14),
)

    gen = ThermalStandard()
end
