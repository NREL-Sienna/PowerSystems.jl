# "smart" summary and REPL printing

# Generic print for power system components (a new type that includes generation
# technology types). The multi-line version simply prints every field of the
# device. Tailored versions can be made for specific devices, if/when
# desired. JJS 11/15/18
function printPST(pst::Component, singleline = false, io::IO = stdout)
    if singleline
        pst_summary = Base.summary(pst)
        # objects of type TechnicalParams do not have a 'name' field
        if in(:name, fieldnames(typeof(pst)))
            print(io, "$pst_summary(name=\"$(pst.name)\")")
        else
            print(io, "$pst_summary")
        end
    else
        print(io, Base.summary(pst),":")
        fnames = fieldnames(typeof(pst))
        for i = 1:nfields(fnames)
            thefield = getfield(pst, i)
            # avoid warning about printing nothing
            if thefield==nothing
                print(io, "\n   ", fnames[i], ": nothing")
            else
                print(io, "\n   ", fnames[i], ": ", thefield)
            end
        end
    end
end
# overload Base.show with printPST function defined above
# single-line format
Base.show(io::IO, pst::Component) = printPST(pst, true, io)
# Multi-line format for plaintext (e.g. from repl); can specify for HTML and
# others too
Base.show(io::IO, ::MIME"text/plain", pst::Component) = printPST(pst, false, io)


# summary, print, repl show for sys.components
function summaryComponents(components::Components)
    strvar = repr(keys(components))
    return replace(strvar, "DataType" => "System.Components")
end
Base.summary(components::Components) = summaryComponents(components::Components)

function printComponents(components::Components, singleline = false, io::IO = stdout)
    if singleline
        # placeholder, just prints the summary -- can change to something more as needed
        print(io, Base.summary(components))
    else
        counts = Dict{String, Int}()
        rows = []

        for (subtype, values) in components
            type_str = strip_module_names(string(subtype))
            counts[type_str] = length(values)
            parents = [strip_module_names(string(x)) for x in supertypes(subtype)]
            row = (ConcreteType=type_str,
                   SuperTypes=join(parents, " <: "),
                   Count=length(values))
            push!(rows, row)
        end

        sort!(rows, by = x -> x.ConcreteType)

        df = DataFrames.DataFrame(rows)
        println(io, "Components")
        println(io, "==========")
        Base.show(io, df)
    end
end
# uncomment this line to overload print() to use "singleline" version above
#Base.show(io::IO, components::Components) = printComponents(components, true, io)
Base.show(io::IO, ::MIME"text/plain", components::Components) = printComponents(components,
                                                                                false, io)

# summary, print, repl show for sys.components
function summaryForecasts(forecasts::SystemForecasts)
    return "SystemForecasts(res: $(forecasts.resolution), hzn:$(forecasts.horizon), int: $(forecasts.interval))"
end
Base.summary(forecasts::SystemForecasts) = summaryForecasts(forecasts::SystemForecasts)

function printForecasts(forecasts::SystemForecasts, singleline = false, io::IO = stdout)
    if singleline
        # placeholder, just prints the summary -- can change to something more as needed
        print(io, Base.summary(forecasts)) 
    else
        counts = Dict{String, Int}()
        rows = []

        println(io, "Forecasts")
        println(io, "=========")
        println(io, "Resolution: $(forecasts.resolution)")
        println(io, "Horizon: $(forecasts.horizon)")
        println(io, "Interval: $(forecasts.interval)\n")
        println(io, "---------------------------------")
        initial_times = _get_forecast_initial_times(forecasts.data)
        for initial_time in initial_times
            for (key, values) in forecasts.data
                if key.initial_time != initial_time
                    continue
                end

                type_str = strip_module_names(string(key.forecast_type))
                counts[type_str] = length(values)
                parents = [strip_module_names(string(x)) for x in supertypes(key.forecast_type)]
                row = (ConcreteType=type_str,
                       SuperTypes=join(parents, " <: "),
                       Count=length(values))
                push!(rows, row)
            end
            println(io, "Initial Time: $initial_time")
            println(io, "---------------------------------")

            sort!(rows, by = x -> x.ConcreteType)

            df = DataFrames.DataFrame(rows)
            Base.show(io, df)
            println(io, "\n")
        end
    end
end
# uncomment this line to overload print() to use "singleline" version above
#Base.show(io::IO, forecasts::SystemForecasts) = printForecasts(forecasts, true, io)
Base.show(io::IO, ::MIME"text/plain", forecasts::SystemForecasts) = printForecasts(forecasts,
                                                                                   false, io)

# summary, print, repl show for sys.components
function summarySystem(sys::System)
    return "System(basepower: $(sys.basepower))"
end
Base.summary(sys::System) = summarySystem(sys::System)

"""Shows the component types and counts in a table (for singleline=false) or a single-line
summary (for singleline=true)."""
function printSystem(sys::System, singleline = false, io::IO = stdout)
    if singleline
        print( io, "System(basepow: $(sys.basepower), "*Base.summary(sys.components)*", "
              *Base.summary(sys.forecasts)*")" )
    else
        println(io, "System")
        println(io, "======")
        println(io, "Base Power: $(sys.basepower)\n")

        printComponents(sys.components, singleline, io)
        println(io, "\n")
        printForecasts(sys.forecasts, singleline, io)
    end
end
# uncomment this line to overload print() to use "singleline" version above
#Base.show(io::IO, sys::System) = printSystem(sys, true, io)
Base.show(io::IO, ::MIME"text/plain", sys::System) = printSystem(sys, false, io)


#### also Base.summary() functions exist in utils/network_calculations/common.jl, but I did
#### not modify those, JJS 9/12/19
