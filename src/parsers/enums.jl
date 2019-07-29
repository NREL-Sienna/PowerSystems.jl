
@enum InputCategory begin
    BRANCH
    BUS
    DC_BRANCH
    GENERATOR
    LOAD
    RESERVES
    SIMULATION_OBJECTS
    STORAGE
    TIMESERIES_POINTERS
end

ENUM_MAPPINGS = Dict()
for enum in (AngleUnit, BusType, InputCategory)
    ENUM_MAPPINGS[enum] = Dict()
    for value in instances(enum)
        ENUM_MAPPINGS[enum][lowercase(string(value))] = value
    end
end

"""Get the enum value for the string. Case insensitive."""
function get_enum_value(enum, value::String)
    if !haskey(ENUM_MAPPINGS, enum)
        throw(InvalidParameter("enum=$enum is not valid"))
    end

    val = lowercase(value)
    if !haskey(ENUM_MAPPINGS[enum], val)
        throw(InvalidParameter("enum=$enum does not have value=$val"))
    end

    return ENUM_MAPPINGS[enum][val]
end

