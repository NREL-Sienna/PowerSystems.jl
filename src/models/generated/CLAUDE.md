# Generated code — never hand-edit

Every file in this directory is generated from
`src/descriptors/power_system_structs.json` by the IS template
(`InfrastructureSystems.jl/src/utils/generate_structs.jl`). Edits here are silently destroyed on
the next regeneration.

To change a field, edit the descriptor and regenerate:

```sh
julia --project=test -e "using InfrastructureSystems; InfrastructureSystems.generate_structs(\"./src/descriptors/power_system_structs.json\", \"./src/models/generated\")"
julia --project=scripts/formatter -e 'include("scripts/formatter/formatter_code.jl")'
```

- Unit-bearing fields need `needs_conversion: true` + `conversion_unit` (`:mva` / `:ohm` /
  `:siemens`) in the descriptor. Codegen then emits `get_X(comp, units)`, `get_X_unitful(comp, units)`,
  and `set_X!(comp, tagged_value)`.
- `exclude_getter` / `exclude_setter` fields have their public accessor hand-written in
  `src/models/*.jl`. `TransformerCircuit`'s `set_*_circuit!` family is the load-bearing example:
  codegen's plain `value.circuit = val` would leave a stale `base_value` and silently wrong
  explicit-units getters. **Do not let a regeneration reintroduce it.**
- Generated signatures use exact types (`::Type{ExponentialLoad}`), never `Type{<:X}`.
- `test/test_generate_structs.jl` checks descriptor↔generated consistency — inspect the
  regenerated diff for intent, don't just accept it.

A PSY field change propagates to up to six repos. The end-to-end recipe is in
`.claude/CLAUDE.md` § "Recipe: add or change a component field".
