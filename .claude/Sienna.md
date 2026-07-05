# Sienna Programming Practices — psy6 / Sienna 1.0 line

General practices and cross-package architecture for the **psy6 (Sienna 1.0) development line**. This file is intended to be **identical across every repo under `/home/jdlara/Sienna_work/psy6/`** — package-specific guidance belongs in that repo's `.claude/CLAUDE.md`, and workspace wiring/policy in `/home/jdlara/Sienna_work/psy6/CLAUDE.md`. The psy5 (released) line at the workspace top level has its own copy of this file; never mix checkouts between the two lines.

## Start here (fresh-session reading order)

1. This file — shared practices, the stack, and the vocabulary (glossary at the end).
2. The current repo's `.claude/CLAUDE.md` — package specifics, verified commands, gotchas.
3. `/home/jdlara/Sienna_work/psy6/CLAUDE.md` — workspace architecture, design decisions, seams, and the knowledge index (audit, active plans).
4. `/home/jdlara/Sienna_work/CLAUDE.md` — the two-line workspace layout and git/test policy.

If you are porting anything from the psy5 line (or reading psy5-era docs/PRs), read the psy5 → psy6 translation map below first — many psy5 facts are actively wrong here.

## The psy6 stack and change blast radius

Acyclic DAG. Each package owns one concept and depends only on layers below. **A change in any package can break every layer above it — plan to run the affected downstream suites, not just the package you edited.**

```
Layer 0  InfrastructureSystems (IS, branch IS4)     data infra: SystemData, containers, time
                                                     series, serialization, struct codegen,
                                                     RelativeUnits (SU/DU/NU)
         InfrastructureOptimizationModels (IOM)     domain-neutral optimization layer:
                                                     OptimizationContainer, Decision/Emulation
                                                     models, stores, settings
Layer 1  PowerSystems (PSY, branch psy6)            the power data model on IS: System,
                                                     ~210 generated component types,
                                                     explicit-units getters. NO parsers.
Layer 2  PowerNetworkMatrices (PNM, branch psy6)    Ybus/PTDF/LODF/MODF, ContingencySpec,
                                                     network reductions (owns them exclusively)
         PowerFlowFileParser (main, IS-only dep)    Matpower/PSSE raw → Dict; the ONLY parser
Layer 3  PowerFlows (PF, branch psy6)               AC/DC power flow, PowerFlowData, PSSE export
         PowerOperationsModels (POM)                power optimization on IOM+PNM+PSY+PF;
                                                     PSI ≈ POM + IOM in this line
Support  PowerSystemCaseBuilder (PSB, branch psy6)  test-system registry + serialized cache
```

Blast-radius quick reference — after changing:

- **IS** → recompile/smoke every other package; time-series, serialization, and units changes are highest risk.
- **PSY** → PNM, PF, POM, PSB all consume it; also **clear PSB's `data/serialized_system/` cache** (no version-aware invalidation) and check SiennaSchemas drift (schemas mirror PSY fields).
- **PNM** → PF and POM iterate its reduction maps and matrices; matrix/reduction-map/KLU-cache changes break them, sometimes latently.
- **PF** → POM consumes it via `ext/PowerFlowsExt` and `PowerFlowEvaluator`.
- **IOM** → POM implements its stubs and (today) calls many non-exported `IOM._*` helpers; treat that surface as load-bearing.
- **SiennaSchemas** → both generated model packages (Julia + Python) and the SiennaGridDB unit registry regenerate from it.

Downstream smoke check after upstream edits:

```sh
julia --project=/home/jdlara/Sienna_work/psy6 -e 'using PowerNetworkMatrices, PowerFlows, PowerOperationsModels, PowerSystemCaseBuilder'
```

## The data/schema pipeline (SiennaSchemas → OpenAPI models → SiennaGridDB)

The psy6 platform adds a language-neutral data architecture alongside the Julia stack:

```
SiennaSchemas (hand-written draft-07 JSON Schemas + Core/units.json unit vocabulary)
  ├─ datamodel-codegen  ──▶ power-openapi-models   (Python / pydantic v2)
  ├─ openapi-generator  ──▶ PowerOpenAPIModels     (5 Julia packages)
  └─ generate_unit_registry.py ──▶ SiennaGridDB    (SQLite schema + sealed unit registry)
```

- **SiennaSchemas is the single source of truth**; the model packages and the GridDB unit registry are generated — never hand-edit generated output (fixes go in the schemas or the generator/post-processing scripts).
- Schemas mirror PSY component types field-for-field but use **natural units and integer-id references** (PSY internals are per-unit). `Core/units.json` is the unit vocabulary; `x-unit` annotations must validate against it.
- **The serialize/deserialize loop is NOT closed yet**: no converter exists between a PSY6 `System` and the OpenAPI model types or GridDB rows. That bridge is the next stage. Until then, consistency is held by validators (`validate_units.py`, the GridDB registry generator, schema↔GridDB↔PSY-descriptor sync checks) — treat schema/PSY field drift as a defect to surface, not to silently absorb.

## psy5 → psy6 translation map (for porting code and knowledge)

Anything read from psy5 repos, PSI PRs, or older docs must be translated:

| psy5 concept | psy6 equivalent |
|---|---|
| PowerSimulations.jl (PSI) | split into IOM (domain-neutral core) + POM (power formulations); simulation orchestration is **not ported** |
| `set_units_base_system!` stateful global units | explicit-unit getters/setters (`get_x(c, PSY.SU)`, tagged setters); the old API survives as display-only |
| `PM.AbstractPowerModel` / PowerModels re-exports | POM-native `DCPPowerModel`/`ACPPowerModel` structs (POM embeds its own PM submodule) |
| PSY `src/parsers/` (Matpower/PSSE/tabular) | PowerFlowFileParser.jl — the sole parser |
| `OptimizationProblemResults`, `RunStatus.SUCCESSFULLY_FINISHED` | `IOM.OptimizationProblemOutputs`, `RunStatus.SUCCESSFULLY_FINALIZED` |
| "never modify PSI `src/core/optimization_container.jl`" | same rule, now IOM `src/core/optimization_container.jl` |
| LODF-based security constraints; generator-side G-1 | branch-side MODF (`VirtualMODF`/`ContingencySpec`); gen-side G-1 removed — do not reintroduce |
| `IS.UnitSystem` enum (cost curves, serialization) | unit marker as type parameter: `CostCurve{T,U}` with `SystemBaseUnit()` etc. |
| PSY serialization ⇄ external tools | JSON+HDF5 device-base serialization unchanged; the OpenAPI/GridDB path is new and its converter does not exist yet |
| "PSI PR #NNNN added X" | check POM `.claude/pom_port_plan.md` before assuming X exists in POM |

The psy5 repos remain the richer source for *numerics and domain* knowledge (PNM solver rules, PF solver design, PSB cache semantics) — that transfers; the *API and package* facts above do not.

## Breaking-release policy (no shims)

psy6 is a planned breaking release. **No compat shims, no deprecation aliases, no defensive deserialization for renamed enums, no changelog entries.** Fix callers instead of bridging; regenerate old serialized systems. Structural cleanups are cheaper now than after 1.0 ships — the window closes at release. (Sanctioned exception: PSB's `psy6_compat.jl`, scoped to pre-psy6 external artifact data.)

## Explicit units (SU / DU / NU)

The single most important psy6 correctness rule. The stateful `set_units_base_system!` global is display-only; unit-bearing values flow through explicit-unit APIs:

- Markers `SU` (system base), `DU` (device base), `NU` (natural, MW/MVA) live in `IS.RelativeUnits`; `RelativeQuantity` carries the base in its type. Cross-unit arithmetic/comparison throws.
- Getters on convertible fields take the unit system explicitly: `PSY.get_rating(br, PSY.SU)`. Setters take **tagged** values and reject bare floats: `set_rating_b!(line, 0.9 * PSY.SU)`.
- **In optimization/power-flow build code, every PSY getter on a convertible field passes `PSY.SU`** (models are all-system-base). PNM aggregators already return system base. A bare `PSY.get_*` on a convertible field in consumer code is a defect.
- Angle limits are radians (no base conversion) — don't "fix" them with SU.
- Wrong objective/limit/rating magnitudes after a refactor → suspect units first.

## Silent-failure patterns — never extend

These exist in the codebase and are flagged for removal; new code must error loudly with context (type, name, expectation) instead:

- missing time series → `@debug` + skip the device (POM `add_parameters`)
- missing validation descriptor → validation silently passes (IS)
- non-converged power flow → NaN-poisoned `PowerFlowData` (PF)
- no `isnothing(x) && continue` absence-sentinel guards; no `Union{Nothing,T}` return sentinels — use a Bool predicate + an accessor that always returns a concrete value.

## Environments and testing in the psy6 workspace

- **Shared dev env:** `julia --project=/home/jdlara/Sienna_work/psy6` dev-wires all co-developed packages (rebuild with `psy6/wire_psy6.jl`). A dev'd dependency's own `[sources]` pins are ignored by the parent env — only the active project's count; that is why the shared env exists.
- **Per-package `Pkg.test()` honors that package's own `[sources]` git pins**, not the shared env. To test against local checkouts, temporarily repoint that repo's `test/Project.toml` `[sources]` to local paths (restore before finishing).
- **No version/compat bumps in any Project.toml until release** (PSY reads 5.10.0, IS 3.6.0 despite being the 6.0/4.0 lines). Bumps have reappeared spontaneously mid-session — revert them.
- PSB cache: no version-aware invalidation — clear `data/serialized_system/` after PSY changes; the CaseData artifact download can flake (retry once).
- Python tooling: use `python3` (never `python`); the units venv is `/home/jdlara/Sienna_work/psy6/.venv-units`; **`just` is not installed** — run the underlying commands from the `.justfile` directly.

## Performance Requirements

**Priority:** Critical. See the [Julia Performance Tips](https://docs.julialang.org/en/v1/manual/performance-tips/). Apply with judgment — focus optimization on hot paths and frequently called code, not every function.

### Anti-Patterns to Avoid

- **Type instability** — functions must return consistent concrete types. Check with `@code_warntype`. Bad: `f(x) = x > 0 ? 1 : 1.0`; good: `f(x) = x > 0 ? 1.0 : 1.0`.
- **Abstract field types** — struct fields must be concrete or parameterized. Bad: `struct Foo; data::AbstractVector; end`; good: `struct Foo{T<:AbstractVector}; data::T; end`.
- **Untyped containers** — use `Vector{Float64}()`, not `Vector{Any}()` / `Vector{Real}()`.
- **Non-const globals** — use `const THRESHOLD = 0.5`. (No type annotation needed on a `const`; the compiler already infers it.)
- **Unnecessary allocations** — use views (`@view`/`@views`), pre-allocate instead of `push!` in loops, use in-place (`!`) operations.
- **Captured variables** — avoid closures that box captured variables; pass them as arguments instead.
- **Splatting penalty** — avoid `...` in performance-critical code.
- **Abstract return types** — avoid returning `Union`s or abstract types.

#### Runtime type checking (`isa` and `<:`) — the canonical rule

**ABSOLUTELY FORBIDDEN unless the user explicitly asks for it.** Never use `isa` or `<:` (subtype) checks to branch on types in a function body — use multiple dispatch instead. Using `<:` to branch is just `isa` with extra steps.

- Bad: `if x isa Float64 ... elseif x isa Int ... end`
- Bad: `if typeof(x) <: AbstractVector ... end`
- Bad: `if T <: SomeAbstractType ... else ... end` (branching on a type parameter)
- Good: `f(x::AbstractVector) = sum(x); f(x::Number) = x`

**Why:** runtime type checks force the compiler to handle multiple paths at runtime, lose type information, prevent specialization, and trigger runtime compilation — defeating Julia's performance model. The only acceptable uses of `isa` are filtering inside a `catch` block (where dispatch is unavailable) and, sanctioned in IS, inside `serialize`/`deserialize` bodies.

### Best Practices

- Use `@inbounds` when bounds are verified; use broadcasting for element-wise ops.
- Avoid `try-catch` in hot paths; use function barriers to isolate type instability.

## Code Conventions

Style guide: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/style/>

**Always run the formatter after completing each task — before reporting it done. This is not optional.** Run the package's formatter script (the script self-activates its own environment):

```sh
julia --project=scripts/formatter -e 'include("scripts/formatter/formatter_code.jl")'
```

This applies after any change to `.jl` files. Treat the formatter's output as authoritative; do not manually revert its changes.

Key rules:

- Constructors: use `function Foo()`, not `Foo() = ...`
- Asserts: prefer `InfrastructureSystems.@assert_op` over `@assert`
- Globals: `UPPER_CASE` for constants; exports: all in the main module file
- Comments: complete sentences; describe why, not how; default to no comment
- Nothing checks: use `isnothing(x)` / `!isnothing(x)`, not `x === nothing` / `x !== nothing`
- Type checks: use multiple dispatch, never `isa`/`<:` branching — see the canonical rule above
- Conditionals: prefer `if/else` over the ternary `? :`
- Zero checks: use `iszero(x)`, never `x == 0` / `f(x) == 0.0`
- Explicit `function … end` with explicit `return` for any non-trivial body; assignment form only for genuine one-liners
- Cache lookups: use the lazy closure form `get!(dict, key) do ... end` (only evaluates on a miss). Never use 3-arg `get!(dict, key, default)` when `default` is expensive — Julia evaluates arguments eagerly, so `default` runs on every call and silently defeats the cache.
- User-facing code (tutorials, docs, public APIs): use `get_*` getters, never dot field access. Getter bodies may use dot access internally.

## Documentation Practices and Requirements

Framework: [Diataxis](https://diataxis.fr/). Sienna guides:

- Explanation / best practices: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/explanation/>
- Tutorials: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/write_a_tutorial/> (script format via Literate.jl: <https://fredrikekre.github.io/Literate.jl/v2/>)
- How-to's: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/write_a_how-to/>
- API docstrings: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/write_docstrings_org_api/>

Docstrings: cover all public-interface elements; include signatures + argument lists; automate with `DocStringExtensions.TYPEDSIGNATURES` (`TYPEDFIELDS` sparingly); add "see also" links for same-named (multiple-dispatch) functions. API docs: public in `docs/src/api/public.md` via `@autodocs` (`Public=true, Private=false`); internals in `docs/src/api/internals.md`.

**The documentation must build for the effort to be accepted.** This is an acceptance criterion for any change, not only documentation work — docstring, export, and public-API edits routinely break the build. Confirm it before reporting done; a broken docs build is a task failure, not a warning:

```sh
julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'   # first time
julia --project=docs docs/make.jl                                                              # must finish without errors
```

Fix Documenter `missing_docs` by registering docstrings in `@autodocs`/`@docs`, never by silencing with `warnonly`.

## Design Principles

- Elegance and concision in both interface and implementation
- Fail fast with actionable error messages rather than hiding problems
- Validate invariants explicitly in subtle cases
- Avoid over-adherence to backwards compatibility for internal helpers (and, in this line, for public ones — see the no-shims policy)

## Contribution Workflow

**The default branch for all Sienna packages is `main`, not `master`** — but note the psy6 checkouts sit on their line branches (`IS4`, `psy6`, feature branches); diff against the correct base. Branch naming: `feature/description` or `fix/description`. Never commit, stage, or push without an explicit ask; leave changes unstaged (`git add -N` for new files so they show in `git diff`).

## Testing Guidelines

**Test custom logic, not language guarantees.** Do not write tests that only verify Julia's built-in behavior.

Avoid: `@test obj isa SomeType` when the type hierarchy makes it tautological; testing that a plain data-holder struct stores the value it was constructed with; testing `==`/`isequal`/`hash` inherited from a parent with no added logic; duplicating a test with trivially different inputs that exercise no new code path.

Instead test: custom dispatch logic and predicates you defined; type-mapping tables and accessors (where typos hide); serialization round-trips; custom `show`/display formatting; validation logic, error paths, and edge cases.

**Constraint math and numerics deserve coefficient-level ground truth.** The MODF suite's pattern — assert JuMP `AffExpr` coefficients equal the corresponding `VirtualMODF` columns — is the template: compare built model coefficients against an independently computed reference, not just objective values or convergence flags.

## Julia Environment Best Practices

**CRITICAL: always run Julia with `julia --project=<env>`** — never bare `julia` or `julia --project` without specifying the environment. Each package defines its environments under `test/`, `docs/`, and `scripts/formatter/`.

```sh
julia --project=test test/runtests.jl                       # full test suite
julia --project=test test/runtests.jl test_file_name        # a single test file (runner-dependent)
julia --project=test -e 'using Pkg; Pkg.instantiate()'      # instantiate test env
julia --project=docs docs/make.jl                           # build docs
```

Test runners differ per repo (ReTest name filters vs `@includetests` file stems vs POM's ParallelTestRunner) — see each repo's `CLAUDE.md` for its exact, verified commands. Compile-check after each edit (`julia --project=<env> -e 'using PackageName'`) before moving on.

## AI Agent Guidance

**Priorities:** read existing patterns first; maintain consistency; use concrete types in hot paths; add docstrings to public API; consider downstream-package impact (see blast radius above); ensure tests pass. **Then run the formatter and never edit auto-generated files** (IS `src/generated/`, PSY `src/models/generated/`, OpenAPI model packages, GridDB `unit_registry.sql`). The rules most often violated:

- **Never use `isa`/`<:` for runtime type branching** — use multiple dispatch.
- **Always run the formatter** before reporting a task done.
- **The docs must build** — in repos with a `docs/` build, the effort is not accepted until `julia --project=docs docs/make.jl` completes without errors.
- **Never pass a bare float to a unit-bearing setter or call a convertible getter without a unit argument** in consumer code.
- Mirror existing structure when adding a parallel implementation (alternate solver/formulation/backend) so validation is a mechanical comparison.

## Troubleshooting

- **Tests fail unexpectedly / packages missing:** re-instantiate — `julia --project=test -e 'using Pkg; Pkg.instantiate()'`.
- **Poor performance, many allocations:** run `@code_warntype` on the suspect function.
- **`UndefVarError` during precompile for a symbol that "should" exist:** mismatched upstream branch in a dev checkout — verify the upstream repo is on its psy6-line branch.
- **A PSB-built system deserializes strangely after a PSY change:** stale cache — clear `data/serialized_system/` or pass `force_build=true`.
- **Wrong magnitudes (rating², limits, objective) after a refactor:** units first — audit every `PSY.get_*` on convertible fields for the explicit-unit argument.

## Glossary (platform vocabulary)

- **psy5 / psy6** — the released line (workspace top level) vs this breaking Sienna 1.0 line (`psy6/` folder). Same package may exist in both; never mix checkouts.
- **IS, PSY, PNM, PF, PFFP, IOM, POM, PSB** — InfrastructureSystems, PowerSystems, PowerNetworkMatrices, PowerFlows, PowerFlowFileParser, InfrastructureOptimizationModels, PowerOperationsModels, PowerSystemCaseBuilder (see stack diagram).
- **PSI** — PowerSimulations.jl, the psy5 operations package. Does not exist here: PSI ≈ IOM + POM.
- **SU / DU / NU** — system-base / device-base / natural-units markers (`IS.RelativeUnits`); a `RelativeQuantity` is a number tagged with one (`0.9 * PSY.SU`).
- **System / Component** — PSY's container and its typed contents (~210 generated component types); mutate only via `add_component!`/setters, read via `get_*`.
- **Arc** — directed (from, to) bus pair underlying branches; orientation carries sign meaning in Ybus/PTDF/flows.
- **Ybus / PTDF / LODF / MODF** — admittance matrix; power-transfer, line-outage, and modified-outage distribution factors. `Virtual*` variants compute rows lazily with an LRU cache.
- **ContingencySpec** — PNM's N-1 modification descriptor; feeds POM's branch-side security constraints via `VirtualMODF`.
- **Network reduction** — PNM-owned topology simplification (radial, degree-2, Ward, zero-impedance, parallel/series merge). `NetworkReductionData` is the consumer-facing map set; consumers never re-derive it.
- **Formulation** — a model variant selected by type, not flags: POM `DeviceModel{Device,Formulation}`/`NetworkModel{F}`; PF formulation×solver type parameters.
- **Two-stage construction** — POM `construct_device!` runs `ArgumentConstructStage` (variables/parameters/expressions) then `ModelConstructStage` (constraints/objective).
- **ProblemTemplate / DecisionModel / EmulationModel** — IOM's problem description and model wrappers; POM's `PowerOperationModel` chain hangs off `IOM.AbstractOptimizationProblem`.
- **Result key** — `"VariableType__ComponentType"` string (e.g. `"FlowActivePowerVariable__Line"`) read from `IOM.OptimizationProblemOutputs` via `read_variable(res, key; table_format=TableFormat.WIDE)`.
- **PSB fixture** — a named test system from `build_system(Category, "name")`, cached on disk under `data/serialized_system/` with **no version-aware invalidation**.
- **SiennaSchemas / x-unit / units.json** — hand-written JSON-schema source of truth mirroring PSY types in natural units; `x-unit` annotations validate against the `Core/units.json` vocabulary.
- **GridDB** — SiennaGridDB's SQLite schema; its unit registry is generated from `units.json` and sha256-sealed.
- **OpenAPI models** — generated transport types (Julia `PowerOpenAPIModels`, Python `power-openapi-models`); zero PSY/IS deps. The System ⇄ OpenAPI ⇄ GridDB converter is the not-yet-built bridge.
- **`[sources]` / shared env** — Project.toml git/path pins vs the workspace env at `psy6/Project.toml` that dev-wires all packages; a dev'd dependency's own `[sources]` are ignored by the parent env.
- **no-shims** — the breaking-release policy: fix callers, regenerate data, no compat layers (single sanctioned exception: PSB `psy6_compat.jl`).
