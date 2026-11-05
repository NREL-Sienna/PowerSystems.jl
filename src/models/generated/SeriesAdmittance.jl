#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SeriesAdmittance <: ACTransmission
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        rating::Float64
        bypassed::Bool
        rating_b::Union{Nothing, Float64}
        rating_c::Union{Nothing, Float64}
        services::Vector{Service}
        base_power::Float64
        operational_flow_limit::Union{Nothing, OperationalFlowLimit}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A fixed series admittance on an [`Arc`](@ref): a series capacitor or reactor, or an AC line without charging susceptance, with constant `r` and `x` (the CIM `SeriesCompensator`). Out of service is `available = false`; a bypassed device (`bypassed = true`) is shorted into a zero-impedance tie

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow through the device (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow through the device (MVAR)
- `arc::Arc`: An [`Arc`](@ref) defining this device `from` a bus `to` another bus
- `r::Float64`: Resistance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 4)`
- `x::Float64`: Series reactance in pu ([`SYSTEM_BASE`](@ref per_unit)); negative for a capacitor, validation range: `(-4, 4)`
- `rating::Float64`: Thermal rating (MVA). Flow through the device must be between -`rating` and `rating`. When defining a device before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to. Displays in component base ([`DEVICE_BASE`](@ref per_unit)) by default, unlike most converted fields which default to system base
- `bypassed::Bool`: (default: `false`) Whether the device is bypassed: shorted into a zero-impedance tie between the `from` and `to` buses. `r` and `x` keep the impedance it has when in service
- `rating_b::Union{Nothing, Float64}`: (default: `nothing`) Second current rating; entered in MVA.
- `rating_c::Union{Nothing, Float64}`: (default: `nothing`) Third current rating; entered in MVA.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `base_power::Float64`: (default: `100.0`) System base power for per-unitization of this component's per-unit fields, recorded per component in lieu of a system-level table (MVA), validation range: `(0.0001, nothing)`
- `operational_flow_limit::Union{Nothing, OperationalFlowLimit}`: (default: `nothing`) Operator-set minimum and maximum flow (MW) in each direction, `from_to` and `to_from`, applied in addition to `rating`. `nothing` means no operational limit
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
- `input_basis`: (keyword constructor only, required) `u"CU"` or `u"NU"`, the units of bare numbers on unit-bearing fields. Tagged values (`50.0u"MW"`) keep their own units
"""
mutable struct SeriesAdmittance <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flow through the device (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow through the device (MVAR)"
    reactive_power_flow::Float64
    "An [`Arc`](@ref) defining this device `from` a bus `to` another bus"
    arc::Arc
    "Resistance in pu ([`SYSTEM_BASE`](@ref per_unit))"
    r::Float64
    "Series reactance in pu ([`SYSTEM_BASE`](@ref per_unit)); negative for a capacitor"
    x::Float64
    "Thermal rating (MVA). Flow through the device must be between -`rating` and `rating`. When defining a device before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to. Displays in component base ([`DEVICE_BASE`](@ref per_unit)) by default, unlike most converted fields which default to system base"
    rating::Float64
    "Whether the device is bypassed: shorted into a zero-impedance tie between the `from` and `to` buses. `r` and `x` keep the impedance it has when in service"
    bypassed::Bool
    "Second current rating; entered in MVA."
    rating_b::Union{Nothing, Float64}
    "Third current rating; entered in MVA."
    rating_c::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    "System base power for per-unitization of this component's per-unit fields, recorded per component in lieu of a system-level table (MVA)"
    base_power::Float64
    "Operator-set minimum and maximum flow (MW) in each direction, `from_to` and `to_from`, applied in addition to `rating`. `nothing` means no operational limit"
    operational_flow_limit::Union{Nothing, OperationalFlowLimit}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function SeriesAdmittance(name, available, active_power_flow, reactive_power_flow, arc, r, x, rating, bypassed=false, rating_b=nothing, rating_c=nothing, services=Device[], base_power=100.0, operational_flow_limit=nothing, ext=Dict{String, Any}(), )
    SeriesAdmittance(name, available, active_power_flow, reactive_power_flow, arc, r, x, rating, bypassed, rating_b, rating_c, services, base_power, operational_flow_limit, ext, InfrastructureSystemsInternal(), )
end

function SeriesAdmittance(; name, available, active_power_flow, reactive_power_flow, arc, r, x, rating, bypassed=false, rating_b=nothing, rating_c=nothing, services=Device[], base_power=100.0, operational_flow_limit=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), input_basis::Unitful.Units, )
    value = SeriesAdmittance(name, available, _placeholder(active_power_flow), _placeholder(reactive_power_flow), arc, _placeholder(r), _placeholder(x), _placeholder(rating), bypassed, _placeholder(rating_b), _placeholder(rating_c), services, base_power, _placeholder(operational_flow_limit), ext, internal, )
    set_active_power_flow!(value, _tag(active_power_flow, input_basis, Val(:mw)))
    set_reactive_power_flow!(value, _tag(reactive_power_flow, input_basis, Val(:mvar)))
    set_r!(value, _tag(r, input_basis, Val(:ohm)))
    set_x!(value, _tag(x, input_basis, Val(:ohm)))
    set_rating!(value, _tag(rating, input_basis, Val(:mva)))
    set_rating_b!(value, _tag(rating_b, input_basis, Val(:mva)))
    set_rating_c!(value, _tag(rating_c, input_basis, Val(:mva)))
    set_operational_flow_limit!(value, _tag(operational_flow_limit, input_basis, Val(:mw)))
    return value
end
_takes_input_basis(::Type{<:SeriesAdmittance}) = true

# Constructor for demo purposes; non-functional.
function SeriesAdmittance(::Nothing)
    SeriesAdmittance(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        rating=0.0,
        bypassed=false,
        rating_b=0.0,
        rating_c=0.0,
        services=Device[],
        base_power=100.0,
        operational_flow_limit=nothing,
        ext=Dict{String, Any}(),
        input_basis=u"CU",
    )
end

"""Get [`SeriesAdmittance`](@ref) `name`."""
get_name(value::SeriesAdmittance) = value.name
"""Get [`SeriesAdmittance`](@ref) `available`."""
get_available(value::SeriesAdmittance) = value.available
"""Get [`SeriesAdmittance`](@ref) `active_power_flow` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_active_power_flow_unitful`](@ref)."""
get_active_power_flow(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:active_power_flow), Val(:mw), units))
"""Get [`SeriesAdmittance`](@ref) `active_power_flow` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_active_power_flow`](@ref)."""
get_active_power_flow_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:active_power_flow), Val(:mw), units)
get_active_power_flow(value::SeriesAdmittance) = _units_arg_required(get_active_power_flow, value, :active_power_flow, Val(:mw))
get_active_power_flow_unitful(value::SeriesAdmittance) = _units_arg_required(get_active_power_flow_unitful, value, :active_power_flow, Val(:mw))
InfrastructureSystems.display_units_arg(::typeof(get_active_power_flow), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_active_power_flow_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `reactive_power_flow` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_reactive_power_flow_unitful`](@ref)."""
get_reactive_power_flow(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:reactive_power_flow), Val(:mvar), units))
"""Get [`SeriesAdmittance`](@ref) `reactive_power_flow` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_reactive_power_flow`](@ref)."""
get_reactive_power_flow_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:reactive_power_flow), Val(:mvar), units)
get_reactive_power_flow(value::SeriesAdmittance) = _units_arg_required(get_reactive_power_flow, value, :reactive_power_flow, Val(:mvar))
get_reactive_power_flow_unitful(value::SeriesAdmittance) = _units_arg_required(get_reactive_power_flow_unitful, value, :reactive_power_flow, Val(:mvar))
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_flow), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_reactive_power_flow_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `arc`."""
get_arc(value::SeriesAdmittance) = value.arc
"""Get [`SeriesAdmittance`](@ref) `r` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_r_unitful`](@ref)."""
get_r(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:r), Val(:ohm), units))
"""Get [`SeriesAdmittance`](@ref) `r` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_r`](@ref)."""
get_r_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:r), Val(:ohm), units)
get_r(value::SeriesAdmittance) = _units_arg_required(get_r, value, :r, Val(:ohm))
get_r_unitful(value::SeriesAdmittance) = _units_arg_required(get_r_unitful, value, :r, Val(:ohm))
InfrastructureSystems.display_units_arg(::typeof(get_r), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_r_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `x` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_x_unitful`](@ref)."""
get_x(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:x), Val(:ohm), units))
"""Get [`SeriesAdmittance`](@ref) `x` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_x`](@ref)."""
get_x_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:x), Val(:ohm), units)
get_x(value::SeriesAdmittance) = _units_arg_required(get_x, value, :x, Val(:ohm))
get_x_unitful(value::SeriesAdmittance) = _units_arg_required(get_x_unitful, value, :x, Val(:ohm))
InfrastructureSystems.display_units_arg(::typeof(get_x), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_x_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `rating` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_rating_unitful`](@ref)."""
get_rating(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating), Val(:mva), units))
"""Get [`SeriesAdmittance`](@ref) `rating` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_rating`](@ref)."""
get_rating_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:rating), Val(:mva), units)
get_rating(value::SeriesAdmittance) = _units_arg_required(get_rating, value, :rating, Val(:mva))
get_rating_unitful(value::SeriesAdmittance) = _units_arg_required(get_rating_unitful, value, :rating, Val(:mva))
InfrastructureSystems.display_units_arg(::typeof(get_rating), ::Type{SeriesAdmittance}) = u"CU"
InfrastructureSystems.display_units_arg(::typeof(get_rating_unitful), ::Type{SeriesAdmittance}) = u"CU"
"""Get [`SeriesAdmittance`](@ref) `bypassed`."""
get_bypassed(value::SeriesAdmittance) = value.bypassed
"""Get [`SeriesAdmittance`](@ref) `rating_b` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_rating_b_unitful`](@ref)."""
get_rating_b(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating_b), Val(:mva), units))
"""Get [`SeriesAdmittance`](@ref) `rating_b` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_rating_b`](@ref)."""
get_rating_b_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:rating_b), Val(:mva), units)
get_rating_b(value::SeriesAdmittance) = _units_arg_required(get_rating_b, value, :rating_b, Val(:mva))
get_rating_b_unitful(value::SeriesAdmittance) = _units_arg_required(get_rating_b_unitful, value, :rating_b, Val(:mva))
InfrastructureSystems.display_units_arg(::typeof(get_rating_b), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_rating_b_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `rating_c` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_rating_c_unitful`](@ref)."""
get_rating_c(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:rating_c), Val(:mva), units))
"""Get [`SeriesAdmittance`](@ref) `rating_c` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_rating_c`](@ref)."""
get_rating_c_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:rating_c), Val(:mva), units)
get_rating_c(value::SeriesAdmittance) = _units_arg_required(get_rating_c, value, :rating_c, Val(:mva))
get_rating_c_unitful(value::SeriesAdmittance) = _units_arg_required(get_rating_c_unitful, value, :rating_c, Val(:mva))
InfrastructureSystems.display_units_arg(::typeof(get_rating_c), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_rating_c_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `services`."""
get_services(value::SeriesAdmittance) = value.services

_get_base_power(value::SeriesAdmittance) = value.base_power
"""Get [`SeriesAdmittance`](@ref) `operational_flow_limit` as a bare number in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"NU"`, `u"MW"`). For the unit-bearing value see [`get_operational_flow_limit_unitful`](@ref)."""
get_operational_flow_limit(value::SeriesAdmittance, units) = InfrastructureSystems._strip_units(get_value(value, Val(:operational_flow_limit), Val(:mw), units))
"""Get [`SeriesAdmittance`](@ref) `operational_flow_limit` as a unit-bearing quantity in the requested `units` (e.g. `u"SU"`, `u"CU"`, `u"MW"`). For a bare number see [`get_operational_flow_limit`](@ref)."""
get_operational_flow_limit_unitful(value::SeriesAdmittance, units) = get_value(value, Val(:operational_flow_limit), Val(:mw), units)
get_operational_flow_limit(value::SeriesAdmittance) = _units_arg_required(get_operational_flow_limit, value, :operational_flow_limit, Val(:mw))
get_operational_flow_limit_unitful(value::SeriesAdmittance) = _units_arg_required(get_operational_flow_limit_unitful, value, :operational_flow_limit, Val(:mw))
InfrastructureSystems.display_units_arg(::typeof(get_operational_flow_limit), ::Type{SeriesAdmittance}) = u"SU"
InfrastructureSystems.display_units_arg(::typeof(get_operational_flow_limit_unitful), ::Type{SeriesAdmittance}) = u"SU"
"""Get [`SeriesAdmittance`](@ref) `ext`."""
get_ext(value::SeriesAdmittance) = value.ext
"""Get [`SeriesAdmittance`](@ref) `internal`."""
get_internal(value::SeriesAdmittance) = value.internal

"""Set [`SeriesAdmittance`](@ref) `available`."""
set_available!(value::SeriesAdmittance, val) = value.available = val
"""Set [`SeriesAdmittance`](@ref) `active_power_flow`."""
set_active_power_flow!(value::SeriesAdmittance, val) = value.active_power_flow = set_value(value, Val(:active_power_flow), val, Val(:mw))
set_active_power_flow!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_active_power_flow!, value, :active_power_flow, Val(:mw), val)
"""Set [`SeriesAdmittance`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::SeriesAdmittance, val) = value.reactive_power_flow = set_value(value, Val(:reactive_power_flow), val, Val(:mvar))
set_reactive_power_flow!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_reactive_power_flow!, value, :reactive_power_flow, Val(:mvar), val)
"""Set [`SeriesAdmittance`](@ref) `arc`."""
set_arc!(value::SeriesAdmittance, val) = value.arc = val
"""Set [`SeriesAdmittance`](@ref) `r`."""
set_r!(value::SeriesAdmittance, val) = value.r = set_value(value, Val(:r), val, Val(:ohm))
set_r!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_r!, value, :r, Val(:ohm), val)
"""Set [`SeriesAdmittance`](@ref) `x`."""
set_x!(value::SeriesAdmittance, val) = value.x = set_value(value, Val(:x), val, Val(:ohm))
set_x!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_x!, value, :x, Val(:ohm), val)
"""Set [`SeriesAdmittance`](@ref) `rating`."""
set_rating!(value::SeriesAdmittance, val) = value.rating = set_value(value, Val(:rating), val, Val(:mva))
set_rating!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_rating!, value, :rating, Val(:mva), val)
"""Set [`SeriesAdmittance`](@ref) `bypassed`."""
set_bypassed!(value::SeriesAdmittance, val) = value.bypassed = val
"""Set [`SeriesAdmittance`](@ref) `rating_b`."""
set_rating_b!(value::SeriesAdmittance, val) = value.rating_b = set_value(value, Val(:rating_b), val, Val(:mva))
set_rating_b!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_rating_b!, value, :rating_b, Val(:mva), val)
"""Set [`SeriesAdmittance`](@ref) `rating_c`."""
set_rating_c!(value::SeriesAdmittance, val) = value.rating_c = set_value(value, Val(:rating_c), val, Val(:mva))
set_rating_c!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_rating_c!, value, :rating_c, Val(:mva), val)
"""Set [`SeriesAdmittance`](@ref) `services`."""
set_services!(value::SeriesAdmittance, val) = value.services = val
"""Set [`SeriesAdmittance`](@ref) `operational_flow_limit`."""
set_operational_flow_limit!(value::SeriesAdmittance, val) = value.operational_flow_limit = set_value(value, Val(:operational_flow_limit), val, Val(:mw))
set_operational_flow_limit!(value::SeriesAdmittance, val::_UntaggedNumber) = _units_tag_required(set_operational_flow_limit!, value, :operational_flow_limit, Val(:mw), val)
"""Set [`SeriesAdmittance`](@ref) `ext`."""
set_ext!(value::SeriesAdmittance, val) = value.ext = val
