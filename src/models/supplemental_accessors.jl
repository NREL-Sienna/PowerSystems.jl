
get_aggregation_topology_accessor(::Type{Area}) = get_area
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

set_load_zone!(bus::Bus, load_zone::LoadZone) = bus.load_zone = load_zone
set_area!(bus::Bus, area::Area) = bus.area = area

"""
Remove the aggregation topology in a Bus
"""
_remove_aggregration_topology!(bus::Bus, ::LoadZone) = bus.load_zone = nothing
_remove_aggregration_topology!(bus::Bus, ::Area) = bus.area = nothing

"""
Calculate the admittance of AC branches
"""
get_series_susceptance(b::ACBranch) = 1 / get_x(b)
get_series_susceptance(b::TapTransformer) = 1 / (get_x(b) * get_tap(b))
function get_series_susceptance(b::PhaseShiftingTransformer)
    y = 1 / (get_r(b) + get_x(b) * 1im)
    y_a = y / (get_tap(b) * exp(get_α(b) * 1im * (π / 180)))
    return 1 / imag(y_a)
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
function get_max_reactive_power(d::T) where {T <: Device}
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
