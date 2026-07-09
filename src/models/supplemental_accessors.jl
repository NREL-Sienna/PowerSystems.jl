
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
Return the series susceptance of [`ACTransmission`](@ref) devices as the inverse of the reactance.

See also: [`get_series_admittance`](@ref)
"""
get_series_susceptance(b::ACTransmission) = 1 / get_x(b)

"""
Return the series susceptance of a controllable 2-winding transformer
([`TapTransformer`](@ref) or [`PhaseShiftingTransformer`](@ref)) as the inverse of the
imaginary part of the impedance, accounting for the tap ratio. The phase shift angle is
ignored.

See also: [`get_series_susceptances`](@ref) for 3-winding transformers
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
Return the series susceptances of a [`ThreeWindingTransformer`](@ref) as a 3-tuple of
values (one per winding), each computed as the inverse of the imaginary part of the
impedance accounting for turns ratios. Phase shift angles are ignored.

See also: [`get_series_susceptance`](@ref) for 2-winding transformers,
"""
function get_series_susceptances(b::ThreeWindingTransformer)
    y1 = 1 / get_x_primary(b)
    y2 = 1 / get_x_secondary(b)
    y3 = 1 / get_x_tertiary(b)

    y1_a = y1 / get_primary_turns_ratio(b)
    y2_a = y2 / get_secondary_turns_ratio(b)
    y3_a = y3 / get_tertiary_turns_ratio(b)

    return (y1_a, y2_a, y3_a)
end

"""
Return the base voltage (kV) of a [`Line`](@ref) or [`MonitoredLine`](@ref) by reading the
`base_voltage` from both endpoints of the line's [`Arc`](@ref).

If the two bus voltages are identical, that value is returned directly. If they differ but
are within `BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL` (percent), the value with fewer significant
figures is returned (i.e., the rounder number). If the difference exceeds the tolerance, an
error is thrown.

# Arguments
- `line::Union{Line, MonitoredLine}`: The transmission line.
"""
function get_base_voltage(line::Union{Line, MonitoredLine})
    v_from = get_base_voltage(get_from_bus(line))
    v_to = get_base_voltage(get_to_bus(line))
    v_from == v_to && return v_from
    percent_diff = abs(v_from - v_to) / ((v_from + v_to) / 2)
    if percent_diff > BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL
        error(
            "Bus voltage mismatch on $(get_name(line)): " *
            "from=$(v_from) kV, to=$(v_to) kV exceeds " *
            "$(BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL * 100)% tolerance.",
        )
    end
    return _select_fewer_significant_figures(v_from, v_to)
end

"""
Select the value with fewer significant figures (the "rounder" number).
Uses trailing zeros after stripping the decimal point as a proxy.
"""
function _select_fewer_significant_figures(a::Float64, b::Float64)
    sa = rstrip(string(a), '0')
    sb = rstrip(string(b), '0')
    la = length(sa)
    lb = length(sb)
    la < lb && return a
    lb < la && return b
    return max(a, b)
end

"""
Return the high-side base voltage (kV) of a [`TwoWindingTransformer`](@ref) as the
maximum of `base_voltage_primary` and `base_voltage_secondary`.

See also: [`get_low_voltage`](@ref)
"""
function get_high_voltage(t::TwoWindingTransformer)
    v_primary = get_base_voltage_primary(t)
    v_secondary = get_base_voltage_secondary(t)
    return max(v_primary, v_secondary)
end

"""
Return the low-side base voltage (kV) of a [`TwoWindingTransformer`](@ref) as the
minimum of `base_voltage_primary` and `base_voltage_secondary`.

See also: [`get_high_voltage`](@ref)
"""
function get_low_voltage(t::TwoWindingTransformer)
    v_primary = get_base_voltage_primary(t)
    v_secondary = get_base_voltage_secondary(t)
    return min(v_primary, v_secondary)
end

"""
Return the series admittance of an [`ACTransmission`](@ref) device as the inverse of
the complex impedance `1 / (R + jX)`.

See also: [`get_series_susceptance`](@ref)
"""
get_series_admittance(b::ACTransmission) = 1 / (get_r(b) + get_x(b) * 1im)

"""
Return the series admittance of a [`PhaseShiftingTransformer`](@ref) as `1 / (tap × (R + jX))`.

The phase angle α affects the admittance matrix construction but not the series impedance magnitude.

See also: [`get_series_susceptance`](@ref), [`get_series_admittance`](@ref)
"""
function get_series_admittance(b::PhaseShiftingTransformer)
    tap = get_tap(b)
    Z_series = get_r(b) + get_x(b) * 1im
    return 1 / (tap * Z_series)
end

"""
Return the series admittance of a [`TapTransformer`](@ref) as `1 / (tap × (R + jX))`.

See also: [`get_series_susceptance`](@ref), [`get_series_admittance`](@ref)
"""
function get_series_admittance(b::TapTransformer)
    tap = get_tap(b)
    Z_series = get_r(b) + get_x(b) * 1im
    return 1 / (tap * Z_series)
end

"""
Return the series admittances of a [`PhaseShiftingTransformer3W`](@ref) as a 3-tuple of
complex values (one per winding), each computed as `1 / (turns_ratio_i × (Ri + jXi))`.
Phase shift angles affect the admittance matrix but not series impedance magnitudes.

See also: [`get_series_admittance`](@ref) for 2-winding transformers
"""
function get_series_admittances(b::PhaseShiftingTransformer3W)
    # Get the turns ratios for each winding
    tap_primary = get_primary_turns_ratio(b)
    tap_secondary = get_secondary_turns_ratio(b)
    tap_tertiary = get_tertiary_turns_ratio(b)

    # Calculate series impedances
    Z1 = get_r_primary(b) + get_x_primary(b) * 1im
    Z2 = get_r_secondary(b) + get_x_secondary(b) * 1im
    Z3 = get_r_tertiary(b) + get_x_tertiary(b) * 1im

    # Calculate admittances accounting for turns ratios (consistent with susceptance pattern)
    Y1 = 1 / (tap_primary * Z1)
    Y2 = 1 / (tap_secondary * Z2)
    Y3 = 1 / (tap_tertiary * Z3)

    return (Y1, Y2, Y3)
end

function get_series_admittance(::Union{PhaseShiftingTransformer3W, Transformer3W})
    throw(
        ArgumentError(
            "get_series_admittance not implemented for multi-winding transformers, use get_series_admittances instead.",
        ),
    )
end

"""
Return the maximum active power for a [`StaticInjection`](@ref) device as the `max` field
of the named tuple returned by [`get_active_power_limits`](@ref).

See also: [`get_max_reactive_power`](@ref), [`get_active_power_limits`](@ref)
"""
function get_max_active_power(d::T) where {T <: StaticInjection}
    return get_active_power_limits(d).max
end

"""
Return the maximum reactive power for a [`StaticInjection`](@ref) device as the `max` field
of the named tuple returned by [`get_reactive_power_limits`](@ref). Returns `Inf` if
`reactive_power_limits` is `nothing`.

See also: [`get_max_active_power`](@ref), [`get_reactive_power_limits`](@ref)
"""
function get_max_reactive_power(d::T)::Float64 where {T <: StaticInjection}
    if isnothing(get_reactive_power_limits(d))
        return Inf
    end
    return get_reactive_power_limits(d).max
end

"""
Return the maximum reactive power for a [`RenewableDispatch`](@ref) generator. If
`reactive_power_limits` is `nothing`, the value is calculated as `rating` × sin(acos(`power_factor`)).

See also: [`get_max_reactive_power`](@ref get_max_reactive_power(d::T) where {T <: StaticInjection})
"""
function get_max_reactive_power(d::RenewableDispatch)
    reactive_power_limits = get_reactive_power_limits(d)
    if isnothing(reactive_power_limits)
        return get_rating(d) * sin(acos(get_power_factor(d)))
    end
    return reactive_power_limits.max
end

"""
Generic fallback — throws `ArgumentError` for devices that do not implement `get_active_power_limits`.

See also: [`get_active_power_limits`](@ref)
"""
get_active_power_limits(::T) where {T <: Device} =
    throw(ArgumentError("get_active_power_limits not implemented for $T"))
"""
Generic fallback — throws `ArgumentError` for devices that do not implement `get_reactive_power_limits`.

See also: [`get_reactive_power_limits`](@ref)
"""
get_reactive_power_limits(::T) where {T <: Device} =
    throw(ArgumentError("get_reactive_power_limits not implemented for $T"))
"""
Generic fallback — throws `ArgumentError` for devices that do not implement `get_rating`.
"""
get_rating(::T) where {T <: Device} =
    throw(ArgumentError("get_rating not implemented for $T"))
"""
Generic fallback — throws `ArgumentError` for devices that do not implement `get_power_factor`.
"""
get_power_factor(::T) where {T <: Device} =
    throw(ArgumentError("get_power_factor not implemented for $T"))

"""
Return the maximum active power for a [`StandardLoad`](@ref) or [`InterruptibleStandardLoad`](@ref)
by summing constant, impedance, and current components at unit voltage.

See also: [`get_max_active_power`](@ref)
"""
function get_max_active_power(d::Union{InterruptibleStandardLoad, StandardLoad})
    total_load = get_max_constant_active_power(d)
    total_load += get_max_impedance_active_power(d)
    total_load += get_max_current_active_power(d)
    return total_load
end

"""
Return the maximum storage level for a [`HydroReservoir`](@ref).

See also: [`get_storage_level_limits`](@ref)
"""
function get_max_storage_level(reservoir::HydroReservoir)
    return get_storage_level_limits(reservoir).max
end

"""
Return the flow limit from the source [`Area`](@ref) to the destination [`Area`](@ref)
for an [`AreaInterchange`](@ref).

See also: [`get_to_from_flow_limit`](@ref), [`get_flow_limits`](@ref)
"""
function get_from_to_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).from_to
end
"""
Return the flow limit from the destination [`Area`](@ref) to the source [`Area`](@ref)
for an [`AreaInterchange`](@ref).

See also: [`get_from_to_flow_limit`](@ref), [`get_flow_limits`](@ref)
"""
function get_to_from_flow_limit(a::AreaInterchange)
    return get_flow_limits(a).to_from
end

"""
Return the minimum active power flow limit for a [`TransmissionInterface`](@ref).

See also: [`get_max_active_power_flow_limit`](@ref), [`get_active_power_flow_limits`](@ref)
"""
function get_min_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).min
end

"""
Return the maximum active power flow limit for a [`TransmissionInterface`](@ref).

See also: [`get_min_active_power_flow_limit`](@ref), [`get_active_power_flow_limits`](@ref)
"""
function get_max_active_power_flow_limit(tx::TransmissionInterface)
    return get_active_power_flow_limits(tx).max
end

"""
Return the phase shift angle α (radians) for a [`TapTransformer`](@ref) or [`Transformer2W`](@ref)
based on its winding group number, calculated as `-(π/6) × winding_group_number`.

Returns `0.0` and logs a debug message if the winding group number is `WindingGroupNumber.UNDEFINED`.

See also: [`get_α_primary`](@ref), [`get_winding_group_number`](@ref)
"""
function get_α(t::Union{TapTransformer, Transformer2W})
    if get_winding_group_number(t) == WindingGroupNumber.UNDEFINED
        @debug "winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_winding_group_number(t).value * -(π / 6)
    end
end

"""
Return the primary winding phase shift angle α (radians) for a [`Transformer3W`](@ref)
based on its primary winding group number, calculated as `-(π/6) × primary_group_number`.

Returns `0.0` and issues a warning if the primary winding group number is `WindingGroupNumber.UNDEFINED`.

See also: [`get_α_secondary`](@ref), [`get_α_tertiary`](@ref), [`get_primary_group_number`](@ref)
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
Return the secondary winding phase shift angle α (radians) for a [`Transformer3W`](@ref)
based on its secondary winding group number, calculated as `-(π/6) × secondary_group_number`.

Returns `0.0` and issues a warning if the secondary winding group number is `WindingGroupNumber.UNDEFINED`.

See also: [`get_α_primary`](@ref), [`get_α_tertiary`](@ref), [`get_secondary_group_number`](@ref)
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
Return the tertiary winding phase shift angle α (radians) for a [`Transformer3W`](@ref)
based on its tertiary winding group number, calculated as `-(π/6) × tertiary_group_number`.

Returns `0.0` and issues a warning if the tertiary winding group number is `WindingGroupNumber.UNDEFINED`.

See also: [`get_α_primary`](@ref), [`get_α_secondary`](@ref), [`get_tertiary_group_number`](@ref)
"""
function get_α_tertiary(t::Transformer3W)
    if get_tertiary_group_number(t) == WindingGroupNumber.UNDEFINED
        @warn "tertiary winding group number for $(summary(t)) is undefined, assuming zero phase shift"
        return 0.0
    else
        return get_tertiary_group_number(t).value * -(π / 6)
    end
end

"""
Return true since [`AreaInterchange`](@ref) supports services.

See also: [`supports_services`](@ref)
"""
function supports_services(::AreaInterchange)
    return true
end

# supports_active_power overrides for types without controllable active power
supports_active_power(::SynchronousCondenser) = false

# supports_reactive_power overrides for types without controllable reactive power
supports_reactive_power(::InterconnectingConverter) = false

# A shunt-admittance component counts as power support only above an absolute
# threshold, so negligible admittances do not force their host bus to be kept.
_nonzero_admittance(x::Real) = abs(x) > ZERO_ADMITTANCE_THRESHOLD

# FixedAdmittance / SwitchedAdmittance support active power via conductance
# (real(Y)) and reactive power via susceptance (imag(Y)), so capability is
# parameter-dependent rather than a fixed type property.
supports_active_power(d::FixedAdmittance) = _nonzero_admittance(real(get_Y(d)))
supports_reactive_power(d::FixedAdmittance) = _nonzero_admittance(imag(get_Y(d)))

# SwitchedAdmittance can also shift admittance via per-block switchable steps, so
# capability includes the base Y and any block with steps and an above-threshold
# increment in the relevant component.
function supports_active_power(d::SwitchedAdmittance)
    _nonzero_admittance(real(get_Y(d))) && return true
    return any(
        n > 0 && _nonzero_admittance(real(yi))
        for (n, yi) in zip(get_number_of_steps(d), get_Y_increase(d))
    )
end

function supports_reactive_power(d::SwitchedAdmittance)
    _nonzero_admittance(imag(get_Y(d))) && return true
    return any(
        n > 0 && _nonzero_admittance(imag(yi))
        for (n, yi) in zip(get_number_of_steps(d), get_Y_increase(d))
    )
end

# FACTSControlDevice reactive power and voltage control depend on control_mode.
# control_mode is nothing for uninitialized devices (e.g. FACTSControlDevice(nothing)).
_facts_is_active(d::FACTSControlDevice) =
    (mode = get_control_mode(d); !isnothing(mode) && mode != FACTSOperationModes.OOS)

# In NML mode both Series and Shunt links operate, enabling active power control.
# In BYP mode the Series link is bypassed and the Shunt acts as a STATCOM (reactive only).
function supports_active_power(d::FACTSControlDevice)
    mode = get_control_mode(d)
    return !isnothing(mode) && mode == FACTSOperationModes.NML
end

supports_reactive_power(d::FACTSControlDevice) = _facts_is_active(d)

# supports_voltage_control overrides for types that can control voltage
supports_voltage_control(::Generator) = true
supports_voltage_control(::Source) = true
supports_voltage_control(::Storage) = true
supports_voltage_control(::StaticInjectionSubsystem) = true

supports_voltage_control(d::FACTSControlDevice) = _facts_is_active(d)

function supports_voltage_control(d::SynchronousCondenser)
    bustype = get_bustype(get_bus(d))
    return bustype ∈ (ACBusTypes.PV, ACBusTypes.REF, ACBusTypes.SLACK)
end
