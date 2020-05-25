#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PGLIBCost <: OperationalCost
        variable::VariableCost
        no_load::Float64
        fixed::Float64
        startup::Float64
        shutdn::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost Data in Three parts fixed, variable cost and start - stop costs.

# Arguments
- `variable::VariableCost`: variable cost
- `no_load::Float64`: no load cost
- `fixed::Float64`: fixed cost
- `startup::Float64`: startup cost, validation range: (0, nothing), action if invalid: warn
- `shutdn::Float64`: shutdown cost, validation range: (0, nothing), action if invalid: warn
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PGLIBCost <: OperationalCost
    "variable cost"
    variable::VariableCost
    "no load cost"
    no_load::Float64
    "fixed cost"
    fixed::Float64
    "startup cost"
    startup::Float64
    "shutdown cost"
    shutdn::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PGLIBCost(variable, no_load, fixed, startup, shutdn, forecasts=InfrastructureSystems.Forecasts(), )
    PGLIBCost(variable, no_load, fixed, startup, shutdn, forecasts, InfrastructureSystemsInternal(), )
end

function PGLIBCost(; variable, no_load, fixed, startup, shutdn, forecasts=InfrastructureSystems.Forecasts(), )
    PGLIBCost(variable, no_load, fixed, startup, shutdn, forecasts, )
end

# Constructor for demo purposes; non-functional.
function PGLIBCost(::Nothing)
    PGLIBCost(;
        variable=VariableCost((0.0, 0.0)),
        no_load=0.0,
        fixed=0.0,
        startup=0.0,
        shutdn=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get PGLIBCost variable."""
get_variable(value::PGLIBCost) = value.variable
"""Get PGLIBCost no_load."""
get_no_load(value::PGLIBCost) = value.no_load
"""Get PGLIBCost fixed."""
get_fixed(value::PGLIBCost) = value.fixed
"""Get PGLIBCost startup."""
get_startup(value::PGLIBCost) = value.startup
"""Get PGLIBCost shutdn."""
get_shutdn(value::PGLIBCost) = value.shutdn

InfrastructureSystems.get_forecasts(value::PGLIBCost) = value.forecasts
"""Get PGLIBCost internal."""
get_internal(value::PGLIBCost) = value.internal

"""Set PGLIBCost variable."""
set_variable!(value::PGLIBCost, val::VariableCost) = value.variable = val
"""Set PGLIBCost no_load."""
set_no_load!(value::PGLIBCost, val::Float64) = value.no_load = val
"""Set PGLIBCost fixed."""
set_fixed!(value::PGLIBCost, val::Float64) = value.fixed = val
"""Set PGLIBCost startup."""
set_startup!(value::PGLIBCost, val::Float64) = value.startup = val
"""Set PGLIBCost shutdn."""
set_shutdn!(value::PGLIBCost, val::Float64) = value.shutdn = val

InfrastructureSystems.set_forecasts!(value::PGLIBCost, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set PGLIBCost internal."""
set_internal!(value::PGLIBCost, val::InfrastructureSystemsInternal) = value.internal = val
