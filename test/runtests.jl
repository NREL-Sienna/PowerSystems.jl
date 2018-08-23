using PowerSystems
using Test

# Testing Topological components of the schema


println("Read Data in *.jl files")
@time @test include("readnetworkdata.jl")
println("Test all the constructors")
@time @test include("constructors.jl")
println("Test PowerSystem constructor")
@test include("powersystemconstructors.jl")

#=
println("Read Parsing code")
@time @test include("parsestandard.jl")
println("Testing Check Function s")
@time @test include("checks_testing.jl")
=#

println("Testing Network Matrices")
@time @test include("network_matrices.jl")




#println("Reading forecast data ")
#@time @test include("readforecastdata.jl")

#include("../data/data_5bus.jl");
#@assert "$sys5" == "PowerSystems.PowerSystem(buses=5, branches=6)"

