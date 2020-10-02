@testset "TestData" begin
    force = get(ENV, "PS_FORCE_DOWNLOAD", "false")
    if force == "true"
        force = true
    elseif force == "false"
        force = false
    else
        error("PS_FORCE_DOWNLOAD must be 'true' or 'false'")
    end

    base = abspath(joinpath(@__DIR__, ".."))
    directory = abspath(download(PowerSystems.TestData; folder = base, force = force))
    @test directory == joinpath(base, "data")
end # testset
