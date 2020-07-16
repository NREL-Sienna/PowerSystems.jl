
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

function get_max_active_power(d::T) where {T <: Device}
    if !hasmethod(get_active_power_limits, Tuple{T})
        throw(MethodError(get_max_active_power, d))
    end
    return get_active_power_limits(d).max
end

function get_max_reactive_power(d::T) where {T <: Device}
    if !hasmethod(get_reactive_power_limits, Tuple{T})
        throw(MethodError(get_max_reactive_power, d))
    end
    return get_reactive_power_limits(d).max
end
