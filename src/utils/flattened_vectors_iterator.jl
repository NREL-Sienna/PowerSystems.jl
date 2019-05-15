
"""Wrapper around Iterators.Flatten to provide total length."""
struct FlattenedVectorsIterator{T}
    iter::Iterators.Flatten{Vector{Vector{T}}}
    length::Int
end

function FlattenedVectorsIterator(vectors::Vector{Vector{T}}) where T
    len = isempty(vectors) ? 0 : sum((length(x) for x in vectors))
    return FlattenedVectorsIterator(Iterators.Flatten(vectors), len)
end

Base.iterate(iter::FlattenedVectorsIterator) = Base.iterate(iter.iter)
Base.iterate(iter::FlattenedVectorsIterator, state) = Base.iterate(iter.iter, state)
Base.eltype(iter::FlattenedVectorsIterator) = Base.eltype(iter.iter)

function Base.length(iter::FlattenedVectorsIterator)
    return iter.length
end
