#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TransformerWinding <: DeviceParameter
        arc::Arc
        tap::Float64
        α::Float64
        winding_group_number::WindingGroupNumber
        control::Union{Nothing, TransformerControl}
        available::Bool
        rating::Union{Nothing, Float64}
        rating_b::Union{Nothing, Float64}
        rating_c::Union{Nothing, Float64}
        active_power_flow::Float64
        reactive_power_flow::Float64
        base_power::Float64
        base_voltage::Union{Nothing, Float64}
        units_info::Union{Nothing, SystemUnitsSettings}
    end

The data defining one modeled arc of a transformer.

A [`TwoWindingTransformer`](@ref) has one winding; a [`ThreeWindingTransformer`](@ref) has three, each connecting a terminal bus to the star bus. Winding `available` is the single source of truth for availability; the owning transformer derives its availability from its windings. `rating`/`rating_b`/`rating_c` and the flow fields are stored in device base per unit on `base_power` (MVA). `base_voltage` is the terminal-side base in kV. For a [`TwoWindingTransformer`](@ref)'s single winding, this `base_power` and the parent's `base_power` are expected to be equal; parsers are responsible for maintaining this invariant, and `check_rating_values` assumes it holds.

# Arguments
- `arc::Arc`: An [`Arc`](@ref) defining this winding `from` a terminal bus `to` the transformer's other terminal or star bus
- `tap::Float64`: (default: `1.0`) Normalized tap changer position for voltage control, varying between 0 and 2, with 1 centered at the nominal voltage
- `α::Float64`: (default: `0.0`) Initial condition of phase shift (radians) across this winding
- `winding_group_number::WindingGroupNumber`: (default: `WindingGroupNumber.UNDEFINED`) Vector group number ('clock number') indicating fixed phase shift (radians) due to the connection group configuration
- `control::Union{Nothing, TransformerControl}`: (default: `nothing`) Tap-changer / phase-shifter control specification, or `nothing` for an uncontrolled winding. See [`TransformerControl`](@ref)
- `available::Bool`: (default: `true`) Indicator of whether this winding is connected and online. Winding availability is the single source of truth; the owning transformer derives its availability from its windings
- `rating::Union{Nothing, Float64}`: (default: `nothing`) Thermal rating (MVA) stored in device base per unit on `base_power`
- `rating_b::Union{Nothing, Float64}`: (default: `nothing`) Second current rating; entered in MVA.
- `rating_c::Union{Nothing, Float64}`: (default: `nothing`) Third current rating; entered in MVA.
- `active_power_flow::Float64`: (default: `0.0`) Initial condition of active power flow through this winding (MW)
- `reactive_power_flow::Float64`: (default: `0.0`) Initial condition of reactive power flow through this winding (MVAR)
- `base_power::Float64`: (default: `100.0`) Base power (MVA) for [per unitization](@ref per_unit) of this winding
- `base_voltage::Union{Nothing, Float64}`: (default: `nothing`) Terminal-side base voltage in kV
- `units_info::Union{Nothing, SystemUnitsSettings}`: (**Do not modify.**) Internal units settings for explicit-units conversion; populated when the owning transformer is attached to a System
"""
mutable struct TransformerWinding <: DeviceParameter
    "An [`Arc`](@ref) defining this winding `from` a terminal bus `to` the transformer's other terminal or star bus"
    arc::Arc
    "Normalized tap changer position for voltage control, varying between 0 and 2, with 1 centered at the nominal voltage"
    tap::Float64
    "Initial condition of phase shift (radians) across this winding"
    α::Float64
    "Vector group number ('clock number') indicating fixed phase shift (radians) due to the connection group configuration"
    winding_group_number::WindingGroupNumber
    "Tap-changer / phase-shifter control specification, or `nothing` for an uncontrolled winding. See [`TransformerControl`](@ref)"
    control::Union{Nothing, TransformerControl}
    "Indicator of whether this winding is connected and online. Winding availability is the single source of truth; the owning transformer derives its availability from its windings"
    available::Bool
    "Thermal rating (MVA) stored in device base per unit on `base_power`"
    rating::Union{Nothing, Float64}
    "Second current rating; entered in MVA."
    rating_b::Union{Nothing, Float64}
    "Third current rating; entered in MVA."
    rating_c::Union{Nothing, Float64}
    "Initial condition of active power flow through this winding (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow through this winding (MVAR)"
    reactive_power_flow::Float64
    "Base power (MVA) for [per unitization](@ref per_unit) of this winding"
    base_power::Float64
    "Terminal-side base voltage in kV"
    base_voltage::Union{Nothing, Float64}
    "(**Do not modify.**) Internal units settings for explicit-units conversion; populated when the owning transformer is attached to a System"
    units_info::Union{Nothing, SystemUnitsSettings}
end

function TransformerWinding(arc, tap=1.0, α=0.0, winding_group_number=WindingGroupNumber.UNDEFINED, control=nothing, available=true, rating=nothing, rating_b=nothing, rating_c=nothing, active_power_flow=0.0, reactive_power_flow=0.0, base_power=100.0, base_voltage=nothing, )
    TransformerWinding(arc, tap, α, winding_group_number, control, available, rating, rating_b, rating_c, active_power_flow, reactive_power_flow, base_power, base_voltage, nothing, )
end

function TransformerWinding(; arc, tap=1.0, α=0.0, winding_group_number=WindingGroupNumber.UNDEFINED, control=nothing, available=true, rating=nothing, rating_b=nothing, rating_c=nothing, active_power_flow=0.0, reactive_power_flow=0.0, base_power=100.0, base_voltage=nothing, units_info=nothing, )
    TransformerWinding(arc, tap, α, winding_group_number, control, available, rating, rating_b, rating_c, active_power_flow, reactive_power_flow, base_power, base_voltage, units_info, )
end

# Constructor for demo purposes; non-functional.
function TransformerWinding(::Nothing)
    TransformerWinding(;
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        tap=1.0,
        α=0.0,
        winding_group_number=WindingGroupNumber.UNDEFINED,
        control=nothing,
        available=false,
        rating=nothing,
        rating_b=nothing,
        rating_c=nothing,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        base_power=100.0,
        base_voltage=nothing,
    )
end

"""Get [`TransformerWinding`](@ref) `arc`."""
get_arc(value::TransformerWinding) = value.arc
"""Get [`TransformerWinding`](@ref) `tap`."""
get_tap(value::TransformerWinding) = value.tap
"""Get [`TransformerWinding`](@ref) `α`."""
get_α(value::TransformerWinding) = value.α
"""Get [`TransformerWinding`](@ref) `winding_group_number`."""
get_winding_group_number(value::TransformerWinding) = value.winding_group_number
"""Get [`TransformerWinding`](@ref) `control`."""
get_control(value::TransformerWinding) = value.control
"""Get [`TransformerWinding`](@ref) `available`."""
get_available(value::TransformerWinding) = value.available
"""Get [`TransformerWinding`](@ref) `rating` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_rating_unitful`](@ref)."""
get_rating(value::TransformerWinding, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating), Val(:mva), units))
"""Get [`TransformerWinding`](@ref) `rating` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_rating`](@ref)."""
get_rating_unitful(value::TransformerWinding, units) = get_value(value, Val(:rating), Val(:mva), units)
InfrastructureSystems.display_units_arg(::typeof(get_rating), ::Type{TransformerWinding}) = InfrastructureSystems.DU
InfrastructureSystems.display_units_arg(::typeof(get_rating_unitful), ::Type{TransformerWinding}) = InfrastructureSystems.DU
"""Get [`TransformerWinding`](@ref) `rating_b` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_rating_b_unitful`](@ref)."""
get_rating_b(value::TransformerWinding, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating_b), Val(:mva), units))
"""Get [`TransformerWinding`](@ref) `rating_b` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_rating_b`](@ref)."""
get_rating_b_unitful(value::TransformerWinding, units) = get_value(value, Val(:rating_b), Val(:mva), units)
InfrastructureSystems.display_units_arg(::typeof(get_rating_b), ::Type{TransformerWinding}) = InfrastructureSystems.DU
InfrastructureSystems.display_units_arg(::typeof(get_rating_b_unitful), ::Type{TransformerWinding}) = InfrastructureSystems.DU
"""Get [`TransformerWinding`](@ref) `rating_c` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_rating_c_unitful`](@ref)."""
get_rating_c(value::TransformerWinding, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating_c), Val(:mva), units))
"""Get [`TransformerWinding`](@ref) `rating_c` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_rating_c`](@ref)."""
get_rating_c_unitful(value::TransformerWinding, units) = get_value(value, Val(:rating_c), Val(:mva), units)
InfrastructureSystems.display_units_arg(::typeof(get_rating_c), ::Type{TransformerWinding}) = InfrastructureSystems.DU
InfrastructureSystems.display_units_arg(::typeof(get_rating_c_unitful), ::Type{TransformerWinding}) = InfrastructureSystems.DU
"""Get [`TransformerWinding`](@ref) `active_power_flow` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_active_power_flow_unitful`](@ref)."""
get_active_power_flow(value::TransformerWinding, units) = InfrastructureSystems._strip_units(get_value(value, Val(:active_power_flow), Val(:mva), units))
"""Get [`TransformerWinding`](@ref) `active_power_flow` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_active_power_flow`](@ref)."""
get_active_power_flow_unitful(value::TransformerWinding, units) = get_value(value, Val(:active_power_flow), Val(:mva), units)
InfrastructureSystems.display_units_arg(::typeof(get_active_power_flow), ::Type{TransformerWinding}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_active_power_flow_unitful), ::Type{TransformerWinding}) = InfrastructureSystems.SU
"""Get [`TransformerWinding`](@ref) `reactive_power_flow` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_reactive_power_flow_unitful`](@ref)."""
get_reactive_power_flow(value::TransformerWinding, units) = InfrastructureSystems._strip_units(get_value(value, Val(:reactive_power_flow), Val(:mva), units))
"""Get [`TransformerWinding`](@ref) `reactive_power_flow` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_reactive_power_flow`](@ref)."""
get_reactive_power_flow_unitful(value::TransformerWinding, units) = get_value(value, Val(:reactive_power_flow), Val(:mva), units)
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_flow), ::Type{TransformerWinding}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_flow_unitful), ::Type{TransformerWinding}) = InfrastructureSystems.SU
"""Get [`TransformerWinding`](@ref) `base_power`."""
get_base_power(value::TransformerWinding) = value.base_power
"""Get [`TransformerWinding`](@ref) `base_voltage`."""
get_base_voltage(value::TransformerWinding) = value.base_voltage

_get_units_info(value::TransformerWinding) = value.units_info

"""Set [`TransformerWinding`](@ref) `arc`."""
set_arc!(value::TransformerWinding, val) = value.arc = val
"""Set [`TransformerWinding`](@ref) `tap`."""
set_tap!(value::TransformerWinding, val) = value.tap = val
"""Set [`TransformerWinding`](@ref) `α`."""
set_α!(value::TransformerWinding, val) = value.α = val
"""Set [`TransformerWinding`](@ref) `winding_group_number`."""
set_winding_group_number!(value::TransformerWinding, val) = value.winding_group_number = val
"""Set [`TransformerWinding`](@ref) `control`."""
set_control!(value::TransformerWinding, val) = value.control = val
"""Set [`TransformerWinding`](@ref) `available`."""
set_available!(value::TransformerWinding, val) = value.available = val
"""Set [`TransformerWinding`](@ref) `rating`."""
set_rating!(value::TransformerWinding, val) = value.rating = set_value(value, Val(:rating), val, Val(:mva))
"""Set [`TransformerWinding`](@ref) `rating_b`."""
set_rating_b!(value::TransformerWinding, val) = value.rating_b = set_value(value, Val(:rating_b), val, Val(:mva))
"""Set [`TransformerWinding`](@ref) `rating_c`."""
set_rating_c!(value::TransformerWinding, val) = value.rating_c = set_value(value, Val(:rating_c), val, Val(:mva))
"""Set [`TransformerWinding`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TransformerWinding, val) = value.active_power_flow = set_value(value, Val(:active_power_flow), val, Val(:mva))
"""Set [`TransformerWinding`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::TransformerWinding, val) = value.reactive_power_flow = set_value(value, Val(:reactive_power_flow), val, Val(:mva))
"""Set [`TransformerWinding`](@ref) `base_power`."""
set_base_power!(value::TransformerWinding, val) = value.base_power = val
"""Set [`TransformerWinding`](@ref) `base_voltage`."""
set_base_voltage!(value::TransformerWinding, val) = value.base_voltage = val
