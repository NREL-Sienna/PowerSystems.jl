# Hand-written (not generated): the loaders that carry document association rows into IS's
# two SQLite association stores (`IS.SupplementalAttributeAssociations`,
# `IS.TimeSeriesMetadataStore`). The document and IS's stores are the same shape except for
# id vs UUID, so this is the id⇄UUID bridge.
#
# WIRED into `from_openapi(::Type{System}, doc)` in `src/openapi/import_document.jl`, which
# calls `load_supplemental_attribute_associations!` and `load_time_series_associations!`
# (both this file) directly.
#
# Reuses, rather than duplicates, import_document.jl's per-type attribute conversion
# (`_attribute_from_openapi`), group-index attach dispatch (`_attach_attribute!`), and
# service-membership dispatch (`_attach_service_membership!`), plus the time-series row
# dispatcher (`_resolve_time_series_type`/`_attach_time_series_row!`, which now covers every
# time-series type) and `has_ref`/`OpenAPIRefs` from `refs.jl`. These are module-private
# helpers, but this file is `include`d into the same `PowerSystems` module, so calling them
# is not an edit to the files that define them.

"""
Whether `owner` is a `Component` or a `SupplementalAttribute` — the two legal values of a
`TimeSeriesAssociation`'s `owner_category` — as a dispatch rather than an `isa` check, so
[`_check_owner_category_matches`](@ref) reads the answer off the resolved object instead of
trusting the document's string in isolation.
"""
_owner_category(::Component) = "Component"
_owner_category(::SupplementalAttribute) = "SupplementalAttribute"

"""Loud error naming `owner_id` when the document's declared `owner_category` is absent or
does not match what `owner_id` actually resolved to."""
function _check_owner_category_matches(owner, declared_category, owner_id)
    isnothing(declared_category) && error(
        "load_time_series_associations!: time series association referencing " *
        "owner_id=$owner_id has no owner_category",
    )
    actual = _owner_category(owner)
    declared_category == actual || error(
        "load_time_series_associations!: owner_id=$owner_id declares owner_category=" *
        "\"$declared_category\" but resolved to a $actual",
    )
    return nothing
end

"""Loud error naming `id` when the document's declared type string is absent or does not
match `nameof(typeof(resolved))` — used for both a real supplemental attribute's
`attribute_type` and a service-membership row's `attribute_type` (which names the service's
own component type, e.g. `"OnlineReserve"`), since both are just "the type of whatever `id`
resolved to"."""
function _check_resolved_type_matches(resolved, declared_type, id)
    isnothing(declared_type) && error(
        "load_supplemental_attribute_associations!: association referencing id=$id has " *
        "no attribute_type",
    )
    actual = string(nameof(typeof(resolved)))
    declared_type == actual || error(
        "load_supplemental_attribute_associations!: id=$id declares attribute_type=" *
        "\"$declared_type\" but resolved to a $actual",
    )
    return nothing
end

"""
$(TYPEDSIGNATURES)

Attach every row of `doc.supplemental_attribute_associations` into `sys`, going through
[`add_supplemental_attribute!`](@ref) rather than the raw `supplemental_attributes` SQLite
table — that API already de-duplicates the association and derives `component_type` from
the component's own type, so this function does no SQL of its own.

One PSY attribute object per `attribute_id`: a `attribute_id` shared by several rows
is converted once, memoized, and attached to every entity that references it — never
copied per row.

Extends the id→UUID resolution map: the first time an `attribute_id` is converted, the new
object is registered into `refs` under that id (`refs[attribute_id] = attribute`), so
[`resolve_uuid`](@ref)/`refs[id]` covers supplemental attributes exactly the way it already
covers components from the dependency-ordered component pass. This is the piece the still-wired
`_attach_supplemental_attribute_associations!` in `import_document.jl` does not do.

A row whose `attribute_id` names a service-membership pair (both `entity_id` and
`attribute_id` resolve to already-registered *components* — e.g. a generator contributing
to an `OnlineReserve`) is recognized and attached via `_attach_service_membership!`, exactly
as the existing import path does. It produces no SQLite row: a `Service` is a `Component`,
not a `SupplementalAttribute`, so it does not belong in IS's supplemental-attribute
association table.

Errors, naming the id, when: an association's `entity_id` or `attribute_id` does not
resolve, or its `attribute_type` is absent or does not match what the id actually resolved
to. No silent skip.
"""
function load_supplemental_attribute_associations!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PC.SystemDocument,
)
    attribute_rows = Dict{Int, Any}(
        Int(getproperty(attr, :id)) => attr for attr in doc.supplemental_attributes
    )
    converted = Dict{Int, SupplementalAttribute}()
    for assoc in doc.supplemental_attribute_associations
        attribute_id = Int(assoc.attribute_id)
        entity_id = Int(assoc.entity_id)
        has_ref(refs, entity_id) || error(
            "load_supplemental_attribute_associations!: association references " *
            "unresolved entity_id=$entity_id (attribute_id=$attribute_id)",
        )
        if haskey(attribute_rows, attribute_id)
            attribute = get!(converted, attribute_id) do
                built = _attribute_from_openapi(attribute_rows[attribute_id], refs)
                _check_resolved_type_matches(built, assoc.attribute_type, attribute_id)
                refs[attribute_id] = built
                return built
            end
            _attach_attribute!(sys, refs[entity_id], attribute, assoc.group_index)
        elseif has_ref(refs, attribute_id)
            service = refs[attribute_id]
            _check_resolved_type_matches(service, assoc.attribute_type, attribute_id)
            _attach_service_membership!(refs[entity_id], service, sys)
        else
            error(
                "load_supplemental_attribute_associations!: association references " *
                "unresolved attribute_id=$attribute_id (entity_id=$entity_id)",
            )
        end
    end
    return nothing
end

"""
$(TYPEDSIGNATURES)

Attach every row of `doc.time_series_associations` into `sys`, going through
[`add_time_series!`](@ref) rather than the raw `time_series_associations` SQLite table, so
the manager's own duplicate-detection and owner-existence checks stay in force.

`owner_category` legally names either a `Component` or a `SupplementalAttribute` (both share
the document's one id counter, so resolving `owner_id` through `refs` is a single lookup
regardless of which). A `SupplementalAttribute` owner resolves only once
[`load_supplemental_attribute_associations!`](@ref) has registered it under its id — call
that function first for a document carrying both kinds of association.

A series referenced by more than one owner row is read off `time_series_storage_path` once,
via [`_materialize_time_series!`](@ref)'s `Base.UUID`-keyed cache, rather than once per row —
every owner row still gets its own attach call.

Requires `time_series_storage_path` whenever the document declares any association — no
silent loss of the document's time series. Errors, naming the association or id, on: an
unresolved `owner_id`, a declared `owner_category` absent or mismatched with what `owner_id`
actually resolved to, an unmapped `time_series_type` or `scaling_factor_multiplier` (from
the reused `_resolve_time_series_type`/`_attach_time_series_row!`), or associations present
with no storage path given.
"""
function load_time_series_associations!(
    sys::System,
    refs::OpenAPIRefs,
    doc::PC.SystemDocument,
    time_series_storage_path,
)
    rows = doc.time_series_associations
    isempty(rows) && return nothing
    isnothing(time_series_storage_path) && error(
        "load_time_series_associations!: document declares $(length(rows)) " *
        "time_series_associations row(s) but no time_series_storage_path was given",
    )
    storage = IS.Hdf5TimeSeriesStorage(false; filename = String(time_series_storage_path))
    # Shared across every row in this call: a series referenced by N owner rows (e.g. RTS's
    # zone/area load fan-out) is read off `storage` once via `_materialize_time_series!`,
    # not N times. Every owner row still gets its own attach call.
    materialized = Dict{Base.UUID, TimeSeriesData}()
    for assoc in rows
        owner_id = Int(assoc.owner_id)
        has_ref(refs, owner_id) || error(
            "load_time_series_associations!: association \"$(assoc.name)\" references " *
            "unresolved owner_id=$owner_id",
        )
        owner = refs[owner_id]
        _check_owner_category_matches(owner, assoc.owner_category, owner_id)
        _attach_time_series_row!(
            _resolve_time_series_type(assoc),
            sys,
            materialized,
            storage,
            owner,
            assoc,
        )
    end
    return nothing
end
