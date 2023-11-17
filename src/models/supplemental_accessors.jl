
get_aggregation_topology_accessor(::Type{Area}) = get_area
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

set_load_zone!(bus::ACBus, load_zone::LoadZone) = bus.load_zone = load_zone
set_area!(bus::ACBus, area::Area) = bus.area = area

"""
Remove the aggregation topology in a ACBus
"""
_remove_aggregration_topology!(bus::ACBus, ::LoadZone) = bus.load_zone = nothing
_remove_aggregration_topology!(bus::ACBus, ::Area) = bus.area = nothing

"""
Calculate the admittance of AC branches
"""
get_series_susceptance(b::ACBranch) = 1 / get_x(b)

"""
Returns the series susceptance of a controllable transformer following the convention
in power systems to define susceptance as the inverse of the imaginary part of the impedance.
In the case of phase shifter transformers the angle is ignored.
"""
function get_series_susceptance(b::Union{PhaseShiftingTransformer, TapTransformer})
    y = 1 / get_x(b)
    y_a = y / (get_tap(b))
    return y_a
end

get_series_admittance(b::ACBranch) = 1 / (get_r(b) + get_x(b) * 1im)

"""
Return the max active power for a device from get_active_power_limits.max
"""
function get_max_active_power(d::T) where {T <: Device}
    return get_active_power_limits(d).max
end

"""
Return the max reactive power for a device from get_reactive_power_limits.max
"""
function get_max_reactive_power(d::T)::Float64 where {T <: Device}
    if isnothing(get_reactive_power_limits(d))
        return Inf
    end
    return get_reactive_power_limits(d).max
end

"""
Return the max reactive power for the Renewable Generation calculated as the rating * power_factor if
reactive_power_limits is nothing
"""
function get_max_reactive_power(d::RenewableDispatch)
    reactive_power_limits = get_reactive_power_limits(d)
    if isnothing(reactive_power_limits)
        return get_rating(d) * sin(acos(get_power_factor(d)))
    end
    return reactive_power_limits.max
end

get_active_power_limits(::T) where {T <: Device} =
    throw(ArgumentError("get_active_power_limits not implemented for $T"))
get_reactive_power_limits(::T) where {T <: Device} =
    throw(ArgumentError("get_reactive_power_limits not implemented for $T"))
get_rating(::T) where {T <: Device} =
    throw(ArgumentError("get_rating not implemented for $T"))
get_power_factor(::T) where {T <: Device} =
    throw(ArgumentError("get_power_factor not implemented for $T"))

function get_max_active_power(d::StandardLoad)
    total_load = get_max_constant_active_power(d)
    # TODO: consider voltage
    total_load += get_max_impedance_active_power(d)
    total_load += get_max_current_active_power(d)
    return total_load
end

get_reactive_power_limits(::Source) = (min = -Inf, max = Inf)
