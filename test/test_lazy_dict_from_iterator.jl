
import PowerSystems: LazyDictFromIterator, reset_iterator

struct TestItem
    field::Int
end

function get_field(item::TestItem)
    return item.field
end

@testset "Test LazyDictFromIterator" begin
    first = [TestItem(x) for x in 1:5]
    second = [TestItem(x) for x in 6:10]
    items = [first, second]
    iter = Iterators.flatten(items)

    container = LazyDictFromIterator(Int, TestItem, iter, get_field)

    # Run through twice because the items must persist in the dict.
    for i in range(1, length=2)
        for x in 1:10
            @test get(container, x) isa TestItem
        end
    end

    # Add an item to an underlying array and ensure it is found.
    push!(first, TestItem(22))
    reset_iterator(container)
    @test get(container, 22) isa TestItem

    @test_throws(KeyError, get(container, 25))
end
