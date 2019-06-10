
abstract type TimeseriesFormat end
abstract type TimeseriesFormatPeriodAsColumn <: TimeseriesFormat end
abstract type TimeseriesFormatYMDPeriodAsColumn <: TimeseriesFormatPeriodAsColumn end
abstract type TimeseriesFormatDateTimePeriodAsColumn <: TimeseriesFormatPeriodAsColumn end
abstract type TimeseriesFormatPeriodAsHeader <: TimeseriesFormat end
abstract type TimeseriesFormatYMDPeriodAsHeader <: TimeseriesFormatPeriodAsHeader end
abstract type TimeseriesFormatComponentsAsColumnsNoTime <: TimeseriesFormat end

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

"""Return a sorted vector of unique timestamps specified in the CSV file."""
function get_unique_timestamps(::Type{T}, file::CSV.File) where T <: TimeseriesFormat
    timestamps = Set{Dates.DateTime}()

    for i in 1:length(file)
        push!(timestamps, get_timestamp(T, file, i))
    end

    return sort!(collect(timestamps))
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

This version of the function covers a special case where the timeseries data is only for
one component and column header does not match that component's name. In other cases it
assumes that the column headers match the names. component_name only needs to be passed in
the first case.
"""
function read_time_array(
                         ::Type{T},
                         file::CSV.File,
                         component_name=nothing;
                         kwargs...
                        ) where T <: TimeseriesFormatPeriodAsColumn
    timestamps = Vector{Dates.DateTime}()
    step = get_step_time(T, file, file.Period)

    for i in 1:length(file)
        timestamp = get_timestamp(T, file, i) + step * (i - 1)
        push!(timestamps, timestamp)
    end

    value_columns = get_value_columns(T, file)
    vals = [getproperty(file, x) for x in value_columns]

    if length(value_columns) == 1 && !isnothing(component_name) && string(value_columns[1]) != component_name
        # TODO DT: Hack. Do we really want to support this?
        # If so, can we check for a specific name?  "VALUE" is used in the examples.
        @warn "column name doesn't match...resetting" value_columns component_name
        value_columns[1] = Symbol(component_name)
    end

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
    if length(file) != 1
        msg = "$T must have only one row. file=$file.name"
        throw(DataFormatError(msg))
    end

    timestamps = Vector{Dates.DateTime}()

    period_cols_as_symbols = get_period_columns(T, file)
    period = [parse(Int, string(x)) for x in period_cols_as_symbols]
    step = get_step_time(T, file, period)

    for i in 1:length(period)
        timestamp = get_timestamp(T, file, 1) + step * (i - 1)
        push!(timestamps, timestamp)
    end

    vals = [getproperty(file, x)[1] for x in period_cols_as_symbols]

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
                      ) where T <: TimeseriesFormat
    @assert period[end] == maximum(period) == length(period)
    num_steps = period[end]

    timestamps = get_unique_timestamps(T, file)
    if length(timestamps) == 1
        # TODO: Not sure how to handle this. We could make specific functions for each type.
        # For any YMD format the lowest resolution is Day.
        # What is it for DateTime? We can't infer from one value.
        resolution = Dates.Day(1)
    else
        resolution = timestamps[2] - timestamps[1]
        if length(timestamps) > 2
            for i in 3:length(timestamps)
                diff = timestamps[i] - timestamps[i - 1]
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
    @debug "file has step time of $step"
    return step
end
