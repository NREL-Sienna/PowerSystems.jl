
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

The tap ratio and phase-shift angle are **not** applied: this returns `1/x` from the
stored series reactance alone. [`TwoWindingTransformer`](@ref) has a more specific
override (below) that additionally divides by the winding tap ratio
(`get_tap(get_winding(t))`), restoring the pre-refactor `TapTransformer`/
`PhaseShiftingTransformer` convention. This is a deliberate asymmetry with
[`get_series_admittance`](@ref), which never divides by tap for any type — the pre-refactor
code only tap-divided the susceptance form. Consumers that need α applied must read
`get_α(get_winding(t))` (2-winding) or the per-winding equivalents (3-winding) and apply
it explicitly.
"""
get_series_susceptance(b::ACTransmission, units::IS.AbstractUnitSystem) =
    1 / get_x(b, units)

"""
    get_series_susceptance(t::TwoWindingTransformer, units::IS.AbstractUnitSystem)

Series susceptance of a [`TwoWindingTransformer`](@ref): the generic `ACTransmission`
value (`1/x`) divided by the winding tap ratio `get_tap(get_winding(t))`. This restores
the pre-refactor `TapTransformer`/`PhaseShiftingTransformer` convention, under which
`get_series_susceptance` divided by `tap`; a fixed-ratio transformer has `tap = 1.0`, so
this is a no-op for it and matches the plain `ACTransmission` value. `get_series_admittance`
does **not** apply this division for any type — the asymmetry is deliberate, mirroring the
pre-refactor code, which only tap-divided the susceptance form.
"""
get_series_susceptance(t::TwoWindingTransformer, units::IS.AbstractUnitSystem) =
    (1 / get_x(t, units)) / get_tap(get_winding(t))

get_series_susceptance(::ThreeWindingTransformer, ::IS.AbstractUnitSystem) =
    throw(
        ArgumentError(
            "get_series_susceptance is not defined for three-winding transformers; " *
            "use get_series_susceptances for three-winding transformers",
        ),
    )

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
maximum of the primary winding's base voltage and `base_voltage_secondary`.
"""
function get_high_voltage(t::TwoWindingTransformer)
    v_primary = get_base_voltage(get_winding(t))
    v_secondary = get_base_voltage_secondary(t)
    return max(v_primary, v_secondary)
end

"""
    get_low_voltage(t::TwoWindingTransformer)

Return the low-side base voltage (kV) of a [`TwoWindingTransformer`](@ref) as the
minimum of the primary winding's base voltage and `base_voltage_secondary`.
"""
function get_low_voltage(t::TwoWindingTransformer)
    v_primary = get_base_voltage(get_winding(t))
    v_secondary = get_base_voltage_secondary(t)
    return min(v_primary, v_secondary)
end

"""
Calculate the series admittance of a [`ACTransmission`](@ref) as the inverse of the complex impedance.
Returns 1/(R + jX) where R is resistance and X is reactance.

The tap ratio and phase-shift angle are **not** applied for any [`ACTransmission`](@ref)
type, including [`TwoWindingTransformer`](@ref) — unlike [`get_series_susceptance`](@ref),
which has a [`TwoWindingTransformer`](@ref)-specific override that divides by tap. That
asymmetry is deliberate, mirroring the pre-refactor `TapTransformer`/
`PhaseShiftingTransformer` code, which only tap-divided the susceptance form. Consumers
that need the tapped model must read `get_tap(get_winding(t))`/`get_α(get_winding(t))`
(2-winding) or the per-winding equivalents (3-winding) and apply them explicitly.
"""
get_series_admittance(b::ACTransmission, units::IS.AbstractUnitSystem) =
    1 / (get_r(b, units) + get_x(b, units) * 1im)

get_series_admittance(::ThreeWindingTransformer, ::IS.AbstractUnitSystem) =
    throw(
        ArgumentError(
            "get_series_admittance is not defined for three-winding transformers; " *
            "use get_series_admittances for three-winding transformers",
        ),
    )

"""
    get_series_admittances(t::ThreeWindingTransformer, units)

Star-leg series admittances `(primary, secondary, tertiary)`, derived on call from
the stored pairwise impedances. Convenience only — repeated impedance math should go
through PowerNetworkMatrices, which owns the cached star derivation.

The tap ratio and phase-shift angle of each winding are **not** applied: these are the
star-leg admittances from the stored pairwise impedances alone. Consumers that need the
tapped model must read `get_tap(w)`/`get_α(w)` for each winding `w` in
`get_windings(t)` and apply them explicitly.

!!! warning "Unfloored — not the value matrix consumers should use"
    This convenience derivation is **unfloored**: a measured-zero star leg (a pairwise
    impedance combination whose derived reactance is exactly, or near, zero) yields an
    infinite admittance here. PowerNetworkMatrices derives the same star legs with
    zero-reactance flooring applied (`STAR_LEG_REACTANCE_FLOOR = 1e-4`), so its values
    differ from this function's for any such winding. Matrix-consistency consumers (Ybus,
    PTDF/LODF, network reductions, ...) must use PowerNetworkMatrices' derived values —
    never re-derive star-leg admittances here and expect them to agree.
"""
function get_series_admittances(t::ThreeWindingTransformer, units::UnitArg)
    units isa IS.DeviceBaseUnit && throw(
        ArgumentError(
            "star-leg admittances are undefined for DU: the three pairwise impedances have different device bases; request SU or NU",
        ),
    )
    z12 = get_r_12(t, units) + im * get_x_12(t, units)
    z23 = get_r_23(t, units) + im * get_x_23(t, units)
    z13 = get_r_13(t, units) + im * get_x_13(t, units)
    z1 = (z12 + z13 - z23) / 2
    z2 = (z12 + z23 - z13) / 2
    z3 = (z13 + z23 - z12) / 2
    return (1 / z1, 1 / z2, 1 / z3)
end

"""
Returns the series susceptance of a [`ThreeWindingTransformer`](@ref) as three values
(for each of the 3 star legs) following the convention in power systems to define
susceptance as the inverse of the imaginary part of the impedance.

See also: [`get_series_susceptance`](@ref) for 2-winding transformers.
"""
get_series_susceptances(t::ThreeWindingTransformer, units::UnitArg) =
    map(imag, get_series_admittances(t, units))

"""
Return the max active power for a device with explicit units specified.
"""
function get_max_active_power(d::T, units) where {T <: StaticInjection}   # units untyped deliberately: typed UnitArg is dispatch-ambiguous vs generated per-type methods (untyped units); fix belongs in the IS codegen template
    return get_active_power_limits(d, units).max
end

"""
Return the max reactive power for a device with explicit units specified.
"""
function get_max_reactive_power(d::T, units) where {T <: StaticInjection}   # units untyped deliberately: see get_max_active_power note above
    limits = get_reactive_power_limits(d, units)
    isnothing(limits) && return Inf
    return limits.max
end

"""
Return the max reactive power for a [`RenewableDispatch`](@ref) generator calculated as the `rating` * `power_factor` if
the field `reactive_power_limits` is `nothing`
"""
function get_max_reactive_power(d::RenewableDispatch, units::UnitArg)
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
function get_max_active_power(
    d::Union{InterruptibleStandardLoad, StandardLoad},
    units::UnitArg,
)
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
function get_from_to_flow_limit(a::AreaInterchange, units::UnitArg)
    return get_flow_limits(a, units).from_to
end
"""
Get the flow limits from destination [`Area`](@ref) to source [`Area`](@ref) for an [`AreaInterchange`](@ref), in the specified `units`.
"""
function get_to_from_flow_limit(a::AreaInterchange, units::UnitArg)
    return get_flow_limits(a, units).to_from
end

"""
Get the minimum active power flow limit for a [`TransmissionInterface`](@ref), in the specified `units`.
"""
function get_min_active_power_flow_limit(tx::TransmissionInterface, units::UnitArg)
    return get_active_power_flow_limits(tx, units).min
end

"""
Get the maximum active power flow limit for a [`TransmissionInterface`](@ref), in the specified `units`.
"""
function get_max_active_power_flow_limit(tx::TransmissionInterface, units::UnitArg)
    return get_active_power_flow_limits(tx, units).max
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
    settings::Union{Float64, Nothing},
)
    IS.set_base_value!(value, settings)
    for component in _get_components(value)
        IS.set_base_value!(component, settings)
    end
    return
end

function set_units_setting!(
    t::Union{TwoWindingTransformer, ThreeWindingTransformer},
    settings::Union{SystemUnitsSettings, Nothing},
)
    set_units_info!(get_internal(t), settings)
    for w in get_windings(t)
        w.units_info = settings
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
