using PowerSystems
using Test
using Logging
using Dates

# Testing Topological components of the schema
gl = global_logger()
global_logger(ConsoleLogger(gl.stream, Logging.Error))

@testset "Check PowerSystems Data" begin
    @info "Check bus index"
    include("busnumberchecks.jl")
end

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

@testset "Utilities testing" begin
    @info "Testing Network Matrices"
    @test @time include("network_matrices.jl")
    @info "Testing Line Check Functions"
    include("branchchecks_testing.jl")
end

@testset "Forecast parsing" begin
    @info "Reading forecast data "
    @time include("readforecastdata.jl")
end

@testset "Parsing Code" begin
    @info "Parsing Matpower"
    include("parse_matpower.jl")
    @info "Parsing PSSe"
    include("parse_psse.jl")
    @info "Parsing CDM"
    include("cdmparse.jl")
end

@testset "Print testing" begin
    include("printing.jl");
end
