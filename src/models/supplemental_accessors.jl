
"""
Return the appropriate accessor function for the given aggregation topology type.
For [`Area`](@ref) types, returns [`get_area`](@ref); for [`LoadZone`](@ref) types, returns [`get_load_zone`](@ref).
"""
get_aggregation_topology_accessor(::Type{Area}) = get_area
"""
Return the appropriate accessor function for the given aggregation topology type.
For [`Area`](@ref) types, returns [`get_area`](@ref); for [`LoadZone`](@ref) types, returns [`get_load_zone`](@ref).
"""
get_aggregation_topology_accessor(::Type{LoadZone}) = get_load_zone

"""
Set the [`LoadZone`](@ref) for an [`ACBus`](@ref).
"""
set_load_zone!(bus::ACBus, load_zone::LoadZone) = bus.load_zone = load_zone
"""
Set the [`Area`](@ref) for an [`ACBus`](@ref).
"""
set_area!(bus::ACBus, area::Area) = bus.area = area

"""
Remove the aggregation topology in a [`ACBus`](@ref) by setting the corresponding field to `nothing`.
"""
_remove_aggregration_topology!(bus::ACBus, ::LoadZone) = bus.load_zone = nothing
_remove_aggregration_topology!(bus::ACBus, ::Area) = bus.area = nothing

"""
Generic method to calculate the admittance of [`ACTransmission`](@ref) devices.
"""
get_series_susceptance(b::ACTransmission) = 1 / get_x(b)

"""
Returns the series susceptance of a controllable 2-winding transformer (e.g., [`TapTransformer`](@ref), [`PhaseShiftingTransformer`](@ref))  following the convention
in power systems to define susceptance as the inverse of the imaginary part of the impedance.
In the case of phase shifter transformers the angle is ignored.
"""
function get_series_susceptance(b::Union{TapTransformer, PhaseShiftingTransformer})
    y = 1 / get_x(b)
    y_a = y / (get_tap(b))
    return y_a
end

function get_series_susceptance(::Union{PhaseShiftingTransformer3W, Transformer3W})
    throw(
        ArgumentError(
            "get_series_susceptance not implemented for multi-winding transformers, use get_series_susceptances instead",
        ),
    )
end

"""
Returns the series susceptance of a [`PhaseShiftingTransformer3W`](@ref) as three values
(for each of the 3 branches) following the convention in power systems to define susceptance as the inverse of the imaginary part of the impedance.
The phase shift angles are ignored in the susceptance calculation.

See also: [`get_series_susceptance`](@ref) for 2-winding transformers and [`get_series_susceptances`](@ref get_series_susceptances(b::Transformer3W)) for [`Transformer3W`](@ref) 
"""
function get_series_susceptances(b::PhaseShiftingTransformer3W)
    y1 = 1 / get_x_primary(b)
    y2 = 1 / get_x_secondary(b)
    y3 = 1 / get_x_tertiary(b)

    y1_a = y1 / get_primary_turns_ratio(b)
    y2_a = y2 / get_secondary_turns_ratio(b)
    y3_a = y3 / get_tertiary_turns_ratio(b)

    return (y1_a, y2_a, y3_a)
end

"""
Returns the series susceptance of a [`Transformer3W`](@ref) as three values
(for each of the 3 branches) following the convention
in power systems to define susceptance as the inverse of the imaginary part of the impedance.

See also: [`get_series_susceptance`](@ref) for 2-winding transformers and [`get_series_susceptances`](@ref get_series_susceptances(b::PhaseShiftingTransformer3W)) for [`PhaseShiftingTransformer3W`](@ref) 
"""
function get_series_susceptances(b::Transformer3W)
    Z1s = get_r_primary(b) + get_x_primary(b) * 1im
    Z2s = get_r_secondary(b) + get_x_secondary(b) * 1im
    Z3s = get_r_tertiary(b) + get_x_tertiary(b) * 1im

    b1s = imag(1 / Z1s)
    b2s = imag(1 / Z2s)
    b3s = imag(1 / Z3s)

    return (b1s, b2s, b3s)
end

"""
Calculate the series admittance of a [`ACTransmission`](@ref) as the inverse of the complex impedance.
Returns 1/(R + jX) where R is resistance and X is reactance.
"""
get_series_admittance(b::ACTransmission) = 1 / (get_r(b) + get_x(b) * 1im)

function get_series_admittance(::Union{PhaseShiftingTransformer3W, Transformer3W})
    throw(
        ArgumentError(
            "get_series_admittance not implemented for multi-winding transformers.",
        ),
    )
end

"""
Return the max active power for a device as the max field in the named tuple returned by [`get_active_power_limits`](@ref).
"""
function get_max_active_power(d::T) where {T <: StaticInjection}
    return get_active_power_limits(d).max
end

"""
Return the max reactive power for a device as the max field in the named tuple returned by [`get_reactive_power_limits`](@ref).
"""
function get_max_reactive_power(d::T)::Float64 where {T <: StaticInjection}
    if isnothing(get_reactive_power_limits(d))
        return Inf
    end
    return get_reactive_power_limits(d).max
end

"""
Return the max reactive power for a [`RenewableDispatch`](@ref) generator calculated as the `rating` * `power_factor` if
the field `reactive_power_limits` is `nothing`
"""
function get_max_reactive_power(d::RenewableDispatch)
    reactive_power_limits = get_reactive_power_limits(d)
    if isnothing(reactive_power_limits)
        return get_rating(d) * sin(acos(get_power_factor(d)))
    end
    return reactive_power_limits.max
end

"""
Generic fallback function for getting active power limits. Throws `ArgumentError` for devices
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
Generic fallback function for getting device rating. Throws `ArgumentError` for devices
that don't implement this function.
"""
get_rating(::T) where {T <: Device} =
    throw(ArgumentError("get_rating not implemented for $T"))
"""
Generic fallback function for getting power factor. Throws `ArgumentError` for devices
that don't implement this function.
"""
get_power_factor(::T) where {T <: Device} =
    throw(ArgumentError("get_power_factor not implemented for $T"))

"""
Calculate the maximum active power for a [`StandardLoad`](@ref) or [`InterruptibleStandardLoad`](@ref)
    by summing the maximum constant, impedance, and current components assuming a 1.0 voltage magnitude at the bus.
"""
function get_max_active_power(d::Union{InterruptibleStandardLoad, StandardLoad})
    total_load = get_max_constant_active_power(d)
    total_load += get_max_impedance_active_power(d)
    total_load += get_max_current_active_power(d)
    return total_load
end

"""
Get the flow limit from source area to destination area for an [`AreaInterchange`](@ref).
"""
function get_from_to_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).from_to
end
"""
Get the flow limit from destination area to source area for an [`AreaInterchange`](@ref).
"""
function get_to_from_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).to_from
end

"""
Get the minimum active power flow limit for a [`TransmissionInterface`](@ref).
"""
function get_min_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).min
end

"""
Get the maximum active power flow limit for a [`TransmissionInterface`](@ref).
"""
function get_max_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).max
end

"""
Calculate the phase shift angle α for a [`TapTransformer`](@ref) or [`Transformer2W`](@ref) based on its winding group number.
Returns the angle in radians, calculated as -(π/6) * winding_group_number.
If the `winding_group_number` is `WindingGroupNumber.UNDEFINED`, returns 0.0 and issues a warning.
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
Calculate the phase shift angle α for the primary winding of a [`Transformer3W`](@ref)
based on its primary winding group number. Returns the angle in radians, calculated
as -(π/6) * `primary_group_number`. If `primary_group_number` is `WindingGroupNumber.UNDEFINED`, returns 0.0 and issues a warning.
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
Calculate the phase shift angle α for the secondary winding of a [`Transformer3W`](@ref)
based on its secondary winding group number. Returns the angle in radians, calculated
as -(π/6) * `secondary_group_number`. If `secondary_group_number` is `WindingGroupNumber.UNDEFINED`, returns 0.0 and issues a warning.
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
Calculate the phase shift angle α for the tertiary winding of a [`Transformer3W`](@ref)
based on its tertiary winding group number. Returns the angle in radians, calculated
as -(π/6) * `tertiary_group_number`. If `tertiary_group_number` is `WindingGroupNumber.UNDEFINED`, returns 0.0 and issues a warning.
"""
function get_α_tertiary(t::Transformer3W)
    if get_tertiary_group_number(t) == WindingGroupNumber.UNDEFINED
        @warn "tertiary winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_tertiary_group_number(t).value * -(π / 6)
    end
end

function supports_services(::AreaInterchange)
    return true
end
