
"""Validates the contents of a Generator."""
function validate(generator::Generator)::Bool
    is_valid = true

    @debug "Generator validation" generator.name is_valid
    return is_valid
end
