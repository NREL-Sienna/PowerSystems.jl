"""
Convert an OpenAPI-model (PO) instance of `T` into the matching PSY component or value type.
"""
function from_openapi end

"""
Convert a PSY component or value into its OpenAPI-model (PO) representation.
"""
function to_openapi end

"""
$(TYPEDEF)
$(TYPEDFIELDS)

Bidirectional id⇄component resolution context for one OpenAPI document conversion.

Populated in dependency order as components are converted. An unregistered id or component is
malformed input, not an absence to tolerate, so lookups error rather than return `nothing`;
call [`has_ref`](@ref) / [`has_component_id`](@ref) first when absence is a valid outcome.
"""
struct OpenAPIRefs
    "Id → component, populated by `setindex!` as each component is converted."
    by_id::Dict{Int, Any}
    "Component → id, keyed by object identity."
    id_by_component::IdDict{Any, Int}
    "The document's declared unit system (e.g. \"NATURAL_UNITS\"), fixed for the whole document."
    unit_system::String
    "The document's system base power (MVA), used by converters for types carrying no
    device-level `base_power` of their own."
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

"""Register `component` under document `id`. Errors on a duplicate id."""
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
Resolve the component registered under document `id`. Errors naming the id when it has not
been registered, which means either malformed input or a dependency-order bug in the caller.
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
Resolve an optional component reference: a schema-optional reference the document omits is an
absent relationship, so `nothing` in means `nothing` out. A stated reference goes through
[`Base.getindex`](@ref) and still errors on an unregistered id.
"""
resolve_ref(::OpenAPIRefs, ::Nothing) = nothing
resolve_ref(refs::OpenAPIRefs, id::Integer) = refs[id]

"""
Resolve a reference whose PSY type the descriptor already states, asserting it on the way
out. `by_id` is a `Dict{Int, Any}` — it holds every converted type — so the 2-arg form
returns `Any` and every generated converter that used it handed the constructor an
untyped value. The assert costs one type check and makes a document that points a `bus`
field at, say, an `Arc` fail there, naming both types, instead of deeper inside the
component constructor.
"""
resolve_ref(::OpenAPIRefs, ::Nothing, ::Type) = nothing
resolve_ref(refs::OpenAPIRefs, id::Integer, ::Type{T}) where {T} = refs[id]::T

"""Whether `id` has a component registered."""
has_ref(refs::OpenAPIRefs, id::Integer) = haskey(refs.by_id, Int(id))

"""
Resolve the UUID of the component or supplemental attribute registered under document `id`.

This is the id⇄UUID bridge the association loaders resolve through, kept isolated here so it
collapses to nothing once IS goes id-native and the `*_uuid` columns become `*_id`.
"""
resolve_uuid(refs::OpenAPIRefs, id::Integer) = IS.get_uuid(refs[id])

"""Resolve the document id a previously-registered `component` was stored under."""
function component_id(refs::OpenAPIRefs, component)
    haskey(refs.id_by_component, component) || error(
        "OpenAPIRefs: component $(summary(component)) has no registered id — it was never " *
        "passed through setindex!",
    )
    return refs.id_by_component[component]
end

"""Whether `component` has a registered id."""
has_component_id(refs::OpenAPIRefs, component) = haskey(refs.id_by_component, component)

"""String → enum lookup table for `T`, matching the document's exact spelling."""
_enum_table(::Type{T}) where {T} = Dict{String, T}(string(m) => m for m in instances(T))
