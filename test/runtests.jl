using PowerSystems
using Test

# Testing Topological components of the schema


@testset "Read PowerSystems data" begin
    @info "Read Data in *.jl files"
    include("readnetworkdata.jl")
end

@testset "Local Functions" begin
    @info "Test all the constructors"
    include("constructors.jl")
    @info "Test PowerSystem constructor"
    include("powersystemconstructors.jl")
end

@testset "Parsing Code" begin
    include("parsestandard.jl")
    @time include("readforecastdata.jl")
end

@testset "Utilities testing" begin
    @info "Testing Network Matrices"
    @test @time include("network_matrices.jl")
    @info "Testing Check Functions"
    include("checks_testing.jl")
end

# #=
# @testset "Print testing" begin
    # include("../data/data_5bus.jl");
    # @test @assert "$sys5" == "PowerSystems.PowerSystem(buses=5, branches=6)"
# # end
# =#
