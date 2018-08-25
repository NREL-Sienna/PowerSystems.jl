
base_dir = string(dirname(dirname(@__FILE__)))
println(joinpath(base_dir,"data/data_5bus.jl"))
@test try include(joinpath(base_dir,"data/data_5bus.jl")); true finally end

println(joinpath(base_dir,"data/data_14bus.jl"))
@test try include(joinpath(base_dir,"data/data_14bus.jl")); true finally end


