
"""Validates the contents of generators."""
function validate(gen::GenClasses)::Bool
    is_valid = true

    for field in fieldnames(typeof(gen))
        generators = getfield(gen, field)
        if !isnothing(generators)
            if !validate_devices(generators)
                is_valid = false
            end
        end
    end

    @debug "GenClasses validation" is_valid
    return is_valid
end

"""Validates the contents of a Generator."""
function validate(generator::Generator)::Bool
    is_valid = true

    @debug "Generator validation" name(generator) is_valid
    return is_valid
end
