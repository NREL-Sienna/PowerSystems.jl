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

# ── OpenAPI converters ───────────────────────────────────────────────────────────
# `Substation` has no descriptor entry (no PSY struct field list for codegen to read), so
# there is no generated file to append a converter to — same situation as
# `EmissionsData`/`GeographicInfo`, whose hand-written converters normally live in
# src/openapi/import_document.jl / export_document.jl next to the `attribute_type` dispatch
# table and the supplemental-attribute export walk. Those two files are owned by a
# concurrent session this pass, so the converters are defined here instead — this file is
# included late enough (after `PO`/`PC` are aliased and after every other openapi/*.jl
# machinery) for both directions to resolve, and Julia dispatch does not care which file a
# method lives in. Needs wiring, reported separately rather than done here:
#   import_document.jl `attribute_type` dispatch: "Substation" => from_openapi(Substation, po)
#   export_document.jl supplemental-attribute walk: to_openapi(attr::Substation, id)
# No unit conversion (`grounding_resistance` is plain ohms, no `needs_conversion`) and no
# `refs` dependency on either side (no component references on the struct).

from_openapi(::Type{Substation}, po::PO.Substation) = Substation(;
    name = po.name,
    number = po.number,
    grounding_resistance = po.grounding_resistance,
)

to_openapi(attr::Substation, id::Int) = PO.Substation(;
    id = id,
    name = get_name(attr),
    number = get_number(attr),
    grounding_resistance = get_grounding_resistance(attr),
)
