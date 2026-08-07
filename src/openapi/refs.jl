# Hand-written (not generated): the resolution context and round-trip ledger the generated
# from_openapi/to_openapi methods in src/models/generated/ are appended to build on.

"""
Convert an OpenAPI-model (PO) instance of `T` into the matching PSY component or value type.

Methods are added per (PSY type, PO type) by the generated converters in
`src/models/generated/`; this generic definition exists so those methods have a function to
extend before any are generated.
"""
function from_openapi end

"""
Convert a PSY component or value into its OpenAPI-model (PO) representation.

Methods are added per PSY type by the generated converters in `src/models/generated/`; this
generic definition exists so those methods have a function to extend before any are
generated.
"""
function to_openapi end

"""
$(TYPEDEF)
$(TYPEDFIELDS)

Bidirectional id<->component resolution context for one OpenAPI document conversion, plus
the document's declared unit system.

Populated in dependency order as components are converted (buses before the branches that
reference them, etc.) An id or a component that has not been registered yet is malformed
input, not an absence to tolerate: [`Base.getindex`](@ref) and [`component_id`](@ref) error
loudly naming what was missing rather than returning `nothing`. Use [`has_ref`](@ref) /
[`has_component_id`](@ref) first when absence is itself a valid outcome to branch on.
"""
struct OpenAPIRefs
    "Id → component, populated by `setindex!` as each component is converted."
    by_id::Dict{Int, Any}
    "Component → id, the reverse of `by_id`, keyed by object identity."
    id_by_component::IdDict{Any, Int}
    "The document's declared unit system (e.g. \"NATURAL_UNITS\"), fixed for the whole document."
    unit_system::String
    "The document's system base power (MVA). Used by hand-written converters for types with
    no device-level base_power of their own (`Line`, `TwoTerminalGenericHVDCLine`, reserves) —
"
    base_power::Float64
end

function OpenAPIRefs(unit_system::AbstractString, base_power::Real = 100.0)
    return OpenAPIRefs(
        Dict{Int, Any}(), IdDict{Any, Int}(), String(unit_system), Float64(base_power),
    )
end

"""Get the document-level unit system this [`OpenAPIRefs`](@ref) was built for."""
get_unit_system(refs::OpenAPIRefs) = refs.unit_system

"""Get the document-level system base power (MVA) this [`OpenAPIRefs`](@ref) was built for."""
get_base_power(refs::OpenAPIRefs) = refs.base_power

"""
Register `component` under document `id`.

Errors when `id` is already registered — a duplicate id is malformed input, not a
last-write-wins update.
"""
function Base.setindex!(refs::OpenAPIRefs, component, id::Integer)
    key = Int(id)
    haskey(refs.by_id, key) && error(
        "OpenAPIRefs: duplicate id $key — already registered as " *
        "$(summary(refs.by_id[key])), cannot register $(summary(component))",
    )
    refs.by_id[key] = component
    refs.id_by_component[component] = key
    return component
end

"""
Resolve the component registered under document `id`.

Errors naming the id when it has not been registered — a missing reference is malformed
input (or a dependency-order bug in the caller), not something to paper over with
`nothing`.
"""
function Base.getindex(refs::OpenAPIRefs, id::Integer)
    key = Int(id)
    haskey(refs.by_id, key) || error(
        "OpenAPIRefs: unresolved id $key — no component registered under it; expected " *
        "every referenced component to be converted earlier, in dependency order",
    )
    return refs.by_id[key]
end

"""
Resolve an **optional** component reference from a document.

`nothing` in means `nothing` out: a schema-optional reference that the document omits is an
absent relationship, not a malformed one. A reference that *is* stated still goes through
[`Base.getindex`](@ref) and so still errors when it names an id nothing was registered under.

Generated converters call this for every `:reference` field rather than indexing `refs`
directly, because indexing cannot express the difference — `refs[nothing]` is a `MethodError`,
which is what a bus with no `area` used to produce.
"""
resolve_ref(::OpenAPIRefs, ::Nothing) = nothing
resolve_ref(refs::OpenAPIRefs, id::Integer) = refs[id]

"""Whether `id` has a component registered. Use before [`Base.getindex`](@ref) when absence
is a valid outcome to branch on, rather than an error to raise."""
has_ref(refs::OpenAPIRefs, id::Integer) = haskey(refs.by_id, Int(id))

"""
Resolve the UUID of the component or supplemental attribute registered under document `id`.

`by_id` already holds whatever was registered there via [`Base.setindex!`](@ref) — a
component from the dependency-ordered component pass, or (once
`load_supplemental_attribute_associations!` registers it) a supplemental attribute — so
this is one lookup over one id space, not two. This is the whole id⇄UUID bridge the
association loaders resolve through, kept isolated here so it collapses to nothing once
IS goes id-native and the `*_uuid` columns it feeds become `*_id`.
"""
resolve_uuid(refs::OpenAPIRefs, id::Integer) = IS.get_uuid(refs[id])

"""
Resolve the document id a previously-registered `component` was stored under.

Errors naming the component's summary when it was never registered via `setindex!`.
"""
function component_id(refs::OpenAPIRefs, component)
    haskey(refs.id_by_component, component) || error(
        "OpenAPIRefs: component $(summary(component)) has no registered id — it was never " *
        "passed through setindex!",
    )
    return refs.id_by_component[component]
end

"""Whether `component` has a registered id. Use before [`component_id`](@ref) when absence
is a valid outcome to branch on, rather than an error to raise."""
has_component_id(refs::OpenAPIRefs, component) = haskey(refs.id_by_component, component)

# The round-trip ledger needs the `System` type, which this repo defines in `src/base.jl` —
# included much later than this file (this file must precede `models/generated/includes.jl`;
# `base.jl` comes after that). It lives in `src/openapi/ledger.jl`, included right after
# `base.jl`, rather than here.
