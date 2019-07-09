#=
This file is auto-generated. Do not edit.
=#

"""Data Structure Operational Cost Data in Three parts fixed, variable cost and start - stop costs."""
mutable struct ThreePartCost <: OperationalCost
    variable::VariableCost
    fixed::Float64
    startup::Float64
    shutdn::Float64
    internal::PowerSystems.PowerSystemInternal
end

function ThreePartCost(variable, fixed, startup, shutdn, )
    ThreePartCost(variable, fixed, startup, shutdn, PowerSystemInternal())
end

function ThreePartCost(; variable, fixed, startup, shutdn, )
    ThreePartCost(variable, fixed, startup, shutdn, )
end

# Constructor for demo purposes; non-functional.

function ThreePartCost(::Nothing)
    ThreePartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
        startup=0.0,
        shutdn=0.0,
    )
end

"""Get ThreePartCost variable."""
get_variable(value::ThreePartCost) = value.variable
"""Get ThreePartCost fixed."""
get_fixed(value::ThreePartCost) = value.fixed
"""Get ThreePartCost startup."""
get_startup(value::ThreePartCost) = value.startup
"""Get ThreePartCost shutdn."""
get_shutdn(value::ThreePartCost) = value.shutdn
"""Get ThreePartCost internal."""
get_internal(value::ThreePartCost) = value.internal
