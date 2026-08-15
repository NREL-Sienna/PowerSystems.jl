# The OpenAPI round-trip ledger: the id⇄UUID map persisted in `System.ext` under one reserved
# key. On the critical path both ways — `from_openapi` writes it (import_document.jl), and
# `to_openapi(sys; unit_system = :original)` reads it to reproduce the document's ids
# (export_document.jl).
#
# It stores UUID strings rather than the components `OpenAPIRefs` holds in memory, because
# component references do not survive a JSON round-trip of `ext`. The whole file is a bridge
# pending the UUID→id migration in IS/PSY; once identity is natively id-based it should be
# deleted, not migrated forward.
#
# Split from refs.jl because it needs `System`, which base.jl defines much later.

const OPENAPI_LEDGER_KEY = "_openapi_ledger"

"""
Whether `x` carries its own UUID and belongs in the id⇄UUID ledger.

`TransformerCircuit` is embedded in its owning transformer and has no `internal` field, so no
UUID — but it is still registered in `OpenAPIRefs`, and must be skipped rather than error.
"""
_has_own_uuid(::Any) = true
_has_own_uuid(::TransformerCircuit) = false

"""
Persist `refs`' id⇄component registry and unit system into `sys`'s `ext` so a later
`to_openapi(sys; unit_system = :original)` can reproduce the document's ids and units.
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
absence is a valid outcome to branch on."""
has_ledger(sys::System) = haskey(get_ext(sys), OPENAPI_LEDGER_KEY)

"""
Read the ledger [`store_ledger!`](@ref) wrote into `sys`'s `ext`. Errors when `sys` carries
none, since `unit_system = :original` export cannot proceed without it.
"""
function load_ledger(sys::System)
    has_ledger(sys) || error(
        "System has no OpenAPI round-trip ledger under ext key \"$OPENAPI_LEDGER_KEY\" — " *
        "it was not built via PSY.from_openapi, or the ledger was removed from ext; " *
        "to_openapi(sys; unit_system = :original) requires one",
    )
    return get_ext(sys)[OPENAPI_LEDGER_KEY]
end
