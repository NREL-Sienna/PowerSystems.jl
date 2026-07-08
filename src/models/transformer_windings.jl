# `TransformerWinding` is a descriptor-generated struct (see
# `src/models/generated/TransformerWinding.jl`): its fields, kwarg/`(nothing)`
# constructors, and explicit-units accessors are emitted by codegen. Its base
# provider methods (`_get_device_base_power`/`_get_system_base_power`) live in
# `src/models/components.jl`. This file holds only the hand-written behavior that
# codegen does not emit.

has_control(w::TransformerWinding) = !isnothing(get_control(w))

const _PHASE_SHIFT_OBJECTIVES = (
    TransformerControlObjective.ACTIVE_POWER_FLOW,
    TransformerControlObjective.ACTIVE_POWER_FLOW_DISABLED,
    TransformerControlObjective.ASYMMETRIC_ACTIVE_POWER_FLOW,
    TransformerControlObjective.ASYMMETRIC_ACTIVE_POWER_FLOW_DISABLED,
)

"""
    is_phase_shifting(w::TransformerWinding)

Canonical predicate: `true` if the winding has a nonzero phase-shift angle or an
active-power (phase-shift) control objective. Downstream packages must use this
instead of re-deriving the answer from raw fields.
"""
function is_phase_shifting(w::TransformerWinding)
    !iszero(get_α(w)) && return true
    ctrl = get_control(w)
    return !isnothing(ctrl) && get_objective(ctrl) in _PHASE_SHIFT_OBJECTIVES
end

Base.summary(
    w::TransformerWinding,
) = "TransformerWinding($(summary(get_from(get_arc(w)))) → $(summary(get_to(get_arc(w)))))"

get_windings(t::TwoWindingTransformer) = (get_winding(t),)
get_windings(t::ThreeWindingTransformer) =
    (get_primary_winding(t), get_secondary_winding(t), get_tertiary_winding(t))

# `winding`/`primary_winding`/`secondary_winding`/`tertiary_winding` are
# `exclude_setter: true` in the descriptor (see power_system_structs.json):
# codegen's generated setters (`value.winding = val`, etc.) install a
# `TransformerWinding` without propagating the parent's `units_info`, so a
# winding swapped in after the transformer is attached is left with stale (or
# missing) units settings and its explicit-units getters silently misbehave.
# These hand-written replacements assign the field, then copy the parent's
# current `units_info` onto the new winding — matching what
# `set_units_setting!` does for the windings a transformer already has. A
# detached parent has `units_info === nothing`; copying that is correct too.
"""Set [`TwoWindingTransformer`](@ref) `winding`, propagating this transformer's units settings to the new winding."""
function set_winding!(t::TwoWindingTransformer, w::TransformerWinding)
    setfield!(t, :winding, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""Set [`ThreeWindingTransformer`](@ref) `primary_winding`, propagating this transformer's units settings to the new winding."""
function set_primary_winding!(t::ThreeWindingTransformer, w::TransformerWinding)
    setfield!(t, :primary_winding, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""Set [`ThreeWindingTransformer`](@ref) `secondary_winding`, propagating this transformer's units settings to the new winding."""
function set_secondary_winding!(t::ThreeWindingTransformer, w::TransformerWinding)
    setfield!(t, :secondary_winding, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""Set [`ThreeWindingTransformer`](@ref) `tertiary_winding`, propagating this transformer's units settings to the new winding."""
function set_tertiary_winding!(t::ThreeWindingTransformer, w::TransformerWinding)
    setfield!(t, :tertiary_winding, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""
    get_available(t)

Derived: a transformer is available if any of its windings is available.
There is no parent-level stored flag; winding availability is the single source
of truth. Note `set_available!(t, true)` re-energizes ALL windings, including any
that were individually out beforehand (PSS/E STAT semantics).
"""
get_available(t::Union{TwoWindingTransformer, ThreeWindingTransformer}) =
    any(get_available, get_windings(t))

function set_available!(
    t::Union{TwoWindingTransformer, ThreeWindingTransformer},
    val::Bool,
)
    foreach(w -> set_available!(w, val), get_windings(t))
    return val
end

is_phase_shifting(t::Union{TwoWindingTransformer, ThreeWindingTransformer}) =
    any(is_phase_shifting, get_windings(t))

# `TransformerWinding` is `<: DeviceParameter <: IS.InfrastructureSystemsType`, so without
# an override it would fall to the generic `IS.serialize(::T) where {T <: InfrastructureSystemsType}`
# / 2-arg `IS.deserialize`, which serializes `arc::Arc` INLINE (a full nested-struct copy,
# not a UUID reference) rather than through `should_encode_as_uuid`/`serialize_uuid_handling` —
# on read-back that produces a dangling/duplicated `Arc` (worse, `Arc`'s own `Bus`-typed
# fields are abstract, so `fieldnames(Bus)` errors outright). `TransformerWinding` is added
# to `_CONTAINS_SHOULD_ENCODE` (`serialization.jl`) so its `arc` field is UUID-encoded like
# any Component field, mirroring the `MarketBidCost`/cost-type precedent for a
# non-`Component` struct with Component-valued fields. `units_info` is internal, runtime
# state repopulated by `add_component!` (via `set_units_setting!`) — it must never be
# serialized.
function IS.serialize(w::TransformerWinding)
    data = Dict{String, Any}()
    for name in fieldnames(TransformerWinding)
        name === :units_info && continue
        data[string(name)] = serialize_uuid_handling(getfield(w, name))
    end
    IS.add_serialization_metadata!(data, TransformerWinding)
    return data
end

function IS.deserialize(
    ::Type{TransformerWinding},
    data::Dict,
    component_cache::Dict,
)
    vals = Dict{Symbol, Any}()
    for (fname, ftype) in
        zip(fieldnames(TransformerWinding), fieldtypes(TransformerWinding))
        fname === :units_info && continue
        vals[fname] = deserialize_uuid_handling(ftype, data[string(fname)], component_cache)
    end
    return TransformerWinding(; vals..., units_info = nothing)
end
