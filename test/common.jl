
const DESCRIPTORS = joinpath(RTS_GMLC_DIR, "user_descriptors.yaml")

function create_rts_system(forecast_resolution=Dates.Hour(1))
    data = PowerSystemRaw(RTS_GMLC_DIR, 100.0, DESCRIPTORS)
    return System(data; forecast_resolution=forecast_resolution)
end

"""Allows comparison of structs that were created from different parsers which causes them
to have different UUIDs."""
function compare_values_without_uuids(x::T, y::T)::Bool where T <: PowerSystemType
    match = true

    for (fieldname, fieldtype) in zip(fieldnames(T), fieldtypes(T))
        if fieldname == :internal
            continue
        end

        val1 = getfield(x, fieldname)
        val2 = getfield(y, fieldname)

        # Recurse if this is a PowerSystemType.
        if val1 isa PowerSystemType
            if !compare_values_without_uuids(val1, val2)
                match = false
            end
            continue
        end

        if val1 != val2
            @error "values do not match" fieldname val1 val2
            match = false
        end
    end

    return match
end

"""Return the first component of type component_type that matches the name of other."""
function get_component_by_name(sys::System, component_type, other::Component)
    for component in get_components(component_type, sys)
        if get_name(component) == get_name(other)
            return component
        end
    end

    error("Did not find component $component")
end

"""Return the Branch in the system that matches another by case-insensitive connectionpoints
names."""
function get_branch(sys::System, other::Branch)
    for branch in get_components(Branch, sys)
        if lowercase(other.connectionpoints.from.name) == lowercase(branch.connectionpoints.from.name) &&
            lowercase(other.connectionpoints.to.name) == lowercase(branch.connectionpoints.to.name)
            return branch
        end
    end

    error("Did not find branch with buses $(other.connectionpoints.from.name) ",
          "$(other.connectionpoints.to.name)")
end

