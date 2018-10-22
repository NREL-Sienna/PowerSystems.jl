using PowerSystems
using Test
using Logging

import Memento
Memento.config!(Memento.getlogger("PowerModels"), "error")

# Testing Topological components of the schema
gl = global_logger()
global_logger(ConsoleLogger(gl.stream, Logging.Error))


@testset "Check PowerSystems Data" begin
    @info "Check bus index"
    include("busnumberchecks.jl")
end

# #=
# @testset "Print testing" begin
    # include("../data/data_5bus.jl");
    # @test @assert "$sys5" == "PowerSystems.PowerSystem(buses=5, branches=6)"
# # end
# =#
