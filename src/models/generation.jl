abstract type Generator <: StaticInjection end
const Generators = Array{<: Generator, 1}

abstract type HydroGen <: Generator end
abstract type RenewableGen <: Generator end
abstract type ThermalGen <: Generator end


function IS.get_limits(valid_range::Union{NamedTuple{(:min,:max)}, NamedTuple{(:max,:min)}},
                       unused::T) where T <: Generator
    # Gets min and max value defined for a field,
    # e.g. "valid_range": {"min":-1.571, "max":1.571}.
    return (min = valid_range.min, max = valid_range.max, zero = 0.0)
end

get_rating(gen::Generator) = get_rating(get_tech(gen))
get_active_power_limits_min(gen::Generator) = get_activepowerlimits(get_tech(gen)).min
get_active_power_limits_max(gen::Generator) = get_activepowerlimits(get_tech(gen)).max
