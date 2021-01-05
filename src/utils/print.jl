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

function Base.show(io::IO, ist::Component)
    print(io, string(nameof(typeof(ist))), "(")
    is_first = true
    for (name, field_type) in zip(fieldnames(typeof(ist)), fieldtypes(typeof(ist)))
        if field_type <: IS.TimeSeriesContainer ||
           field_type <: InfrastructureSystemsInternal
            continue
        else
            getter_func = getfield(PowerSystems, Symbol("get_$name"))
            val = getter_func(ist)
        end
        if is_first
            is_first = false
        else
            print(io, ", ")
        end
        print(io, val)
    end
    print(io, ")")
end

function Base.show(io::IO, ::MIME"text/plain", ist::Component)
    default_units = false
    if !has_units_setting(ist)
        print(io, "\n")
        @warn(
            "SystemUnitSetting not defined, using NATURAL_UNITS for dispalying device specification."
        )
        set_units_setting!(
            ist,
            SystemUnitsSettings(100.0, UNIT_SYSTEM_MAPPING["NATURAL_UNITS"]),
        )
        default_units = true
    end
    try
        print(io, summary(ist), ":")
        for (name, field_type) in zip(fieldnames(typeof(ist)), fieldtypes(typeof(ist)))
            obj = getfield(ist, name)
            if (obj isa InfrastructureSystemsInternal) && !default_units
                print(io, "\n   ")
                show(io, MIME"text/plain"(), obj.units_info)
                continue
            elseif obj isa IS.TimeSeriesContainer ||
                   obj isa InfrastructureSystemsType ||
                   obj isa Vector{<:InfrastructureSystemsComponent}
                val = summary(getfield(ist, name))
            else
                getter_func = getfield(PowerSystems, Symbol("get_$name"))
                val = getter_func(ist)
            end
            # Not allowed to print `nothing`
            if isnothing(val)
                val = "nothing"
            end
            print(io, "\n   ", name, ": ", val)
        end
    finally
        if default_units
            set_units_setting!(ist, nothing)
        end
    end
end
