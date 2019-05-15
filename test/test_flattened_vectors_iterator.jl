
function run_test(a::Vector{T}, b::Vector{T}) where T
    c = [a, b]
    len = length(a) + length(b)
    iter = PowerSystems.FlattenedVectorsIterator(c)
    @test length(iter) == len
    @test eltype(iter) == T

    i = 0
    for x in iter
        i += 1
    end
    @test i == len
end

@testset "Test FlattenedVectorsIterator" begin
    run_test([1, 2, 3], [4, 5, 6])
    run_test([], [])
end
