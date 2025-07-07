
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

"""
Returns the series susceptance of a 3 winding phase shifting transformer as three values 
(for each of the 3 branches) following the convention
in power systems to define susceptance as the inverse of the imaginary part of the impedance.
The phase shift angles are ignored in the susceptance calculation.
"""
function get_series_susceptance(b::PhaseShiftingTransformer3W)
    y1 = 1 / get_x_primary(b)
    y2 = 1 / get_x_secondary(b)
    y3 = 1 / get_x_tertiary(b)

    y1_a = y1 / get_primary_turns_ratio(b)
    y2_a = y2 / get_secondary_turns_ratio(b)
    y3_a = y3 / get_tertiary_turns_ratio(b)

    return (y1_a, y2_a, y3_a)
end

"""
Returns the series susceptance of a 3 winding transformer as three values 
(for each of the 3 branches) following the convention
in power systems to define susceptance as the inverse of the imaginary part of the impedance.
"""
function get_series_susceptance(b::Transformer3W)
    Z1s = get_r_primary(b) + get_x_primary(b) * 1im
    Z2s = get_r_secondary(b) + get_x_secondary(b) * 1im
    Z3s = get_r_tertiary(b) + get_x_tertiary(b) * 1im

    b1s = imag(1 / Z1s)
    b2s = imag(1 / Z2s)
    b3s = imag(1 / Z3s)

    return (b1s, b2s, b3s)
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

function get_from_to_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).from_to
end
function get_to_from_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).to_from
end

function get_min_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).min
end

function get_max_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).max
end
