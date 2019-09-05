struct ValidationInfo
    field_descriptor::Dict
    struct_name::AbstractString
    ps_struct::PowerSystemType
    field_type::Any
    limits:: Union{NamedTuple{(:min, :max)}, NamedTuple{(:min, :max, :zero)}}
end

#Get validation info for one struct.
function get_config_descriptor(config::Vector, name::AbstractString)
    for item in config
        if item["struct_name"] == name
            return item
        end
    end
    error("PowerSystems struct $name does not exist in validation configuration file")
end

#Get validation info for one field of one struct.
function get_field_descriptor(struct_descriptor::Dict, fieldname::AbstractString)
    for field in struct_descriptor["fields"]
        if field["name"] == fieldname
            return field
        end
    end

    throw(DataFormatError("field $fieldname does not exist in $(struct_descriptor["struct_name"]) validation config"))
end

function validate_fields(sys::System, ps_struct::T) where T <: PowerSystemType
    struct_descriptor = get_config_descriptor(sys.validation_descriptor, repr(T))
    is_valid = true

    for (name,fieldtype) in zip(fieldnames(T), fieldtypes(T))
        field_value = getfield(ps_struct, name)
        if isnothing(field_value) #Many structs are of type Union{Nothing, xxx}.
            ;
        elseif fieldtype <: Union{Nothing, PowerSystemType} && !(fieldtype <: Component)
            # Recurse. Components are validated separately and do not need to be validated twice.
            if !validate_fields(sys, getfield(ps_struct, name))
                is_valid = false
            end
        else
            field_descriptor = get_field_descriptor(struct_descriptor, string(name))
            if !haskey(field_descriptor, "valid_range")
                continue
            end
            valid_range = field_descriptor["valid_range"]
            limits = get_limits(valid_range, ps_struct)
            valid_info = ValidationInfo(field_descriptor, struct_descriptor["struct_name"],
                                        ps_struct, fieldtype, limits)
            if !validate_range(valid_range, valid_info, field_value)
                is_valid = false
            end
        end
    end
    return is_valid
end

function get_limits(valid_range::String, ps_struct::PowerSystemType)
    #Gets min and max values from activepowerlimits for activepower, etc.
    function recur(d, a, i=1)
        if i <= length(a)
            d = getfield(d,Symbol(a[i]))
            recur(d,a,i+1)
        else
            return d
        end
    end
    valid_range, ps_struct
    vr = recur(ps_struct, split(valid_range,"."))

    if isnothing(vr)
        limits = (min=nothing, max=nothing)
    else
        limits = get_limits(vr, ps_struct)
    end
    return limits
end

function get_limits(valid_range::Dict, unused::PowerSystemType)
    #Gets min and max value defined for a field, e.g. "valid_range": {"min":-1.571, "max":1.571}.
    limits = (min = valid_range["min"], max = valid_range["max"])
    return limits
end


function get_limits(valid_range::Union{NamedTuple{(:min,:max)}, NamedTuple{(:max,:min)}},
                    unused::PowerSystemType)
    #Gets min and max value defined for a field, e.g. "valid_range": {"min":-1.571, "max":1.571}.
    limits = (min = valid_range.min, max = valid_range.max)
    return limits
end

function get_limits(valid_range::Union{NamedTuple{(:min,:max)}, NamedTuple{(:max,:min)}},
                    unused::T) where T <: Generator
    #Gets min and max value defined for a field, e.g. "valid_range": {"min":-1.571, "max":1.571}.
    limits = (min = valid_range.min, max = valid_range.max, zero = 0.0)
    return limits
end

function validate_range(::String, valid_info::ValidationInfo, field_value)
    #Validates activepower against activepowerlimits, etc.
    is_valid = true
    if !isnothing(valid_info.limits)
        is_valid = check_limits_impl(valid_info, field_value)
    end
    return is_valid
end

function validate_range(::Union{Dict, NamedTuple{(:min,:max)}, NamedTuple{(:max,:min)}, NamedTuple{(:min,:max,:zero)}},
                        valid_info::ValidationInfo, field_value)
    return check_limits(valid_info.field_type, valid_info, field_value)
end

function check_limits(::Type{T}, valid_info::ValidationInfo, field_value) where T <: Union{Nothing, Float64}
    #Validates numbers.
    return check_limits_impl(valid_info, field_value)
end

function check_limits(::Type{T}, valid_info::ValidationInfo, field_value) where T <: Union{Nothing, NamedTuple}
    #Validates up/down, min/max, from/to named tuples.
    @assert length(field_value) == 2
    result1 = check_limits_impl(valid_info, field_value[1])
    result2 = check_limits_impl(valid_info, field_value[2])
    return result1 && result2
end

function check_limits_impl(valid_info::ValidationInfo, field_value)
    is_valid = true
    action_function = get_validation_action(valid_info.field_descriptor)
    if ((!isnothing(valid_info.limits.min) && field_value < valid_info.limits.min) ||
        (!isnothing(valid_info.limits.max) && field_value > valid_info.limits.max)) &&
        !(haskey(valid_info.limits, :zero) && field_value == 0.0)

        is_valid = action_function(valid_info, field_value)
    end
    return is_valid
end

function get_validation_action(field_descriptor::Dict)
    action = get(field_descriptor, "validation_action", "error")
    if action == "warn"
        action_function = validation_warning
    elseif action == "error"
        action_function = validation_error
    else
        error("Invalid validation action $action")
    end
    return action_function
end

function validation_warning(valid_info::ValidationInfo, field_value)
    valid_range = valid_info.field_descriptor["valid_range"]
    field_name = valid_info.field_descriptor["name"]
    @warn "Invalid range" valid_info.struct_name field_name field_value valid_range valid_info.ps_struct
    return true
end

function validation_error(valid_info::ValidationInfo, field_value)
    valid_range = valid_info.field_descriptor["valid_range"]
    field_name = valid_info.field_descriptor["name"]
    @error "Invalid range" valid_info.struct_name field_name field_value valid_range valid_info.ps_struct
    return false
end


function validate_struct(sys::System, ps_struct::T) where T <: PowerSystemType
    return true
end

"""
    validate_system(sys::System)

Iterates over all components and throws InvalidRange if any of the component's field values are outside of defined valid range.
"""
function validate_system(sys::System)
    error_detected = false
    for component in iterate_components(sys)
        if validate_fields(sys, component)
            error_detected = true
        end
        if validate_struct(sys, component)
            error_detected = true
        end
    end
    if error_detected
        throw(InvalidRange("Invalid range detected"))
    end
end
