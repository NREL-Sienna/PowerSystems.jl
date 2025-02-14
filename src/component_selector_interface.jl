# A continuation of `get_components_interface.jl` to facilitate neater documentation of
# `ComponentSelector`. See the long comment at the top of that file.

# get_components
"""
Get the components of the `System` that make up the `ComponentSelector`. Optionally specify
a filter function `scope_limiter` as the first argument to limit the components that should
be considered.
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
Get the component of the `System` that makes up the `SingularComponentSelector`; `nothing`
if there is none. Optionally specify a filter function `scope_limiter` as the first argument
to limit the components that should be considered.
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
Get the available components of the collection that make up the `ComponentSelector`.
Optionally specify a filter function `scope_limiter` as the first argument to further limit
the components that should be considered.
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
Like [`get_component`](@ref) but also returns `nothing` if the component is not
[`get_available`](@ref). Optionally specify a filter function `scope_limiter` as the first
argument to limit the components that should be considered.
"""
get_available_component(
    scope_limiter::Union{Function, Nothing},
    selector::IS.SingularComponentSelector,
    sys::System,
) =
    IS.get_available_component(scope_limiter, selector, sys)

"""
Like [`get_component`](@ref) but also returns `nothing` if the component is not [`get_available`](@ref).
"""
get_available_component(
    selector::IS.SingularComponentSelector,
    sys::System,
) =
    IS.get_available_component(selector, sys)

# get_groups
"""
Get the groups that make up the `ComponentSelector`. Optionally specify a filter function
`scope_limiter` as the first argument to limit the components that should be considered.
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
Optionally specify a filter function `scope_limiter` as the first argument to limit the
components that should be considered.
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
