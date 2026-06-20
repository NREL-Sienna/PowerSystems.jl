# Sienna Programming Practices

General programming practices and conventions that apply across all Sienna packages (PowerSystems.jl, PowerSimulations.jl, PowerFlows.jl, PowerNetworkMatrices.jl, InfrastructureSystems.jl, etc.). This file is intended to be **identical across every Sienna repository** — package-specific guidance belongs in that package's `CLAUDE.md`, not here.

## Performance Requirements

**Priority:** Critical. See the [Julia Performance Tips](https://docs.julialang.org/en/v1/manual/performance-tips/). Apply with judgment — focus optimization on hot paths and frequently called code, not every function.

### Anti-Patterns to Avoid

- **Type instability** — functions must return consistent concrete types. Check with `@code_warntype`. Bad: `f(x) = x > 0 ? 1 : 1.0`; good: `f(x) = x > 0 ? 1.0 : 1.0`.
- **Abstract field types** — struct fields must be concrete or parameterized. Bad: `struct Foo; data::AbstractVector; end`; good: `struct Foo{T<:AbstractVector}; data::T; end`.
- **Untyped containers** — use `Vector{Float64}()`, not `Vector{Any}()` / `Vector{Real}()`.
- **Non-const globals** — use `const THRESHOLD = 0.5`. (No type annotation needed on a `const`; the compiler already infers it — annotating gives no precompilation benefit.)
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

**Why:** runtime type checks force the compiler to handle multiple paths at runtime, lose type information, prevent specialization, and trigger runtime compilation — defeating Julia's performance model. The only acceptable use of `isa` is filtering inside a `catch` block, where dispatch is unavailable.

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
- Comments: complete sentences; describe why, not how
- Nothing checks: use `isnothing(x)` / `!isnothing(x)`, not `x === nothing` / `x !== nothing`
- Type checks: use multiple dispatch, never `isa`/`<:` branching — see the runtime type-checking rule above
- Conditionals: prefer `if/else` over the ternary `? :`, especially in multi-line expressions
- Cache lookups: use the lazy closure form `get!(dict, key) do ... end` (only evaluates on a miss). Never use 3-arg `get!(dict, key, default)` when `default` is expensive — Julia evaluates arguments eagerly, so `default` runs on every call and silently defeats the cache.

## Documentation Practices and Requirements

Framework: [Diataxis](https://diataxis.fr/). Sienna guides:

- Explanation / best practices: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/explanation/>
- Tutorials: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/write_a_tutorial/> (script format via Literate.jl: <https://fredrikekre.github.io/Literate.jl/v2/>)
- How-to's: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/write_a_how-to/>
- API docstrings: <https://sienna-platform.github.io/InfrastructureSystems.jl/stable/docs_best_practices/how-to/write_docstrings_org_api/>

Docstrings: cover all public-interface elements (IS is selective about exports); include signatures + argument lists; automate with `DocStringExtensions.TYPEDSIGNATURES` (`TYPEDFIELDS` sparingly); add "see also" links for same-named (multiple-dispatch) functions. API docs: public in `docs/src/api/public.md` via `@autodocs` (`Public=true, Private=false`); internals in `docs/src/api/internals.md`.

**The documentation must build to succeed.** Before considering any documentation-affecting task complete, confirm the docs build cleanly — a broken docs build is a task failure, not a warning. Documenter treats missing docstring references, broken `@ref` links, and failing doctests as errors:

```sh
julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'   # first time
julia --project=docs docs/make.jl                                                              # must finish without errors
```

Where the package provides a docstring-coverage checker, also run it so every exported symbol is documented (this is enforced in CI):

```sh
julia --project=test scripts/check_docstrings.jl <PackageName>
```

## Design Principles

- Elegance and concision in both interface and implementation
- Fail fast with actionable error messages rather than hiding problems
- Validate invariants explicitly in subtle cases
- Avoid over-adherence to backwards compatibility for internal helpers

## Contribution Workflow

**The default branch for all Sienna packages is `main`, not `master`.** Branch naming: `feature/description` or `fix/description`. Workflow: create a feature branch → follow the style guide and run the formatter → ensure tests pass → submit a pull request.

## Testing Guidelines

**Test custom logic, not language guarantees.** Do not write tests that only verify Julia's built-in behavior.

Avoid: `@test obj isa SomeType` when the type hierarchy makes it tautological; testing that a plain data-holder struct stores the value it was constructed with; testing `==`/`isequal`/`hash` inherited from a parent with no added logic; duplicating a test with trivially different inputs that exercise no new code path.

Instead test: custom dispatch logic and predicates you defined; type-mapping tables and accessors (where typos hide); serialization round-trips; custom `show`/display formatting; validation logic, error paths, and edge cases.

## Julia Environment Best Practices

**CRITICAL: always run Julia with `julia --project=<env>`** — never bare `julia` or `julia --project` without specifying the environment, or required packages won't be available. Each package defines its environments under `test/`, `docs/`, and `scripts/formatter/`.

```sh
julia --project=test test/runtests.jl                       # full test suite
julia --project=test test/runtests.jl test_file_name        # a single test file
julia --project=test -e 'using Pkg; Pkg.instantiate()'      # instantiate test env
julia --project=docs docs/make.jl                           # build docs
```

(See each repo's `CLAUDE.md` for its exact, verified commands and test-runner style.)

## AI Agent Guidance

**Priorities:** read existing patterns first; maintain consistency; use concrete types in hot paths; add docstrings to public API; consider downstream-package impact; ensure tests pass. **Then run the formatter and never edit auto-generated files.** The two rules most often violated:

- **Never use `isa`/`<:` for runtime type branching** — use multiple dispatch (see the canonical rule above).
- **Always run the formatter** (`julia --project=scripts/formatter -e 'include("scripts/formatter/formatter_code.jl")'`) before reporting a task done.

## Troubleshooting

- **Tests fail unexpectedly / packages missing:** re-instantiate — `julia --project=test -e 'using Pkg; Pkg.instantiate()'`.
- **Poor performance, many allocations:** run `@code_warntype` on the suspect function (see the performance anti-patterns above).
