abstract type Generator <: StaticInjection end
const Generators = Array{<:Generator, 1}

abstract type HydroGen <: Generator end

"""
Abstract Type to represent renewable generation devices. Requires the implementation of get_rating
and get_power_factor methods
"""
abstract type RenewableGen <: Generator end
abstract type ThermalGen <: Generator end

function IS.get_limits(
    valid_range::Union{NamedTuple{(:min, :max)}, NamedTuple{(:max, :min)}},
    unused::T,
) where {T <: Generator}
    # Gets min and max value defined for a field,
    # e.g. "valid_range": {"min":-1.571, "max":1.571}.
    return (min = valid_range.min, max = valid_range.max, zero = 0.0)
end

"""
Return the max active power for the Renewable Generation calculated as the rating * power_factor
"""
function get_max_active_power(d::T) where {T <: RenewableGen}
    return get_rating(d) * get_power_factor(d)
end

"""
Return the max reactive power for the Renewable Generation calculated as the rating * power_factor
"""
function get_max_reactive_power(d::T) where {T <: RenewableGen}
    return get_rating(d) * sin(acos(get_power_factor(d)))
end