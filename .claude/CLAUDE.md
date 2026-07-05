# PowerSystems.jl (PSY) — psy6 branch

The Sienna power-system **data model**: the `System` container plus ~210 component types (buses, branches, generators, storage, loads, services, dynamic models), operational cost structures, time series, and the **explicit-units engine**. Layer 1 of the psy6 stack, built on InfrastructureSystems (IS4 branch). Platform-wide conventions: `.claude/Sienna.md`. Workspace architecture: `/home/jdlara/Sienna_work/psy6/CLAUDE.md`.

**This branch has NO parsers.** `src/parsers/` was removed in the psy6 line; all Matpower/PSSE/table parsing lives in PowerFlowFileParser.jl (and PSB's parser wrappers). Do not re-add parsing here.

## Downstream blast radius

PNM, PF, POM, and PSB all consume PSY; SiennaSchemas mirrors PSY component fields (JSON schemas), so field renames/retypes create schema drift the sync tooling must catch. After a PSY change:

1. compile-smoke the stack: `julia --project=/home/jdlara/Sienna_work/psy6 -e 'using PowerNetworkMatrices, PowerFlows, PowerOperationsModels, PowerSystemCaseBuilder'`
2. **clear PSB's `data/serialized_system/` cache** — it has no version-aware invalidation, and stale cached systems produce confusing deserialization failures downstream.
3. if the change touched a component field also present in SiennaSchemas, flag the schema counterpart (example of real drift: `head_to_volume_factor` moved to `FunctionData` in PSY commit `ed30a682` while `SiennaSchemas/Operations/StaticInjection/HydroReservoir.json` still `$ref`s `ValueCurve`).

## Source layout

- `src/PowerSystems.jl` — module, include order, all exports (~560)
- `src/base.jl` — `System` container and core methods
- `src/definitions.jl` — enums/constants
- `src/units/` — **the explicit-units engine**: `types.jl`, `conversions.jl`, `serialization.jl`; conversion entry points also in `src/models/components.jl`
- `src/models/` — hand-written behavior over generated structs (validation, supplemental constructors/accessors/setters, custom `show`), `cost_functions/`, and `generated/` (**auto-generated, never edit**)
- `src/descriptors/power_system_structs.json` — source of truth for generated structs (top-level key `auto_generated_structs`)
- `src/deprecated.jl` — legacy 4.0.0-era constructor deprecations (predate the no-shims policy). Do not add to it; psy6 breaking changes get no shims.
- `subsystems.jl`, `contingencies.jl`, `outages.jl`, `component_selector.jl`, `plant_attribute.jl`, `emissions_data.jl`, `utils/`

## Generated code workflow

Edit the descriptor, then regenerate — never hand-edit `src/models/generated/`:

```sh
julia --project=test -e "using InfrastructureSystems; InfrastructureSystems.generate_structs(\"./src/descriptors/power_system_structs.json\", \"./src/models/generated\")"
```

- Generated signatures use exact types (`::Type{ExponentialLoad}`), never `Type{<:X}`.
- Hand-written behavior (validation, extra constructors, custom show) goes in non-generated `src/models/*.jl`.
- `test/test_generate_structs.jl` checks descriptor↔generated consistency — inspect the regenerated diff for intent.

### Recipe: add or change a component field (end-to-end)

The canonical example of psy6 cross-repo propagation — a PSY field change touches up to six repos:

1. **Descriptor**: edit `power_system_structs.json` (set `needs_conversion`/`conversion_unit` if unit-bearing) → regenerate → formatter.
2. **Hand-written layer**: validation/supplemental accessors in `src/models/*.jl` if needed; `exclude_getter` fields need their public getter written by hand.
3. **Verify locally**: `test_units` filter if convertible; full suite; **docs must build**.
4. **PSB**: clear `data/serialized_system/` (cached fixtures embed the old shape); check whether any builder in `src/library/` sets the field.
5. **SiennaSchemas**: mirror the field in the matching `Operations/...json` with an `x-unit` annotation; run `validate_units.py`. Skipping this creates the drift the sync check exists to catch.
6. **GridDB**: if the field maps to a DB column, update `column_conventions.json` and regenerate the sealed registry.
7. **Downstream smoke**: `julia --project=/home/jdlara/Sienna_work/psy6 -e 'using PowerNetworkMatrices, PowerFlows, PowerOperationsModels, PowerSystemCaseBuilder'`; consumers reading the field must pass an explicit unit system.

## The explicit-units engine (the defining psy6 feature)

- Descriptor fields carry `needs_conversion: true` + `conversion_unit` (`:mva` / `:ohm` / `:siemens`) — **247 fields** across the descriptor. Codegen (IS-side) emits `get_X(comp, units)`, `get_X_unitful(comp, units)`, and `set_X!(comp, tagged_value)`.
- Getters require the unit system explicitly: `get_rating(br, PSY.SU)`. `SU`/`DU`/`NU` markers come from `IS.RelativeUnits`; PSY gives them domain meaning (`base_power` is the device base, MVA).
- Setters take **tagged** values and reject bare floats: `set_rating_b!(line, 0.9 * PSY.SU)`.
- PSY extends `IS._strip_units` (required by the IS codegen contract) and overrides `IS.default_units(::Component)` to return `SU` for time-series multipliers.
- **`with_units_base` / `set_units_base_system!` are deliberately kept as display-only API** — do not delete or deprecation-mark them. The legacy `UnitSystem` enum is display metadata only.
- Serialization stores component values in **device base**; there is no natural-units export path yet (documented-not-implemented; the OpenAPI/GridDB pipeline expects natural units — that converter is the unclosed loop).
- Cost curves default to `power_units = IS.NaturalUnit()`; `CostCurve{T,U}`/`FuelCurve{T,U}` carry the unit as a type parameter (IS4).
- Units test filter: `julia --project=test test/runtests.jl test_units` (fast, ~22 s).

### Known audit items (do not silently "fix"; coordinate)

- `check_rating_values(::Union{Line,MonitoredLine}, basemva)` at `src/utils/IO/branchdata_checks.jl:98` reads raw DU `getfield(line, :rating)` against a system-base threshold — numerically correct today only because Line/MonitoredLine lack `base_power` (DU==SU). Latent trap if `base_power` is ever added; the transformer sibling at line ~189 (`_get_base_power`) is the correct pattern.
- `_set_units_base!` at `src/base.jl:574` — `IS.get_units_info` is nothing-unguarded for detached components on the display path; wants the `isnothing(...) && error(...)` guard matching `_get_system_base_power` (`src/models/components.jl`).
- `src/base.jl:~3290` — copy-paste bug: `old_load.max_active_power` copied into `max_constant_reactive_power`. Known, pending a separate fix.
- Setters bypass validation and `set_bus!` does not maintain `sys.bus_numbers` — mutation after `add_component!` is convention-trusted.
- Sweep artifacts live in `.claude/`: `convertible_fields.txt` (72 convertible field names), `units_sweep_hits.txt`, `units_sweep_report.md`.

## Commands

```sh
julia --project=test -e 'using Pkg; Pkg.instantiate()'            # first time
julia --project=test -e 'using Pkg; Pkg.develop(path = ".")'      # once per clone: test env must dev the working tree
julia --project=test test/runtests.jl                             # full suite
julia --project=test test/runtests.jl test_plant_attributes       # single file (stem, no .jl)
julia --project=docs docs/make.jl                                 # docs must build cleanly
julia --project=scripts/formatter -e 'include("scripts/formatter/formatter_code.jl")'   # always before done
```

Compile-check after each edit: `julia --project=/home/jdlara/Sienna_work/psy6 -e 'using PowerSystems'`.

## Working with the data model

- Add components via `add_component!(sys, comp)`, never direct container insertion; retrieve via `get_component(Type, sys, name)` / `get_components(Type, sys)`.
- Time series always attach to components, never standalone.
- Bus numbers must be unique (validated when `runchecks=true`; keep it on during development).
- Public API is `get_*`/`set_*` accessors — no dot field access in user-facing code (tutorials/docs/tests included).
- Tests that mutate a PSB-built system must `deepcopy` first; read-only tests must not.

## Line policy reminders

- No version/compat bumps (stays 5.10.0 until release); local `[sources]` path pins for co-dev are fine but restore git pins before finishing.
- No shims, no deserialization aliases, no changelog edits. Regenerate old serialized systems instead of bridging.
- IS is pinned to the `IS4` branch via `[sources]`; a precompile `UndefVarError` usually means the IS checkout is on the wrong branch.
