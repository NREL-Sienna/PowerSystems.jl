#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TwoWindingTransformer <: ACTransmission
        name::String
        winding::TransformerWinding
        r::Float64
        x::Float64
        magnetizing_shunt::Complex{Float64}
        base_power::Float64
        base_voltage_secondary::Union{Nothing, Float64}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A two-winding transformer connecting two buses.

The modeled arc, tap, phase shift, ratings, per-winding base power, base voltage, and control all live on the single [`TransformerWinding`](@ref) obtained with [`get_winding`](@ref); availability is winding-level (see [`get_available`](@ref)). `r`/`x` are the series impedance and `magnetizing_shunt` the magnetizing shunt admittance, both in pu on `base_power` referenced to the primary (winding) base voltage. The model uses an equivalent circuit assuming the impedance is on the high-voltage side and allocates iron losses and magnetizing susceptance to the primary side. The parent `base_power` and the winding's `base_power` are expected to be equal; parsers are responsible for maintaining this invariant, and `check_rating_values` assumes it holds.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `winding::TransformerWinding`: The [`TransformerWinding`](@ref) carrying this transformer's arc, tap, phase shift, ratings, per-winding base power/voltage, availability, and control
- `r::Float64`: Resistance in pu (device base on `base_power`), referenced to the primary (winding) base voltage, validation range: `(-2, 4)`
- `x::Float64`: Reactance in pu (device base on `base_power`), referenced to the primary (winding) base voltage, validation range: `(-2, 4)`
- `magnetizing_shunt::Complex{Float64}`: Magnetizing shunt admittance in pu (device base on `base_power`), referenced to the primary (winding) base voltage
- `base_power::Float64`: Base power (MVA) for [per unitization](@ref per_unit), validation range: `(0.0001, nothing)`
- `base_voltage_secondary::Union{Nothing, Float64}`: (default: `get_base_voltage(get_to(get_arc(winding)))`) Secondary base voltage in kV, validation range: `(0, nothing)`
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct TwoWindingTransformer <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "The [`TransformerWinding`](@ref) carrying this transformer's arc, tap, phase shift, ratings, per-winding base power/voltage, availability, and control"
    winding::TransformerWinding
    "Resistance in pu (device base on `base_power`), referenced to the primary (winding) base voltage"
    r::Float64
    "Reactance in pu (device base on `base_power`), referenced to the primary (winding) base voltage"
    x::Float64
    "Magnetizing shunt admittance in pu (device base on `base_power`), referenced to the primary (winding) base voltage"
    magnetizing_shunt::Complex{Float64}
    "Base power (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "Secondary base voltage in kV"
    base_voltage_secondary::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function TwoWindingTransformer(name, winding, r, x, magnetizing_shunt, base_power, base_voltage_secondary=get_base_voltage(get_to(get_arc(winding))), services=Device[], ext=Dict{String, Any}(), )
    TwoWindingTransformer(name, winding, r, x, magnetizing_shunt, base_power, base_voltage_secondary, services, ext, InfrastructureSystemsInternal(), )
end

function TwoWindingTransformer(; name, winding, r, x, magnetizing_shunt, base_power, base_voltage_secondary=get_base_voltage(get_to(get_arc(winding))), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TwoWindingTransformer(name, winding, r, x, magnetizing_shunt, base_power, base_voltage_secondary, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function TwoWindingTransformer(::Nothing)
    TwoWindingTransformer(;
        name="init",
        winding=TransformerWinding(nothing),
        r=0.0,
        x=0.0,
        magnetizing_shunt=0.0,
        base_power=100.0,
        base_voltage_secondary=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`TwoWindingTransformer`](@ref) `name`."""
get_name(value::TwoWindingTransformer) = value.name
"""Get [`TwoWindingTransformer`](@ref) `winding`."""
get_winding(value::TwoWindingTransformer) = value.winding
"""Get [`TwoWindingTransformer`](@ref) `r` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_r_unitful`](@ref)."""
get_r(value::TwoWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:r), Val(:ohm), units))
"""Get [`TwoWindingTransformer`](@ref) `r` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_r`](@ref)."""
get_r_unitful(value::TwoWindingTransformer, units) = get_value(value, Val(:r), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_r), ::Type{TwoWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_r_unitful), ::Type{TwoWindingTransformer}) = InfrastructureSystems.SU
"""Get [`TwoWindingTransformer`](@ref) `x` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_x_unitful`](@ref)."""
get_x(value::TwoWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:x), Val(:ohm), units))
"""Get [`TwoWindingTransformer`](@ref) `x` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_x`](@ref)."""
get_x_unitful(value::TwoWindingTransformer, units) = get_value(value, Val(:x), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_x), ::Type{TwoWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_x_unitful), ::Type{TwoWindingTransformer}) = InfrastructureSystems.SU
"""Get [`TwoWindingTransformer`](@ref) `magnetizing_shunt` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_magnetizing_shunt_unitful`](@ref)."""
get_magnetizing_shunt(value::TwoWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:magnetizing_shunt), Val(:siemens), units))
"""Get [`TwoWindingTransformer`](@ref) `magnetizing_shunt` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_magnetizing_shunt`](@ref)."""
get_magnetizing_shunt_unitful(value::TwoWindingTransformer, units) = get_value(value, Val(:magnetizing_shunt), Val(:siemens), units)
InfrastructureSystems.display_units_arg(::typeof(get_magnetizing_shunt), ::Type{TwoWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_magnetizing_shunt_unitful), ::Type{TwoWindingTransformer}) = InfrastructureSystems.SU

_get_base_power(value::TwoWindingTransformer) = value.base_power
"""Get [`TwoWindingTransformer`](@ref) `base_voltage_secondary`."""
get_base_voltage_secondary(value::TwoWindingTransformer) = value.base_voltage_secondary
"""Get [`TwoWindingTransformer`](@ref) `services`."""
get_services(value::TwoWindingTransformer) = value.services
"""Get [`TwoWindingTransformer`](@ref) `ext`."""
get_ext(value::TwoWindingTransformer) = value.ext
"""Get [`TwoWindingTransformer`](@ref) `internal`."""
get_internal(value::TwoWindingTransformer) = value.internal

"""Set [`TwoWindingTransformer`](@ref) `r`."""
set_r!(value::TwoWindingTransformer, val) = value.r = set_value(value, Val(:r), val, Val(:ohm))
"""Set [`TwoWindingTransformer`](@ref) `x`."""
set_x!(value::TwoWindingTransformer, val) = value.x = set_value(value, Val(:x), val, Val(:ohm))
"""Set [`TwoWindingTransformer`](@ref) `magnetizing_shunt`."""
set_magnetizing_shunt!(value::TwoWindingTransformer, val) = value.magnetizing_shunt = set_value(value, Val(:magnetizing_shunt), val, Val(:siemens))
"""Set [`TwoWindingTransformer`](@ref) `base_voltage_secondary`."""
set_base_voltage_secondary!(value::TwoWindingTransformer, val) = value.base_voltage_secondary = val
"""Set [`TwoWindingTransformer`](@ref) `services`."""
set_services!(value::TwoWindingTransformer, val) = value.services = val
"""Set [`TwoWindingTransformer`](@ref) `ext`."""
set_ext!(value::TwoWindingTransformer, val) = value.ext = val
