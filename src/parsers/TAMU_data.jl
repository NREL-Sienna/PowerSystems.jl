
"""
Creates a system from a PSS/e .RAW (v33) load flow case, and an associated .csv with MW load
time series data. The format is established by the
[Texas A&M University Test Case Archive](https://electricgrids.engr.tamu.edu/electric-grid-test-cases/)

The general format for data is
folder:
   [casename].raw
   [casename]_load_time_series_MW.csv

# Arguments
- `directory::AbstractString`: directory containing RAW and CSV files

# Examples
```julia
sys = TamuSystem(
    "./ACTIVSg25k",
    configpath = "ACTIVSg25k_validation.json",
    bus_name_formatter = x->string(x["name"]*"-"*string(x["index"])),
    load_name_formatter = x->strip(join(x["source_id"], "_"))
)
```
"""

function TamuSystem(tamu_folder::AbstractString; kwargs...)
    TAMU_CASE = basename(tamu_folder)
    raw_file = joinpath(tamu_folder, TAMU_CASE * ".RAW")
    !isfile(raw_file) && throw(DataFormatError("Cannot find $raw_file"))

    pm_data = PowerModelsData(raw_file)

    bus_name_formatter =
        get(kwargs, :bus_name_formatter, x -> string(x["name"]) * "-" * string(x["index"]))
    load_name_formatter =
        get(kwargs, :load_name_formatter, x -> strip(join(x["source_id"], "_")))

    # make system
    sys = System(
        pm_data,
        bus_name_formatter = bus_name_formatter,
        load_name_formatter = load_name_formatter;
        kwargs...,
    )

    # add forecasts
    header_row = 2

    tamu_files = readdir(tamu_folder)
    load_file = joinpath(
        tamu_folder,
        tamu_files[occursin.("_load_time_series_MW.csv", tamu_files)][1],
    ) # currently only adding MW load forecasts

    !isfile(load_file) && throw(DataFormatError("Cannot find $load_file"))

    header = String.(split(open(readlines, load_file)[header_row], ","))
    fixed_cols = ["Date", "Time", "Num Load", "Total MW Load", "Total Mvar Load"]

    # value columns have the format "Bus 1001 #1 MW", we want "load_1001_1"
    for load in header
        load in fixed_cols && continue
        lsplit = split(replace(string(load), "#" => ""), " ")
        @assert length(lsplit) == 4
        push!(fixed_cols, "load_" * join(lsplit[2:3], "_"))
    end

    loads = CSV.read(load_file, skipto = 3, header = fixed_cols)

    function parse_datetime_ampm(ds::AbstractString, fmt::Dates.DateFormat)
        m = match(r"(.*)\s(AM|PM)", ds)
        d = Dates.DateTime(m.captures[1], fmt)
        ampm = uppercase(something(m.captures[2], ""))
        d + Dates.Hour(12 * +(ampm == "PM", ampm == "" || Dates.hour(d) != 12, -1))
    end

    dfmt = Dates.DateFormat("m/dd/yyy H:M:S")

    loads[!, :timestamp] =
        parse_datetime_ampm.(string.(loads[!, :Date], " ", loads[!, :Time]), dfmt)

    for lname in setdiff(
        names(loads),
        [
            :timestamp,
            :Date,
            :Time,
            Symbol("Num Load"),
            Symbol("Total MW Load"),
            Symbol("Total Mvar Load"),
        ],
    )
        c = get_component(PowerLoad, sys, string(lname))
        if !isnothing(c)
            add_forecast!(
                sys,
                loads[!, ["timestamp", lname]],
                c,
                "get_maxactivepower",
                Float64(maximum(loads[!, lname])),
            )
        end
    end

    return sys
end
