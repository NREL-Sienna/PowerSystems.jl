# `TransformerCircuit` is a descriptor-generated struct (see
# `src/models/generated/TransformerCircuit.jl`): its fields, kwarg/`(nothing)`
# constructors, and explicit-units accessors are emitted by codegen. Its base
# provider methods (`_get_device_base_power`/`_get_system_base_power`) live in
# `src/models/components.jl`. This file holds only the hand-written behavior that
# codegen does not emit.

# A circuit has no control block when its objective is UNDEFINED.
has_control(w::TransformerCircuit) =
    get_control_objective(w) != TransformerControlObjective.UNDEFINED

const _PHASE_SHIFT_OBJECTIVES = (
    TransformerControlObjective.ACTIVE_POWER_FLOW,
    TransformerControlObjective.ACTIVE_POWER_FLOW_DISABLED,
    TransformerControlObjective.ASYMMETRIC_ACTIVE_POWER_FLOW,
    TransformerControlObjective.ASYMMETRIC_ACTIVE_POWER_FLOW_DISABLED,
)

"""
    is_phase_shifting(w::TransformerCircuit)

Canonical predicate: `true` if the circuit has a nonzero phase-shift angle or an
active-power (phase-shift) control objective. Downstream packages must use this
instead of re-deriving the answer from raw fields.
"""
function is_phase_shifting(w::TransformerCircuit)
    !iszero(get_α(w)) && return true
    return get_control_objective(w) in _PHASE_SHIFT_OBJECTIVES
end

Base.summary(
    w::TransformerCircuit,
) = "TransformerCircuit($(summary(get_from(get_arc(w)))) → $(summary(get_to(get_arc(w)))))"

get_circuits(t::TwoWindingTransformer) = (get_circuit(t),)
get_circuits(t::ThreeWindingTransformer) =
    (get_primary_circuit(t), get_secondary_circuit(t), get_tertiary_circuit(t))

# `circuit`/`primary_circuit`/`secondary_circuit`/`tertiary_circuit` are
# `exclude_setter: true` in the descriptor (see power_system_structs.json):
# codegen's generated setters (`value.circuit = val`, etc.) install a
# `TransformerCircuit` without propagating the parent's `units_info`, so a
# circuit swapped in after the transformer is attached is left with stale (or
# missing) units settings and its explicit-units getters silently misbehave.
# These hand-written replacements assign the field, then copy the parent's
# current `units_info` onto the new circuit — matching what
# `set_units_setting!` does for the circuits a transformer already has. A
# detached parent has `units_info === nothing`; copying that is correct too.
"""Set [`TwoWindingTransformer`](@ref) `circuit`, propagating this transformer's units settings to the new circuit."""
function set_circuit!(t::TwoWindingTransformer, w::TransformerCircuit)
    setfield!(t, :circuit, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""Set [`ThreeWindingTransformer`](@ref) `primary_circuit`, propagating this transformer's units settings to the new circuit."""
function set_primary_circuit!(t::ThreeWindingTransformer, w::TransformerCircuit)
    setfield!(t, :primary_circuit, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""Set [`ThreeWindingTransformer`](@ref) `secondary_circuit`, propagating this transformer's units settings to the new circuit."""
function set_secondary_circuit!(t::ThreeWindingTransformer, w::TransformerCircuit)
    setfield!(t, :secondary_circuit, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""Set [`ThreeWindingTransformer`](@ref) `tertiary_circuit`, propagating this transformer's units settings to the new circuit."""
function set_tertiary_circuit!(t::ThreeWindingTransformer, w::TransformerCircuit)
    setfield!(t, :tertiary_circuit, w)
    w.units_info = IS.get_units_info(get_internal(t))
    return
end

"""
    get_available(t)

Derived: a transformer is available if any of its circuits is available.
There is no parent-level stored flag; circuit availability is the single source
of truth. Note `set_available!(t, true)` re-energizes ALL circuits, including any
that were individually out beforehand (PSS/E STAT semantics).
"""
get_available(t::Union{TwoWindingTransformer, ThreeWindingTransformer}) =
    any(get_available, get_circuits(t))

function set_available!(
    t::Union{TwoWindingTransformer, ThreeWindingTransformer},
    val::Bool,
)
    foreach(w -> set_available!(w, val), get_circuits(t))
    return val
end

is_phase_shifting(t::Union{TwoWindingTransformer, ThreeWindingTransformer}) =
    any(is_phase_shifting, get_circuits(t))

# `TransformerCircuit` is `<: DeviceParameter <: IS.InfrastructureSystemsType`, so without
# an override it would fall to the generic `IS.serialize(::T) where {T <: InfrastructureSystemsType}`
# / 2-arg `IS.deserialize`, which serializes `arc::Arc` INLINE (a full nested-struct copy,
# not a UUID reference) rather than through `should_encode_as_uuid`/`serialize_uuid_handling` —
# on read-back that produces a dangling/duplicated `Arc` (worse, `Arc`'s own `Bus`-typed
# fields are abstract, so `fieldnames(Bus)` errors outright). `TransformerCircuit` is added
# to `_CONTAINS_SHOULD_ENCODE` (`serialization.jl`) so its `arc` field is UUID-encoded like
# any Component field, mirroring the `MarketBidCost`/cost-type precedent for a
# non-`Component` struct with Component-valued fields. `units_info` is internal, runtime
# state repopulated by `add_component!` (via `set_units_setting!`) — it must never be
# serialized.
function IS.serialize(w::TransformerCircuit)
    data = Dict{String, Any}()
    for name in fieldnames(TransformerCircuit)
        name === :units_info && continue
        data[string(name)] = serialize_uuid_handling(getfield(w, name))
    end
    IS.add_serialization_metadata!(data, TransformerCircuit)
    return data
end

function IS.deserialize(
    ::Type{TransformerCircuit},
    data::Dict,
    component_cache::Dict,
)
    vals = Dict{Symbol, Any}()
    for (fname, ftype) in
        zip(fieldnames(TransformerCircuit), fieldtypes(TransformerCircuit))
        fname === :units_info && continue
        vals[fname] = deserialize_uuid_handling(ftype, data[string(fname)], component_cache)
    end
    return TransformerCircuit(; vals..., units_info = nothing)
end
