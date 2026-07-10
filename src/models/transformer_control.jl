"""
    TransformerControl(; objective, regulated_bus_number, limits,
                       controlled_quantity_limits, number_of_tap_positions)

Control specification for a transformer winding tap changer or phase shifter,
mirroring the PSS/E per-winding control block.

The interpretation of `limits` (RMA/RMI) and `controlled_quantity_limits` (VMA/VMI)
depends on `objective` (COD): for voltage or reactive-power control `limits` bounds
the tap ratio and `controlled_quantity_limits` is in pu voltage / Mvar; for
active-power control `limits` bounds the phase angle (rad) and
`controlled_quantity_limits` is in MW. Values are stored as given by the data source.

An uncontrolled winding stores `nothing` in its `control` field, never a
`TransformerControl` with `objective = UNDEFINED`.

# Arguments
- `objective::TransformerControlObjective`: control mode (PSS/E COD)
- `regulated_bus_number::Int`: controlled bus number (PSS/E CONT; sign = regulation side)
- `limits::MinMax`: PSS/E RMA/RMI
- `controlled_quantity_limits::MinMax`: PSS/E VMA/VMI
- `number_of_tap_positions::Int`: PSS/E NTP
"""
struct TransformerControl
    objective::TransformerControlObjective
    regulated_bus_number::Int
    limits::MinMax
    controlled_quantity_limits::MinMax
    number_of_tap_positions::Int

    function TransformerControl(
        objective,
        regulated_bus_number,
        limits,
        controlled_quantity_limits,
        number_of_tap_positions,
    )
        objective == TransformerControlObjective.UNDEFINED && throw(
            ArgumentError(
                "An uncontrolled winding is represented by `control = nothing`, " *
                "not by objective = UNDEFINED.",
            ),
        )
        limits.min <= limits.max ||
            throw(ArgumentError("limits.min must be <= limits.max, got $limits"))
        controlled_quantity_limits.min <= controlled_quantity_limits.max || throw(
            ArgumentError(
                "controlled_quantity_limits.min must be <= max, got $controlled_quantity_limits",
            ),
        )
        number_of_tap_positions >= 0 || throw(
            ArgumentError(
                "number_of_tap_positions must be non-negative, got $number_of_tap_positions",
            ),
        )
        return new(
            objective,
            regulated_bus_number,
            limits,
            controlled_quantity_limits,
            number_of_tap_positions,
        )
    end
end

function TransformerControl(;
    objective,
    regulated_bus_number,
    limits,
    controlled_quantity_limits,
    number_of_tap_positions,
)
    return TransformerControl(
        objective,
        regulated_bus_number,
        limits,
        controlled_quantity_limits,
        number_of_tap_positions,
    )
end

get_objective(c::TransformerControl) = c.objective
get_regulated_bus_number(c::TransformerControl) = c.regulated_bus_number
get_limits(c::TransformerControl) = c.limits
get_controlled_quantity_limits(c::TransformerControl) = c.controlled_quantity_limits
get_number_of_tap_positions(c::TransformerControl) = c.number_of_tap_positions

# No Component-valued fields, so the generic field-iterating (de)serializers suffice;
# deserializing through the kwarg constructor re-runs the validation.
IS.serialize(c::TransformerControl) = IS.serialize_struct(c)
IS.deserialize(::Type{TransformerControl}, data::Dict) =
    IS.deserialize_struct(TransformerControl, data)
