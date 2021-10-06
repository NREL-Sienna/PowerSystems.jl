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
        throw(
            ArgumentError(
                "cannot assign a dynamic injector on a device that already has one",
            ),
        )
    end

    # All of these types implement this field.
    static_injector.dynamic_injector = dynamic_injector
    return
end
