
function run_test(T, a, b)
    c = [values(a), values(b)]
    len = length(a) + length(b)
    iter = PowerSystems.FlattenIteratorWrapper(T, c)
    @test length(iter) == len
    @test eltype(iter) == T

    i = 0
    for x in iter
        i += 1
    end
    @test i == len
end

@testset "Test FlattenIteratorWrapper dictionaries" begin
    run_test(Int, Dict("1"=>1, "2"=>2, "3"=>3), Dict("4"=>4, "5"=>5, "6"=>6))
    run_test(Int, Dict{String, Int}(), Dict{String, Int}())
end

@testset "Test FlattenIteratorWrapper vectors" begin
    run_test(Int, [1, 2, 3], [4, 5, 6])
    run_test(Int, [], [])
end
