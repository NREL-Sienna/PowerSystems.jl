# "smart" summary and REPL printing

function Base.summary(sys::System)
    return "System (base power $(get_base_power(sys)))"
end

function Base.show(io::IO, sys::System)
    println(io, "base_power=$(get_base_power(sys))")
    show(io, sys.data)
end

function Base.show(io::IO, ::MIME"text/plain", sys::System)
    println(io, "System")
    println(io, "======")
    println(io, "System Units Base: $(get_units_base(sys))")
    println(io, "Base Power: $(get_base_power(sys))")
    println(io, "Base Frequency: $(get_frequency(sys))\n")
    show(io, MIME"text/plain"(), sys.data)
end

function Base.show(io::IO, ::MIME"text/html", sys::System)
    println(io, "<h1>System</h1>")
    println(io, "<p><b>Base Power</b>: $(get_base_power(sys))</p>")
    show(io, MIME"text/html"(), sys.data)
end

function Base.summary(tech::DeviceParameter)
    return "$(typeof(tech))"
end

function Base.summary(arc::Arc)
    return "$(get_name(get_from(arc))) -> $(get_name(get_to(arc))): ($(typeof(arc)))"
end

function Base.show(io::IO, ::MIME"text/plain", data::PowerSystemTableData)
    println(io, "$(typeof(data)):")
    println(io, "  directory:  $(data.directory)")
    if !isnothing(data.timeseries_metadata_file)
        println(io, "  timeseries_metadata_file:  $(data.timeseries_metadata_file)")
    end
    println(io, "  base_power:  $(data.base_power)")
    for (field, df) in data.category_to_df
        print(io, "  $field:  ")
        println(io, "$(summary(df))")
    end
end
