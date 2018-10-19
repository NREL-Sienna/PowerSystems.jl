
base_dir = string(dirname(dirname(@__FILE__)))
@info joinpath(base_dir,"data/data_5bus.jl")
@test try include(joinpath(base_dir,"data/data_5bus.jl")); true finally end
@info joinpath(base_dir,"data/data_5bus_uc.jl")
@test try include(joinpath(base_dir,"data/data_5bus_uc.jl")); true finally end
@info joinpath(base_dir,"data/data_5bus_dc.jl")
@test try include(joinpath(base_dir,"data/data_5bus_dc.jl")); true finally end

@info joinpath(base_dir,"data/data_14bus.jl")
@test try include(joinpath(base_dir,"data/data_14bus.jl")); true finally end


