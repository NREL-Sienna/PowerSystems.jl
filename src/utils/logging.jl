
import Logging

export configure_logging
export open_file_logger
export MultiLogger
export LogEvent
export LogEventTracker
export report_log_summary
export get_log_events


"""
    configure_logging([console, console_stream, console_level,
                       file, filename, file_level, file_mode,
                       tracker, set_global])

Creates console and file loggers per caller specification and returns a MultiLogger.

**Note:** If logging to a file users must call Base.close() on the returned MultiLogger to
ensure that all events get flushed.

# Arguments
- `console::Bool=true`: create console logger
- `console_stream::IOStream=stderr`: stream for console logger
- `console_level::Logging.LogLevel=Logging.Error`: level for console messages
- `file::Bool=true`: create file logger
- `filename::String=log.txt`: log file
- `file_level::Logging.LogLevel=Logging.Info`: level for file messages
- `file_mode::String=w+`: mode used when opening log file
- `tracker::Union{LogEventTracker, Nothing}=LogEventTracker()`: optionally track log events
- `set_global::Bool=true`: set the created logger as the global logger

# Example
```julia
logger = configure_logging(filename="mylog.txt")
```
"""
function configure_logging(;
                           console=true,
                           console_stream=stderr,
                           console_level=Logging.Error,
                           file=true,
                           filename="log.txt",
                           file_level=Logging.Info,
                           file_mode="w+",
                           tracker=LogEventTracker(),
                           set_global=true
                          )::MultiLogger
    if !console && !file
        error("At least one of console or file must be true")
    end

    loggers = Array{Logging.AbstractLogger, 1}()
    if console
        console_logger = Logging.ConsoleLogger(console_stream, console_level)
        push!(loggers, console_logger)
    end

    if file
        io = open(filename, file_mode)
        file_logger = Logging.SimpleLogger(io, file_level)
        push!(loggers, file_logger)
    end

    logger = MultiLogger(loggers, tracker)
    if set_global
        Logging.global_logger(logger)
    end

    return logger
end

"""
    open_file_logger(func, filename[, level, mode])

Opens a file logger using Logging.SimpleLogger.

# Example
```julia
open_file_logger("log.txt", Logging.Info) do logger
    global_logger(logger)
    @info "hello world"
end
```
"""
function open_file_logger(func::Function, filename::String, level=Logging.Info, mode="w+")
    stream = open(filename, mode)
    try
        logger = Logging.SimpleLogger(stream, level)
        func(logger)
    finally
        close(stream)
    end
end

"""Contains information describing a log event."""
mutable struct LogEvent
    file::String
    line::Int
    id::Symbol
    message::String
    level::Logging.LogLevel
    count::Int
    suppressed::Int
end

LogEvent(file, line, id, message, level) = LogEvent(file, line, id, message, level, 1, 0)

struct LogEventTracker
    events::Dict{Logging.LogLevel, Dict{Symbol, LogEvent}}

    # Defining an inner constructor to prohibit creation of a default constructor that
    # takes a parameter of type Any. The outer constructor below causes an overwrite of
    # that method, which results in a warning message from Julia.
    LogEventTracker(events::Dict{Logging.LogLevel, Dict{Symbol, LogEvent}}) = new(events)
end

"""
    LogEventTracker(Tuple{Logging.LogLevel})

Tracks counts of all log events by level.

# Examples
```julia
LogEventTracker()
LogEventTracker((Logging.Info, Logging.Warn, Logging.Error))
```
"""
function LogEventTracker(levels=(Logging.Info, Logging.Warn, Logging.Error))
    return LogEventTracker(Dict(l => Dict{Symbol, LogEvent}() for l in levels))
end

"""Returns a summary of log event counts by level."""
function report_log_summary(tracker::LogEventTracker)::String
    text = "\nLog message summary:\n"
    # Order by criticality.
    for level in sort!(collect(keys(tracker.events)), rev=true)
        num_events = length(tracker.events[level])
        text *= "\n$num_events $level events:\n"
        for event in sort!(collect(get_log_events(tracker, level)), by=x->x.count, rev=true)
            text *= "  count=$(event.count) at $(event.file):$(event.line)\n"
            text *= "    example message=\"$(event.message)\"\n"
            if event.suppressed > 0
                text *= "    suppressed=$(event.suppressed)\n"
            end
        end
    end

    return text
end

"""Returns an iterable of log events for a level."""
function get_log_events(tracker::LogEventTracker, level::Logging.LogLevel)
    if !_is_level_valid(tracker, level)
        return []
    end

    return values(tracker.events[level])
end

"""Increments the count of a log event."""
function increment_count(tracker::LogEventTracker, event::LogEvent, suppressed::Bool)
    if _is_level_valid(tracker, event.level)
        if haskey(tracker.events[event.level], event.id)
            tracker.events[event.level][event.id].count += 1
            if suppressed
                tracker.events[event.level][event.id].suppressed += 1
            end
        else
            tracker.events[event.level][event.id] = event
        end
    end
end

function _is_level_valid(tracker::LogEventTracker, level::Logging.LogLevel)
    return level in keys(tracker.events)
end

"""
    MultiLogger(Array{AbstractLogger}, Union{LogEventTracker, Nothing})

Redirects log events to multiple loggers. The primary use case is to allow logging to
both a file and the console. Secondarily, it can track the counts of all log messages.

# Example
```julia
MultiLogger([ConsoleLogger(stderr), SimpleLogger(stream)], LogEventTracker())
```
"""
mutable struct MultiLogger <: Logging.AbstractLogger
    loggers::Array{Logging.AbstractLogger}
    tracker::Union{LogEventTracker, Nothing}
end

"""
Creates a MultiLogger with no event tracking.

# Example
```julia
MultiLogger([ConsoleLogger(stderr), SimpleLogger(stream)])
```
"""
function MultiLogger(loggers::Array{T}) where T <: Logging.AbstractLogger
    return MultiLogger(loggers, nothing)
end

Logging.shouldlog(logger::MultiLogger, level, _module, group, id) = true

function Logging.min_enabled_level(logger::MultiLogger)
    return minimum([Logging.min_enabled_level(x) for x in logger.loggers])
end

Logging.catch_exceptions(logger::MultiLogger) = false

function Logging.handle_message(logger::MultiLogger,
                                level,
                                message,
                                _module,
                                group,
                                id,
                                file,
                                line;
                                maxlog=nothing,
                                kwargs...)
    suppressed = false
    for logger_ in logger.loggers
        if level >= Logging.min_enabled_level(logger_)
            if Logging.shouldlog(logger_, level, _module, group, id)
                Logging.handle_message(logger_, level, message, _module, group, id, file,
                                       line; maxlog=maxlog, kwargs...)
            else
                suppressed = true
            end
        end
    end

    if logger.tracker != nothing
        id = isa(id, Symbol) ? id : :empty
        event = LogEvent(file, line, id, string(message), level)
        increment_count(logger.tracker, event, suppressed)
    end

    return
end

"""Returns a summary of log event counts by level."""
function report_log_summary(logger::MultiLogger)::String
    if logger.tracker == nothing
        error("log event tracking is not enabled")
    end

    return report_log_summary(logger.tracker)
end

"""Flush any file streams."""
function Base.flush(logger::MultiLogger)
    for logger_ in logger.loggers
        if isa(logger_, Logging.SimpleLogger)
           flush(logger_.stream)
        end
    end
end

"""Ensures that any file streams are flushed and closed."""
function Base.close(logger::MultiLogger)
    for logger_ in logger.loggers
        if isa(logger_, Logging.SimpleLogger)
            close(logger_.stream)
        end
    end
end
