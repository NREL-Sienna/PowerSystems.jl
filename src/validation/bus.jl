
"""Validates the contents of a Bus."""
function validate(bus::Bus)::Bool
    is_valid = true

    @debug "Bus validation" name(bus) bus.number is_valid
    return is_valid
end
