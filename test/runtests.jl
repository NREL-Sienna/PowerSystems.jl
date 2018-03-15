using PowerSystems
using Base.Test


# Testing Topological components of the schema

tic()
println("5Bus Test")
@time @test include("readnetworkdata.jl")
toc()

