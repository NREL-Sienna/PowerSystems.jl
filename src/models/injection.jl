"""
Any StaticInjection struct that wants to support dynamic injectors must implement this
method to set the value.

The method is only for internal uses.
"""
function set_dynamic_injector!(
    static_injector::T,
    dynamic_injector::U,
) where {T <: StaticInjection, U <: Union{Nothing, DynamicInjection}}
    current_dynamic_injector = get_dynamic_injector(static_injector)
    if !isnothing(current_dynamic_injector) && !isnothing(dynamic_injector)
        throw(ArgumentError("cannot assign a dynamic injector on a device that already has one"))
    end

    # All of these types implement this field.
    static_injector.dynamic_injector = dynamic_injector
end

"""
All DynamicInjection structs must implement this method to set the value.

The method is only for internal uses.
"""
function set_static_injector!(
    dynamic_injector::T,
    static_injector::U,
) where {T <: DynamicInjection, U <: Union{Nothing, StaticInjection}}
    current_static_injector = get_static_injector(dynamic_injector)
    if !isnothing(current_static_injector) && !isnothing(static_injector)
        throw(ArgumentError("cannot assign a static injector on a device that already has one"))
    end

    # All of these types implement this field.
    dynamic_injector.static_injector = static_injector
end
