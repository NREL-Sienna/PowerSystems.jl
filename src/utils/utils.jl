import InteractiveUtils: subtypes


"""Returns an array of all concrete subtypes of T."""
function get_all_concrete_subtypes(::Type{T}) where T
    return _get_all_concrete_subtypes(T)
end

function _get_all_concrete_subtypes(::Type{T}, sub_types=[]) where T
    for sub_type in subtypes(T)
        push!(sub_types, sub_type)
        if isabstracttype(sub_type)
            _get_all_concrete_subtypes(sub_type, sub_types)
        end
    end

    return sub_types
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

function strip_module_names(name::String)
    index = findlast(".", name)
    if !isnothing(index)
        basename = name[index.start + 1:end]
    else
        basename = name
    end

    return basename
end

"""
Compares immutable struct values by performing == on each field in the struct.
When performing == on values of immutable structs Julia will perform === on
each field.  This will return false if any field is mutable even if the
contents are the same.  So, comparison of any PowerSystems type with an array
will fail.

This is an unresolved Julia issue. Refer to
https://github.com/JuliaLang/julia/issues/4648.

An option is to overload == for all subtypes of PowerSystemType. That may not be
appropriate in all cases. Until the Julia developers decide on a solution, this
function is provided for convenience for specific comparisons.

"""
function compare_values(x::T, y::T) where T
    match = true
    fields = fieldnames(T)
    if isempty(fields)
        match = x == y
    else
        for fieldname in fields
            val1 = getfield(x, fieldname)
            val2 = getfield(y, fieldname)
            if !isempty(fieldnames(typeof(val1)))
                if !compare_values(val1, val2)
                    match = false
                    break
                end
            else
                if val1 != val2
                    match = false
                    break
                end
            end
        end
    end

    return match
end

