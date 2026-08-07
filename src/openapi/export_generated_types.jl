# Hand-written export-direction helpers shared by the generated `to_openapi` methods and by
# `export_handwritten.jl`. The 22 `to_openapi` methods that used to live here (one
# `Val{:DEVICE_BASE}`/`Val{:NATURAL_UNITS}` pair per `ACBus`, `AreaInterchange`, `PowerLoad`,
# `InterruptiblePowerLoad`, `ShiftablePowerLoad`, `HydroDispatch`, `HydroTurbine`,
# `RenewableDispatch`, `RenewableNonDispatch`, `ThermalStandard`, `SynchronousCondenser`) are
# now generated straight into src/models/generated/<Type>.jl from the `openapi_type`-annotated
# descriptor entries, alongside the `from_openapi` methods those files already carried — see
# `src/generate_structs.jl`'s `compute_openapi_export_converter!`. Their `<ENUM>_TO_STRING`
# tables moved the same way, generated beside the matching `<ENUM>_FROM_STRING` table.
#
# What remains here is purely infrastructure the generated methods call into, plus the pieces
# `export_handwritten.jl` still depends on for the types codegen does not yet reach (`Area`,
# `LoadZone`, `Line`, `TransformerCircuit`, the reserves, and others — see that file's header).
#
# Mechanical rules the generator follows (for reference, mirrored from `compute_openapi_
# converter!`'s import-direction rules, inverted):
#   - scalar (device-base pu):    DEVICE_BASE -> get_X(c, DU) directly; NATURAL_UNITS ->
#                                 get_X(c, DU) * _get_base_power(c)
#   - MinMax/UpDown (device-base): same, per-member
#   - enum                        <ENUM>_TO_STRING[get_X(c)] — literal tables built by
#                                 *inverting* the generated `<ENUM>_FROM_STRING` tables
#                                 (Dict comprehensions over `instances(T)`, hence bijective)
#   - component reference          component_id(refs, get_X(c))
#   - cost                        convert_cost_to_openapi(get_operation_cost(c))
#   - id                          component_id(refs, c) — the reflexive lookup: the document
#                                 walk (export_document.jl) registers every component's
#                                 id via `refs[id] = component` *before* calling `to_openapi`,
#                                 so this always resolves.

# ── Shared compound-field helpers (device-base pu), reused by both the generated
# `to_openapi` methods and export_handwritten.jl ──

_minmax_po(nt) = PC.MinMax(; min = nt.min, max = nt.max)
_minmax_po_optional(::Nothing) = nothing
_minmax_po_optional(nt) = _minmax_po(nt)
_minmax_po_scaled(nt, base) = PC.MinMax(; min = nt.min * base, max = nt.max * base)
_minmax_po_scaled_optional(::Nothing, base) = nothing
_minmax_po_scaled_optional(nt, base) = _minmax_po_scaled(nt, base)

_updown_po_optional(::Nothing) = nothing
_updown_po_optional(nt) = PC.UpDown(; up = nt.up, down = nt.down)
_updown_po_scaled_optional(::Nothing, base) = nothing
_updown_po_scaled_optional(nt, base) = PC.UpDown(; up = nt.up * base, down = nt.down * base)

_fromto_po(nt) = PC.FromTo(; from = nt.from, to = nt.to)
_fromto_toframe_po(nt) = PC.FromToToFrom(; from_to = nt.from_to, to_from = nt.to_from)
_fromto_toframe_po_scaled(nt, base) =
    PC.FromToToFrom(; from_to = nt.from_to * base, to_from = nt.to_from * base)
_inout_po(nt) = PC.InOut(; in = nt.in, out = nt.out)
# Inverse of the import side's `_complex_number` (import_handwritten.jl).
_complex_number_po(c) = PC.ComplexNumber(; real = real(c), imag = imag(c))

_scale_optional_po(::Nothing, base) = nothing
_scale_optional_po(v, base) = v * base

"""`component_id`, but tolerant of a `nothing` field (e.g. `ACBus.area`/`load_zone`, which are
`Union{Nothing, T}` on the PSY side) — reverses to `nothing` rather than erroring."""
_component_id_optional(::OpenAPIRefs, ::Nothing) = nothing
_component_id_optional(refs::OpenAPIRefs, component) = component_id(refs, component)

# ── Reverse enum tables, for the enums generated `to_openapi` methods do not already cover
# (inverted from the `<ENUM>_FROM_STRING` tables; those are built as
# `Dict(string(m) => m for m in instances(T))`, which is bijective since `instances(T)` yields
# unique values — verified, so inversion is safe rather than hand-writing a second literal
# table that could drift from the first). `export_handwritten.jl` still calls `_invert`
# directly for the enums on types it hand-writes. ──

# A Dict rather than `string(e)`: `@scoped_enum`'s `string` routes through
# `_value2name(Val{value}())`, a dynamic dispatch that is ~7x slower and infers `Any`. These
# lookups run per component per enum field, so the table stays.
_invert(d) = Dict(v => k for (k, v) in d)
