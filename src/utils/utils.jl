import InteractiveUtils: subtypes


"""Returns an array of all concrete subtypes of T."""
function get_all_concrete_subtypes(::Type{T}) where T
    sub_types = Vector{Any}()
    _get_all_concrete_subtypes(T, sub_types)
    return sub_types
end

"""Recursively builds a vector of subtypes."""
function _get_all_concrete_subtypes(::Type{T}, sub_types::Vector{Any}) where T
    for sub_type in subtypes(T)
        push!(sub_types, sub_type)
        if isabstracttype(sub_type)
            _get_all_concrete_subtypes(sub_type, sub_types)
        end
    end

    return nothing
end

"""Returns an array of concrete types that are direct subtypes of T.""" 
function get_concrete_subtypes(::Type{T}) where T
    return [x for x in subtypes(T) if isconcretetype(x)]
end

"""Returns an array of abstract types that are direct subtypes of T.""" 
function get_abstract_subtypes(::Type{T}) where T
    return [x for x in subtypes(T) if isabstracttype(x)]
end

"""Returns an array of all super types of T."""
function supertypes(::Type{T}, types=[]) where T
    super = supertype(T)
    push!(types, super)
    if super == Any
        return types
    end

    supertypes(super, types)
end

"""Converts a DataType to a Symbol, stripping off the module name(s)."""
function type_to_symbol(data_type::DataType)
    return Symbol(strip_module_names(string(data_type)))
end

"""Strips the module name(s) off of a type."""
function strip_module_names(name::String)
    index = findlast(".", name)
    if !isnothing(index)
        basename = name[index.start + 1:end]
    else
        basename = name
    end

    return basename
end

function strip_module_names(::Type{T}) where T
    return strip_module_names(type_to_symbol(T))
end
