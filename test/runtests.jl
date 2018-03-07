using PowerSystems
using Base.Test

# Testing Topological components of the schema

tic()
println("Bus Tests")
@time @test include("readbusdata.jl")
println("Network Tests")
@time @test include("readnetworkdata.jl")
toc()

