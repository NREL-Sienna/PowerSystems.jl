"""
    EmissionsData(; name, pollutant, emission_rate, basis, energy_unit, ...)

A [`SupplementalAttribute`](@ref) describing the emission of a single pollutant from a
host component. Combines pollutant identity (CO2, NOx, etc.) with an emission rate
expressed as a [`ValueCurve`](@ref) (supporting constant, linear, or piecewise
relationships between fuel consumption / power output and emissions). One `EmissionsData`
instance can be attached to one or many components via [`add_supplemental_attribute!`](@ref).

# Arguments
- `name::String`: Identifier for this emissions attribute.
- `pollutant::PollutantType`: Scoped enum (CO2, CO2E, CH4, N2O, NOX, SO2, PM25, PM10, HG, HAP, CUSTOM).
- `emission_rate::ValueCurve`: Emission rate as a [`ValueCurve`](@ref), typically an
    [`IncrementalCurve`](@ref). A convenience constructor accepts a `Real` scalar, which
    is wrapped in an `IncrementalCurve` with constant rate.
- `basis::EmissionBasis`: FUEL_INPUT (mass per unit of heat input) or POWER_OUTPUT (mass per unit of electrical output).
- `energy_unit::EnergyUnit`: Energy unit for the rate denominator (MMBTU, GJ, or MWH). Must be consistent with `basis`.
- `start_up_adder::Float64`: (default: `0.0`) Per-start emission pulse, in `mass_unit`.
- `mass_unit::MassUnit`: (default: `MassUnit.KG`) KG, LB, SHORT_TON, METRIC_TON.
- `gwp::Float64`: (default: `1.0`) GWP100 multiplier for CO2-equivalent reporting.
- `available::Bool`: (default: `true`) Whether this attribute is active.
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) Extra metadata dictionary.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems internal reference.
"""
mutable struct EmissionsData <: SupplementalAttribute
    name::String
    pollutant::PollutantType
    emission_rate::IS.ValueCurve
    basis::EmissionBasis
    start_up_adder::Float64
    mass_unit::MassUnit
    energy_unit::EnergyUnit
    gwp::Float64
    available::Bool
    ext::Dict{String, Any}
    internal::InfrastructureSystemsInternal
end

# Validation helpers (shared between constructor and setters)
function _validate_nonneg_finite(val::Real, field::String)
    if !isfinite(val) || val < 0.0
        throw(ArgumentError("$field must be finite and >= 0.0, got $val"))
    end
end

function _validate_pos_finite(val::Real, field::String)
    if !isfinite(val) || val <= 0.0
        throw(ArgumentError("$field must be finite and > 0.0, got $val"))
    end
end

function _validate_basis_energy_unit(basis::EmissionBasis, energy_unit::EnergyUnit)
    if basis == EmissionBasis.FUEL_INPUT
        if energy_unit != EnergyUnit.MMBTU && energy_unit != EnergyUnit.GJ
            throw(
                ArgumentError(
                    "energy_unit must be MMBTU or GJ when basis is FUEL_INPUT, got $energy_unit",
                ),
            )
        end
    elseif basis == EmissionBasis.POWER_OUTPUT
        if energy_unit != EnergyUnit.MWH
            throw(
                ArgumentError(
                    "energy_unit must be MWH when basis is POWER_OUTPUT, got $energy_unit",
                ),
            )
        end
    end
end

"""
    EmissionsData(; name, pollutant, emission_rate, basis, energy_unit, ...)

Construct an [`EmissionsData`](@ref) with validation.

`emission_rate` can be any [`ValueCurve`](@ref) (e.g., `IncrementalCurve`,
`InputOutputCurve`) or a scalar `Real` value (which is automatically wrapped in an
`IncrementalCurve` with constant rate).
"""
function EmissionsData(;
    name::AbstractString,
    pollutant::PollutantType,
    emission_rate::Union{Real, IS.ValueCurve},
    basis::EmissionBasis,
    energy_unit::EnergyUnit,
    start_up_adder::Real = 0.0,
    mass_unit::MassUnit = MassUnit.KG,
    gwp::Real = 1.0,
    available::Bool = true,
    ext::Dict{String, Any} = Dict{String, Any}(),
    internal::InfrastructureSystemsInternal = InfrastructureSystemsInternal(),
)
    _validate_nonneg_finite(start_up_adder, "start_up_adder")
    _validate_pos_finite(gwp, "gwp")

    # Validate basis/energy_unit combination
    _validate_basis_energy_unit(basis, energy_unit)

    # Convert scalar to IncrementalCurve with constant rate
    if emission_rate isa Real
        _validate_nonneg_finite(emission_rate, "emission_rate")
        rate = IS.IncrementalCurve(
            LinearFunctionData(0.0, Float64(emission_rate)),
            nothing,
            nothing,
        )
    else
        rate = emission_rate
    end

    return EmissionsData(
        String(name),
        pollutant,
        rate,
        basis,
        Float64(start_up_adder),
        mass_unit,
        energy_unit,
        Float64(gwp),
        available,
        ext,
        internal,
    )
end

# IS integration
supports_time_series(::EmissionsData) = false

"""Get [`EmissionsData`](@ref) `name`."""
get_name(value::EmissionsData) = value.name
"""Get [`EmissionsData`](@ref) `pollutant`."""
get_pollutant(value::EmissionsData) = value.pollutant
"""Get [`EmissionsData`](@ref) `emission_rate`."""
get_emission_rate(value::EmissionsData) = value.emission_rate
"""Get [`EmissionsData`](@ref) `basis`."""
get_basis(value::EmissionsData) = value.basis
"""Get [`EmissionsData`](@ref) `start_up_adder`."""
get_start_up_adder(value::EmissionsData) = value.start_up_adder
"""Get [`EmissionsData`](@ref) `mass_unit`."""
get_mass_unit(value::EmissionsData) = value.mass_unit
"""Get [`EmissionsData`](@ref) `energy_unit`."""
get_energy_unit(value::EmissionsData) = value.energy_unit
"""Get [`EmissionsData`](@ref) `gwp`."""
get_gwp(value::EmissionsData) = value.gwp
"""Get [`EmissionsData`](@ref) `available`."""
get_available(value::EmissionsData) = value.available
"""Get [`EmissionsData`](@ref) `ext`."""
get_ext(value::EmissionsData) = value.ext
"""Get [`EmissionsData`](@ref) `internal`."""
get_internal(value::EmissionsData) = value.internal

"""Set [`EmissionsData`](@ref) `emission_rate` with a [`ValueCurve`](@ref)."""
function set_emission_rate!(value::EmissionsData, val::IS.ValueCurve)
    value.emission_rate = val
    return
end

"""Set [`EmissionsData`](@ref) `emission_rate` with a scalar (wraps in `IncrementalCurve` with constant rate)."""
function set_emission_rate!(value::EmissionsData, val::Real)
    _validate_nonneg_finite(val, "emission_rate")
    value.emission_rate =
        IS.IncrementalCurve(LinearFunctionData(0.0, Float64(val)), nothing, nothing)
    return
end

"""Set [`EmissionsData`](@ref) `start_up_adder`."""
function set_start_up_adder!(value::EmissionsData, val::Real)
    _validate_nonneg_finite(val, "start_up_adder")
    value.start_up_adder = Float64(val)
    return
end

"""Set [`EmissionsData`](@ref) `available`."""
function set_available!(value::EmissionsData, val::Bool)
    value.available = val
    return
end

"""Set [`EmissionsData`](@ref) `gwp`."""
function set_gwp!(value::EmissionsData, val::Real)
    _validate_pos_finite(val, "gwp")
    value.gwp = Float64(val)
    return
end
