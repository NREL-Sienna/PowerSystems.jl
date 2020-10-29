
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
    GeneratorCostModels.GeneratorCostModel,
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

Base.convert(::Type{AngleUnits.AngleUnit}, val::String) =
    get_enum_value(AngleUnits.AngleUnit, val)
Base.convert(::Type{BusTypes.BusType}, val::String) = get_enum_value(BusTypes.BusType, val)
Base.convert(::Type{GeneratorCostModels.GeneratorCostModel}, val::String) =
    get_enum_value(GeneratorCostModels.GeneratorCostModel, val)
Base.convert(::Type{LoadModels.LoadModel}, val::String) =
    get_enum_value(LoadModels.LoadModel, val)
Base.convert(::Type{PrimeMovers.PrimeMover}, val::String) =
    get_enum_value(PrimeMovers.PrimeMover, val)
Base.convert(::Type{StateTypes.StateType}, val::String) =
    get_enum_value(StateTypes.StateType, val)
Base.convert(::Type{ThermalFuels.ThermalFuel}, val::String) =
    get_enum_value(ThermalFuels.ThermalFuel, val)
