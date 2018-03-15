using PowerSystems
using Base.Test
cd(string(homedir(),"/.julia/v0.6/PowerSystems/data_files"))

# Testing Topological components of the schema

tic()
println("5Bus Test")
@time @test include("data_5bus.jl")
toc()

