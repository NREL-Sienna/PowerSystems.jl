"""
Attribute to represent a substation that groups node [`ACBus`](@ref) components and
[`DiscreteControlledACBranch`](@ref) switching devices of a full-topology
(node-breaker) network model. Attach the attribute to every member component.

Geospatial data is not stored here; attach a [`GeographicInfo`](@ref) attribute
to the member components instead.

# Arguments
- `name::String`: Name of the substation
- `number::Int`: Substation number in the source power flow data
- `grounding_resistance::Float64`: Substation grounding DC resistance in ohms
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems internal reference
"""
struct Substation <: SupplementalAttribute
    name::String
    number::Int
    grounding_resistance::Float64
    internal::InfrastructureSystemsInternal
end

"""
    Substation(; name, number, grounding_resistance, internal)

Construct a [`Substation`](@ref).

# Arguments
- `name::String`: Name of the substation
- `number::Int`: Substation number in the source power flow data
- `grounding_resistance::Float64`: (default: 0.1) Substation grounding DC resistance in ohms
- `internal::InfrastructureSystemsInternal`: (default: `InfrastructureSystemsInternal()`) (**Do not modify.**) PowerSystems internal reference
"""
function Substation(;
    name::String,
    number::Int,
    grounding_resistance::Float64 = 0.1,
    internal::InfrastructureSystemsInternal = InfrastructureSystemsInternal(),
)
    return Substation(name, number, grounding_resistance, internal)
end

"""Get [`Substation`](@ref) `name`."""
get_name(value::Substation) = value.name
"""Get [`Substation`](@ref) `number`."""
get_number(value::Substation) = value.number
"""Get [`Substation`](@ref) `grounding_resistance`."""
get_grounding_resistance(value::Substation) = value.grounding_resistance
"""Get [`Substation`](@ref) `internal`."""
get_internal(value::Substation) = value.internal

# `Substation` has no descriptor entry, so both OpenAPI directions are hand-written here,
# in the same supplemental-attribute converter shape as src/openapi/import_document.jl /
# export_document.jl: value-dispatched, `refs` in both directions, id via `component_id`.

from_openapi(po::PO.Substation, ::OpenAPIRefs) = Substation(;
    name = po.name,
    number = po.number,
    grounding_resistance = po.grounding_resistance,
)

to_openapi(attr::Substation, refs::OpenAPIRefs) = PO.Substation(;
    id = component_id(refs, attr),
    name = get_name(attr),
    number = get_number(attr),
    grounding_resistance = get_grounding_resistance(attr),
)
