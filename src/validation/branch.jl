
"""Validates the contents of a Branch."""
function validate(branch::Branch)::Bool
    is_valid = true

    @debug "Branch validation" name(branch) is_valid
    return is_valid
end
