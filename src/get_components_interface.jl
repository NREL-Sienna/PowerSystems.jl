# The PSY `get_components`-like methods here (`get_components`, `get_component`,
# `get_available_components`, `get_available_component`, `get_groups`, `get_available_groups`)
# exist only to carry PSY-facing documentation: they must purely redirect to the IS versions
# and never add functionality. Implement the actual behavior in IS. Internal code that works
# with any "thing with components" should call the IS functions, not these.
# `ComponentSelector`-related methods go in `component_selector_interface.jl` instead.
# See https://github.com/Sienna-Platform/InfrastructureSystems.jl/issues/388.

# get_components
"""
Return an iterator of components of a given `Type` from a [`System`](@ref).

`T` can be a concrete or abstract [`Component`](@ref) type from the [Type Tree](@ref).
Call collect on the result if an array is desired.

# Examples
```julia
iter = get_components(ThermalStandard, sys)
iter = get_components(Generator, sys)
generators = collect(get_components(Generator, sys))
```

See also: [`iterate_components`](@ref), [`get_components` with a filter](@ref get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component}),
[`get_available_components`](@ref), [`get_buses`](@ref)
"""
get_components(::Type{T}, sys::System; subsystem_name = nothing) where {T <: Component} =
    IS.get_components(T, sys; subsystem_name = subsystem_name)

"""
Return a vector of components that are attached to the supplemental attribute.

# Arguments
- `sys::System`: the `System` to search
- `attribute::SupplementalAttribute`: Only return components associated with this attribute.
- `component_type::Union{Nothing, <:Component}`: Optional type of the components to return.
  Can be concrete or abstract. If not provided, all components associated with the attribute
  will be returned.
"""
function get_associated_components(
    sys::System,
    attribute::SupplementalAttribute;
    component_type::Union{Nothing, Type{<:Component}} = nothing,
)
    return IS.get_associated_components(
        sys.data,
        attribute;
        component_type = component_type,
    )
end

"""
Return a vector of components that are associated to one or more supplemental attributes of
the given type.
"""
function get_associated_components(
    sys::System,
    attribute_type::Type{<:SupplementalAttribute};
    component_type::Union{Nothing, Type{<:Component}} = nothing,
)
    return IS.get_associated_components(
        sys.data,
        attribute_type;
        component_type = component_type,
    )
end

"""
Return an iterator of components of a given `Type` from a [`System`](@ref), using an
additional filter

`T` can be a concrete or abstract [`Component`](@ref) type from the [Type Tree](@ref).
Call collect on the result if an array is desired.

# Examples
```julia
iter_coal = get_components(x -> get_fuel(x) == ThermalFuels.COAL, Generator, sys)
pv_gens =
    collect(get_components(x -> get_prime_mover_type(x) == PrimeMovers.PVe, Generator, sys))
```

See also: [`get_components`](@ref get_components(
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component}), [`get_available_components`](@ref),
[`get_buses`](@ref)
"""
get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component} =
    IS.get_components(filter_func, T, sys; subsystem_name = subsystem_name)

# get_component
"""
Get the component by integer id.
"""
get_component(sys::System, id::Int) = IS.get_component(sys, id)

"""
Get the component of type T with name. Returns nothing if no component matches. If T is an abstract
type then the names of components across all subtypes of T must be unique.

See [`get_components_by_name`](@ref) for abstract types with non-unique names across subtypes.

Throws ArgumentError if T is not a concrete type and there is more than one component with
    requested name
"""
get_component(::Type{T}, sys::System, name::AbstractString) where {T <: Component} =
    IS.get_component(T, sys, name)

# get_available_components
"""
Like [`get_components`](@ref get_components(
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
    ) where {T <: Component}
) but returns only components that are [`get_available`](@ref).
```
"""
get_available_components(
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component} =
    IS.get_available_components(T, sys; subsystem_name = subsystem_name)

"""
Like [`get_associated_components`](@ref) but returns only components that are
[`get_available`](@ref).
"""
get_available_components(sys::System, attribute::SupplementalAttribute) =
    IS.get_available_components(sys, attribute)

"""
Like [`get_components`](@ref get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
    ) where {T <: Component}
) but returns only components that are [`get_available`](@ref).
"""
get_available_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component} =
    IS.get_available_components(filter_func, T, sys; subsystem_name = subsystem_name)

# get_available_component
"""
Get the available component by integer id.
"""
get_available_component(sys::System, id::Int) =
    IS.get_available_component(sys, id)

"""
Like [`get_component`](@ref) but also returns `nothing` if the component is not [`get_available`](@ref).
"""
get_available_component(::Type{T}, sys::System, args...; kwargs...) where {T <: Component} =
    IS.get_available_component(T, sys, args...; kwargs...)
