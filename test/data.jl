

@testset "TestData" begin

    @test download(PowerSystems.TestData) |> abspath == joinpath(@__DIR__, "../data") |> abspath

end # testset

