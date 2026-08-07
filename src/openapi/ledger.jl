# Hand-written: the OpenAPI round-trip ledger. Extends `src/openapi/refs.jl` conceptually;
# split into its own file because it needs `System`, defined in `base.jl`, included after
# `refs.jl` — see the note there.
#
# id<->UUID persisted in `System.ext` under one reserved key. This is a deliberate TEMPORARY
# BRIDGE pending the planned UUID→id migration in IS/PSY — once component identity is natively
# id-based, this ext entry becomes redundant and should be DELETED, not migrated forward.
# Component object references do not survive a JSON round-trip of `System.ext` (a plain
# `Dict{String,Any}`), so the ledger stores UUIDs — strings — rather than the components
# `OpenAPIRefs` holds in memory during one conversion pass.

const OPENAPI_LEDGER_KEY = "_openapi_ledger"

"""
Whether `x` carries its own UUID and belongs in the id<->UUID ledger.

`TransformerCircuit` is a `DeviceParameter` embedded in its owning transformer, not an
`InfrastructureSystemsComponent` — it has no `internal` field and thus no UUID of its own.
It is still registered in `OpenAPIRefs` (transformers resolve it by id), so
[`store_ledger!`](@ref) must skip it rather than error.
"""
_has_own_uuid(::Any) = true
_has_own_uuid(::TransformerCircuit) = false

"""
Persist `refs`' id<->component registry and unit system into `sys`'s `ext`, keyed under
`OPENAPI_LEDGER_KEY`, so a later `to_openapi(sys; unit_system = :original)` can reproduce
the document's ids and unit convention. See [`load_ledger`](@ref), [`has_ledger`](@ref).
"""
function store_ledger!(sys::System, refs::OpenAPIRefs)
    id_to_uuid = Dict{String, String}(
        string(id) => string(IS.get_uuid(component))
        for (id, component) in refs.by_id if _has_own_uuid(component)
    )
    get_ext(sys)[OPENAPI_LEDGER_KEY] = Dict{String, Any}(
        "unit_system" => get_unit_system(refs),
        "id_to_uuid" => id_to_uuid,
    )
    return nothing
end

"""Whether `sys` carries an OpenAPI round-trip ledger. Use before [`load_ledger`](@ref) when
absence is a valid outcome to branch on, rather than an error to raise."""
has_ledger(sys::System) = haskey(get_ext(sys), OPENAPI_LEDGER_KEY)

"""
Read the OpenAPI round-trip ledger `store_ledger!` wrote into `sys`'s `ext`.

Errors when `sys` carries no ledger — it was never built via `PSY.from_openapi`, or the
`ext` key was cleared — naming the missing key, since exporting with
`unit_system = :original` cannot proceed without it.
"""
function load_ledger(sys::System)
    has_ledger(sys) || error(
        "System has no OpenAPI round-trip ledger under ext key \"$OPENAPI_LEDGER_KEY\" — " *
        "it was not built via PSY.from_openapi, or the ledger was removed from ext; " *
        "to_openapi(sys; unit_system = :original) requires one",
    )
    return get_ext(sys)[OPENAPI_LEDGER_KEY]
end
