# Hand-written: the file-level entry points, `from_file` / `to_file`.
#
# A serialized System is a directory holding two members:
#
#     case/
#       system.json      the OpenAPI document (PowerCoreOpenAPIModels writes/reads it)
#       time_series.h5   the HDF5 sidecar (PSY writes/reads it, via IS's storage layer)
#
# The split of labor is the point. PowerCoreOpenAPIModels owns JSON <-> SystemDocument and
# never opens HDF5; PSY owns SystemDocument <-> System and owns the sidecar. The document
# records only the sidecar's *basename* (`time_series_storage_file`), so the pair moves
# together and the layout stays this file's choice rather than the container's.
#
# These replace the removed `System(::AbstractString)` constructor and `to_json`/`from_json`.

"""Document member of a serialized System directory."""
const SYSTEM_DOCUMENT_FILE = "system.json"

"""HDF5 sidecar member of a serialized System directory."""
const TIME_SERIES_FILE = "time_series.h5"

"""
Whether `sys` has any time series, and therefore needs a sidecar written.

A system with none gets no `time_series.h5` at all and a null `time_series_storage_file`,
rather than an empty HDF5 file that would imply the data went missing.
"""
has_time_series_data(sys::System) = !iszero(IS.get_num_time_series(sys.data))

function _prepare_bundle_dir(dir::AbstractString, force::Bool)
    if !isdir(dir)
        mkpath(dir)
        return nothing
    end
    for member in (SYSTEM_DOCUMENT_FILE, TIME_SERIES_FILE)
        path = joinpath(dir, member)
        if isfile(path) && !force
            throw(
                IS.DataFormatError(
                    "$path already exists; pass force = true to overwrite the bundle",
                ),
            )
        end
        # Removed rather than truncated: Hdf5TimeSeriesStorage appends to an existing file,
        # so a stale sidecar would leave orphaned series behind in the new bundle.
        if force
            rm(path; force = true)
        end
    end
    return nothing
end

"""
$(TYPEDSIGNATURES)

Write `sys` to `dir` as a `system.json` + `time_series.h5` bundle.

`unit_system` is passed through to [`to_openapi`](@ref): `:original` (default) reproduces the
document `sys` was read from and needs the round-trip ledger, while `:device_base` and
`:natural_units` force a convention and work for any system.

The sidecar is written only when `sys` actually carries time series; otherwise the document's
`time_series_storage_file` is null and no HDF5 file is created.
"""
function to_file(
    sys::System,
    dir::AbstractString;
    unit_system::Symbol = :original,
    force::Bool = false,
    pretty::Bool = false,
)
    _prepare_bundle_dir(dir, force)
    storage_path = _sidecar_path_for_write(sys, dir)
    doc =
        to_openapi(sys; unit_system = unit_system, time_series_storage_path = storage_path)
    PC.write_document(
        doc,
        joinpath(dir, SYSTEM_DOCUMENT_FILE);
        pretty = pretty,
        force = force,
    )
    @info "Serialized System to $dir"
    return nothing
end

function _sidecar_path_for_write(sys::System, dir::AbstractString)
    return _sidecar_path_for_write(Val(has_time_series_data(sys)), dir)
end

_sidecar_path_for_write(::Val{false}, ::AbstractString) = nothing
_sidecar_path_for_write(::Val{true}, dir::AbstractString) = joinpath(dir, TIME_SERIES_FILE)

"""
$(TYPEDSIGNATURES)

Read a `System` from a `dir` written by [`to_file`](@ref).

The sidecar is located by the document's own `time_series_storage_file`, resolved relative to
`dir` — so a bundle stays readable after being moved or renamed. A document that names a
sidecar which is not present errors rather than yielding a system silently missing its time
series.

`system_kwargs` pass through to the `System` being built (`time_series_in_memory`,
`time_series_directory`, `runchecks`, ...).
"""
function from_file(::Type{System}, dir::AbstractString; system_kwargs...)
    document_path = joinpath(dir, SYSTEM_DOCUMENT_FILE)
    if !isfile(document_path)
        throw(
            IS.DataFormatError(
                "$dir is not a serialized System bundle: no $SYSTEM_DOCUMENT_FILE in it",
            ),
        )
    end
    doc = PC.read_document(document_path)
    return from_openapi(
        System,
        doc;
        time_series_storage_path = _resolve_sidecar(doc, dir),
        system_kwargs...,
    )
end

"""
Absolute path of the sidecar the document names, or `nothing` when it names none.

Errors when the document names a file that is absent: the alternative is a `System` quietly
missing every time series the document declared.
"""
function _resolve_sidecar(doc::PC.SystemDocument, dir::AbstractString)
    named = PC.get_time_series_storage_file(doc)
    return _resolve_sidecar(named, dir)
end

_resolve_sidecar(::Nothing, ::AbstractString) = nothing

function _resolve_sidecar(named::AbstractString, dir::AbstractString)
    path = joinpath(dir, named)
    if !isfile(path)
        throw(
            IS.DataFormatError(
                "the document names time_series_storage_file=\"$named\" but $path does " *
                "not exist — refusing to build a System missing its time series",
            ),
        )
    end
    return path
end
