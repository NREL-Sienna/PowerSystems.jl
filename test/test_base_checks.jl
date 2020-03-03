
@testset "Test base checks" begin
    unordered = [1, 4, 2, 6]

    @test_throws(
        PowerSystems.DataFormatError,
        PowerSystems.check_ascending_order(unordered, "test")
    )

    ordered = sort(unordered)
    PowerSystems.check_ascending_order(ordered, "test")

end
