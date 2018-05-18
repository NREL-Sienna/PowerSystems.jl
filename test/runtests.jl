using PowerSystems
using Base.Test


# Testing Topological components of the schema

tic()
println("Read Data in *.jl files")
@time @test include("readnetworkdata.jl")
println("Test all the constructors")
@time @test include("constructors.jl")
println("Test PowerSystem constructor")
@test include("powersystemconstructors.jl")
toc()

