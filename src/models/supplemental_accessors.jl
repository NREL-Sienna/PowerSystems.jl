
"""
Return the appropriate accessor function for the given aggregation topology type.
For Area types, returns get_area; for LoadZone types, returns get_load_zone.
"""
get_aggregation_topology_accessor(::Type{Area}) = get_area
"""
Return the appropriate accessor function for the given aggregation topology type.
For Area types, returns get_area; for LoadZone types, returns get_load_zone.
"""
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

"""
Set the load zone for an AC bus.
"""
set_load_zone!(bus::ACBus, load_zone::LoadZone) = bus.load_zone = load_zone
"""
Set the area for an AC bus.
"""
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
function get_series_susceptance(b::Union{TapTransformer, PhaseShiftingTransformer})
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

"""
Calculate the series admittance of an AC branch as the inverse of the complex impedance.
Returns 1/(R + jX) where R is resistance and X is reactance.
"""
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

"""
Generic fallback function for getting active power limits. Throws ArgumentError for devices
that don't implement this function.
"""
get_active_power_limits(::T) where {T <: Device} =
    throw(ArgumentError("get_active_power_limits not implemented for $T"))
"""
Generic fallback function for getting reactive power limits. Throws ArgumentError for devices
that don't implement this function.
"""
get_reactive_power_limits(::T) where {T <: Device} =
    throw(ArgumentError("get_reactive_power_limits not implemented for $T"))
"""
Generic fallback function for getting device rating. Throws ArgumentError for devices
that don't implement this function.
"""
get_rating(::T) where {T <: Device} =
    throw(ArgumentError("get_rating not implemented for $T"))
"""
Generic fallback function for getting power factor. Throws ArgumentError for devices
that don't implement this function.
"""
get_power_factor(::T) where {T <: Device} =
    throw(ArgumentError("get_power_factor not implemented for $T"))

"""
Calculate the maximum active power for a standard load by summing the maximum
constant, impedance, and current components.
"""
function get_max_active_power(d::StandardLoad)
    total_load = get_max_constant_active_power(d)
    # TODO: consider voltage
    total_load += get_max_impedance_active_power(d)
    total_load += get_max_current_active_power(d)
    return total_load
end

"""
Calculate the maximum active power for an interruptible standard load by summing
the maximum constant, impedance, and current components.
"""
function get_max_active_power(d::InterruptibleStandardLoad)
    total_load = get_max_constant_active_power(d)
    # TODO: consider voltage
    total_load += get_max_impedance_active_power(d)
    total_load += get_max_current_active_power(d)
    return total_load
end

"""
Get the flow limit from source area to destination area for an area interchange.
"""
function get_from_to_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).from_to
end
"""
Get the flow limit from destination area to source area for an area interchange.
"""
function get_to_from_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).to_from
end

"""
Get the minimum active power flow limit for a transmission interface.
"""
function get_min_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).min
end

"""
Get the maximum active power flow limit for a transmission interface.
"""
function get_max_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).max
end

"""
Calculate the phase shift angle α for a 2-winding transformer based on its winding group number.
Returns the angle in radians, calculated as -(π/6) * winding_group_number.
If the winding group number is undefined, returns 0.0 and issues a warning.
"""
function get_α(t::Union{TapTransformer, Transformer2W})
    if get_winding_group_number(t) == WindingGroupNumber.UNDEFINED
        @warn "winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_winding_group_number(t).value * -(π / 6)
    end
end

"""
Calculate the phase shift angle α for the primary winding of a 3-winding transformer
based on its primary winding group number. Returns the angle in radians, calculated
as -(π/6) * primary_group_number. If undefined, returns 0.0 and issues a warning.
"""
function get_α_primary(t::Transformer3W)
    if get_primary_group_number(t) == WindingGroupNumber.UNDEFINED
        @warn "primary winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_primary_group_number(t).value * -(π / 6)
    end
end
"""
Calculate the phase shift angle α for the secondary winding of a 3-winding transformer
based on its secondary winding group number. Returns the angle in radians, calculated
as -(π/6) * secondary_group_number. If undefined, returns 0.0 and issues a warning.
"""
function get_α_secondary(t::Transformer3W)
    if get_secondary_group_number(t) == WindingGroupNumber.UNDEFINED
        @warn "secondary winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_secondary_group_number(t).value * -(π / 6)
    end
end
"""
Calculate the phase shift angle α for the tertiary winding of a 3-winding transformer
based on its tertiary winding group number. Returns the angle in radians, calculated
as -(π/6) * tertiary_group_number. If undefined, returns 0.0 and issues a warning.
"""
function get_α_tertiary(t::Transformer3W)
    if get_tertiary_group_number(t) == WindingGroupNumber.UNDEFINED
        @warn "tertiary winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_tertiary_group_number(t).value * -(π / 6)
    end
end
