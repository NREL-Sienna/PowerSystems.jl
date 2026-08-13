#!/usr/bin/env julia
#
# PowerFlowFileParser -> OpenAPI document -> PowerSystems, over a directory of PSS/E or
# MATPOWER cases.
#
#   julia --project=scripts/pffp_openapi_roundtrip \
#         scripts/pffp_openapi_roundtrip/roundtrip.jl --dir path/to/cases
#
#   --dir DIR      directory of cases (default: the sibling PowerFlowFileParser.jl/SSWG)
#   --recurse      also descend into subdirectories
#   --limit N      stop after N cases
#   --out FILE     JSON Lines results, one object per case
#   --keep-json    leave each case's document on disk instead of deleting it
#
# Why a script and not a testset: the pipeline spans two packages that must not depend on
# each other (PowerFlowFileParser has no PowerSystems dependency, by design), and the corpus
# it is meant to cover — ERCOT SSWG cases at ~23 MB of RAW each, ~60 MB of JSON and ~250k
# components apiece — is far too large to commit as a fixture. Point `--dir` at a local
# corpus and read the summary.
#
# Each case is run through five stages and the stage it stops at is recorded, so one bad case
# never hides the rest of the corpus:
#
#   parse           PFP.PowerModelsData(raw)
#   build_openapi   PFP.build_openapi_system(pm)
#   to_json         PFP.to_json(oapi, path)
#   read_document   PC.read_document(path)
#   from_openapi    PSY.from_openapi(PSY.System, doc)
#
# Exit status is 1 when any case fails, so this can gate a manual verification run.

import JSON

using PowerFlowFileParser
const PFP = PowerFlowFileParser
using PowerCoreOpenAPIModels
const PC = PowerCoreOpenAPIModels
using PowerSystems
const PSY = PowerSystems

"""The SSWG corpus in the sibling PowerFlowFileParser checkout, the corpus this was written
against. Not committed anywhere — pass `--dir` for any other location."""
const DEFAULT_DIR =
    joinpath(dirname(pkgdir(PowerSystems)), "PowerFlowFileParser.jl", "SSWG")

function parse_args(argv)
    dir = DEFAULT_DIR
    limit = typemax(Int)
    out = "pffp_roundtrip_results.jsonl"
    recurse = false
    keep_json = false
    i = 1
    while i <= length(argv)
        arg = argv[i]
        if arg == "--dir"
            dir = argv[i + 1]
            i += 2
        elseif arg == "--limit"
            limit = parse(Int, argv[i + 1])
            i += 2
        elseif arg == "--out"
            out = argv[i + 1]
            i += 2
        elseif arg == "--recurse"
            recurse = true
            i += 1
        elseif arg == "--keep-json"
            keep_json = true
            i += 1
        else
            error("unknown argument $arg")
        end
    end
    return (; dir, limit, out, recurse, keep_json)
end

function collect_cases(dir, recurse)
    cases = String[]
    for (root, _dirs, files) in walkdir(dir)
        if !recurse && root != dir
            continue
        end
        for file in files
            if endswith(file, ".raw") || endswith(file, ".m")
                push!(cases, joinpath(root, file))
            end
        end
    end
    return sort(cases)
end

"""The exception's own message, capped so one enormous error cannot swamp the results file."""
function brief(e)
    io = IOBuffer()
    showerror(io, e)
    return first(String(take!(io)), 4000)
end

_sidecar(::Nothing, _json_path) = nothing
_sidecar(named::AbstractString, json_path) = joinpath(dirname(json_path), named)

"""
Run one case through every stage, returning a record of where it stopped.

`rec["stage"]` is the stage that was in flight, so a failure names the boundary it died on
rather than just the exception; on success it reads "done".
"""
function run_case(path, workdir, keep_json)
    rec = Dict{String, Any}("case" => basename(path), "stage" => "start", "ok" => false)
    json_path = joinpath(workdir, string(first(basename(path), 60), ".json"))
    try
        rec["stage"] = "parse"
        rec["t_parse"] = @elapsed pm = PFP.PowerModelsData(path)

        rec["stage"] = "build_openapi"
        rec["t_build"] = @elapsed oapi = PFP.build_openapi_system(pm)
        rec["component_types"] = sort(collect(PFP.component_type_names(oapi)))

        rec["stage"] = "to_json"
        rec["t_json"] = @elapsed PFP.to_json(oapi, json_path; force = true)
        rec["json_mb"] = round(filesize(json_path) / 1e6; digits = 1)

        rec["stage"] = "read_document"
        rec["t_read"] = @elapsed doc = PC.read_document(json_path)

        rec["stage"] = "from_openapi"
        ts_file = PC.get_time_series_storage_file(doc)
        rec["t_psy"] = @elapsed sys = PSY.from_openapi(
            PSY.System, doc;
            time_series_storage_path = _sidecar(ts_file, json_path),
        )

        rec["stage"] = "done"
        rec["ok"] = true
        rec["n_components"] = length(collect(PSY.get_components(PSY.Component, sys)))
        rec["n_buses"] = length(collect(PSY.get_components(PSY.ACBus, sys)))
    catch e
        rec["error_type"] = string(typeof(e))
        rec["error"] = brief(e)
    finally
        keep_json || rm(json_path; force = true)
    end
    for key in ("t_parse", "t_build", "t_json", "t_read", "t_psy")
        haskey(rec, key) && (rec[key] = round(rec[key]; digits = 2))
    end
    return rec
end

function report(results)
    passed = count(r -> r["ok"], results)
    println("\n==== $passed / $(length(results)) cases completed the round trip ====")
    for r in results
        r["ok"] && continue
        println("FAIL  $(r["case"])")
        println("      stage=$(r["stage"])  $(get(r, "error_type", ""))")
        println("      $(first(get(r, "error", ""), 400))")
    end
    types = Set{String}()
    for r in results
        union!(types, get(r, "component_types", String[]))
    end
    if !isempty(types)
        println("\ncomponent types emitted across the corpus: ", join(sort(collect(types)), ", "))
    end
    return passed == length(results)
end

function main()
    a = parse_args(ARGS)
    isdir(a.dir) || error("--dir $(a.dir) is not a directory")
    cases = collect_cases(a.dir, a.recurse)
    isempty(cases) && error("no .raw or .m cases found under $(a.dir)")
    cases = cases[1:min(a.limit, length(cases))]
    @info "running $(length(cases)) cases from $(a.dir)"

    workdir = mktempdir()
    results = Dict{String, Any}[]
    open(a.out, "w") do io
        for (i, case) in enumerate(cases)
            println(stderr, "[$i/$(length(cases))] $(basename(case))")
            flush(stderr)
            rec = run_case(case, workdir, a.keep_json)
            push!(results, rec)
            println(io, JSON.json(rec))
            flush(io)
            println(stderr, rec["ok"] ? "    OK" : "    FAIL at $(rec["stage"])")
            flush(stderr)
        end
    end
    println("\nper-case records: $(a.out)")
    exit(report(results) ? 0 : 1)
end

main()
