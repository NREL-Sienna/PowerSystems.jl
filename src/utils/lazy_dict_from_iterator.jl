
mutable struct LazyDictFromIterator{K, V}
    iter::Any
    state::Union{Nothing, Tuple}
    getter::Function
    items::Dict{K, V}
end

"""
LazyDictFromIterator creates a dictionary from an iterator, but only increments the iterator
and adds items to the dictionary as it needs them. In the worst case it is identical to
creating a dictionary by iterating over the entire list.
Each V should have a K member.

# Arguments
- `K`: type of the dictionary keys
- `V`: type of the dictionary values
- `iter`: any object implementing the Iterator interface
- `getter::Function`: method to call on V to get its K

"""
function LazyDictFromIterator(
                              ::Type{K},
                              ::Type{V},
                              iter::Any,
                              getter::Function,
                             ) where {K, V}
    return LazyDictFromIterator(iter, nothing, getter, Dict{K, V}())
end

"""
Returns the item mapped to key. If the key is already stored then it will be returned
with a dictionary lookup. If it has not been stored then iterate over the list until it is
found.

Returns nothing if key is not found.
"""
function Base.get(container::LazyDictFromIterator, key::K) where K
    if haskey(container.items, key)
        return container.items[key]
    end

    # Exit loop when item is found or throw an exception.
    while true
        if isnothing(container.state)
            result = Base.iterate(container.iter)
        else
            result = Base.iterate(container.iter, container.state)
        end

        if isnothing(result)
            @debug "Key not found" key
            return nothing
        end

        item = result[1]
        container.state = result[2]
        item_key = container.getter(item)

        # Store this item for future lookups.
        container.items[item_key] = item
        if key == item_key
            return item
        end
    end

    @assert false
end

"""Reset the iterator for cases where underlying arrays have changed."""
function reset_iterator(container::LazyDictFromIterator)
    @debug "reset_iterator"
    container.state = nothing
end

"""Replace the iterator, maintaining the cached dict."""
function replace_iterator(container::LazyDictFromIterator, iter)
    @debug "replace_iterator"
    container.state = nothing
    container.iter = iter
end
