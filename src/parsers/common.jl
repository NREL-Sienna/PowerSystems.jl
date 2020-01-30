const GENERATOR_MAPPING_FILE =
    joinpath(dirname(pathof(PowerSystems)), "parsers", "generator_mapping.yaml")

const STRING2FUEL = Dict((string(e) => e) for e in instances(ThermalFuels))
merge!(
    STRING2FUEL,
    Dict(
        "NG" => NATURAL_GAS::ThermalFuels,
        "NUC" => NUCLEAR::ThermalFuels,
        "GAS" => NATURAL_GAS::ThermalFuels,
        "OIL" => DISTILLATE_FUEL_OIL::ThermalFuels,
        "SYNC_COND" => OTHER::ThermalFuels,
    ),
)

const STRING2PRIMEMOVER = Dict((string(e) => e) for e in instances(PrimeMovers))
merge!(
    STRING2PRIMEMOVER,
    Dict(
        "W2" => WT::PrimeMovers,
        "WIND" => WT::PrimeMovers,
        "PV" => PVe::PrimeMovers,
        "RTPV" => PVe::PrimeMovers,
        "NB" => ST::PrimeMovers,
        "STEAM" => ST::PrimeMovers,
        "HYDRO" => HY::PrimeMovers,
        "ROR" => HY::PrimeMovers,
        "NUCLEAR" => ST::PrimeMovers,
        "SYNC_COND" => OT::PrimeMovers,
        "CSP" => CP::PrimeMovers,
        "UN" => OT::PrimeMovers,
        "STORAGE" => BA::PrimeMovers,
    ),
)

"""Return a dict where keys are a tuple of input parameters (fuel, unit_type) and values are
generator types."""
function get_generator_mapping(filename = nothing)
    if isnothing(filename)
        filename = GENERATOR_MAPPING_FILE
    end
    genmap = open(filename) do file
        YAML.load(file)
    end

    mappings = Dict{NamedTuple,DataType}()
    for (gen_type, vals) in genmap
        gen = getfield(PowerSystems, Symbol(gen_type))
        for val in vals
            key = (fuel = val["fuel"], unit_type = val["type"])
            if haskey(mappings, key)
                error("duplicate generator mappings: $gen $(key.fuel) $(key.unit_type)")
            end
            mappings[key] = gen
        end
    end

    return mappings
end

"""Return the PowerSystems generator type for this fuel and unit_type."""
function get_generator_type(fuel, unit_type, mappings::Dict{NamedTuple,DataType})
    fuel = uppercase(fuel)
    unit_type = uppercase(unit_type)
    generator = nothing

    # Try to match the unit_type if it's defined. If it's nothing then just match on fuel.
    for ut in (unit_type, nothing)
        key = (fuel = fuel, unit_type = ut)
        if haskey(mappings, key)
            generator = mappings[key]
            break
        end
    end

    if isnothing(generator)
        @error "No mapping for generator fuel=$fuel unit_type=$unit_type"
    end

    return generator
end

function get_branch_type(tap::Float64, alpha::Float64)
    if tap <= 0.0
        branch_type = Line
    elseif tap == 1.0
        branch_type = Transformer2W
    else
        if alpha == 0.0
            branch_type = TapTransformer
        else
            branch_type = PhaseShiftingTransformer
        end
    end

    return branch_type
end

function calculate_rating(active_power_max::Float64, reactive_power_max::Float64)
    return sqrt(active_power_max^2 + reactive_power_max^2)
end

function convert_units!(
    value::Float64,
    unit_conversion::NamedTuple{(:From, :To),Tuple{String,String}},
)

    if unit_conversion.From == "degree" && unit_conversion.To == "radian"
        value = deg2rad(value)
    elseif unit_conversion.From == "radian" && unit_conversion.To == "degree"
        value = rad2deg(value)
    else
        throw(DataFormatError("Unit conversion from $(unit_conversion.From) to $(unit_conversion.To) not supported"))
    end
    return value
end

function Base.convert(::Type{ThermalFuels}, fuel::AbstractString)
    return STRING2FUEL[uppercase(fuel)]
end

function Base.convert(::Type{ThermalFuels}, fuel::Symbol)
    return convert(ThermalFuels, string(fuel))
end

function Base.convert(::Type{PrimeMovers}, primemover::AbstractString)
    return STRING2PRIMEMOVER[uppercase(primemover)]
end

function Base.convert(::Type{PrimeMovers}, primemover::Symbol)
    return convert(PrimeMovers, string(primemover))
end
