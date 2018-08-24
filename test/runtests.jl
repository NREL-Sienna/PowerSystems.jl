using PowerSystems
using Test

# Testing Topological components of the schema

@testset "Local Functions" begin
    println("Read Data in *.jl files")
    include("readnetworkdata.jl")
    println("Test all the constructors")
    include("constructors.jl")
    println("Test PowerSystem constructor")
    include("powersystemconstructors.jl")
end

#=
@testset "Parsing Code" begin
    println("Read Parsing code")
    include("parsestandard.jl")
    println("Reading forecast data ")
    include("readforecastdata.jl")
end
=#

@testset "Utilities testing" begin
    println("Testing Network Matrices")
    include("network_matrices.jl")
    println("Testing Check Function s")
    include("checks_testing.jl")
end

#=
@testset "Print testing" begin
    include("../data/data_5bus.jl");
    @assert "$sys5" == "PowerSystems.PowerSystem(buses=5, branches=6)"
end
=#
