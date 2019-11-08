#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ThreePartCost <: OperationalCost
        variable::VariableCost
        fixed::Float64
        startup::Float64
        shutdn::Float64
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost Data in Three parts fixed, variable cost and start - stop costs.

# Arguments
-`variable::VariableCost`: variable cost
-`fixed::Float64`: fixed cost
-`startup::Float64`: startup cost
-`shutdn::Float64`: shutdown cost
-`_forecasts::InfrastructureSystems.Forecasts`: component forecasts
-`internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThreePartCost <: OperationalCost
    "variable cost"
    variable::VariableCost
    "fixed cost"
    fixed::Float64
    "startup cost"
    startup::Float64
    "shutdown cost"
    shutdn::Float64
    "component forecasts"
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThreePartCost(variable, fixed, startup, shutdn, _forecasts=InfrastructureSystems.Forecasts(), )
    ThreePartCost(variable, fixed, startup, shutdn, _forecasts, InfrastructureSystemsInternal())
end

function ThreePartCost(; variable, fixed, startup, shutdn, _forecasts=InfrastructureSystems.Forecasts(), )
    ThreePartCost(variable, fixed, startup, shutdn, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function ThreePartCost(::Nothing)
    ThreePartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
        startup=0.0,
        shutdn=0.0,
        _forecasts=InfrastructureSystems.Forecasts(),
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
"""Get ThreePartCost _forecasts."""
get__forecasts(value::ThreePartCost) = value._forecasts
"""Get ThreePartCost internal."""
get_internal(value::ThreePartCost) = value.internal
