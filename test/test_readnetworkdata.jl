
base_dir = string(dirname(@__FILE__))

@testset "read_data" begin
    include(joinpath(base_dir,"test_aux_files/test_data_5bus_pu.jl"));
    include(joinpath(base_dir,"test_aux_files/test_data_14bus_pu.jl"))
end
