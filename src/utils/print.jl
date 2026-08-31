# "smart" summary and REPL printing

# Getters for unit-bearing fields declare their display-units choice via the
# `IS.display_units_arg` trait (set by the struct-generator template, default
# `SU` for converted fields unless overridden per field in the descriptor,
# e.g. `rating` fields default to `DU`). Pass `units` to force a specific
# display unit system (e.g. `MW`, `SU`, `DU`, `NU`) instead of resolving the
# trait; an explicit request that fails is an error, not a silent fallback.
# `IS.unitful_variant` resolves the getter's `_unitful` companion (a
# `RelativeQuantity` printing as "1.0 DU"/"0.3 SU", or a `Unitful.Quantity`
# printing as "30.0 MW") instead of a bare number, so display can show the
# unit system explicitly without any extra formatting code here.
function _show_accessor_value(getter_func::Function, ist::Component; units = nothing)
    trait_arg = IS.display_units_arg(getter_func, typeof(ist))
    # Fields without a units trait (e.g. `get_name`) aren't unit-convertible at
    # all — an explicit `units` override must not force a units argument onto
    # a getter that doesn't accept one.
    ismissing(trait_arg) && return getter_func(ist)
    arg = if isnothing(units)
        trait_arg
    else
        units
    end
    unitful_func = IS.unitful_variant(getter_func)
    try
        return unitful_func(ist, arg)
    catch err
        # An explicit `units` request that fails is a caller error worth
        # surfacing, not something display should paper over — only the
        # trait's own automatic resolution gets the never-error fallback below.
        isnothing(units) || rethrow()
        err isa ErrorException && occursin("not attached", err.msg) || rethrow()
        # NU can also fail (it may need the system base or a base voltage).
        # Automatic resolution must never error: fall back to the raw stored
        # value, which the DU conversion returns without touching any base.
        # Only swallow the engine's own ErrorExceptions — a MethodError here
        # is a bug.
        try
            return unitful_func(ist, NU)
        catch err2
            err2 isa ErrorException || rethrow()
            return unitful_func(ist, DU)
        end
    end
end

function Base.summary(sys::System)
    return "System (base power $(_get_base_power(sys)))"
end

function Base.show(io::IO, sys::System)
    show_system_table(io, sys; backend = :auto)

    if IS.get_num_components(sys) > 0
        show_components_table(io, sys; backend = :auto)
    end

    println(io)
    IS.show_time_series_data(io, sys.data; backend = :auto)
    return
end

Base.show(io::IO, ::MIME"text/plain", sys::System) = show(io, sys)

function Base.summary(io::IO, tech::DeviceParameter)
    print(io, "$(typeof(tech))")
end

function Base.summary(io::IO, data::OperationalCost)
    field_msgs = []
    for field_name in fieldnames(typeof(data))
        val = getproperty(data, field_name)
        # Only the most important fields
        (val isa ProductionVariableCostCurve) &&
            push!(field_msgs, "$(field_name): $(typeof(val))")
        # A key carries only its association id; the name is a catalog column, and a
        # summary must not query the store to print one.
        (val isa TimeSeriesKey) &&
            push!(
                field_msgs,
                "$(field_name): time series association_id=$(get_association_id(val))",
            )
    end
    isempty(field_msgs) && return
    print(io, "$(typeof(data)) composed of ")
    join(io, field_msgs, ", ")
end

function Base.show(io::IO, ::MIME"text/plain", data::OperationalCost)
    print(io, "$(typeof(data)): ")
    for field_name in fieldnames(typeof(data))
        val = getproperty(data, field_name)
        val_printout =
            replace(sprint(show, "text/plain", val; context = io), "\n" => "\n  ")
        print(io, "\n  $(field_name): $val_printout")
    end
end

function Base.show(io::IO, ist::Component)
    print(io, IS.strip_module_name(typeof(ist)), "(")
    is_first = true
    for (name, field_type) in zip(fieldnames(typeof(ist)), fieldtypes(typeof(ist)))
        getter_name = Symbol("get_$name")
        if field_type <: InfrastructureSystemsInternal
            continue
        elseif hasproperty(PowerSystems, getter_name)
            getter_func = getproperty(PowerSystems, getter_name)
            val = _show_accessor_value(getter_func, ist)
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

"""
Print `ist` to `io` in the same verbose form as the REPL's `text/plain` display of a
`Component`. Pass `units` (e.g. `MW`, `SU`, `DU`, `NU`) to force every unit-converted
field to display in that unit system instead of resolving each field's own
`display_units_arg` default (system base when attached, natural units otherwise, and
device base for capacity/`rating`-style fields).

# Examples
```julia
show_component(gen)
show_component(gen; units = MW)
```
"""
function show_component(io::IO, ist::Component; units = nothing)
    print(io, summary(ist), ":")
    for name in fieldnames(typeof(ist))
        obj = getproperty(ist, name)
        getter_name = Symbol("get_$name")
        if obj isa InfrastructureSystemsInternal
            base_value = IS.get_base_value(obj)
            if !isnothing(base_value)
                print(io, "\n   System base power (MVA): ", base_value)
            end
            continue
        elseif obj isa InfrastructureSystemsType ||
               obj isa Vector{<:InfrastructureSystemsComponent}
            val = summary(getproperty(ist, name))
        elseif hasproperty(PowerSystems, getter_name)
            getter_func = getproperty(PowerSystems, getter_name)
            val = _show_accessor_value(getter_func, ist; units = units)
        else
            val = getproperty(ist, name)
        end
        print(io, "\n   ", name, ": ", val)
    end
    print(
        io,
        "\n   ",
        "has_supplemental_attributes",
        ": ",
        string(has_supplemental_attributes(ist)),
    )
    print(io, "\n   ", "has_time_series", ": ", string(has_time_series(ist)))
    return
end

show_component(ist::Component; units = nothing) = show_component(stdout, ist; units = units)

function Base.show(io::IO, ::MIME"text/plain", ist::Component)
    if !has_units_setting(ist)
        @warn(
            "Component is not attached to a System; each field displays in its own " *
            "fallback units (natural units, or device base for fields like `rating` " *
            "that default to device-base display)."
        )
    end
    show_component(io, ist)
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
  The Vector option is an array of field names for the `component_type`; unit-converted
  fields are printed with an explicit unit suffix (e.g. `"30.0 MW"`, `"1.0 DU"`).

# Keyword Arguments
- `units`: When `additional_columns` is a `Vector`, force every unit-converted column to
  display in this unit system (e.g. `MW`, `SU`, `DU`, `NU`) instead of each field's own
  `display_units_arg` default. Ignored for `Dict`-form `additional_columns`, whose
  functions compute their own values.
- Remaining keyword arguments are forwarded to `PrettyTables.pretty_table`.

# Examples
```julia
show_components(sys, ThermalStandard)
show_components(sys, ThermalStandard, Dict("has_time_series" => x -> has_time_series(x)))
show_components(sys, ThermalStandard, [:active_power, :reactive_power])
show_components(sys, ThermalStandard, [:rating]; units = MW)
```
"""
function show_components(
    sys::System,
    component_type::Type{<:Component},
    additional_columns::Union{Dict, Vector} = Dict();
    units = nothing,
    kwargs...,
)
    show_components(
        stdout,
        sys,
        component_type,
        additional_columns;
        units = units,
        kwargs...,
    )
    return
end

function show_components(
    io::IO,
    sys::System,
    component_type::Type{<:Component},
    additional_columns::Union{Dict, Vector} = Dict();
    units = nothing,
    kwargs...,
)
    IS.show_components(
        io,
        sys.data.components,
        component_type,
        additional_columns;
        units = units,
        kwargs...,
    )
    return
end

# The placement of the type in the argument list has been confusing for people. Support
# it both before and after the system.

show_components(
    component_type::Type{<:Component},
    sys::System,
    additional_columns::Union{Dict, Vector} = Dict();
    kwargs...,
) = show_components(sys, component_type, additional_columns; kwargs...)

show_components(
    io::IO,
    component_type::Type{<:Component},
    sys::System,
    additional_columns::Union{Dict, Vector} = Dict();
    kwargs...,
) = show_components(io, sys, component_type, additional_columns; kwargs...)

"""
Show a table with the summary of time series attached to the system.
"""
function show_time_series(sys::System)
    IS.show_time_series_data(stdout, sys.data)
end
