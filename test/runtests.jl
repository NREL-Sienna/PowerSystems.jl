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
println("Read Parsing code")
@time @test include("parsestandard.jl")
toc()

include("../data/data_5bus.jl");

@assert "$sys5" == "PowerSystems.PowerSystem(buses=5, generators=7, branches=6)"
