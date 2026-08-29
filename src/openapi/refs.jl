# `from_openapi`/`to_openapi` are declared in InfrastructureSystems and imported in
# PowerSystems.jl, not declared here: IS owns converters for its own supplemental attributes
# (`GeographicInfo`, `DataSource`), so the generic functions have to live at the layer both
# packages can extend. The methods below and throughout src/openapi/ extend them.

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
    by_id::Dict{Int, IS.InfrastructureSystemsType}
    "Component → id, keyed by object identity."
    id_by_component::IdDict{IS.InfrastructureSystemsType, Int}
    "The document's declared unit system (e.g. \"NATURAL_UNITS\"), fixed for the whole document."
    unit_system::String
    "The document's system base power (MVA), used by converters for types carrying no
    device-level `base_power` of their own."
    base_power::Float64
    "Component→component reference resolutions queued by [`defer_ref!`](@ref) because the
    referenced component had not converted yet — drained by [`resolve_deferred_refs!`](@ref).
    Import-only; export never defers, so this stays empty on that side."
    deferred_refs::Vector{Function}
    "Import-only: the adopted sidecar's time series store, used to resolve an
    association-id-bearing cost's wire id to a `TimeSeriesKey` (`IS.get_time_series_key(store,
    id)`). `nothing` on export — export reads association ids straight off PSY's own keys via
    `IS.get_association_id`, no store needed — and on an import with no sidecar."
    store::Union{Nothing, IS.Store}
end

function OpenAPIRefs(unit_system::AbstractString, base_power::Real = 100.0; store = nothing)
    return OpenAPIRefs(
        Dict{Int, IS.InfrastructureSystemsType}(),
        IdDict{IS.InfrastructureSystemsType, Int}(),
        String(unit_system), Float64(base_power), Function[], store,
    )
end

"""
Defer a component→component reference a `from_openapi` converter cannot resolve on its own
first pass: either a genuine forward reference (the referenced type converts later in
`DOCUMENT_PLAN`) or a same-type reference (the referenced component is of the SAME type,
converted earlier or later within that type's own document-key pass, so no `DOCUMENT_PLAN`
reordering could express it — a cascading `HydroReservoir` chain is the motivating case).

A converter facing either one constructs its component with that field left at its own
empty/`nothing` default, then calls `defer_ref!(refs, f)` with a zero-argument `f` that
performs the resolution (typically closing over the constructed component, `refs`, and the
raw ids still to resolve) via a mutating setter. `f` runs later, from
[`resolve_deferred_refs!`](@ref), once every component in the document is registered — a raw
id still unresolvable then is genuinely absent from the document and errors from `refs`'s own
`getindex`, not from here.
"""
defer_ref!(refs::OpenAPIRefs, f) = push!(refs.deferred_refs, f)

"""
Run every reference resolution queued by [`defer_ref!`](@ref), in the order queued, then clear
the queue. Called once, after every component in the document has converted and registered —
see `from_openapi(::Type{System}, doc)` in `import_document.jl`.
"""
function resolve_deferred_refs!(refs::OpenAPIRefs)
    for f in refs.deferred_refs
        f()
    end
    empty!(refs.deferred_refs)
    return nothing
end

"""Get the document-level unit system this [`OpenAPIRefs`](@ref) was built for."""
get_unit_system(refs::OpenAPIRefs) = refs.unit_system

"""Get the document-level system base power (MVA) this [`OpenAPIRefs`](@ref) was built for."""
get_base_power(refs::OpenAPIRefs) = refs.base_power

"""Get the time series store bound for this import (see [`OpenAPIRefs`](@ref)'s `store`
field), or `nothing` on export or for a sidecar-less import."""
get_store(refs::OpenAPIRefs) = refs.store

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
out. `by_id` is a `Dict{Int, IS.InfrastructureSystemsType}` — it holds every converted type
under that common abstract supertype — so the 2-arg form returns `IS.InfrastructureSystemsType`
and every generated converter that used it handed the constructor an under-typed value. The
assert costs one type check and makes a document that points a `bus` field at, say, an `Arc`
fail there, naming both types, instead of deeper inside the component constructor.
"""
resolve_ref(::OpenAPIRefs, ::Nothing, ::Type) = nothing
resolve_ref(refs::OpenAPIRefs, id::Integer, ::Type{T}) where {T} = refs[id]::T

"""Whether `id` has a component registered."""
has_ref(refs::OpenAPIRefs, id::Integer) = haskey(refs.by_id, Int(id))

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
