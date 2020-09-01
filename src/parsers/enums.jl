
@enum InputCategory begin
    BRANCH
    BUS
    DC_BRANCH
    GENERATOR
    LOAD
    RESERVE
    SIMULATION_OBJECTS
    STORAGE
end

const ENUMS = (
    AngleUnits.AngleUnit,
    BusTypes.BusType,
    InputCategory,
    LoadModels.LoadModel,
    PrimeMovers.PrimeMover,
    StateTypes.StateType,
    ThermalFuels.ThermalFuel,
    UnitSystem,
)

const ENUM_MAPPINGS = Dict()

for enum in ENUMS
    ENUM_MAPPINGS[enum] = Dict()
    for value in instances(enum)
        ENUM_MAPPINGS[enum][lowercase(string(value))] = value
    end
end

"""Get the enum value for the string. Case insensitive."""
function get_enum_value(enum, value::String)
    if !haskey(ENUM_MAPPINGS, enum)
        throw(ArgumentError("enum=$enum is not valid"))
    end

    val = lowercase(value)
    if !haskey(ENUM_MAPPINGS[enum], val)
        throw(ArgumentError("enum=$enum does not have value=$val"))
    end

    return ENUM_MAPPINGS[enum][val]
end
