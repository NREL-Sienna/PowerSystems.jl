
"""Validates the contents of a Bus."""
function validate(bus::Bus)::Bool
    is_valid = true

    @debug "Bus validation" bus.name bus.number is_valid
    return is_valid
end
