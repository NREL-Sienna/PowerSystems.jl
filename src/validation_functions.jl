mutable struct validation_info
    field_descriptor::Union{Nothing, Dict}
    struct_name::AbstractString
    validation_action::Union{Nothing, Bool}
    component::PowerSystemType
    field_type::Any
    valid_min::Union{Nothing, Float64}
    valid_max::Union{Nothing, Float64}
end

#Get validation info for one struct
function get_config_descriptor(config::Vector, name::AbstractString)
    for item in config
        if item["struct_name"] == name
            return item
        end
    end
    error("PowerSystems struct $name does not exist in validation configuration file")
end

#Get validation info for one field of one struct
function get_field_descriptor(struct_descriptor::Dict, fieldname::AbstractString)
    for field in struct_descriptor["fields"]
        if field["name"] == fieldname
            return field
        end
    end
    error("field $fieldname does not exist in $(struct_descriptor["name"])")
end

function validate_fields(sys::System, component::T) where T <: PowerSystemType
    struct_descriptor = get_config_descriptor(sys.validation_descriptor, repr(T))
    valid_info = validation_info(nothing, struct_descriptor["struct_name"], false,
                                           component, nothing, nothing, nothing)
    for (name,fieldtype) in zip(fieldnames(T), fieldtypes(T))
        field_value = getfield(component, name)
        valid_info.field_type = fieldtype

        if field_value == nothing
            continue
        end
        if fieldtype <: Union{Nothing, PowerSystemType} && !(fieldtype <: Component)
            error_detected = validate_fields(sys, getfield(component, name))
            if error_detected
                valid_info.validation_action = true
            end
        else
            field_descriptor = get_field_descriptor(struct_descriptor, string(name))
            valid_info.field_descriptor = field_descriptor
            validate_num_value(valid_info, field_value)
        end
    end
    return valid_info.validation_action
end

function validate_num_value(valid_info::validation_info, field_value)
    if haskey(valid_info.field_descriptor, "valid_range")
        if valid_info.field_descriptor["valid_range"] isa String
            validate_custom_range!(valid_info, field_value)
        else
            validate_standard_range!(valid_info, field_value)
        end
    end
end

#validates activepower against activepowerlimits, etc.
function validate_custom_range!(valid_info::validation_info, field_value)
    limits = getfield(valid_info.component, Symbol(valid_info.field_descriptor["valid_range"]))
    if !isnothing(limits)
        valid_info.valid_min = limits.min
        valid_info.valid_max = limits.max
        check_limits(valid_info, field_value)
    end
end

function validate_standard_range!(valid_info::validation_info, field_value)
    valid_info.valid_min = valid_info.field_descriptor["valid_range"]["min"]
    valid_info.valid_max = valid_info.field_descriptor["valid_range"]["max"]
    if valid_info.field_type <: Union{Nothing, NamedTuple}
        check_limits(valid_info, field_value[1])
        check_limits(valid_info, field_value[2])
    else
        check_limits(valid_info, field_value)
    end
end

function check_limits(valid_info::validation_info, field_value)
    action_function = get_validation_action(valid_info.field_descriptor)
    if !isnothing(valid_info.valid_min) && field_value < valid_info.valid_min
        action_function(valid_info, field_value)
    elseif !isnothing(valid_info.valid_max) && field_value > valid_info.valid_max
        action_function(valid_info, field_value)
    end
end

function get_validation_action(field_descriptor::Dict)
    action = get(field_descriptor, "validation_action", "error")
    if action == "warn"
        action_function = validation_warning
    elseif action == "error"
        action_function = validation_error!
    else
        error("Invalid validation action $action")
    end
    return action_function
end

function validation_warning(valid_info::validation_info, field_value)
    valid_range = valid_info.field_descriptor["valid_range"]
    field_name = valid_info.field_descriptor["name"]
    @warn "Invalid range" valid_info.struct_name field_name field_value valid_range
end

function validation_error!(valid_info::validation_info, field_value)
    valid_range = valid_info.field_descriptor["valid_range"]
    field_name = valid_info.field_descriptor["name"]
    @error "Invalid range" valid_info.struct_name field_name field_value valid_range
    valid_info.validation_action = true
end

#could be called from PowerSimulations
function validate_system(sys::System)
    error_detected = false
    for component in iterate_components(sys)
        if validate_fields(sys, component)
            error_detected = true
        end
    end
    if error_detected
        error("Invalid range detected")
    end
end
