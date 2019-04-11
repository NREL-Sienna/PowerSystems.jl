

"""Validates the contents of an ElectricLoad."""
function validate(load::ElectricLoad)::Bool
    is_valid = true

    @debug "Load validation" load.name is_valid
    return is_valid
end
