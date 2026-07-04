# Task 6 — Units-discipline sweep of PSY non-generated source

## Scope

Find every read of a `needs_conversion` field in non-generated `src/` that bypasses the
units-aware getter, plus hand-written accessors of unit-bearing data that take no units
argument. Classify each; fix genuine base-boundary violations only.

## Methodology actually used

1. **Field list.** Descriptor top-level key is `auto_generated_structs` (not the brief's
   `struct_data`); adapted the extraction. JSON3 is not a direct dep of the bare/test env, so
   parsed with `python3`. Result: **72 distinct convertible field names**
   (`.claude/convertible_fields.txt`).
2. **Property-read sweep.** `grep -rn "\.$f\b"` per field over `src/`, excluding
   `src/models/generated/` and `\.$f *=` writes → **53 raw hits**
   (`.claude/units_sweep_hits.txt`).
3. **Assignment-filter audit.** Re-ran the sweep without the `.field =` exclusion and diffed:
   the filter dropped **zero** lines (no `.field =` writes matched), so the hit set is complete
   for comparisons/`==` too.
4. **`getfield`/`getproperty` sweep.** The `.field` grep cannot see dynamic-symbol reads
   (`getfield(line, field)`, `getproperty(xfrm, field)`), so grepped those separately for
   convertible-field symbols. Found the two `branchdata_checks.jl` `getfield` reads plus the
   transformer `getproperty` reads.
5. **Brief-named candidates.** `src/checks.jl` does not exist (checks live in
   `src/utils/IO/branchdata_checks.jl` + `src/base.jl`). `src/models/cost_function_timeseries.jl`
   → `src/models/cost_functions/` and `cost_function_timeseries.jl`: no raw convertible-field
   property reads.
6. **Base-boundary reasoning.** For each real code hit, checked whether the raw device-base (DU)
   number crosses a base boundary: compared/combined with another component's value or a
   system-base quantity, exported/printed as another base, or returned from a non-getter API.
   Crucially, established which owning types actually *have* a device base (a `base_power` field)
   vs. those where device base == system base.

## Verdict histogram

| Verdict | Count |
|---|---|
| OK-DU-internal | 24 |
| OK-getter-body | 0 |
| VIOLATION | 0 |
| VIOLATION-SUSPECT | 2 |
| Non-hit (comment/docstring false positive) | 29 |
| **Total classified raw hits** | **53** |

(Two SUSPECTs are counted from the `getfield`/known-finding audit, not from the 53 `.field`
hits; the 53 `.field` hits split 24 OK-DU-internal + 29 comment false-positives.)

## Classification of every hit

### Comment / docstring false positives (29) — Non-hit

The `\.$f\b` pattern matches `e.g.`-style prose and Markdown where a period precedes a
field-name-lookalike (mostly single-letter fields `g`, `b`, `x`). None are code.

| file:line | why non-hit |
|---|---|
| src/base.jl:46,460,550,588,608,1540 | docstring/comment prose |
| src/definitions.jl:17,41,72,494,648,649 | enum/docstring prose |
| src/emissions_data.jl:125 | docstring |
| src/models/components.jl:36,60,99,187 | docstring/comment/error-string prose (`e.g.`→`.g`) |
| src/models/cost_functions/LoadCost.jl:8 | docstring |
| src/models/generation.jl:26 | comment (`valid_range` JSON example) |
| src/models/supplemental_accessors.jl:35,442 | docstring/comment |
| src/units/types.jl:22 | docstring |
| src/units/conversions.jl:329 | comment |

### OK-DU-internal (24)

**`src/models/serialization.jl:161,164,167** — `deserialize_uuid_or_value` (Union
introspection). `field_type.b` / `field_type.a` are `Union` type members, not component fields;
base-agnostic deserialization plumbing.

**`src/base.jl:3199-3210` (Line→MonitoredLine) and `:3246-3256` (MonitoredLine→Line)** —
`convert_component!`. Raw field copies into a new component. Both types lack a `base_power`
field (device base == system base), and no base_power crosses, so the copy is trivially
same-base. Constructor/conversion plumbing.

**`src/base.jl:3287-3290`** — `convert_component!(PowerLoad→StandardLoad)`. Raw DU field copies
(`active_power`, `reactive_power`, `max_active_power`). The new `StandardLoad` is constructed
with `base_power = _get_base_power(old_load)` (same device base preserved, line 3286), so the
copied DU values remain correct. Already documented in-code (lines 3280-3281). Constructor
plumbing.

**`src/utils/IO/branchdata_checks.jl:122,123`** — `line_rating_calculation`. `l.r`, `l.x` are
device-base per-unit impedances; `y_mag` is device-base pu admittance; `new_rate` is device-base
pu, written back to the device-base `rating` field (`correct_rate_limits!` line 156). All device
base in → device base out → stored in device-base field. Same-base internal (validation).

**Transformer `check_rating_values` `getproperty` reads (branchdata_checks.jl:204,230)** — read
`xfrm.rating`/`xfrm.x` (DU) and immediately convert to MW via `* _get_base_power(xfrm)` (device
base) or compare against a base-invariant per-unit reactance range. Correct same-base pattern —
this is the *reference* for how the Line path should read (see SUSPECT-1). OK-DU-internal.

## VIOLATION-SUSPECTs (2) — left for the controller, not fixed

### SUSPECT-1 — `check_rating_values(::Union{Line,MonitoredLine}, basemva)` reads raw DU rating and compares against a system-base threshold

- **File:** `src/utils/IO/branchdata_checks.jl:98` (loop body); reached from exported
  `check_ac_transmission_rate_values` (`src/base.jl:2393-2403`) and from
  `validate_component_with_system`→`correct_rate_limits!`→`check_rating_values`.
- **Enclosing function:** `check_rating_values(line::Union{Line,MonitoredLine}, basemva)`.
- **The concern:** `rating_value = getfield(line, :rating)` is a **device-base** pu number, but
  the caller passes `basemva = _get_base_power(sys)` (**system** base). The code then does
  `rating_value * basemva` for the MW display and compares `rating_value >= closest_rate_range.max
  / basemva` (system-base pu). That mixes device-base pu against a system-base threshold — the
  exact base-boundary shape a VIOLATION would take.
- **Why SUSPECT and not VIOLATION (why not fixed):** neither `Line` nor `MonitoredLine` has a
  `base_power` field, so for these types device base **equals** system base and
  `getfield(line, :rating) == get_rating(line, SU)` **always**. The number computed today is
  correct; there is no numeric difference to demonstrate. The brief's own bar for a genuine
  VIOLATION is a regression test showing the numeric difference the bug would cause, and that
  test is **impossible to write** — a `Line` cannot be given `device_base = 250` because it has
  no base_power field, and `_sys_with_thermal` builds a `ThermalStandard`, not a based branch.
- **Contrast (the tell):** the sibling `check_rating_values(::TwoWindingTransformer, ::Float64)`
  (line 189) *ignores* the passed system base and correctly uses
  `device_base_power = _get_base_power(xfrm)` with MW comparisons (no `/basemva`). Transformers
  *do* have a device base, so that path had to be written robustly; the Line path is written
  fragilely and only survives because Line has no device base.
- **Recommendation for controller:** low-risk hardening — replace `getfield(line, field)` with the
  SU getter (`get_rating`/`get_rating_b`/`get_rating_c`, which passthrough `nothing`) so the read
  is base-correct by construction and matches convention C6 ("treat every bare get on a
  convertible field as a defect"). This is behavior-preserving today. It cannot carry a
  numeric-difference regression test, so it does not meet this task's VIOLATION-fix bar; flagging
  rather than fixing per the honesty rule. Applied and reverted during this task to confirm it
  compiles cleanly.

### SUSPECT-2 — `_set_units_base!` reads `units_info` with no nothing-guard (known prior finding)

- **File:** `src/base.jl:574-582`, specifically `units_info = IS.get_units_info(get_internal(c))`
  (575) then `old_base_value = units_info.base_value` (576).
- **Enclosing function:** `_set_units_base!(c::Component, settings::UnitSystem)`, reached from the
  deliberately-kept display API `with_units_base` / `set_units_base_system!`.
- **The concern:** for a **detached** component `IS.get_units_info(...)` returns `nothing`, so
  `nothing.base_value` throws a raw `FieldError` on the display path. The parallel
  `_get_system_base_power` (`src/models/components.jl:1-5`) guards this with
  `isnothing(units_info) && error("Component $(get_name(c)) is not attached to a system.")` and
  gives a helpful message.
- **Why SUSPECT and not VIOLATION (why not fixed):** this is an error-message/robustness defect,
  **not** a base-crossing units bug — no raw DU number is combined/exported in a wrong base. It
  also lives in the display-only API that global-constraints marks as "deliberately kept — do NOT
  delete or deprecation-mark." Touching it is a judgment call for the controller.
- **Recommendation for controller:** add the same nothing-guard as `_get_system_base_power`
  (an `isnothing(units_info) && error(...)` line after 575) so the detached-component path errors
  helpfully instead of a `FieldError`. Style-compliant (predicate guard, no sentinel return).

## Additional observations (out of units scope)

- `src/base.jl:3290` copies `old_load.max_active_power` into **`max_constant_reactive_power`**
  (line 3289 already copies it into `max_constant_active_power`). Looks like a copy-paste
  field-mapping bug (reactive slot fed by the active field), independent of units. Flagged for the
  controller; not touched.

## Tests

No confirmed VIOLATION → no fix → no new regression test added (would be untestable per the
numeric-difference bar; see SUSPECT-1). `test_units` filter: **84/84 pass** (unchanged from
baseline), 22.3 s. No net source change from this task (SUSPECT-1 fix was applied then reverted
after establishing it cannot demonstrate a numeric difference).

## Concerns / notes for Task 9 review gate

- The Line `check_rating_values` fragility (SUSPECT-1) is a real latent trap: adding a
  `base_power` field to `Line`/`MonitoredLine` later, or reusing this function for a based branch
  type, would silently reintroduce a rating² -vs- rating class of base error. Worth the low-risk
  getter swap even though it is not testably a bug today.
- `_set_units_base!` nothing-guard (SUSPECT-2) is a trivially safe robustness fix in kept code.
- The `max_constant_reactive_power` copy-paste (above) is unrelated to units but was surfaced by
  the sweep; recommend a separate fix.
