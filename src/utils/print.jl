# "smart" summary and REPL printing

function Base.summary(sys::System)
    return "System (base power $(get_base_power(sys)))"
end

function Base.show(io::IO, ::MIME"text/plain", sys::System)
    show_system_table(io, sys, backend = Val(:auto))

    if IS.get_num_components(sys.data.components) > 0
        show_components_table(io, sys, backend = Val(:auto))
    end

    println(io)
    IS.show_time_series_data(io, sys.data, backend = Val(:auto))
    return
end

function Base.show(io::IO, ::MIME"text/html", sys::System)
    show_system_table(io, sys, backend = Val(:html), standalone = false)

    if IS.get_num_components(sys.data.components) > 0
        show_components_table(
            io,
            sys,
            backend = Val(:html),
            tf = PrettyTables.tf_html_simple,
            standalone = false,
        )
    end

    println(io)
    IS.show_time_series_data(
        io,
        sys.data,
        backend = Val(:html),
        tf = PrettyTables.tf_html_simple,
        standalone = false,
    )
    return
end

function show_system_table(io::IO, sys::System; kwargs...)
    header = ["Property", "Value"]
    num_components = IS.get_num_components(sys.data.components)
    table = [
        "System Units Base" string(get_units_base(sys))
        "Base Power" string(get_base_power(sys))
        "Base Frequency" string(get_frequency(sys))
        "Num Components" string(num_components)
    ]
    PrettyTables.pretty_table(
        io,
        table;
        header = header,
        title = "System",
        alignment = :l,
        kwargs...,
    )
    return
end

function show_components_table(io::IO, sys::System; kwargs...)
    static_header = ["Type", "Count", "Has Static Time Series", "Has Forecasts"]
    dynamic_header = ["Type", "Count"]
    components = sys.data.components

    static_types = Vector{DataType}()
    dynamic_types = Vector{DataType}()
    for component_type in keys(components.data)
        if component_type <: DynamicInjection
            push!(dynamic_types, component_type)
        else
            push!(static_types, component_type)
        end
    end
    static_data = Array{Any, 2}(undef, length(static_types), length(static_header))
    dynamic_data = Array{Any, 2}(undef, length(dynamic_types), length(dynamic_header))

    static_type_names = [(IS.strip_module_name(string(x)), x) for x in static_types]
    sort!(static_type_names, by = x -> x[1])
    for (i, (type_name, type)) in enumerate(static_type_names)
        vals = components.data[type]
        has_sts = false
        has_forecasts = false
        for val in values(vals)
            if has_time_series(val, StaticTimeSeries)
                has_sts = true
            end
            if has_time_series(val, Forecast)
                has_forecasts = true
            end
            if has_sts && has_forecasts
                break
            end
        end
        static_data[i, 1] = type_name
        static_data[i, 2] = length(vals)
        static_data[i, 3] = has_sts
        static_data[i, 4] = has_forecasts
    end

    if !isempty(static_types)
        println(io)
        PrettyTables.pretty_table(
            io,
            static_data;
            header = static_header,
            title = "Static Components",
            alignment = :l,
            kwargs...,
        )
    end

    dynamic_type_names = [(IS.strip_module_name(string(x)), x) for x in dynamic_types]
    sort!(dynamic_type_names, by = x -> x[1])
    for (i, (type_name, type)) in enumerate(dynamic_type_names)
        vals = components.data[type]
        dynamic_data[i, 1] = type_name
        dynamic_data[i, 2] = length(vals)
    end

    if !isempty(dynamic_types)
        println(io)
        PrettyTables.pretty_table(
            io,
            dynamic_data;
            header = dynamic_header,
            title = "Dynamic Components",
            alignment = :l,
            kwargs...,
        )
    end
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
        getter_name = Symbol("get_$name")
        if field_type <: IS.TimeSeriesContainer ||
           field_type <: InfrastructureSystemsInternal
            continue
        elseif hasproperty(PowerSystems, getter_name)
            getter_func = getproperty(PowerSystems, getter_name)
            val = getter_func(ist)
        else
            val = getproperty(ist, name)
        end
        if is_first
            is_first = false
        else
            print(io, ", ")
        end
        print(io, val)
    end
    print(io, ")")
    return
end

function Base.show(io::IO, ::MIME"text/plain", ist::Component)
    default_units = false
    if !has_units_setting(ist)
        print(io, "\n")
        @warn(
            "SystemUnitSetting not defined, using NATURAL_UNITS for displaying device specification."
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
            obj = getproperty(ist, name)
            getter_name = Symbol("get_$name")
            if (obj isa InfrastructureSystemsInternal) && !default_units
                print(io, "\n   ")
                show(io, MIME"text/plain"(), obj.units_info)
                continue
            elseif obj isa IS.TimeSeriesContainer ||
                   obj isa InfrastructureSystemsType ||
                   obj isa Vector{<:InfrastructureSystemsComponent}
                val = summary(getproperty(ist, name))
            elseif hasproperty(PowerSystems, getter_name)
                getter_func = getproperty(PowerSystems, getter_name)
                val = getter_func(ist)
            else
                val = getproperty(ist, name)
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
    return
end

"""
Show all components of the given type in a table.

# Arguments
- `sys::System`: System containing the components.
- `component_type::Type{<:Component}`: Type to display. Must be a concrete type.
- `additional_columns::Union{Dict, Vector}`: Additional columns to display.
  The Dict option is a mapping of column name to function. The function must accept
  a component.
  The Vector option is an array of field names for the `component_type`.

Extra keyword arguments are forwarded to PrettyTables.pretty_table.

# Examples
```julia
show_components(sys, ThermalStandard)
show_components(sys, ThermalStandard, Dict("has_time_series" => x -> has_time_series(x)))
show_components(sys, ThermalStandard, [:active_power, :reactive_power])
```
"""
function show_components(
    sys::System,
    component_type::Type{<:Component},
    additional_columns::Union{Dict, Vector} = Dict();
    kwargs...,
)
    show_components(stdout, sys, component_type, additional_columns; kwargs...)
    return
end

function show_components(
    io::IO,
    sys::System,
    component_type::Type{<:Component},
    additional_columns::Union{Dict, Vector} = Dict();
    kwargs...,
)
    IS.show_components(
        io,
        sys.data.components,
        component_type,
        additional_columns;
        kwargs...,
    )
    return
end
