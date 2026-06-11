
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
Generic method to calculate the susceptance of [`ACTransmission`](@ref) devices.
"""
get_series_susceptance(b::ACTransmission, units::IS.AbstractUnitSystem) =
    1 / get_x(b, units)

"""
Returns the series susceptance of a controllable 2-winding transformer (e.g., [`TapTransformer`](@ref), [`PhaseShiftingTransformer`](@ref)) following the convention
in power systems to define susceptance as the inverse of the imaginary part of the impedance.
In the case of phase shifter transformers the angle is ignored.

See also: [`get_series_susceptances`](@ref) for 3-winding transformers
"""
function get_series_susceptance(
    b::Union{TapTransformer, PhaseShiftingTransformer},
    units::IS.AbstractUnitSystem,
)
    y = 1 / get_x(b, units)
    y_a = y / (get_tap(b))
    return y_a
end

function get_series_susceptance(
    ::Union{PhaseShiftingTransformer3W, Transformer3W},
    ::IS.AbstractUnitSystem,
)
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
function get_series_susceptances(
    b::PhaseShiftingTransformer3W,
    units::IS.AbstractUnitSystem,
)
    y1 = 1 / get_x_primary(b, units)
    y2 = 1 / get_x_secondary(b, units)
    y3 = 1 / get_x_tertiary(b, units)

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
function get_series_susceptances(b::Transformer3W, units::IS.AbstractUnitSystem)
    Z1s = get_r_primary(b, units) + get_x_primary(b, units) * 1im
    Z2s = get_r_secondary(b, units) + get_x_secondary(b, units) * 1im
    Z3s = get_r_tertiary(b, units) + get_x_tertiary(b, units) * 1im

    b1s = imag(1 / Z1s)
    b2s = imag(1 / Z2s)
    b3s = imag(1 / Z3s)

    return (b1s, b2s, b3s)
end

"""
    get_base_voltage(line::Union{Line, MonitoredLine})

Return the base voltage (kV) of a [`Line`](@ref) or [`MonitoredLine`](@ref) by reading the
`base_voltage` from both endpoints of the line's [`Arc`](@ref).

If the two bus voltages are identical, that value is returned directly. If they differ but
are within `BRANCH_BUS_VOLTAGE_DIFFERENCE_TOL` (percent), the value with fewer significant
figures is returned (i.e., the rounder number). If the difference exceeds the tolerance, an
error is thrown.
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
Select the value with fewer significant figures (the "rounder" number),
comparing the coarsest decimal granularity at which each value is exactly
representable. Purely numeric — this sits on conversion paths, so no string
round-trips.
"""
function _select_fewer_significant_figures(a::Float64, b::Float64)
    ga = _decimal_granularity(a)
    gb = _decimal_granularity(b)
    ga < gb && return a
    gb < ga && return b
    return max(a, b)
end

# Smallest digit count `d` such that `round(v; digits = d) == v`; lower means
# coarser (rounder) numbers.
function _decimal_granularity(v::Float64)
    for d in -6:10
        round(v; digits = d) == v && return d
    end
    return 11
end

"""
    get_high_voltage(t::TwoWindingTransformer)

Return the high-side base voltage (kV) of a [`TwoWindingTransformer`](@ref) as the
maximum of `base_voltage_primary` and `base_voltage_secondary`.
"""
function get_high_voltage(t::TwoWindingTransformer)
    v_primary = get_base_voltage_primary(t)
    v_secondary = get_base_voltage_secondary(t)
    return max(v_primary, v_secondary)
end

"""
    get_low_voltage(t::TwoWindingTransformer)

Return the low-side base voltage (kV) of a [`TwoWindingTransformer`](@ref) as the
minimum of `base_voltage_primary` and `base_voltage_secondary`.
"""
function get_low_voltage(t::TwoWindingTransformer)
    v_primary = get_base_voltage_primary(t)
    v_secondary = get_base_voltage_secondary(t)
    return min(v_primary, v_secondary)
end

"""
Calculate the series admittance of a [`ACTransmission`](@ref) as the inverse of the complex impedance.
Returns 1/(R + jX) where R is resistance and X is reactance.
"""
get_series_admittance(b::ACTransmission, units::IS.AbstractUnitSystem) =
    1 / (get_r(b, units) + get_x(b, units) * 1im)

"""
Calculate the series admittance of a [`PhaseShiftingTransformer`](@ref) accounting for the tap ratio.
For a phase-shifting transformer, the series admittance is calculated as the inverse of the
complex impedance modified by the tap ratio, following the same pattern as the susceptance calculation:
Y = 1/(tap * (R + jX)).
The phase angle α affects the admittance matrix construction but not the series impedance magnitude directly.

See also: [`get_series_susceptance`](@ref)
"""
function get_series_admittance(b::PhaseShiftingTransformer, units::IS.AbstractUnitSystem)
    tap = get_tap(b)
    Z_series = get_r(b, units) + get_x(b, units) * 1im
    return 1 / (tap * Z_series)
end

"""
Calculate the series admittance of a [`TapTransformer`](@ref) accounting for the tap ratio.
For a tap transformer, the series admittance is calculated as the inverse of the
complex impedance modified by the tap ratio, following the same pattern as the susceptance calculation:
Y = 1/(tap * (R + jX)).

See also: [`get_series_susceptance`](@ref)
"""
function get_series_admittance(b::TapTransformer, units::IS.AbstractUnitSystem)
    tap = get_tap(b)
    Z_series = get_r(b, units) + get_x(b, units) * 1im
    return 1 / (tap * Z_series)
end

"""
Calculate the series admittances of a [`PhaseShiftingTransformer3W`](@ref) as three complex values
(for each of the 3 branches) accounting for turns ratios.
For each winding, the series admittance is calculated following the same pattern as the susceptance calculation:
Yi = 1/(turns_ratio_i * (Ri + jXi)).
The phase shift angles affect the admittance matrix construction but not the series impedance magnitudes directly.

See also: [`get_series_admittance`](@ref) for 2-winding transformers
"""
function get_series_admittances(b::PhaseShiftingTransformer3W, units::IS.AbstractUnitSystem)
    # Get the turns ratios for each winding
    tap_primary = get_primary_turns_ratio(b)
    tap_secondary = get_secondary_turns_ratio(b)
    tap_tertiary = get_tertiary_turns_ratio(b)

    # Calculate series impedances
    Z1 = get_r_primary(b, units) + get_x_primary(b, units) * 1im
    Z2 = get_r_secondary(b, units) + get_x_secondary(b, units) * 1im
    Z3 = get_r_tertiary(b, units) + get_x_tertiary(b, units) * 1im

    # Calculate admittances accounting for turns ratios (consistent with susceptance pattern)
    Y1 = 1 / (tap_primary * Z1)
    Y2 = 1 / (tap_secondary * Z2)
    Y3 = 1 / (tap_tertiary * Z3)

    return (Y1, Y2, Y3)
end

function get_series_admittance(
    ::Union{PhaseShiftingTransformer3W, Transformer3W},
    ::IS.AbstractUnitSystem,
)
    throw(
        ArgumentError(
            "get_series_admittance not implemented for multi-winding transformers, use get_series_admittances instead.",
        ),
    )
end

"""
Return the max active power for a device with explicit units specified.
"""
function get_max_active_power(d::T, units) where {T <: StaticInjection}
    return get_active_power_limits(d, units).max
end

"""
Return the max reactive power for a device with explicit units specified.
"""
function get_max_reactive_power(d::T, units) where {T <: StaticInjection}
    limits = get_reactive_power_limits(d, units)
    isnothing(limits) && return Inf
    return limits.max
end

"""
Return the max reactive power for a [`RenewableDispatch`](@ref) generator calculated as the `rating` * `power_factor` if
the field `reactive_power_limits` is `nothing`
"""
function get_max_reactive_power(d::RenewableDispatch, units)
    limits = get_reactive_power_limits(d, units)
    if isnothing(limits)
        return get_rating(d, units) * sin(acos(get_power_factor(d)))
    end
    return limits.max
end

"""
Generic fallback function for getting active power limits. Throws `ArgumentError` for devices
that don't implement this function.
"""
get_active_power_limits(::T, _) where {T <: Device} =
    throw(ArgumentError("get_active_power_limits not implemented for $T"))
"""
Generic fallback function for getting reactive power limits. Throws `ArgumentError` for devices
that don't implement this function.
"""
get_reactive_power_limits(::T, _) where {T <: Device} =
    throw(ArgumentError("get_reactive_power_limits not implemented for $T"))
"""
Generic fallback function for getting device rating. Throws `ArgumentError` for devices
that don't implement this function.
"""
get_rating(::T, _) where {T <: Device} =
    throw(ArgumentError("get_rating not implemented for $T"))
"""
Generic fallback function for getting power factor. Throws `ArgumentError` for devices
that don't implement this function.
"""
get_power_factor(::T) where {T <: Device} =
    throw(ArgumentError("get_power_factor not implemented for $T"))

"""
Calculate the maximum active power for a [`StandardLoad`](@ref) or [`InterruptibleStandardLoad`](@ref)
    with explicit units specified.
"""
function get_max_active_power(d::Union{InterruptibleStandardLoad, StandardLoad}, units)
    total_load = get_max_constant_active_power(d, units)
    total_load += get_max_impedance_active_power(d, units)
    total_load += get_max_current_active_power(d, units)
    return total_load
end

"""
Get the maximum storage capacity for HydroReservoir.
"""
function get_max_storage_level(reservoir::HydroReservoir)
    return get_storage_level_limits(reservoir).max
end

"""
Get the flow limits from source [`Area`](@ref) to destination [`Area`](@ref) for an [`AreaInterchange`](@ref), in the specified `units`.
"""
function get_from_to_flow_limit(a::AreaInterchange, units)
    return get_flow_limits(a, units).from_to
end
"""
Get the flow limits from destination [`Area`](@ref) to source [`Area`](@ref) for an [`AreaInterchange`](@ref), in the specified `units`.
"""
function get_to_from_flow_limit(a::AreaInterchange, units)
    return get_flow_limits(a, units).to_from
end

"""
Get the minimum active power flow limit for a [`TransmissionInterface`](@ref), in the specified `units`.
"""
function get_min_active_power_flow_limit(tx::TransmissionInterface, units)
    return get_active_power_flow_limits(tx, units).min
end

"""
Get the maximum active power flow limit for a [`TransmissionInterface`](@ref), in the specified `units`.
"""
function get_max_active_power_flow_limit(tx::TransmissionInterface, units)
    return get_active_power_flow_limits(tx, units).max
end

"""
Calculate the phase shift angle α for a [`TapTransformer`](@ref) or [`Transformer2W`](@ref) based on its winding group number.
Returns the angle in radians, calculated as -(π/6) * `winding_group_number`.
If the `winding_group_number` is `WindingGroupNumber.UNDEFINED`, returns 0.0 and issues a warning.
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

function _get_components(value::HybridSystem)
    components =
        [value.thermal_unit, value.electric_load, value.storage, value.renewable_unit]
    filter!(x -> !isnothing(x), components)
    return components
end

function set_units_setting!(
    value::HybridSystem,
    settings::Union{SystemUnitsSettings, Nothing},
)
    set_units_info!(get_internal(value), settings)
    for component in _get_components(value)
        set_units_info!(get_internal(component), settings)
    end
    return
end

"""
Return an iterator over the subcomponents in the HybridSystem.

# Examples
```julia
for subcomponent in get_subcomponents(hybrid_sys)
    @show subcomponent
end
subcomponents = collect(get_subcomponents(hybrid_sys))
```
"""
function get_subcomponents(hybrid::HybridSystem)
    return (
        sc for sc in (
            hybrid.thermal_unit,
            hybrid.electric_load,
            hybrid.storage,
            hybrid.renewable_unit,
        ) if sc !== nothing
    )
end
