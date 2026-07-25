# Units-Management Review — Integration Brief

This file is an implementation work order for Claude Code. It integrates the findings of
a deep multi-agent review (Fable, max effort: 9 finder angles → adversarial verification →
gap sweep → security review) of the units-management rework spanning:

- **InfrastructureSystems.jl, branch `IS4`** (diff vs `main`: 62 files) — the new
  domain-agnostic `RelativeUnits` module, `U <: AbstractUnitSystem` cost-curve type
  parameter, time-series-backed function data, and struct-codegen template.
- **PowerSystems.jl, branch `psy6`** (this repo) — `src/units/{types,conversions,serialization}.jl`,
  the `get_value`/`set_value` machinery in `src/models/components.jl`, and the regenerated
  2-arg explicit-units getters with `_unitful` companions.

Every item below was independently verified (standalone Julia repro, exact-signature
replica, or full dispatch-table enumeration). Still: **re-verify each item against the
current source before changing it** — line numbers drift, and a few items may have been
fixed since the review snapshot. Work through the phases in order; correctness first.

---

## ⚠️ Status note — the transformer refactor landed (2026-07-24, PR #1714 `d19f3244f`)

This brief was written against the pre-refactor transformer architecture. That architecture
is gone, and several items below now describe types and code paths that no longer exist.
**Do not action a transformer item without re-reading the current source** — "fixing" a bug in
a deleted type is worse than leaving it.

What changed: `Transformer2W`/`TapTransformer`/`PhaseShiftingTransformer` →
`TwoWindingTransformer`; `Transformer3W`/`PhaseShiftingTransformer3W` →
`ThreeWindingTransformer` (both formerly abstract supertypes, now concrete structs). Series
electrical data moved onto `TransformerCircuit <: DeviceParameter`, one per 2W, three per 3W.
Architecture detail: `.claude/CLAUDE.md` §Transformer architecture.

Item-by-item, verified against `origin/psy6`:

- **1.1, 1.2 — superseded.** The winding-aware `get_value`/`set_value` asymmetry is gone with
  the winding method family. `TransformerCircuit` is now its own explicit-units base provider:
  `_get_device_base_power(w::TransformerCircuit) = w.base_power` (`components.jl:22`) and
  `_get_system_base_power(w)` reads the `base_value` anchor, erroring explicitly when the
  circuit is detached rather than silently falling back to the system base. The specific bug —
  a 3W field scaling against the system base because `Transformer3W` had no `base_power` — is
  structurally impossible now: every circuit carries its own `base_power`.
- **1.7 — likely superseded, re-verify.** Both directions now resolve base voltage through one
  circuit-level accessor, `get_base_voltage(w::TransformerCircuit) = get_base_voltage_primary(w)`
  (`components.jl:34`). The getter/setter split that caused the (230/115)² drift should be
  single-sourced. Confirm with the round-trip test the item asks for before closing it.
- **3.1 — partially delivered, rewrite the remainder.** The refactor implemented three of its
  five steps for the transformer path:
  - step 1: `_get_device_base_power(c::Component) = _get_base_power(c)` exists
    (`components.jl:16`), as does the per-type base-voltage resolver.
  - step 3: the proposed `WindingBase(c, winding)` view is realized — better — as
    `TransformerCircuit` being a first-class `UnitsBearer`
    (`const UnitsBearer = Union{Component, TransformerCircuit}`, `components.jl:36`) plus
    `_conversion_base(c::UnitsBearer, ::Any) = c` (`:158`) and a `PairBase` provider for the
    3W pairwise fields (`:314`). The duplicated 6-arg winding family in `conversions.jl` is
    deleted.
  - step 5: the triplicated base-power accessor family is collapsed; the 3W `@eval` loop is
    gone.
  Steps 2 and 4 (collapse the `Val{:mva}/:ohm/:siemens` ladder into `convert_units`; derive
  `_du_to_su_ratio`) are **untouched and still valid** — and now cheaper, since the winding
  special-casing that complicated them is gone.
- Everything outside the transformer path (1.3-1.6, 1.8-1.18, Phase 2, 3.2-3.4, Phase 4) is
  unaffected by this refactor. The Phase 0 versioning blocker also still stands.

## Ground rules

1. **Never hand-edit `src/models/generated/*.jl`.** They are generated from
   `src/descriptors/power_system_structs.json` by the IS template
   (`InfrastructureSystems.jl/src/utils/generate_structs.jl`). Fix the template and/or the
   descriptor, then regenerate:
   ```
   julia --project=test -e "using InfrastructureSystems; InfrastructureSystems.generate_structs(\"./src/descriptors/power_system_structs.json\", \"./src/models/generated\")"
   ```
2. **Co-development**: PSY pins IS via `[sources]` → `rev = "IS4"`. IS-side fixes go on a
   branch off `IS4` in InfrastructureSystems.jl; point PSY's `[sources]` at it while
   developing, restore to `IS4` after merge. Template changes require regenerating PSY
   structs in the same change set.
3. **Tests must stay green**: full PSY suite (`Pkg.test()`, ~5300 tests) and IS suite.
   Run the formatter before committing: `julia scripts/formatter/formatter_code.jl`.
4. Several fixes change public behavior — record each in `CHANGELOG.md`.
5. Add a regression test with every fix. Where a test is suggested below, that is the
   minimum bar.

---

## Phase 0 — Release blockers (versioning)

### 0.1 IS4 version / PSY compat are mutually inconsistent
- `PowerSystems.jl/Project.toml`: compat was **lowered** to `InfrastructureSystems = "^3.4"`
  while psy6 source requires IS4-only API (`IS.AbstractUnitSystem`, `IS.NaturalUnit`,
  `IS.display_units_arg`, `IS._strip_units`, `TimeSeriesPiecewiseIncrementalCurve`, …).
  It only resolves locally because of the `[sources]` git pin, which is stripped on
  registration. A registered build would fail at precompile
  (first hit: `src/models/cost_functions/ReserveDemandCurve.jl`).
- `InfrastructureSystems.jl/Project.toml` on IS4 still says `version = "3.6.0"` —
  byte-identical to the registered 3.6.0 despite breaking API removals/renames
  (`Results`→`Outputs`, deleted Optimization types, `CostCurve` signature change, JSON3→JSON).
- **Fix**: bump IS4 to `4.0.0-DEV` (or `4.0.0`), set PSY compat to `^4.0` (and PSY itself
  to its next major), keep `[sources]` for development only.

---

## Phase 1 — Correctness: silent wrong numbers (highest priority)

### 1.1 ThreeWindingTransformer: Unitful targets bypass winding bases (getters) — ⚠️ SUPERSEDED, see the status note above
- `PSY src/models/components.jl` (~line 422): the winding-aware override is
  `get_value(c::ThreeWindingTransformer, field::Val, cu::Val, units::IS.AbstractUnitSystem)`.
  `MW`/`MVA`/`Ω`/`S` are `Unitful.Units`, *disjoint* from `IS.AbstractUnitSystem`, so those
  calls fall to the generic `get_value(c::Component, …)`, which scales by `_get_base_power(c)`
  — and `Transformer3W` has no `base_power` field, so that falls back to the **system** base.
  - `get_rating_primary(t3w, MW)` and `get_rating_primary(t3w, NU)` return contradictory
    values (system-base vs winding-base scaling) for the same field.
  - `get_r_primary(t3w, OHMS)` crashes: the `Branch` fallback calls `get_arc(c)`, which has
    no method for 3W types.
  The generated docstrings explicitly advertise `MW` as a valid `units` argument.
- **Fix**: widen the 3W override to all unit targets (`units::UnitArg`), routing Unitful
  targets through the winding-aware `convert_units(..., winding)` path (see 3.1 for the
  deeper consolidation). Existing test `test/test_base_power.jl` covers only `DU/SU/NU` on
  3W — add `MW`, `OHMS`, `SIEMENS` target cases asserting agreement with the `NU` path.

### 1.2 ThreeWindingTransformer: no winding-aware `set_value` at all (setters) — ⚠️ SUPERSEDED, see the status note above
- All `set_value` methods in `components.jl:200-279` dispatch on `Component`/`Branch` only.
  Generated 3W setters (`set_rating_primary!`, `set_r_12!`, `set_active_power_flow_primary!`,
  also `PhaseShiftingTransformer3W`) route through them:
  - power fields divide by `_get_base_power(c)` = **system base** instead of the winding
    base → silently corrupted stored DU values (e.g. `base_power_12=15`, system 100:
    `set_rating_primary!(t3w, 30.0u"MW")` stores `0.3` instead of `2.0`);
  - Ω/S-valued setters crash at `get_arc(t3w)`.
  Only `DU`-tagged input round-trips. Current tests dodge this by seeding 3W fields with
  `setproperty!` directly (`test/test_base_power.jl:266`).
- **Fix**: add winding-aware `set_value` methods mirroring the winding `get_value`
  (field → winding token map already exists: `_get_device_base_power(c, field::Val)` at
  `components.jl:440`). Add set→get round-trip tests per winding for MW, SU, DU, Ω, S.

### 1.3 `_du_to_su_ratio(::CurrentCategory)` is inverted
- `PSY src/units/conversions.jl:102-103` returns `sb/db`; the category's own
  `base_value` (db/V) and `system_base_value` (sb/V) imply DU→SU multiplies by **db/sb**.
  `convert_units(c, v, CURRENT, DU, Float64)` and `convert_units(c, v, CURRENT, DU, SU)`
  return reciprocal-scaled answers today.
- **Fix**: delete the 5 hand-written methods and define once:
  `_du_to_su_ratio(c, cat::UnitCategory) = base_value(c, cat) / system_base_value(c, cat)`
  (makes this bug class impossible; see also 4.2 for the cheap power-ratio form).
  Add a test asserting `convert_units(c, v, cat, DU, Float64) == IS.ustrip-equivalent of
  convert_units(c, v, cat, DU, SU)` for **every** category.

### 1.4 Time-series scaling-factor multipliers: arity break
- `IS src/time_series_interface.jl` (~line 999): `_make_time_array` now calls
  `multiplier(owner, units)` (with a hard-coded `units = SU` default threaded through
  ~10 signatures). Every 1-arg multiplier breaks at retrieval time with a MethodError:
  user closures, multipliers in previously serialized systems, and PSY's own generated
  1-arg getters — e.g. the documented reserve pattern
  `scaling_factor_multiplier = get_requirement` on `VariableReserve` (PSY generates only
  `get_requirement(value::VariableReserve)`; IS's own tests needed 2-arg `get_val` shims).
- **Fix** (three parts):
  1. Restore 1-arg compatibility at the call boundary, e.g.
     `_apply_multiplier(m, owner, units) = applicable(m, owner, units) ? m(owner, units) : m(owner)`
     (resolve once per retrieval, not per row).
  2. Replace the literal `SU` default with a trait IS owns and PSY implements:
     `default_units(owner)` (IS fallback: a no-conversion marker). Domain policy ("SU")
     does not belong in domain-agnostic IS.
  3. PSY descriptor: `VariableReserve.requirement` is the only reserve `requirement`
     lacking `needs_conversion` (siblings `ConstantReserve`, `ConstantReserveNonSpinning`,
     `VariableReserveNonSpinning` all have it). Decide deliberately: if it should convert,
     add the flag and regenerate; if not, document why.
  Note the semantic change regardless: on `main`, scaling respected the system's dynamic
  units base; on IS4 it is fixed. Document this in the IS4 migration notes.
- Tests: retrieval with a 1-arg closure multiplier; retrieval with a generated 2-arg
  getter; a deserialized-system round-trip that exercises a stored multiplier name.

### 1.5 `len` kwarg accepted and silently ignored in TS cost getters
- `PSY src/models/cost_function_timeseries.jl` (~line 107 and siblings:
  `get_variable_cost`, `get_incremental/decremental_variable_cost`,
  `get_import/export_variable_cost`, `get_no_load_cost`, `get_shut_down`,
  `ReserveDemandTimeSeriesCurve.get_variable_cost`): the getter takes `len` but resolves
  exactly one timestep via `IS.build_static_curve` (which supports only `len = 1`; IS
  carries a TODO). A caller requesting a 24-period window silently gets hour-1 bids for
  all 24 hours.
- **Fix**: until windowed resolution lands (see 4.1), make `len != 1` (or `!isnothing(len)`
  beyond one step) **throw** `ArgumentError("windowed cost retrieval not yet supported")`
  rather than silently truncate. Then implement the windowed path: one metadata resolution
  + one HDF5 window read returning `Vector{<:ValueCurve}`.

### 1.6 Branch admittance with missing base voltage: silent DU return
- `PSY src/models/components.jl:106-126`: the `:siemens` → `SIEMENS`/`NU` conversion, when
  the from-bus base voltage is `nothing`, logs an un-throttled `@warn` and returns
  `value * DU` — the caller asked for siemens and receives a device-base per-unit number
  that `_strip_units` then silently unwraps. The `:ohm` twin **errors** in the same state.
- **Fix**: make `:siemens` error exactly like `:ohm` (consistent, type-stable, no per-call
  warn). If a lenient mode is truly needed, it must return `missing`, never a mislabeled
  number.

### 1.7 2W transformer Ω/S set→get round-trip drift — ⚠️ LIKELY SUPERSEDED, re-verify (see status note above)
- Setter (`components.jl:204-218`, `T <: Branch`) divides by `get_base_voltage(get_arc(c).from)`;
  getter (`components.jl:98-126`, `T <: TwoWindingTransformer`) multiplies by
  `get_base_voltage_primary(c)`. These coincide only as a construction-time snapshot;
  `set_base_voltage_primary!`, `set_arc!`, constructor kwargs, or editing the bus voltage
  desynchronize them → e.g. (230/115)² = 4× round-trip error. SU paths are consistent
  (power-only); the drift is specific to Unitful Ω/S values.
- **Fix**: add `TwoWindingTransformer`-specific Quantity setters using
  `get_base_voltage_primary`, or better, give both directions one base-voltage resolver
  per component type (falls out of the 3.1 consolidation). Add a round-trip test with
  `base_voltage_primary ≠ arc.from` voltage.

### 1.8 `RelativeQuantity` is a leaky `Number` (IS `src/relative_units.jl`)
All verified by execution:
- `(0.6*DU)*SU` silently nests: `Base.:*(a::Number, b::AbstractRelativeUnit)` (line 75)
  accepts `a::RelativeQuantity` → `RelativeQuantity{RelativeQuantity{…,DU},SU}`; downstream
  `set_value`/`convert_units` then treat DU data as SU. **Fix**: add
  `Base.:*(::RelativeQuantity, ::AbstractRelativeUnit)` (and the flipped order) that throws
  `ArgumentError("value is already unit-tagged")`.
- `zero(q)`, `iszero(q)`, `isfinite(q)` MethodError on every instance (Base instance
  fallback needs `oftype`/constructor from `Real`). **Fix**: define instance `zero`/`one`,
  `iszero`, `isnan`, `isfinite`, `abs`, and unary ops on `q.value` directly. Do **not**
  add `convert(::Type{RelativeQuantity}, ::Real)` — implicit unit-attachment is the bug
  class this design exists to prevent.
- No `Base.hash` while `==` spans value types (`RQ(1,DU) == RQ(1.0,DU)`,
  `0.0DU == -0.0DU`) → Dict/Set lookups raise KeyError for equal keys. **Fix**:
  `Base.hash(q::RelativeQuantity{<:Any,U}, h::UInt) where {U} = hash(q.value, hash(U, h))`.
- Mixed-unit `==`/`isequal`/`in` throw a cryptic promotion `ErrorException` instead of
  returning `false`. **Fix**: define cross-unit `==`/`isequal` returning `false`; keep
  ordered comparisons (`<`, `<=`, arithmetic) as errors but with an informative
  `ArgumentError` (mixing DU/SU is a user mistake worth a clear message).
- `isapprox(q, 0.6)` vs a plain `Real` throws (`MethodError` in `real`). Decide one
  semantics and implement it: recommended — error with a clear message telling the user to
  compare `ustrip`/same-tagged values; silent raw-value comparison would hide base mixups.
- Test: a dedicated `RelativeQuantity` Number-interface testset (hash/Dict/Set, zero/one,
  iszero/isfinite, mixed-unit equality false, nested-tagging error, `q^2` error message).

### 1.9 Detached-component display crashes (PSY `src/utils/print.jl:10-15`)
- `_show_accessor_value` catches the "not attached to a system" error from the SU getter
  and retries `getter_func(ist, NU)` **outside the try** — for components without their own
  `base_power` field (`Line`, `MonitoredLine`, HVDC lines, …) the NU path needs the system
  base too and rethrows the same error uncaught. REPL display of any not-yet-attached
  `Line` crashes immediately after warning "displaying in natural units".
- **Fix**: wrap the NU retry; on failure print the raw stored value annotated `(device base)`
  — never error from `show`. Test: `repr(MIME"text/plain"(), Line(nothing))` (and inside a
  vector) succeeds.

### 1.10 `display_units_arg` trait never matches parametric structs
- IS template (`src/utils/generate_structs.jl`, ~line 71) emits
  `display_units_arg(::typeof(get_X), ::Type{ {{struct_name}} })`. For parametric structs
  this is the **UnionAll singleton** — `Type{ConstantReserve{ReserveUp}} <: Type{ConstantReserve}`
  is false — so both call sites (`PSY print.jl:8`, `IS print_pt.jl:132` pass
  `typeof(component)`) get `missing` and fall back to a 1-arg getter that no longer exists.
  REPL display of any `ConstantReserve{T}` / `ConstantReserveGroup{T}` instance throws
  MethodError; `show_components(sys, ConstantReserve{ReserveUp}, [:requirement])` too.
- **Fix in the template**: emit `::Type{<:{{struct_name}}}` and regenerate PSY structs.
  Test: REPL repr of a `ConstantReserve{ReserveUp}` instance; `show_components` with a
  units column over a parametric type.

### 1.11 `ImportExportCost` compat constructor: infinite recursion
- `PSY src/models/cost_functions/ImportExportCost.jl:62-76`: the positional compat
  constructor recursively calls `ImportExportCost(...)`, which re-selects itself whenever
  the implicit constructor doesn't match — any concretely-typed services vector
  (`[my_reserve]`) or mixed-`U` curves → StackOverflowError (replica-reproduced). It is
  also dead for its stated purpose: deserialization goes through the kwarg constructor.
- **Fix**: delete it (preferred), or make it construct via the kwarg form with explicit
  same-`U` validation. Test: `ImportExportCost(nothing, nothing, 1.0, 1.0, VariableReserve{ReserveUp}[])`
  returns or throws an `ArgumentError` — never overflows.

### 1.12 `is_import_export_curve` calls `iszero(::Nothing)`
- `ImportExportCost.jl` (~line 107): `iszero(get_initial_input(...))`/`iszero(get_input_at_zero(...))`
  on `Union{Nothing, Float64}` fields — MethodError for any curve built with the documented
  3-arg `PiecewiseIncrementalCurve` form, **including the package's own `ZERO_OFFER_CURVE`
  default**.
- **Fix**: treat `nothing` explicitly (`_iszero_or_nothing(x) = isnothing(x) || iszero(x)` —
  pick the semantics intended for "is this a pure import/export curve" and test both arms).

### 1.13 `set_variable_cost!` family vs `U`-pinned cost fields
- `PSY src/models/cost_function_timeseries.jl` (~lines 367-394, 414-451):
  - `_check_power_units` validates the data against the caller's `power_units` **argument**,
    never against the cost's own `U`; `MarketBidCost{NaturalUnit}` (the default, via
    `ZERO_OFFER_CURVE`) then fails in `setproperty!` convert with a raw MethodError —
    SU/DU bids can never be set on an existing cost.
  - The same setters' validator deliberately admits `MarketBidTimeSeriesCost`, whose field
    is `CostCurve{TimeSeriesPiecewiseIncrementalCurve,U}` — assignment can never succeed.
- **Fix**: decide the model. Recommended: setters **rebuild** the cost object with the new
  `U` (costs are plain data; replace the whole `MarketBidCost{U}` on the component) and the
  validator rejects `MarketBidTimeSeriesCost` for static-curve setters with an actionable
  `ArgumentError`. Add tests: set SU bid data on a default cost; static setter on a
  TS-cost component errors cleanly.

### 1.14 `ThermalFuels.OTHEHR_BIOMASS_GAS` rename breaks old systems
- `PSY src/definitions.jl` (~line 379): renamed to `OTHER_BIOMASS_GAS` with no
  deserialization alias. Scoped enums serialize by name → loading any system saved by a
  prior release with that fuel throws `MethodError: no method matching
  _name2value(::Val{:OTHEHR_BIOMASS_GAS})` (reproduced).
- **Fix**: add a deserialization-time alias (e.g. in the JSON→enum path or data-format
  migration for the old name). Breaking renames need a migration entry, not just a PR note.
  Test: deserialize a fixture containing the old string.

### 1.15 IS enum `convert` calls an undefined function
- `IS src/Optimization/enums.jl:3` and `IS src/Simulation/enums.jl:13-14`:
  `Base.convert(::Type{ModelBuildStatus|SimulationBuildStatus|RunStatus}, ::String)` call
  `get_enum_value`, defined **nowhere in IS** (it lives in PSY) → `UndefVarError` on first
  use. No test exercises them.
- **Fix**: `@scoped_enum` already provides a String constructor — the body is `T(val)`.
  Add one conversion test per enum.

### 1.16 IS trait methods return `ArgumentError` instead of throwing
- `IS src/Optimization/optimization_container_types.jl:15, 24`:
  `convert_output_to_natural_units(::Type{<:InitialConditionType})` and
  `should_write_resulting_value(::Type{<:InitialConditionType})` **return** the
  `ArgumentError(...)` object. Boolean contexts then raise a confusing `TypeError`.
- **Fix**: `throw(...)`. Grep both files for the same pattern elsewhere.

### 1.17 `ext` serialization validation regressions (IS `src/serialization.jl`)
- The new `_is_ext_value_basic` allowlist (~line 338) rejects `Char` and plain `Base.@enum`
  values (`isstructtype` is false for primitives) that JSON3 happily serialized on `main` →
  `to_json(sys)` now errors for previously valid systems.
- The recursion uses `getfield(x, name)` without an `isdefined` guard and runs **outside**
  the `try` that wraps only `JSON.json` → an `ext` struct with an `#undef` field escapes as
  a raw `UndefRefError` instead of the friendly "cannot be serialized" error (reproduced).
- **Fix**: accept `Char` and `Base.Enum` explicitly (they JSON-serialize as strings);
  add `isdefined(x, name) || return false` in the recursion (or move it inside the try).
  Tests: ext with `Char`, a plain `@enum`, and an incompletely-initialized mutable struct.

### 1.18 Legacy `UnitSystem` enum bridge: positional only
- `IS src/production_variable_cost_curve.jl`: the compat bridge accepts the legacy enum
  positionally (~line 292) but the kwarg constructors annotate
  `power_units::AbstractUnitSystem` → `CostCurve(; value_curve = lc,
  power_units = IS.UnitSystem.SYSTEM_BASE)` (worked on `main`) now throws `TypeError`.
- **Fix**: accept `Union{AbstractUnitSystem, UnitSystem}` in the kwarg constructors and
  normalize, or delete the bridge entirely and migrate callers (it exists for
  PowerSystemCaseBuilder fixtures — check before deleting). Test the kwarg+enum form.

---

## Phase 2 — API hygiene (do after Phase 1; several overlap with Phase 3 refactors)

### 2.1 `ustrip`: three mechanisms, one collision
- IS defines its own generic `ustrip` (only method: `RelativeQuantity`) *and* `_strip_units`;
  PSY imports and **exports** IS's `ustrip` while also depending on Unitful, which exports
  its own. Consequences: `using PowerSystems, Unitful` makes unqualified `ustrip` ambiguous,
  and PSY's exported `ustrip` MethodErrors on the `Unitful.Quantity` values its own
  `*_unitful` getters return.
- **Fix**: delete `RelativeUnits.ustrip`; keep `_strip_units` as IS's single internal strip
  extension point; in PSY define `Unitful.ustrip(q::IS.RelativeQuantity) = q.value` so one
  public generic handles both quantity kinds; stop exporting `ustrip` from PSY (Unitful's
  works once PSY extends it). Migrate the internal call sites (set_value, set_base_power!).

### 2.2 Orphaned IS `get_value`/`set_value` stubs
- `IS src/InfrastructureSystems.jl:14-17` declares and exports zero-method generics that
  PSY does not extend (PSY defines its **own** functions of the same names). Two maximally
  generic exported names with no methods invite clashes.
- **Fix**: either have PSY extend `IS.get_value`/`IS.set_value` (preferred — one shared
  generic, and IS code could then call it) or delete the stubs and exports.

### 2.3 `convert_cost_coefficient` (IS `src/relative_units.jl:148-177`)
- Exported, documented, 9-method ratio table — zero callers in IS src or PSY (only its own
  tests), and its `system_base_power`/`device_base_power` arguments are power-domain
  concepts inside the module whose header says "domain-agnostic".
- **Fix**: delete from IS4 (reintroduce where the first consumer lands, presumably PSI, in
  terms of PSY's `_du_to_su_ratio`). If kept for an imminent consumer, un-export and move
  the power-specific semantics to PSY.

### 2.4 `RelativeQuantity` carries a redundant field
- `unit::U` is fully determined by the singleton type parameter (the file's own
  `zero`/`one` already reconstruct it as `U()`).
- **Fix**: drop the field (`RelativeQuantity{T,U}(value)`; `unit(q) = U()` accessor). Purely
  mechanical; do together with 1.8.

### 2.5 Misc, quick
- `IS src/outputs.jl:30`: error message says `write_output`, method is `write_outputs`.
- PSY `Project.toml` + `src/PowerSystems.jl` + `src/units/serialization.jl`: `StructTypes`
  dependency and imports are dead (zero uses) — remove.
- IS `AnyCostCurve{T}` / `AnyFuelCurve{T}` / `AnyProductionVariableCostCurve{T}` aliases
  duplicate what plain `CostCurve{T}` already means; the latter two have zero users — delete.
- Hand-rolled `deserialize(::Type{CostCurve/FuelCurve}, …)` lists fields explicitly; a
  future field would be silently dropped. Route through `deserialize_to_dict` +
  `T(; vals..., power_units = …)` so field lists come from the struct.
- IS test files copy the same `ForecastKey` fixture ~8 times — add a helper.

---

## Phase 3 — Consolidation refactors (design debt; sequence after Phases 1-2)

### 3.1 One conversion engine, not two and a half — ⚠️ PARTIALLY DELIVERED (steps 1, 3, 5 done; 2 and 4 still open — see status note above)
PSY currently has **two parallel implementations** of per-unit conversion that have already
diverged behaviorally (missing-voltage handling; CurrentCategory inversion):
- the `Val{:mva}/:ohm/:siemens` × target × component-type ladder in
  `src/models/components.jl` (`_convert_from_device_base`, ~20 methods + the hand-written
  inverse `set_value` family) — used by all generated getters;
- the category engine in `src/units/conversions.jl` (`convert_units`, `base_value`,
  `system_base_value`, `natural_unit`) — exported, but reachable in production **only**
  through the 3W winding path; its scalar form MethodErrors on real components because no
  1-arg `_get_device_base_power(::Component)` method exists (its own docstring example is
  broken).

**Target architecture** (incremental, keep tests green at each step):
1. Implement the engine's component interface once:
   `_get_device_base_power(c::Component) = _get_base_power(c)`;
   `get_base_voltage(c::Branch) = get_base_voltage(get_arc(c).from)` (already exists);
   `get_base_voltage(c::TwoWindingTransformer) = get_base_voltage_primary(c)` — making the
   getter/setter base-voltage choice single-sourced (fixes 1.7 structurally).
2. Map `Val{:mva}/:ohm/:siemens` → category via the existing `_unit_category` and make
   `_convert_from_device_base(c, v, cu, units) = convert_units(c, v, _unit_category(cu), DU, units)`
   a one-liner; same for the `set_value` inverse (add `convert_units(..., from_units, DU)`
   coverage). Delete the ladder.
3. Generalize windings as a *base provider*, not a parallel method family: a lightweight
   `WindingBase(c, winding)` view implementing the same three interface functions lets the
   entire 5-arg engine and all setters work per-winding; delete the duplicated 6-arg family
   (`conversions.jl:236-274`).
4. Derive, don't restate: `_du_to_su_ratio(c, cat) = base_value(c, cat) / system_base_value(c, cat)`
   (see 1.3), and for SU↔DU short-circuit with the power-only ratio (see 4.2). Remove the
   `::Type{Float64}` target special-case — "strip the default units" belongs to the getter
   layer (`_strip_units` ∘ `convert_units(..., DEFAULT_UNITS)`), not the engine.
5. Triplicated base-power accessor family (Component `components.jl:19-56`, System
   `base.jl`, 3W `@eval` loop `components.jl:349-381`): extract one helper over the raw
   MVA value and delegate all three.

### 3.2 Codegen: units metadata should be data, not template literals
- The template hardcodes `display_units_arg(...) = SU` for every converted accessor and
  forces `exclude_getter/exclude_setter` + ~30 hand-written lines for every exception
  (`base_power`, winding base powers, …).
- **Fix**: per-field descriptor keys (e.g. `"display_units"`, `"storage_units"`) with SU/DU
  defaults; template emits the trait from the descriptor. Hand-written accessor families
  shrink to genuinely special cases. (Do together with the 1.10 template fix to regenerate
  once.)

### 3.3 IS time-series additions: extend mechanisms instead of forking them
- `TupleTimeSeries` invents a bespoke `namedtuple_fields` serialization key while its
  sibling `TimeSeriesFunctionData{T}` uses the existing `PARAMETERS_KEY` /
  `CONSTRUCT_WITH_PARAMETERS_KEY` mechanism — generic tooling resolves one but not the
  other. Unify on the shared mechanism (extend it to structured parameters once).
- The three `TimeSeries*Curve` types pair with static counterparts by naming convention:
  three near-identical `build_static_curve` bodies, the valid-FunctionData Union restated
  5×. Add `static_curve_type(::Type{TimeSeriesIncrementalCurve}) = IncrementalCurve` (and
  a shared valid-data Union per kind) with one generic `build_static_curve`.

### 3.4 Two units paradigms coexist in PSY — write the deprecation story
- The legacy stateful system (`SystemUnitsSettings`, `set_units_base_system!`,
  `with_units_base`, `get_units_base`) survives in `base.jl` while getters/setters moved to
  explicit units. They interact only at the time-series boundary (see 1.4's semantic note).
- **Fix**: decide and document: which APIs the enum still governs, the deprecation timeline,
  and a migration guide section ("stateful → explicit units") in the PSY docs. Don't leave
  both as apparent peers.

---

## Phase 4 — Performance (hot paths; benchmark before/after with a realistic system)

### 4.1 Time-series-backed cost resolution does 3×(SQLite + HDF5) per lookup
- `IS build_static_curve` / `build_static_tuple` issue up to three independent
  `get_time_series_values(...; len = 1)` calls (function data, `initial_input`,
  `input_at_zero`); each runs a full metadata SQL query (`_execute_cached` caches only the
  prepared statement, not results) plus a 1-element HDF5 read. The consumer pattern
  (PowerSimulations: per component × per timestep) multiplies this into millions of round
  trips per simulation.
- **Fix**: implement windowed resolution (one metadata hit + one window read →
  `Vector{<:ValueCurve}`) — this is also the prerequisite for honoring `len` (1.5) — and/or
  route repeated lookups through `TimeSeriesCache`. Merge the three reads when the keys
  reference the same series.

### 4.2 DU↔SU conversions recompute voltage terms that cancel
- `convert_units(..., DU, SU)` computes `base_value/system_base_value`, fetching and
  squaring base voltages twice per call even though they cancel for
  impedance/admittance/current; on the 3W path that's 12 redundant winding-voltage
  dispatches per `get_series_admittances(t3w, SU)` during Y-bus assembly. Worse,
  `get_base_voltage(line)` (`supplemental_accessors.jl`) allocates **two strings** per call
  (`_select_fewer_significant_figures` uses `string`/`rstrip`) whenever endpoint voltages
  differ within tolerance.
- **Fix**: short-circuit relative↔relative conversions through the power-only ratio
  (= `_du_to_su_ratio` from 1.3/3.1.4); make the significant-figures tiebreak numeric
  (no string round-trip), and stop re-deriving the line base voltage per conversion.

### 4.3 Abstract-typed time-series-key fields
- `time_series_key::TimeSeriesKey` (IS `time_series_function_data.jl`, `tuple_time_series.jl`,
  and the `Union{Nothing, TimeSeriesKey}` fields on the TS curves) forces boxed loads +
  dynamic dispatch in the per-timestep resolution path and breaks isbits.
- **Fix**: parameterize on the concrete key type or declare
  `Union{Nothing, StaticTimeSeriesKey, ForecastKey}` so union-splitting applies.

### 4.4 `show_components` per-cell work
- IS `print_pt.jl` resolves `Symbol("get_$column")`, `parentmodule`, `hasproperty`, and the
  `display_units_arg` double-dynamic dispatch **inside** the row loop (rows × columns).
- **Fix**: hoist a per-column vector of `(getter, units_arg)` before the loop.

---

## Security review result

A dedicated security pass (parsers, SQL construction, deserialization type resolution,
eval/codegen, path handling) found **no high-confidence vulnerabilities** in either branch:
SQL stays parameterized in the metadata store; unit-string parsing is a hardcoded
allowlist (no `eval`/`uparse` of data); the only new `@eval` iterates hardcoded symbols at
load time; psy6 removes the legacy parser tree (net attack-surface reduction); the new
`ext` validation is stricter than `main` (modulo the 1.17 bugs). No action items.

---

## Suggested order & verification

1. Phase 0 (version/compat) — small, unblocks everything else being releasable.
2. Phase 1 items 1.3, 1.6, 1.8, 1.11, 1.12, 1.15, 1.16, 1.17 (small, independent, test-backed).
3. Phase 1 items 1.1 + 1.2 + 1.7 together with the 3.1 consolidation steps 1-3 (they share
   the winding/base-provider mechanics) — this is the core units-correctness milestone.
4. Phase 1 items 1.4, 1.5 with 4.1 (shared time-series boundary work), then 1.9, 1.10 (one
   regeneration), 1.13, 1.14, 1.18.
5. Phase 2, then remaining Phase 3, then Phase 4 with benchmarks.

After each milestone: full PSY + IS test suites, the formatter, and a CHANGELOG entry.
Definition of done for the units work: a single conversion engine; every getter/setter
target documented in docstrings actually dispatches (grep for `units` docstring claims and
test MW/Ω/S/DU/SU/NU per component family); `RelativeQuantity` passes a Number-interface
testset; old-system deserialization fixtures load.
