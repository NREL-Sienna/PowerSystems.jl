
abstract type TimeseriesFileFormat end
abstract type TimeseriesFormatPeriodAsColumn <: TimeseriesFileFormat end
abstract type TimeseriesFormatYMDPeriodAsColumn <: TimeseriesFormatPeriodAsColumn end
abstract type TimeseriesFormatDateTimePeriodAsColumn <: TimeseriesFormatPeriodAsColumn end
abstract type TimeseriesFormatPeriodAsHeader <: TimeseriesFileFormat end
abstract type TimeseriesFormatYMDPeriodAsHeader <: TimeseriesFormatPeriodAsHeader end
abstract type TimeseriesFormatComponentsAsColumnsNoTime <: TimeseriesFileFormat end

"""Return the timeseries format used in the CSV file."""
function get_timeseries_format(file::CSV.File)
    columns = propertynames(file)
    has_ymd = :Year in columns && :Month in columns && :Day in columns
    has_period = :Period in columns
    has_datetime = :DateTime in columns

    if has_period
        if has_datetime
            format = TimeseriesFormatDateTimePeriodAsColumn
        else
            format = TimeseriesFormatYMDPeriodAsColumn
        end
    elseif has_ymd
        format = TimeseriesFormatYMDPeriodAsHeader
    elseif !has_datetime
        format = TimeseriesFormatComponentsAsColumnsNoTime
    else
        @assert(false, "Unknown timeseries format in $(file.name)")
    end

    if format in (TimeseriesFormatYMDPeriodAsColumn, TimeseriesFormatYMDPeriodAsHeader)
        if !has_ymd
            throw(DataFormatError("$(file.name) is missing required Year/Month/Day"))
        end
    end

    return format
end

"""Return the column names with values (components)."""
function get_value_columns(::Type{TimeseriesFormatYMDPeriodAsColumn},
                           file::CSV.File)
    return [x for x in propertynames(file) if !in(x, (:Year, :Month, :Day, :Period))]
end

function get_value_columns(::Type{TimeseriesFormatDateTimePeriodAsColumn},
                           file::CSV.File)
    return [x for x in propertynames(file) if !in(x, (:DateTime, :Period))]
end

"""Return the column names with values."""
function get_value_columns(::Type{TimeseriesFormatComponentsAsColumnsNoTime},
                           file::CSV.File)
    return propertynames(file)
end

"""Return the column names that specify the Period."""
function get_period_columns(::Type{TimeseriesFormatPeriodAsColumn},
                            file::CSV.File)
    return [:Period]
end

function get_period_columns(::Type{TimeseriesFormatYMDPeriodAsHeader},
                            file::CSV.File)
    return [x for x in propertynames(file) if !in(x, (:Year, :Month, :Day))]
end

"""Return a vector of dicts of unique timestamps and their counts."""
function get_unique_timestamps(::Type{T}, file::CSV.File) where T <: TimeseriesFileFormat
    timestamps = Vector{Dict{String, Any}}()
    new_timestamp = x -> Dict("timestamp" => x, "count" => 1)

    for i in 1:length(file)
        timestamp = get_timestamp(T, file, i)
        if i == 1
            push!(timestamps, new_timestamp(timestamp))
        else
            if timestamp == timestamps[end]["timestamp"]
                timestamps[end]["count"] += 1
            else
                push!(timestamps, new_timestamp(timestamp))
            end
        end
    end

    @assert length(timestamps) > 0
    for timestamp in timestamps[2:end]
        @assert timestamp["count"] == timestamps[1]["count"]
    end

    return timestamps
end

"""Return a Dates.DateTime for the row in the CSV file."""
function get_timestamp(::Type{TimeseriesFormatYMDPeriodAsColumn}, file::CSV.File,
                       row_index::Int)
    return Dates.DateTime(file.Year[row_index], file.Month[row_index], file.Day[row_index])
end

function get_timestamp(::Type{TimeseriesFormatDateTimePeriodAsColumn}, file::CSV.File,
                       row_index::Int)
    return Dates.DateTime(file.DateTime[row_index])
end

function get_timestamp(::Type{TimeseriesFormatYMDPeriodAsHeader}, file::CSV.File,
                       row_index::Int)
    return get_timestamp(TimeseriesFormatYMDPeriodAsColumn, file, row_index)
end


"""Return a TimeSeries.TimeArray representing the CSV file.

This version of the function only has component_name to match the interface. It is unused.
"""
function read_time_array(
                         ::Type{T},
                         file::CSV.File,
                         component_name=nothing;
                         kwargs...
                        ) where T <: TimeseriesFormatPeriodAsColumn
    timestamps = Vector{Dates.DateTime}()
    step = get_step_time(T, file, file.Period)

    # All timestamps must be sequential by step, so we can ignore the timestamps in the
    # file after the first one.
    # They were validated in get_step_time.
    first = get_timestamp(T, file, 1)
    push!(timestamps, first)
    for i in 2:length(file)
        timestamp = first + step * (i - 1)
        push!(timestamps, timestamp)
    end

    value_columns = get_value_columns(T, file)
    vals = [getproperty(file, x) for x in value_columns]

    return TimeSeries.TimeArray(timestamps, hcat(vals...), value_columns)
end

"""This version of the function supports the format where there is no column header for
a component, so the component_name must be passed in.
"""
function read_time_array(
                         ::Type{T},
                         file::CSV.File,
                         component_name::AbstractString;
                         kwargs...
                        ) where T <: TimeseriesFormatPeriodAsHeader
    timestamps = Vector{Dates.DateTime}()

    period_cols_as_symbols = get_period_columns(T, file)
    period = [parse(Int, string(x)) for x in period_cols_as_symbols]
    step = get_step_time(T, file, period)

    # All timestamps must be sequential by step, so we can ignore the timestamps in the
    # file after the first one.
    # They were validated in get_step_time.

    first = Dates.DateTime(Dates.today())
    count = 0
    for i in 1:length(file)
        if i == 1
            first = get_timestamp(T, file, 1)
        end
        for j in 1:length(period)
            timestamp = first + step * count
            count += 1
            push!(timestamps, timestamp)
        end
    end

    vals = Vector{Float64}()
    for i in 1:length(file)
        for period in period_cols_as_symbols
            val = getproperty(file, period)[i]
            push!(vals, val)
        end
    end

    return TimeSeries.TimeArray(timestamps, vals, Symbol.([component_name]))
end

"""This version of the function only has component_name to match the interface.
It is unused and shouldn't be passed.

Set start_datetime as a keyword argument for the starting timestamp, otherwise the current
day is used.
"""
function read_time_array(
                         ::Type{T},
                         file::CSV.File,
                         component_name=nothing;
                         kwargs...
                        ) where T <: TimeseriesFormatComponentsAsColumnsNoTime
    @assert isnothing(component_name)

    timestamps = Vector{Dates.DateTime}()
    step = get_step_time(T, file)

    start = get(kwargs, :start_datetime, Dates.DateTime(Dates.today()))
    for i in 1:length(file)
        timestamp = start + step * (i - 1)
        push!(timestamps, timestamp)
    end

    value_columns = get_value_columns(T, file)
    vals = [getproperty(file, x) for x in value_columns]

    return TimeSeries.TimeArray(timestamps, hcat(vals...), value_columns)
end

"""Return a DateTime for the step between values as specified by the period in the file."""
function get_step_time(
                       ::Type{T},
                       file::CSV.File,
                       period::AbstractArray,
                      ) where T <: TimeseriesFileFormat
    timestamps = get_unique_timestamps(T, file)
    if T <: TimeseriesFormatPeriodAsColumn
        num_steps = timestamps[1]["count"]
    elseif T <: TimeseriesFormatPeriodAsHeader
        num_steps = period[end]
    else
        error("unsupported $T")
    end

    @debug timestamps, num_steps
    if length(timestamps) == 1
        # TODO: Not sure how to handle this. We could make specific functions for each type.
        # For any YMD format the lowest resolution is Day.
        # What is it for DateTime? We can't infer from one value.
        resolution = Dates.Day(1)
    else
        resolution = timestamps[2]["timestamp"] - timestamps[1]["timestamp"]
        if length(timestamps) > 2
            for i in 3:length(timestamps)
                diff = timestamps[i]["timestamp"] - timestamps[i - 1]["timestamp"]
                if diff != resolution
                    msg = "conflicting resolution=$resolution i=$i diff=$diff"
                    throw(DataFormatError(msg))
                end
            end
        end
    end

    return calculate_step_time(resolution, num_steps)
end

function get_step_time(
                       ::Type{T},
                       file::CSV.File,
                      ) where T <: TimeseriesFormatComponentsAsColumnsNoTime
    resolution = Dates.Day(1)
    num_steps = length(file)
    return calculate_step_time(resolution, num_steps)
end

function calculate_step_time(resolution::Dates.Period, num_steps::Int)
    # Seconds should be the lowest possible resolution.
    step = Dates.Second(resolution) / num_steps
    @debug "file has step time of $step" resolution num_steps
    return step
end
