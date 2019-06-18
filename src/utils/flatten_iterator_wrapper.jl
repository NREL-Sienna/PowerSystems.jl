
"""Wrapper around Iterators.Flatten to provide total length."""
struct FlattenIteratorWrapper{T}
    element_type::Type{T}
    iter::Iterators.Flatten
    length::Int
end

function FlattenIteratorWrapper(element_type::Type{T},
                                 vals) where T
    len = isempty(vals) ? 0 : sum((length(x) for x in vals))
    return FlattenIteratorWrapper(T, Iterators.Flatten(vals), len)
end

Base.iterate(iter::FlattenIteratorWrapper) = Base.iterate(iter.iter)
Base.iterate(iter::FlattenIteratorWrapper, state) = Base.iterate(iter.iter, state)
Base.eltype(iter::FlattenIteratorWrapper) = iter.element_type

function Base.length(iter::FlattenIteratorWrapper)
    return iter.length
end
