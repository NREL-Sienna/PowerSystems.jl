# Parallelization Proposal for `_pti_to_powermodels!`

## Executive Summary

The `_pti_to_powermodels!` function in `src/parsers/pm_io/psse.jl` (lines 2206-2320) processes PSS(R)E data by calling multiple `_psse2pm_*` conversion functions sequentially. This proposal outlines strategies to parallelize the conversion process while respecting critical ordering requirements.

## Current Implementation Analysis

### Function Structure

The function calls 14 different `_psse2pm_*` functions in a specific order:

```julia
# Group 1: Metadata (Independent)
_psse2pm_interarea_transfer!(pm_data, pti_data, import_all)
_psse2pm_area_interchange!(pm_data, pti_data, import_all)
_psse2pm_zone!(pm_data, pti_data, import_all)

# Group 2: Buses (Must be first)
_psse2pm_bus!(pm_data, pti_data, import_all)

# Group 3: Network topology (Depends on buses)
_psse2pm_branch!(pm_data, pti_data, import_all)
_psse2pm_switch_breaker!(pm_data, pti_data, import_all)
_psse2pm_multisection_line!(pm_data, pti_data, import_all)
_psse2pm_transformer!(pm_data, pti_data, import_all)

# Group 4: Injectors (Depends on buses + topology)
_psse2pm_load!(pm_data, pti_data, import_all)
_psse2pm_shunt!(pm_data, pti_data, import_all)
_psse2pm_generator!(pm_data, pti_data, import_all)
_psse2pm_facts!(pm_data, pti_data, import_all)

# Group 5: Additional components (Independent of each other, depend on buses)
_psse2pm_dcline!(pm_data, pti_data, import_all)
_psse2pm_impedance_correction!(pm_data, pti_data, import_all)
_psse2pm_substation_data!(pm_data, pti_data, import_all)
_psse2pm_storage!(pm_data, pti_data, import_all)
```

### Critical Dependencies (from code comments)

1. **Line 2229-2230**: "Order matters here. Buses need to be parsed first"
2. **Line 2231-2232**: "Branches need to be parsed after buses to find topologically connected buses"
3. **Line 2236-2237**: "Injectors need to be parsed after branches and transformers to find topologically connected buses"

### Dependency Analysis

**Bus Processing** (`_psse2pm_bus!`):
- No dependencies
- Creates `pm_data["bus"]` dictionary
- Initializes `pm_data["connected_buses"]` set (if isolated buses exist)
- Thread-safety issue: Uses dictionary with integer keys

**Branch/Topology Processing**:
- **Dependencies**: Requires `pm_data["bus"]` to be complete
- **Example** (line 176-178 of `_psse2pm_branch!`):
  ```julia
  bus_from = pm_data["bus"][sub_data["f_bus"]]
  sub_data["base_voltage_from"] = bus_from["base_kv"]
  ```
- **Writes**: Modifies `pm_data["connected_buses"]` set (lines 180-184)
- Thread-safety issue: Multiple functions push to `pm_data["connected_buses"]`

**Injector Processing** (loads, shunts, generators, facts):
- **Dependencies**: Requires buses and topology to be complete
- **Shared function**: `_determine_injector_status` (line 341-377)
  - Reads `pm_data["bus"][gen_bus]` (line 359)
  - Reads `pm_data["connected_buses"]` (line 360)
  - Modifies `pm_data["bus"][gen_bus]["bus_status"]` (lines 364, 368)
  - Modifies `pm_data[bus_conversion_list]` (line 363)
- Thread-safety issues: Multiple concurrent modifications to bus status and conversion lists

## Parallelization Strategies

### Strategy 1: Intra-Function Parallelization (Recommended First Step)

Parallelize the loops **within** each `_psse2pm_*` function that process individual data items.

#### Advantages
- Minimal architectural changes
- Respects existing function ordering
- Easier to implement incrementally
- Targets the actual computational bottleneck

#### Implementation Approach

**A. Simple cases (no shared state modification):**

Functions that only append to arrays without reading shared state can use `Threads.@threads`:

```julia
function _psse2pm_area_interchange!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E AreaInterchange data into a PowerModels Dict..."

    if haskey(pti_data, "AREA INTERCHANGE")
        n = length(pti_data["AREA INTERCHANGE"])
        temp_data = Vector{Dict{String,Any}}(undef, n)

        Threads.@threads for i in 1:n
            area_int = pti_data["AREA INTERCHANGE"][i]
            sub_data = Dict{String, Any}()
            # ... transform data ...
            temp_data[i] = sub_data
        end

        pm_data["area_interchange"] = temp_data
    else
        pm_data["area_interchange"] = []
    end
end
```

**B. Cases with read-only shared state:**

Functions like `_psse2pm_branch!` that read `pm_data["bus"]` but only write to local results:

```julia
function _psse2pm_branch!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Branch data into a PowerModels Dict..."

    if haskey(pti_data, "BRANCH")
        branches = pti_data["BRANCH"]
        n = length(branches)
        temp_data = Vector{Union{Dict{String,Any}, Nothing}}(undef, n)

        # Thread-local collections for connected buses
        thread_local_connected = [Set{Int}() for _ in 1:Threads.nthreads()]

        Threads.@threads for i in 1:n
            branch = branches[i]
            tid = Threads.threadid()

            if !haskey(branch, "I") || !haskey(branch, "J")
                temp_data[i] = nothing
                continue
            end

            if first(branch["CKT"]) != '@' && first(branch["CKT"]) != '*'
                sub_data = Dict{String, Any}()
                sub_data["f_bus"] = branch["I"]
                sub_data["t_bus"] = branch["J"]

                # Read from shared pm_data["bus"] (thread-safe read)
                bus_from = pm_data["bus"][sub_data["f_bus"]]
                bus_to = pm_data["bus"][sub_data["t_bus"]]

                # Store connected buses in thread-local set
                if pm_data["has_isolated_type_buses"]
                    if !(bus_from["bus_type"] == 4 || bus_to["bus_type"] == 4)
                        push!(thread_local_connected[tid], sub_data["f_bus"])
                        push!(thread_local_connected[tid], sub_data["t_bus"])
                    end
                end

                # ... rest of transformation ...
                temp_data[i] = sub_data
            else
                temp_data[i] = nothing
            end
        end

        # Merge thread-local results
        if pm_data["has_isolated_type_buses"]
            for local_set in thread_local_connected
                union!(pm_data["connected_buses"], local_set)
            end
        end

        # Filter out nothing entries
        pm_data["branch"] = filter(!isnothing, temp_data)
    else
        pm_data["branch"] = []
    end
end
```

**C. Cases with complex shared state (injectors):**

For functions like `_psse2pm_load!` that call `_determine_injector_status`:

```julia
function _psse2pm_load!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Load data into a PowerModels Dict..."

    if haskey(pti_data, "LOAD")
        loads = pti_data["LOAD"]
        n = length(loads)
        temp_data = Vector{Dict{String,Any}}(undef, n)

        # Thread-local state tracking
        n_threads = Threads.nthreads()
        thread_local_bus_conversions = [Set{Int}() for _ in 1:n_threads]
        thread_local_bus_status = [Dict{Int,Bool}() for _ in 1:n_threads]

        Threads.@threads for i in 1:n
            load = loads[i]
            tid = Threads.threadid()
            sub_data = Dict{String, Any}()

            sub_data["load_bus"] = load["I"]
            # ... other transformations ...

            # Modified _determine_injector_status that returns status info
            # instead of directly modifying pm_data
            status, should_convert, new_bus_status =
                _determine_injector_status_parallel(
                    load,
                    pm_data,
                    sub_data["load_bus"],
                    "STATUS"
                )

            sub_data["status"] = status

            if should_convert
                push!(thread_local_bus_conversions[tid], sub_data["load_bus"])
                thread_local_bus_status[tid][sub_data["load_bus"]] = new_bus_status
            end

            sub_data["index"] = i
            temp_data[i] = sub_data
        end

        # Merge thread-local state changes
        for local_conversions in thread_local_bus_conversions
            union!(pm_data["candidate_isolated_to_pq_buses"], local_conversions)
        end

        for local_status in thread_local_bus_status
            for (bus, status) in local_status
                pm_data["bus"][bus]["bus_status"] = status
            end
        end

        pm_data["load"] = temp_data
    else
        pm_data["load"] = []
    end
end
```

### Strategy 2: Inter-Function Parallelization (Advanced)

Run independent groups of functions concurrently using `Threads.@spawn` or `@async`.

#### Dependency Graph

```
Level 0: metadata group (parallel)
  ├─ _psse2pm_interarea_transfer!
  ├─ _psse2pm_area_interchange!
  └─ _psse2pm_zone!

Level 1: buses (sequential - must complete first)
  └─ _psse2pm_bus!

Level 2: topology group (parallel - all depend on buses)
  ├─ _psse2pm_branch!
  ├─ _psse2pm_switch_breaker!
  ├─ _psse2pm_multisection_line!
  └─ _psse2pm_transformer!

Level 3: injector group (parallel - all depend on Level 2)
  ├─ _psse2pm_load!
  ├─ _psse2pm_shunt!
  ├─ _psse2pm_generator!
  └─ _psse2pm_facts!

Level 4: additional components (parallel - all depend on buses)
  ├─ _psse2pm_dcline!
  ├─ _psse2pm_impedance_correction!
  ├─ _psse2pm_substation_data!
  └─ _psse2pm_storage!
```

#### Implementation

```julia
function _pti_to_powermodels!(
    pti_data::Dict;
    import_all = false,
    validate = true,
    correct_branch_rating = true,
    parallel = true,  # New parameter
)::Dict
    pm_data = Dict{String, Any}()

    # ... initial setup ...

    if parallel
        # Level 0: Metadata (can run in parallel)
        tasks = [
            Threads.@spawn _psse2pm_interarea_transfer!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_area_interchange!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_zone!(pm_data, pti_data, import_all)
        ]
        wait.(tasks)

        # Level 1: Buses (must complete before next level)
        _psse2pm_bus!(pm_data, pti_data, import_all)

        # Level 2: Topology (can run in parallel)
        tasks = [
            Threads.@spawn _psse2pm_branch!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_switch_breaker!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_multisection_line!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_transformer!(pm_data, pti_data, import_all)
        ]
        wait.(tasks)

        # Level 3: Injectors (can run in parallel)
        tasks = [
            Threads.@spawn _psse2pm_load!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_shunt!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_generator!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_facts!(pm_data, pti_data, import_all)
        ]
        wait.(tasks)

        # Level 4: Additional components (can run in parallel)
        tasks = [
            Threads.@spawn _psse2pm_dcline!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_impedance_correction!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_substation_data!(pm_data, pti_data, import_all),
            Threads.@spawn _psse2pm_storage!(pm_data, pti_data, import_all)
        ]
        wait.(tasks)
    else
        # Original sequential implementation
        _psse2pm_interarea_transfer!(pm_data, pti_data, import_all)
        # ... etc
    end

    # ... rest of function ...
end
```

#### Caveat

Inter-function parallelization provides limited benefit because:
1. Many functions must wait for their dependencies
2. The actual bottleneck is processing thousands of items within each function
3. Only provides speedup proportional to the number of functions in each parallel group

## Thread Safety Considerations

### Safe Patterns

1. **Read-only shared data**: Multiple threads can safely read from `pm_data["bus"]`
2. **Pre-allocated arrays with index assignment**: `temp_data[i] = sub_data` is thread-safe
3. **Thread-local collections**: Each thread maintains its own Set/Dict, merged afterward

### Unsafe Patterns (Must Avoid)

1. **Concurrent dictionary writes**: `pm_data["branch"][key] = value` from multiple threads
2. **Concurrent set modifications**: `push!(pm_data["connected_buses"], bus_id)` from multiple threads
3. **Resizing arrays**: `push!(pm_data["load"], sub_data)` from multiple threads

### Required Modifications

1. **Replace `push!` with pre-allocated arrays**
2. **Use thread-local collections for accumulation**
3. **Merge thread-local results after parallel section**
4. **Create `_determine_injector_status_parallel` variant** that returns state changes instead of modifying shared data

## Performance Expectations

### Theoretical Speedup

For a system with `N` threads and data with `M` items to process:
- **Intra-function parallelization**: Up to `N×` speedup per function
- **Inter-function parallelization**: Limited by dependency chains, typically 1.5-2× at best

### Practical Considerations

- **Overhead**: Thread creation and synchronization have costs
- **Amdahl's Law**: Sequential portions limit total speedup
- **Memory bandwidth**: May become bottleneck with many threads
- **Best use case**: Large PSS(R)E files with thousands of buses/branches

### Recommended Heuristic

Only use parallelization when:
```julia
n_items > 1000  # Threshold where overhead is justified
```

## Implementation Roadmap

### Phase 1: Foundation (Low Risk)
1. Add `parallel` parameter to `_pti_to_powermodels!` (default `false`)
2. Parallelize simple functions with no shared state:
   - `_psse2pm_interarea_transfer!`
   - `_psse2pm_area_interchange!`
   - `_psse2pm_zone!`
3. Add tests to verify correctness

### Phase 2: Topology Processing (Medium Risk)
1. Parallelize `_psse2pm_branch!` with thread-local sets
2. Parallelize `_psse2pm_transformer!`
3. Parallelize `_psse2pm_switch_breaker!`
4. Parallelize `_psse2pm_multisection_line!`
5. Validate `connected_buses` set is correctly merged

### Phase 3: Injector Processing (Higher Risk)
1. Create `_determine_injector_status_parallel` helper
2. Parallelize `_psse2pm_generator!`
3. Parallelize `_psse2pm_load!`
4. Parallelize `_psse2pm_shunt!`
5. Parallelize `_psse2pm_facts!`
6. Extensive testing of bus status modifications

### Phase 4: Inter-Function (Optional)
1. Implement dependency-aware task spawning
2. Benchmark to verify benefit justifies complexity
3. Consider only if Phase 1-3 insufficient

## Testing Requirements

1. **Correctness**: Results must match sequential version exactly
2. **Thread safety**: Test with various thread counts (1, 2, 4, 8, 16)
3. **Performance**: Benchmark with different file sizes
4. **Edge cases**:
   - Empty sections
   - Isolated buses
   - Large systems (>10k buses)
5. **Determinism**: Multiple runs should produce identical results

## Benchmarking Plan

```julia
using BenchmarkTools

# Test files of varying sizes
files = [
    "small_system.raw",     # ~100 buses
    "medium_system.raw",    # ~1000 buses
    "large_system.raw",     # ~10000 buses
    "xlarge_system.raw",    # ~50000 buses
]

for file in files
    println("Benchmarking: $file")

    # Sequential
    @btime parse_psse($file, parallel=false)

    # Parallel
    for nthreads in [2, 4, 8, 16]
        @info "Testing with $nthreads threads"
        @btime parse_psse($file, parallel=true)
    end
end
```

## Recommendations

### Immediate Actions
1. **Implement Phase 1** (simple functions) as proof of concept
2. **Create comprehensive test suite** for parallelization
3. **Benchmark on representative data** to validate speedup

### Priority Order
1. **Highest ROI**: `_psse2pm_branch!` - Often largest data section
2. **High ROI**: `_psse2pm_generator!`, `_psse2pm_load!` - Large sections
3. **Medium ROI**: `_psse2pm_transformer!` - Moderate size
4. **Lower ROI**: Metadata functions - Small data sections

### Configuration
- Add `JULIA_NUM_THREADS` environment variable documentation
- Default `parallel=true` only when `Threads.nthreads() > 1`
- Add logging to indicate when parallel mode is active

## Alternative: Using ThreadsX.jl or FLoops.jl

For simpler implementation, consider adding ThreadsX.jl dependency:

```julia
using ThreadsX

function _psse2pm_branch!(pm_data::Dict, pti_data::Dict, import_all::Bool)
    @info "Parsing PSS(R)E Branch data into a PowerModels Dict..."

    if haskey(pti_data, "BRANCH")
        pm_data["branch"] = ThreadsX.map(pti_data["BRANCH"]) do branch
            # Transform logic here
            return sub_data
        end |> collect |> filter_valid_branches
    end
end
```

Benefits:
- Cleaner syntax
- Automatic load balancing
- Well-tested thread safety

Drawbacks:
- Additional dependency
- Less control over thread-local state management

## Conclusion

Parallelization of `_pti_to_powermodels!` is feasible and potentially beneficial for large PSS(R)E files. The recommended approach is **intra-function parallelization** using `Threads.@threads` with thread-local state accumulation. This provides:

- Significant speedup potential (especially for large files)
- Manageable implementation complexity
- Backward compatibility
- Incremental deployment path

The key challenges are managing shared state modifications and ensuring deterministic results. With careful implementation and thorough testing, this can provide meaningful performance improvements for users processing large power system datasets.
