# A serialized System is written as either:
#   - format = :json    a directory holding system.json (the OpenAPI document, written/read
#                        via PowerOpenAPIModels) + time_series.h5 + time_series.h5.sqlite (the
#                        InfraStore sidecar PSY writes/reads via IS's storage layer)
#   - format = :sienna   the same three files, tar+gzip'd into one `.sn` file
#
# The document records only the sidecar's basename, so the pair moves together.

"""Document member of a serialized System directory."""
const SYSTEM_DOCUMENT_FILE = "system.json"

"""HDF5 sidecar member of a serialized System directory."""
const TIME_SERIES_FILE = "time_series.h5"

"""Extension for a single-file, compressed System archive."""
const SIENNA_ARCHIVE_EXTENSION = ".sn"

"""
Whether `sys` has any time series, and therefore needs a sidecar written.

A system with none gets no `time_series.h5` at all and a null `time_series_storage_file`,
rather than an empty HDF5 file that would imply the data went missing.
"""
has_time_series_data(sys::System) = !iszero(IS.get_num_time_series(sys.data))

"""
Warn when `sys` carries state the OpenAPI document format cannot represent, so a `to_file`
round trip does not silently drop it. There is no plan yet for either.
"""
function _warn_on_bundle_data_loss(sys::System)
    if !isempty(get_subsystems(sys))
        @warn "System has user-defined subsystems; to_file/from_file does not represent " *
              "them, and they will not survive the round trip."
    end
    if !isempty(IS.get_masked_components(Component, sys.data))
        @warn "System has masked components; to_file/from_file does not guarantee they " *
              "survive the round trip."
    end
    return nothing
end

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

Write `sys` to `path`.

# The `format` keyword

  - `:json` (default) — `path` is a directory; writes `system.json` + `time_series.h5` +
    `time_series.h5.sqlite` into it (the sidecar files only when `sys` has time series).
  - `:sienna` — `path` is a single file (conventionally ending `.sn`); writes the same three
    members into a temporary directory and archives it with `Tar` + gzip.

# The `unit_system` keyword

`unit_system` is passed through to [`to_openapi`](@ref) (as its `power_units` keyword — that
function's own name is unchanged; it predates and is independent of this keyword) and chooses
the basis every value in the document is written on:

  - `:component_base` (default) writes each component's values on its own `base_power`, the
    convention PSY stores natively. Nothing is converted, so the numbers on disk are the
    numbers in memory and the round trip is exact.
  - `:natural_units` converts on the way out to physical units — MW, MVAr, MVA — which is
    what a reader outside Sienna generally wants.

Both are complete: any `System` exports either way, whatever it was built from. **`format =
:sienna` only ever writes `:component_base`** — that is the representation PSY stores natively,
so it costs no conversion pass over every component, and the archive format is chosen
specifically to be cheap to produce. Passing `unit_system = :natural_units` (or anything other
than `:component_base`) together with `format = :sienna` throws rather than silently ignoring
the keyword or paying the conversion cost the format exists to avoid.

Note the asymmetry between writing and reading `:json`. **A write is uniform**: PSY does not
track a per-component basis, so the choice made here stamps every power-bearing blob in the
document with the same value. **A read is per component**: each blob is converted according to
the unit system it carries, so a document written by another client with a mixed basis is read
back correctly, and a blob missing the field is an error rather than a guess (see
`from_openapi`). Writing then reading therefore returns what you exported regardless of which
basis you chose.

`sys.subsystems`/masked components have no representation in the document; `to_file` warns
(does not error) when either is present.
"""
function to_file(
    sys::System,
    path::AbstractString;
    format::Symbol = :json,
    unit_system::Symbol = :component_base,
    force::Bool = false,
    pretty::Bool = false,
)
    _warn_on_bundle_data_loss(sys)
    if format === :json
        _to_file_json(sys, path; unit_system = unit_system, force = force, pretty = pretty)
    elseif format === :sienna
        if unit_system !== :component_base
            error(
                "format = :sienna only ever writes :component_base (it is the cheapest " *
                "representation to produce); got unit_system = $unit_system",
            )
        end
        _to_file_sienna(sys, path; force = force, pretty = pretty)
    else
        error("format = $format is not supported. Use :json or :sienna.")
    end
    return nothing
end

function _to_file_json(
    sys::System,
    dir::AbstractString;
    unit_system::Symbol,
    force::Bool,
    pretty::Bool,
)
    _prepare_bundle_dir(dir, force)
    storage_path = _sidecar_path_for_write(sys, dir)
    doc =
        to_openapi(sys; power_units = unit_system, time_series_storage_path = storage_path)
    PD.write_document(
        doc,
        joinpath(dir, SYSTEM_DOCUMENT_FILE);
        pretty = pretty,
        force = force,
    )
    @info "Serialized System to $dir"
    return nothing
end

function _to_file_sienna(
    sys::System,
    path::AbstractString;
    force::Bool,
    pretty::Bool,
)
    if isfile(path) && !force
        throw(
            IS.DataFormatError(
                "$path already exists; pass force = true to overwrite the archive",
            ),
        )
    end
    mktempdir() do dir
        bundle = joinpath(dir, "case")
        _to_file_json(
            sys,
            bundle;
            unit_system = :component_base,
            force = true,
            pretty = pretty,
        )
        open(CodecZlib.GzipCompressorStream, path, "w") do io
            Tar.create(bundle, io)
        end
    end
    @info "Serialized System to $path"
    return nothing
end

function _sidecar_path_for_write(sys::System, dir::AbstractString)
    return _sidecar_path_for_write(Val(has_time_series_data(sys)), dir)
end

_sidecar_path_for_write(::Val{false}, ::AbstractString) = nothing
_sidecar_path_for_write(::Val{true}, dir::AbstractString) = joinpath(dir, TIME_SERIES_FILE)

"""
$(TYPEDSIGNATURES)

Read a `System` written by [`to_file`](@ref). `path` may be a `:json`-format directory or a
`:sienna` `.sn` archive — the format is inferred from `path` (a directory, or an archive file).

The sidecar is located by the document's own `time_series_storage_file`, resolved relative to
the bundle directory — so a bundle stays readable after being moved or renamed. A document that
names a sidecar which is not present errors rather than yielding a system silently missing its
time series.

`system_kwargs` pass through to the `System` being built (`time_series_in_memory`,
`time_series_directory`, `runchecks`, ...).
"""
function from_file(path::AbstractString; system_kwargs...)
    if isdir(path)
        return _from_file_json(path; system_kwargs...)
    elseif lowercase(splitext(path)[2]) == SIENNA_ARCHIVE_EXTENSION
        return _from_file_sienna(path; system_kwargs...)
    else
        throw(
            IS.DataFormatError(
                "$path is not a serialized System bundle directory or a " *
                "$SIENNA_ARCHIVE_EXTENSION archive",
            ),
        )
    end
end

function _from_file_json(dir::AbstractString; system_kwargs...)
    document_path = joinpath(dir, SYSTEM_DOCUMENT_FILE)
    if !isfile(document_path)
        throw(
            IS.DataFormatError(
                "$dir is not a serialized System bundle: no $SYSTEM_DOCUMENT_FILE in it",
            ),
        )
    end
    doc = PD.read_document(document_path)
    return from_openapi(
        System,
        doc;
        time_series_storage_path = _resolve_sidecar(doc, dir),
        system_kwargs...,
    )
end

function _from_file_sienna(path::AbstractString; system_kwargs...)
    # Not cleaned up here: the returned System's time series are read from the extracted
    # sidecar lazily, so the directory must outlive this function. It lives under the OS temp
    # root for the rest of the session, same lifetime contract as a :json bundle the caller
    # opened from a directory they later delete out from under it.
    dir = mktempdir(; cleanup = false)
    open(CodecZlib.GzipDecompressorStream, path, "r") do io
        Tar.extract(io, dir)
    end
    return _from_file_json(dir; system_kwargs...)
end

"""
Absolute path of the sidecar the document names, or `nothing` when it names none.

Errors when the document names a file that is absent: the alternative is a `System` quietly
missing every time series the document declared.
"""
function _resolve_sidecar(doc::PD.SystemDocument, dir::AbstractString)
    named = PD.get_time_series_storage_file(doc)
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
