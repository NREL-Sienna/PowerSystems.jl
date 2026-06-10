###############################
# Power-domain unit types.
#
# Relative-unit markers (`DU`, `SU`, `NU`, `AbstractRelativeUnit`,
# `RelativeQuantity`) live in InfrastructureSystems and are re-exported from
# this package. This file adds the power-domain Unitful units and the
# `UnitArg` convenience union.
###############################

# Power-system-specific natural units (same dimension as MW, different display)
@unit Mvar "Mvar" Mvar 1u"MW" false
@unit MVA "MVA" MVA 1u"MW" false

# Re-export common Unitful units for power systems
const MW = u"MW"
const kV = u"kV"
const OHMS = u"Ω"
const SIEMENS = u"S"

"""
Accepted target-unit argument for unit-aware getters/setters: a Unitful unit
(e.g. `MW`, `kV`) or a relative per-unit marker (`DU`, `SU`, `NU`).
"""
const UnitArg = Union{Unitful.Units, IS.AbstractUnitSystem}

# One public strip generic for both quantity kinds: Unitful's `ustrip` works on
# `RelativeQuantity` too (IS deliberately does not define its own `ustrip`).
Unitful.ustrip(q::IS.RelativeQuantity) = IS._strip_units(q)
