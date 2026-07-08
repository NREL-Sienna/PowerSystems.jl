#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ThreeWindingTransformer <: ACTransmission
        name::String
        primary_winding::TransformerWinding
        secondary_winding::TransformerWinding
        tertiary_winding::TransformerWinding
        star_bus::ACBus
        r_12::Float64
        x_12::Float64
        r_23::Float64
        x_23::Float64
        r_13::Float64
        x_13::Float64
        base_power_12::Float64
        base_power_23::Float64
        base_power_13::Float64
        magnetizing_shunt::Complex{Float64}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A three-winding transformer.

The model uses an equivalent star model with a star (hidden) bus. Each of the three [`TransformerWinding`](@ref) objects ([`get_primary_winding`](@ref), [`get_secondary_winding`](@ref), [`get_tertiary_winding`](@ref)) connects a terminal bus to the star bus and carries its own arc, tap, phase shift, ratings, per-winding base power/voltage, availability, and control. The pairwise measured impedances `r_12`/`x_12`, `r_23`/`x_23`, `r_13`/`x_13` are the only stored impedance representation; the individual star-leg impedances are derived downstream from them. Each pairwise impedance (and `magnetizing_shunt`) is in pu (device base) on the corresponding `base_power_12`/`base_power_23`/`base_power_13`, referenced to the FIRST-INDEX winding's base voltage: `r_12`/`x_12` and `magnetizing_shunt` to the primary winding's base voltage, `r_23`/`x_23` to the secondary winding's base voltage, and `r_13`/`x_13` to the primary winding's base voltage (PSS/E CZ = 1). Availability is winding-level (see [`get_available`](@ref)). The model is described in Chapter 3.6 of J.D. Glover, M.S. Sarma and T. Overbye: Power Systems Analysis and Design.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `primary_winding::TransformerWinding`: The primary [`TransformerWinding`](@ref) connecting the primary bus to the star bus
- `secondary_winding::TransformerWinding`: The secondary [`TransformerWinding`](@ref) connecting the secondary bus to the star bus
- `tertiary_winding::TransformerWinding`: The tertiary [`TransformerWinding`](@ref) connecting the tertiary bus to the star bus
- `star_bus::ACBus`: Star (hidden) Bus that this component (equivalent model) is connected to
- `r_12::Float64`: Measured resistance in pu (device base on `base_power_12`), referenced to the primary winding's base voltage, from primary to secondary windings (R1-2 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `x_12::Float64`: Measured reactance in pu (device base on `base_power_12`), referenced to the primary winding's base voltage, from primary to secondary windings (X1-2 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `r_23::Float64`: Measured resistance in pu (device base on `base_power_23`), referenced to the secondary winding's base voltage, from secondary to tertiary windings (R2-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `x_23::Float64`: Measured reactance in pu (device base on `base_power_23`), referenced to the secondary winding's base voltage, from secondary to tertiary windings (X2-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `r_13::Float64`: Measured resistance in pu (device base on `base_power_13`), referenced to the primary winding's base voltage, from primary to tertiary windings (R1-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `x_13::Float64`: Measured reactance in pu (device base on `base_power_13`), referenced to the primary winding's base voltage, from primary to tertiary windings (X1-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `base_power_12::Float64`: Base power (MVA) for [per unitization](@ref per_unit) for primary-secondary windings., validation range: `(0.0001, nothing)`
- `base_power_23::Float64`: Base power (MVA) for [per unitization](@ref per_unit) for secondary-tertiary windings., validation range: `(0.0001, nothing)`
- `base_power_13::Float64`: Base power (MVA) for [per unitization](@ref per_unit) for primary-tertiary windings., validation range: `(0.0001, nothing)`
- `magnetizing_shunt::Complex{Float64}`: Magnetizing shunt admittance in pu (device base on `base_power_12`), referenced to the primary winding's base voltage, from star (hidden) bus to ground
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct ThreeWindingTransformer <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "The primary [`TransformerWinding`](@ref) connecting the primary bus to the star bus"
    primary_winding::TransformerWinding
    "The secondary [`TransformerWinding`](@ref) connecting the secondary bus to the star bus"
    secondary_winding::TransformerWinding
    "The tertiary [`TransformerWinding`](@ref) connecting the tertiary bus to the star bus"
    tertiary_winding::TransformerWinding
    "Star (hidden) Bus that this component (equivalent model) is connected to"
    star_bus::ACBus
    "Measured resistance in pu (device base on `base_power_12`), referenced to the primary winding's base voltage, from primary to secondary windings (R1-2 with CZ = 1 in PSS/E)."
    r_12::Float64
    "Measured reactance in pu (device base on `base_power_12`), referenced to the primary winding's base voltage, from primary to secondary windings (X1-2 with CZ = 1 in PSS/E)."
    x_12::Float64
    "Measured resistance in pu (device base on `base_power_23`), referenced to the secondary winding's base voltage, from secondary to tertiary windings (R2-3 with CZ = 1 in PSS/E)."
    r_23::Float64
    "Measured reactance in pu (device base on `base_power_23`), referenced to the secondary winding's base voltage, from secondary to tertiary windings (X2-3 with CZ = 1 in PSS/E)."
    x_23::Float64
    "Measured resistance in pu (device base on `base_power_13`), referenced to the primary winding's base voltage, from primary to tertiary windings (R1-3 with CZ = 1 in PSS/E)."
    r_13::Float64
    "Measured reactance in pu (device base on `base_power_13`), referenced to the primary winding's base voltage, from primary to tertiary windings (X1-3 with CZ = 1 in PSS/E)."
    x_13::Float64
    "Base power (MVA) for [per unitization](@ref per_unit) for primary-secondary windings."
    base_power_12::Float64
    "Base power (MVA) for [per unitization](@ref per_unit) for secondary-tertiary windings."
    base_power_23::Float64
    "Base power (MVA) for [per unitization](@ref per_unit) for primary-tertiary windings."
    base_power_13::Float64
    "Magnetizing shunt admittance in pu (device base on `base_power_12`), referenced to the primary winding's base voltage, from star (hidden) bus to ground"
    magnetizing_shunt::Complex{Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function ThreeWindingTransformer(name, primary_winding, secondary_winding, tertiary_winding, star_bus, r_12, x_12, r_23, x_23, r_13, x_13, base_power_12, base_power_23, base_power_13, magnetizing_shunt, services=Device[], ext=Dict{String, Any}(), )
    ThreeWindingTransformer(name, primary_winding, secondary_winding, tertiary_winding, star_bus, r_12, x_12, r_23, x_23, r_13, x_13, base_power_12, base_power_23, base_power_13, magnetizing_shunt, services, ext, InfrastructureSystemsInternal(), )
end

function ThreeWindingTransformer(; name, primary_winding, secondary_winding, tertiary_winding, star_bus, r_12, x_12, r_23, x_23, r_13, x_13, base_power_12, base_power_23, base_power_13, magnetizing_shunt, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    ThreeWindingTransformer(name, primary_winding, secondary_winding, tertiary_winding, star_bus, r_12, x_12, r_23, x_23, r_13, x_13, base_power_12, base_power_23, base_power_13, magnetizing_shunt, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function ThreeWindingTransformer(::Nothing)
    ThreeWindingTransformer(;
        name="init",
        primary_winding=TransformerWinding(nothing),
        secondary_winding=TransformerWinding(nothing),
        tertiary_winding=TransformerWinding(nothing),
        star_bus=ACBus(nothing),
        r_12=0.0,
        x_12=0.0,
        r_23=0.0,
        x_23=0.0,
        r_13=0.0,
        x_13=0.0,
        base_power_12=100.0,
        base_power_23=100.0,
        base_power_13=100.0,
        magnetizing_shunt=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`ThreeWindingTransformer`](@ref) `name`."""
get_name(value::ThreeWindingTransformer) = value.name
"""Get [`ThreeWindingTransformer`](@ref) `primary_winding`."""
get_primary_winding(value::ThreeWindingTransformer) = value.primary_winding
"""Get [`ThreeWindingTransformer`](@ref) `secondary_winding`."""
get_secondary_winding(value::ThreeWindingTransformer) = value.secondary_winding
"""Get [`ThreeWindingTransformer`](@ref) `tertiary_winding`."""
get_tertiary_winding(value::ThreeWindingTransformer) = value.tertiary_winding
"""Get [`ThreeWindingTransformer`](@ref) `star_bus`."""
get_star_bus(value::ThreeWindingTransformer) = value.star_bus
"""Get [`ThreeWindingTransformer`](@ref) `r_12` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_r_12_unitful`](@ref)."""
get_r_12(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:r_12), Val(:ohm), units))
"""Get [`ThreeWindingTransformer`](@ref) `r_12` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_r_12`](@ref)."""
get_r_12_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:r_12), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_r_12), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_r_12_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
"""Get [`ThreeWindingTransformer`](@ref) `x_12` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_x_12_unitful`](@ref)."""
get_x_12(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:x_12), Val(:ohm), units))
"""Get [`ThreeWindingTransformer`](@ref) `x_12` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_x_12`](@ref)."""
get_x_12_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:x_12), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_x_12), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_x_12_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
"""Get [`ThreeWindingTransformer`](@ref) `r_23` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_r_23_unitful`](@ref)."""
get_r_23(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:r_23), Val(:ohm), units))
"""Get [`ThreeWindingTransformer`](@ref) `r_23` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_r_23`](@ref)."""
get_r_23_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:r_23), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_r_23), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_r_23_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
"""Get [`ThreeWindingTransformer`](@ref) `x_23` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_x_23_unitful`](@ref)."""
get_x_23(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:x_23), Val(:ohm), units))
"""Get [`ThreeWindingTransformer`](@ref) `x_23` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_x_23`](@ref)."""
get_x_23_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:x_23), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_x_23), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_x_23_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
"""Get [`ThreeWindingTransformer`](@ref) `r_13` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_r_13_unitful`](@ref)."""
get_r_13(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:r_13), Val(:ohm), units))
"""Get [`ThreeWindingTransformer`](@ref) `r_13` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_r_13`](@ref)."""
get_r_13_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:r_13), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_r_13), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_r_13_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
"""Get [`ThreeWindingTransformer`](@ref) `x_13` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_x_13_unitful`](@ref)."""
get_x_13(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:x_13), Val(:ohm), units))
"""Get [`ThreeWindingTransformer`](@ref) `x_13` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_x_13`](@ref)."""
get_x_13_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:x_13), Val(:ohm), units)
InfrastructureSystems.display_units_arg(::typeof(get_x_13), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_x_13_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU

_get_base_power_12(value::ThreeWindingTransformer) = value.base_power_12

_get_base_power_23(value::ThreeWindingTransformer) = value.base_power_23

_get_base_power_13(value::ThreeWindingTransformer) = value.base_power_13
"""Get [`ThreeWindingTransformer`](@ref) `magnetizing_shunt` as a bare number in the requested `units` (e.g. `SU`, `DU`; domain-provided units such as `MW` are also accepted when the owning domain package has registered a `_strip_units` method for the returned quantity type). Returns a bare number only when such a method is registered; otherwise returns the quantity wrapper. For the unit-bearing value see [`get_magnetizing_shunt_unitful`](@ref)."""
get_magnetizing_shunt(value::ThreeWindingTransformer, units) = InfrastructureSystems._strip_units(get_value(value, Val(:magnetizing_shunt), Val(:siemens), units))
"""Get [`ThreeWindingTransformer`](@ref) `magnetizing_shunt` as a unit-bearing quantity in the requested `units` (e.g. `SU`, `DU`, `MW`). For a bare number see [`get_magnetizing_shunt`](@ref)."""
get_magnetizing_shunt_unitful(value::ThreeWindingTransformer, units) = get_value(value, Val(:magnetizing_shunt), Val(:siemens), units)
InfrastructureSystems.display_units_arg(::typeof(get_magnetizing_shunt), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
InfrastructureSystems.display_units_arg(::typeof(get_magnetizing_shunt_unitful), ::Type{ThreeWindingTransformer}) = InfrastructureSystems.SU
"""Get [`ThreeWindingTransformer`](@ref) `services`."""
get_services(value::ThreeWindingTransformer) = value.services
"""Get [`ThreeWindingTransformer`](@ref) `ext`."""
get_ext(value::ThreeWindingTransformer) = value.ext
"""Get [`ThreeWindingTransformer`](@ref) `internal`."""
get_internal(value::ThreeWindingTransformer) = value.internal

"""Set [`ThreeWindingTransformer`](@ref) `star_bus`."""
set_star_bus!(value::ThreeWindingTransformer, val) = value.star_bus = val
"""Set [`ThreeWindingTransformer`](@ref) `r_12`."""
set_r_12!(value::ThreeWindingTransformer, val) = value.r_12 = set_value(value, Val(:r_12), val, Val(:ohm))
"""Set [`ThreeWindingTransformer`](@ref) `x_12`."""
set_x_12!(value::ThreeWindingTransformer, val) = value.x_12 = set_value(value, Val(:x_12), val, Val(:ohm))
"""Set [`ThreeWindingTransformer`](@ref) `r_23`."""
set_r_23!(value::ThreeWindingTransformer, val) = value.r_23 = set_value(value, Val(:r_23), val, Val(:ohm))
"""Set [`ThreeWindingTransformer`](@ref) `x_23`."""
set_x_23!(value::ThreeWindingTransformer, val) = value.x_23 = set_value(value, Val(:x_23), val, Val(:ohm))
"""Set [`ThreeWindingTransformer`](@ref) `r_13`."""
set_r_13!(value::ThreeWindingTransformer, val) = value.r_13 = set_value(value, Val(:r_13), val, Val(:ohm))
"""Set [`ThreeWindingTransformer`](@ref) `x_13`."""
set_x_13!(value::ThreeWindingTransformer, val) = value.x_13 = set_value(value, Val(:x_13), val, Val(:ohm))
"""Set [`ThreeWindingTransformer`](@ref) `magnetizing_shunt`."""
set_magnetizing_shunt!(value::ThreeWindingTransformer, val) = value.magnetizing_shunt = set_value(value, Val(:magnetizing_shunt), val, Val(:siemens))
"""Set [`ThreeWindingTransformer`](@ref) `services`."""
set_services!(value::ThreeWindingTransformer, val) = value.services = val
"""Set [`ThreeWindingTransformer`](@ref) `ext`."""
set_ext!(value::ThreeWindingTransformer, val) = value.ext = val
