function orderedlimits(
    limits::Union{NamedTuple{(:min, :max), Tuple{Float64, Float64}}, Nothing},
    limitsname::String,
)
    if isa(limits, Nothing)
        @info "'$limitsname' limits defined as nothing"
    else
        if limits.max < limits.min
            throw(DataFormatError("$limitsname limits not in ascending order"))
        end
    end

    return limits
end

"""Throws DataFormatError if the array is not in ascending order."""
function check_ascending_order(array::Array{Int}, name::AbstractString)
    for (i, num) in enumerate(array)
        if i > 1 && num < array[i - 1]
            throw(DataFormatError("$name Numbers are not in ascending order."))
        end
    end

    return
end

"""Checks if a PowerSystemDevice has a field or subfield name."""
function isafield(component::Component, field::Symbol)
    function _wrap(t, d = [])
        fn = fieldnames(typeof(t))
        for n in fn
            push!(d, n)
            f = getfield(t, n)
            if length(fieldnames(typeof(f))) > 0
                _wrap(f, d)
            end
        end
        return d
    end

    allfields = _wrap(component)
    return field in allfields
end
