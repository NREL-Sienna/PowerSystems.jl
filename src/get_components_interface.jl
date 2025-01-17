# The longstanding status quo in Sienna has been for `PSY.get_components` to be distinct
# from `IS.get_components`, mostly so that PowerSystems users aren't confused by all the
# InfrastructureSystems methods. This lack of a unified interface on "things with
# components" has begun to cause problems, most notably for ComponentSelector. Therefore,
# the new plan is:
#   1. Implement, wherever relevant, methods of the IS `get_components`-like functions
#      listed below on PSY data structures.
#   2. Add, in this file, methods of the PSY `get_components`-like functions that purely
#      redirect to the IS versions and have the documentation PSY users should see. Never
#      add actual functionality in these PSY methods; they must only redirect to the IS
#      versions.
#   3. In downstream Sienna packages like PowerSimulations that seek to add their own
#      `get_components`-like methods on their own data structures that show up in
#      user-friendly documentation, do the same thing: add the implementation in the IS
#      method and add a PSY method that purely redirects.
#   4. Internal code designed to work with all "things with components" should use the IS
#      functions, not the PSY ones.

# This design preserves the simplified interface presented to the casual PSY user while
# allowing for better cross-package integration behind the scenes. It also enables a quick
# switch to a design where we no longer maintain two versions of each `get_components`-like
# function at the cost of slightly more confusing documentation -- simply import the IS
# versions into PowerSystems and delete this file (and analogous redirects in downstream
# packages). See https://github.com/NREL-Sienna/InfrastructureSystems.jl/issues/388.

# Here is the current list of "`get_components`-like functions" to which this plan applies:
#  - `get_components`
#  - `get_component`
#  - `get_available_components`
#  - `get_available_component`
#  - `get_groups`
#  - `get_available_groups`

# get_components
"""
Returns an iterator of components. T can be concrete or abstract.
Call collect on the result if an array is desired.

# Examples
```julia
iter = PowerSystems.get_components(ThermalStandard, sys)
iter = PowerSystems.get_components(Generator, sys)
iter = PowerSystems.get_components(x -> PowerSystems.get_status(x), ThermalStandard, sys)
thermal_gens = get_components(ThermalStandard, sys) do gen
    get_status(gen)
end
generators = collect(PowerSystems.get_components(Generator, sys))

```

See also: [`iterate_components`](@ref)
"""
get_components(::Type{T}, sys::System; subsystem_name = nothing) where {T <: Component} =
    IS.get_components(T, sys; subsystem_name = subsystem_name)

"""
Return a vector of components that are attached to the supplemental attribute.
"""
get_components(sys::System, attribute::SupplementalAttribute) =
    IS.get_components(sys, attribute)

"Variant of `get_components` that applies a filter function."
get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component} =
    IS.get_components(filter_func, T, sys; subsystem_name = subsystem_name)

"""
Get the components of the `System` that make up the `ComponentSelector`.
"""
get_components(
    scope_limiter::Union{Function, Nothing},
    selector::ComponentSelector,
    sys::System,
) =
    IS.get_components(scope_limiter, selector, sys)

"""
Get the components of the `System` that make up the `ComponentSelector`.
"""
get_components(selector::ComponentSelector, sys::System) =
    IS.get_components(selector, sys)

# get_component
"""
Get the component by UUID.
"""
get_component(sys::System, uuid::Base.UUID) = IS.get_component(sys, uuid)
get_component(sys::System, uuid::String) = IS.get_component(sys, uuid)

"""
Get the component of type T with name. Returns nothing if no component matches. If T is an abstract
type then the names of components across all subtypes of T must be unique.

See [`get_components_by_name`](@ref) for abstract types with non-unique names across subtypes.

Throws ArgumentError if T is not a concrete type and there is more than one component with
    requested name
"""
get_component(::Type{T}, sys::System, name::AbstractString) where {T <: Component} =
    IS.get_component(T, sys, name)

"""
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
"""
get_component(
    scope_limiter::Union{Function, Nothing},
    selector::SingularComponentSelector,
    sys::System,
) =
    IS.get_component(scope_limiter, selector, sys)

"""
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none.
"""
get_component(selector::SingularComponentSelector, sys::System) =
    IS.get_component(selector, sys)

# get_available_components
"""
Like [`get_components`](@ref) but returns only those components `c` for which `get_available(c)`.
"""
get_available_components(
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component} =
    IS.get_available_components(T, sys; subsystem_name = subsystem_name)

get_available_components(sys::System, attribute::SupplementalAttribute) =
    IS.get_available_components(sys, attribute)

get_available_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
) where {T <: Component} =
    IS.get_available_components(filter_func, T, sys; subsystem_name = subsystem_name)

"""
Get the available components of the collection that make up the `ComponentSelector`.
"""
get_available_components(
    scope_limiter::Union{Function, Nothing},
    selector::ComponentSelector,
    sys::System,
) =
    IS.get_available_components(scope_limiter, selector::ComponentSelector, sys::System)

"""
Get the available components of the collection that make up the `ComponentSelector`.
"""
get_available_components(selector::ComponentSelector, sys::System) =
    IS.get_available_components(selector::ComponentSelector, sys::System)

# get_available_component
"""
Get the available component by UUID.
"""
get_available_component(sys::System, uuid::Base.UUID) =
    IS.get_available_component(sys, uuid)
get_available_component(sys::System, uuid::String) = IS.get_available_component(sys, uuid)

"""
Like [`get_component`](@ref) but also returns `nothing` if the component is not `get_available`.
"""
get_available_component(::Type{T}, sys::System, args...; kwargs...) where {T <: Component} =
    IS.get_available_component(T, sys, args...; kwargs...)

"""
Like [`get_component`](@ref) but also returns `nothing` if the component is not `get_available`.
"""
get_available_component(
    scope_limiter::Union{Function, Nothing},
    selector::IS.SingularComponentSelector,
    sys::System,
) =
    IS.get_available_component(scope_limiter, selector, sys)

"""
Like [`get_component`](@ref) but also returns `nothing` if the component is not `get_available`.
"""
get_available_component(
    selector::IS.SingularComponentSelector,
    sys::System,
) =
    IS.get_available_component(selector, sys)

# get_groups
"""
Get the groups that make up the `ComponentSelector`.
"""
get_groups(
    scope_limiter::Union{Function, Nothing},
    selector::ComponentSelector,
    sys::System,
) =
    IS.get_groups(scope_limiter, selector, sys)

"""
Get the groups that make up the `ComponentSelector`.
"""
get_groups(selector::ComponentSelector, sys::System) =
    IS.get_groups(selector, sys)

# get_available_groups
"""
Like [`get_groups`](@ref) but as if the `System` only contained its available components.
"""
get_available_groups(
    scope_limiter::Union{Function, Nothing},
    selector::ComponentSelector,
    sys::System,
) =
    IS.get_available_groups(scope_limiter, selector, sys)

"""
Like [`get_groups`](@ref) but as if the `System` only contained its available components.
"""
get_available_groups(selector::ComponentSelector, sys::System) =
    IS.get_available_groups(selector, sys)
