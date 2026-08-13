# Export-direction helpers shared by the generated `to_openapi` methods (emitted by
# `compute_openapi_export_converter!` in src/generate_structs.jl) and by export_handwritten.jl.

# ── Compound-field helpers (device-base pu) ──

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

# Reverse enum tables, inverted from the `<ENUM>_FROM_STRING` tables rather than hand-written
# again, so the two cannot drift. A Dict rather than `string(e)`: `@scoped_enum`'s `string`
# routes through `_value2name(Val{value}())`, a dynamic dispatch ~7x slower that infers `Any`,
# and these lookups run per component per enum field.
_invert(d) = Dict(v => k for (k, v) in d)
