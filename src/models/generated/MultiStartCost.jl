#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct MultiStartCost <: OperationalCost
        variable::VariableCost
        no_load::Float64
        fixed::Float64
        start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
        shut_dn::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost Data which includes fixed, variable cost, multiple start up cost and stop costs.

# Arguments
- `variable::VariableCost`: variable cost
- `no_load::Float64`: no load cost
- `fixed::Float64`: fixed cost
- `start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}`: startup cost
- `shut_dn::Float64`: shutdown cost, validation range: (0, nothing), action if invalid: warn
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct MultiStartCost <: OperationalCost
    "variable cost"
    variable::VariableCost
    "no load cost"
    no_load::Float64
    "fixed cost"
    fixed::Float64
    "startup cost"
    start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
    "shutdown cost"
    shut_dn::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function MultiStartCost(variable, no_load, fixed, start_up, shut_dn, forecasts=InfrastructureSystems.Forecasts(), )
    MultiStartCost(variable, no_load, fixed, start_up, shut_dn, forecasts, InfrastructureSystemsInternal(), )
end

function MultiStartCost(; variable, no_load, fixed, start_up, shut_dn, forecasts=InfrastructureSystems.Forecasts(), )
    MultiStartCost(variable, no_load, fixed, start_up, shut_dn, forecasts, )
end

# Constructor for demo purposes; non-functional.
function MultiStartCost(::Nothing)
    MultiStartCost(;
        variable=VariableCost((0.0, 0.0)),
        no_load=0.0,
        fixed=0.0,
        start_up=(hot = START_COST, warm = START_COST,cold = START_COST),
        shut_dn=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get MultiStartCost variable."""
get_variable(value::MultiStartCost) = value.variable
"""Get MultiStartCost no_load."""
get_no_load(value::MultiStartCost) = value.no_load
"""Get MultiStartCost fixed."""
get_fixed(value::MultiStartCost) = value.fixed
"""Get MultiStartCost start_up."""
get_start_up(value::MultiStartCost) = value.start_up
"""Get MultiStartCost shut_dn."""
get_shut_dn(value::MultiStartCost) = value.shut_dn

InfrastructureSystems.get_forecasts(value::MultiStartCost) = value.forecasts
"""Get MultiStartCost internal."""
get_internal(value::MultiStartCost) = value.internal

"""Set MultiStartCost variable."""
set_variable!(value::MultiStartCost, val::VariableCost) = value.variable = val
"""Set MultiStartCost no_load."""
set_no_load!(value::MultiStartCost, val::Float64) = value.no_load = val
"""Set MultiStartCost fixed."""
set_fixed!(value::MultiStartCost, val::Float64) = value.fixed = val
"""Set MultiStartCost start_up."""
set_start_up!(value::MultiStartCost, val::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}) = value.start_up = val
"""Set MultiStartCost shut_dn."""
set_shut_dn!(value::MultiStartCost, val::Float64) = value.shut_dn = val

InfrastructureSystems.set_forecasts!(value::MultiStartCost, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set MultiStartCost internal."""
set_internal!(value::MultiStartCost, val::InfrastructureSystemsInternal) = value.internal = val
