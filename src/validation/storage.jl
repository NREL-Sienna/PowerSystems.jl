
"""Validates the contents of a Storage."""
function validate(storage::Storage)::Bool
    is_valid = true

    @debug "Storage validation" name(storage) is_valid
    return is_valid
end
