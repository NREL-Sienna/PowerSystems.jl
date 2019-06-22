import InteractiveUtils: subtypes


g_cached_subtypes = Dict{DataType, Vector{DataType}}()

"""Returns an array of all concrete subtypes of T."""
function get_all_concrete_subtypes(::Type{T}) where T
    if haskey(g_cached_subtypes, T)
        return g_cached_subtypes[T]
    end

    sub_types = Vector{DataType}()
    _get_all_concrete_subtypes(T, sub_types)
    g_cached_subtypes[T] = sub_types
    return sub_types
end

"""Recursively builds a vector of subtypes."""
function _get_all_concrete_subtypes(::Type{T}, sub_types::Vector{DataType}) where T
    for sub_type in subtypes(T)
        if isconcretetype(sub_type)
            push!(sub_types, sub_type)
        elseif isabstracttype(sub_type)
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
    return strip_module_names(string(T))
end

"""Converts an object deserialized from JSON into a Julia type, such as NamedTuple,
to an instance of T. Similar to Base.convert, but not a viable replacement.
"""
function convert_type(::Type{T}, data::Any) where T
    # Improvement: implement the conversion logic. Need to recursively convert fieldnames
    # to fieldtypes, collect the values, and pass them to T(). Also handle literals.
    # The JSON2 library already handles almost all of the cases.
    if data isa AbstractString
        return T(data)
    end

    return JSON2.read(JSON2.write(data), T)
end

"""
Recursively compares immutable struct values by performing == on each field in the struct.
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
function compare_values(x::T, y::T)::Bool where T
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
                    @debug "values do not match" T fieldname val1 val2
                    match = false
                    break
                end
            elseif val1 isa AbstractArray
                if !compare_values(val1, val2)
                    match = false
                end
            else
                if val1 != val2
                    @debug "values do not match" T fieldname val1 val2
                    match = false
                    break
                end
            end
        end
    end

    return match
end

function compare_values(x::Vector{T}, y::Vector{T})::Bool where T
    if length(x) != length(y)
        @debug "lengths do not match" T length(x) length(y)
        return false
    end

    for i in range(1, length=length(x))
        if !compare_values(x[i], y[i])
            @debug "values do not match" typeof(x[i]) i x[i] y[i]
            return false
        end
    end

    return true
end

function compare_values(x::Dict, y::Dict)::Bool
    keys_x = Set(keys(x))
    keys_y = Set(keys(y))
    if keys_x != keys_y
        @debug "keys don't match" keys_x keys_y
        return false
    end

    for key in keys_x
        if !compare_values(x[key], y[key])
            @debug "values do not match" typeof(x[key]) key x[key] y[key]
            return false
        end
    end

    return true
end

function compare_values(x::T, y::U)::Bool where {T, U}
    # This is a catch-all for where where the types may not be identical but are close
    # enough.
    return x == y
end
