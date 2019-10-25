#=
This file is auto-generated. Do not edit.
=#

"""Data Structure Operational Cost Data in two parts fixed and variable cost."""
mutable struct TwoPartCost <: OperationalCost
    variable::VariableCost
    fixed::Float64
    _forecasts::InfrastructureSystems.Forecasts
    internal::InfrastructureSystemsInternal
end

function TwoPartCost(variable, fixed, _forecasts=InfrastructureSystems.Forecasts(), )
    TwoPartCost(variable, fixed, _forecasts, InfrastructureSystemsInternal())
end

function TwoPartCost(; variable, fixed, _forecasts=InfrastructureSystems.Forecasts(), )
    TwoPartCost(variable, fixed, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function TwoPartCost(::Nothing)
    TwoPartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get TwoPartCost variable."""
get_variable(value::TwoPartCost) = value.variable
"""Get TwoPartCost fixed."""
get_fixed(value::TwoPartCost) = value.fixed
"""Get TwoPartCost _forecasts."""
get__forecasts(value::TwoPartCost) = value._forecasts
"""Get TwoPartCost internal."""
get_internal(value::TwoPartCost) = value.internal
