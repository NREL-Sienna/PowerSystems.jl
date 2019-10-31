# Logging
This document describes logging facilities available in the PowerSystems
module. The examples assume the following imports:

```julia
import Logging
import PowerSystems: configure_logging, open_file_logger, MultiLogger, LogEventTracker
```

## Use Cases

### Enable logging in REPL or Jupyter Notebook

Use `configure_logging` to create a logger with your preferences (console
and/or file, levels, etc.).

**Note:** log messages are not automatically flushed to files. Call
`flush(logger)` to make this happen.

#### Example

```julia
logger = configure_logging(; filename="log.txt")
@info "hello world"
flush(logger)
@error "some error"
close(logger)
```

The function provides lots of customization. Refer to the docstring for complete details.

### Log to console and file in an application or unit test environment.

Create a `MultiLogger` from `Logging.ConsoleLogger` and `Logging.SimpleLogger`.
Use `open_file_logger` to guarantee that all messages get flushed to the file.

#### Example

```julia
console_logger = ConsoleLogger(stderr, Logging.Error)

open_file_logger("log.txt", Logging.Info) do file_logger
    multi_logger = MultiLogger([console_logger, file_logger])
    global_logger(multi_logger)
    
    do_stuff()
end
```

**Note:** If someone may execute the code in the REPL then wrap that code in a
try/finally block and reset the global logger upon exit.

#### Example

```julia
function run_tests()
    console_logger = ConsoleLogger(stderr, Logging.Error)
    
    open_file_logger("log.txt", Logging.Info) do file_logger
        multi_logger = MultiLogger([console_logger, file_logger])
        global_logger(multi_logger)
        
        do_stuff()
    end
end

logger = global_logger()

try
    run_tests()
finally
    # Guarantee that the global logger is reset.
    global_logger(logger)
    nothing
end
```

### Suppress frequent messages
The standard Logging module in Julia provides a method to suppress messages.
Tag the log message with maxlog=X.

#### Example

```julia
for i in range(1, length=100)
    @error "something happened" i maxlog=2
end
```

Only 2 messages will get logged.

### Get a summary of log messages

By default a `MultiLogger` creates a `LogEventTracker` that keeps counts of all
messages. Call `report_log_summary` after execution.

#### Example

```julia
logger = configure_logging(; filename="log.txt")
@info "hello world"

# Include a summary in the log file.
@info report_log_summary(logger)
close(logger)
```

##### Example output
```
julia> for i in range(1, length=100)
           @info "hello" maxlog=2
           @warn "beware" maxlog=2
       end
julia> @info report_log_summary(logger)
┌ Info:
│ Log message summary:
│
│ 0 Error events:
│
│ 1 Warn events:
│   count=100 at REPL[19]:3
│     example message="beware"
│     suppressed=98
│
│ 1 Info events:
│   count=100 at REPL[19]:2
│     example message="hello"
└     suppressed=98
```
