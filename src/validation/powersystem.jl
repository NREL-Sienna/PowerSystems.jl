
include("branch.jl")
include("bus.jl")
include("generator.jl")
include("load.jl")
include("storage.jl")


"""Validates an array of devices."""
function validate_devices(devices::Array{<: PowerSystemDevice, 1})::Bool
    is_valid = true

    for device in devices
        if !validate(device)
            is_valid = false
        end
    end

    return is_valid
end

"""Validates the contents of a PowerSystem."""
function validate(sys::PowerSystem)::Bool
    is_valid = true

    for field in (:buses, :loads)
        objs = getfield(sys, field)
        if !validate_devices(objs)
            is_valid = false
        end
    end

    if !validate(sys.generators)
        is_valid = false
    end

    for field in (:branches, :storage)
        objs = getfield(sys, field)
        if !isnothing(objs)
            if !validate_devices(objs)
                is_valid = false
            end
        end
    end

    @debug "PowerSystem validation" is_valid
    return is_valid
end
