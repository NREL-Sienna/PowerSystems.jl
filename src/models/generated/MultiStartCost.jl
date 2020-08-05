#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct MultiStartCost <: OperationalCost
        variable::VariableCost
        no_load::Float64
        fixed::Float64
        startup::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
        shutdn::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost Data which includes fixed, variable cost, multiple start up cost and stop costs.

# Arguments
- `variable::VariableCost`: variable cost
- `no_load::Float64`: no load cost
- `fixed::Float64`: fixed cost
- `startup::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}`: startup cost
- `shutdn::Float64`: shutdown cost, validation range: (0, nothing), action if invalid: warn
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
    startup::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
    "shutdown cost"
    shutdn::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function MultiStartCost(variable, no_load, fixed, startup, shutdn, forecasts=InfrastructureSystems.Forecasts(), )
    MultiStartCost(variable, no_load, fixed, startup, shutdn, forecasts, InfrastructureSystemsInternal(), )
end

function MultiStartCost(; variable, no_load, fixed, startup, shutdn, forecasts=InfrastructureSystems.Forecasts(), )
    MultiStartCost(variable, no_load, fixed, startup, shutdn, forecasts, )
end

# Constructor for demo purposes; non-functional.
function MultiStartCost(::Nothing)
    MultiStartCost(;
        variable=VariableCost((0.0, 0.0)),
        no_load=0.0,
        fixed=0.0,
        startup=(hot = START_COST, warm = START_COST,cold = START_COST),
        shutdn=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get MultiStartCost variable."""
get_variable(value::MultiStartCost) = value.variable
"""Get MultiStartCost no_load."""
get_no_load(value::MultiStartCost) = value.no_load
"""Get MultiStartCost fixed."""
get_fixed(value::MultiStartCost) = value.fixed
"""Get MultiStartCost startup."""
get_startup(value::MultiStartCost) = value.startup
"""Get MultiStartCost shutdn."""
get_shutdn(value::MultiStartCost) = value.shutdn

InfrastructureSystems.get_forecasts(value::MultiStartCost) = value.forecasts
"""Get MultiStartCost internal."""
get_internal(value::MultiStartCost) = value.internal

"""Set MultiStartCost variable."""
set_variable!(value::MultiStartCost, val) = value.variable = val
"""Set MultiStartCost no_load."""
set_no_load!(value::MultiStartCost, val) = value.no_load = val
"""Set MultiStartCost fixed."""
set_fixed!(value::MultiStartCost, val) = value.fixed = val
"""Set MultiStartCost startup."""
set_startup!(value::MultiStartCost, val) = value.startup = val
"""Set MultiStartCost shutdn."""
set_shutdn!(value::MultiStartCost, val) = value.shutdn = val

InfrastructureSystems.set_forecasts!(value::MultiStartCost, val) = value.forecasts = val
"""Set MultiStartCost internal."""
set_internal!(value::MultiStartCost, val) = value.internal = val
