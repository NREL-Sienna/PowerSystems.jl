using PowerSystems
using Test

# Testing Topological components of the schema

@testset "Local Functions" begin
    println("Read Data in *.jl files")
    @test @time include("readnetworkdata.jl")
    println("Test all the constructors")
    @test @time include("constructors.jl")
    println("Test PowerSystem constructor")
    @test @time include("powersystemconstructors.jl")
end

#=
@testset "Parsing Code" begin
    println("Read Parsing code")
    @test @time include("parsestandard.jl")
    println("Reading forecast data ")
    @test @time include("readforecastdata.jl")
end
=#

@testset "Utilities testing" begin
    println("Testing Network Matrices")
    @test @time include("network_matrices.jl")
    println("Testing Check Functions")
    @test @time include("checks_testing.jl")
end

#=
@testset "Print testing" begin
    include("../data/data_5bus.jl");
    @test @assert "$sys5" == "PowerSystems.PowerSystem(buses=5, branches=6)"
end
=#
