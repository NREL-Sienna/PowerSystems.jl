
IS.@scoped_enum(
    InputCategory,
    BRANCH = 1,
    BUS = 2,
    DC_BRANCH = 3,
    GENERATOR = 4,
    LOAD = 5,
    RESERVE = 6,
    SIMULATION_OBJECTS = 7,
    STORAGE = 8,
)

const ENUMS = (
    AngleUnits,
    BusTypes,
    GeneratorCostModels,
    InputCategory,
    PrimeMovers,
    StateTypes,
    ThermalFuels,
    UnitSystem,
)

const ENUM_MAPPINGS = Dict()

for enum in ENUMS
    ENUM_MAPPINGS[enum] = Dict()
    for value in instances(enum)
        ENUM_MAPPINGS[enum][normalize(string(value), casefold = true)] = value
    end
end

"""Get the enum value for the string. Case insensitive."""
function get_enum_value(enum, value::AbstractString)
    if !haskey(ENUM_MAPPINGS, enum)
        throw(ArgumentError("enum=$enum is not valid"))
    end

    val = normalize(value, casefold = true)
    if !haskey(ENUM_MAPPINGS[enum], val)
        throw(ArgumentError("enum=$enum does not have value=$val"))
    end

    return ENUM_MAPPINGS[enum][val]
end

Base.convert(::Type{AngleUnits}, val::AbstractString) = get_enum_value(AngleUnits, val)
Base.convert(::Type{BusTypes}, val::AbstractString) = get_enum_value(BusTypes, val)
Base.convert(::Type{GeneratorCostModels}, val::AbstractString) =
    get_enum_value(GeneratorCostModels, val)
Base.convert(::Type{LoadModels}, val::AbstractString) = get_enum_value(LoadModels, val)
Base.convert(::Type{PrimeMovers}, val::AbstractString) = get_enum_value(PrimeMovers, val)
Base.convert(::Type{StateTypes}, val::AbstractString) = get_enum_value(StateTypes, val)
Base.convert(::Type{ThermalFuels}, val::AbstractString) = get_enum_value(ThermalFuels, val)
