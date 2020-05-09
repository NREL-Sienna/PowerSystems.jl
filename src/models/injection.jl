
"""
Any StaticInjection struct that wants to support dynamic injectors must implement this
method to set the value.

The method is only for internal uses.
"""
function set_dynamic_injector!(
    static_injector::T,
    dynamic_injector::U,
) where {T <: Union{Nothing, StaticInjection}, U <: Union{Nothing, DynamicInjection}}
    error("set_dynamic_injector! is not implemented for $T")
end

"""
All DynamicInjection structs must implement this method to set the value.

The method is only for internal uses.
"""
function set_static_injector!(
    dynamic_injector::T,
    static_injector::U,
) where {T <: Union{Nothing, DynamicInjection}, U <: Union{Nothing, StaticInjection}}
    error("set_static_injector! is not implemented for $T")
end
