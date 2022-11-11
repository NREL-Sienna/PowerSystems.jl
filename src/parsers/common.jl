const GENERATOR_MAPPING_FILE =
    joinpath(dirname(pathof(PowerSystems)), "parsers", "generator_mapping.yaml")

const PSSE_DYR_MAPPING_FILE =
    joinpath(dirname(pathof(PowerSystems)), "parsers", "psse_dynamic_mapping.yaml")

const STRING2FUEL = Dict((string(x) => x) for x in instances(ThermalFuels))
merge!(
    STRING2FUEL,
    Dict(
        "NG" => ThermalFuels.NATURAL_GAS,
        "NUC" => ThermalFuels.NUCLEAR,
        "GAS" => ThermalFuels.NATURAL_GAS,
        "OIL" => ThermalFuels.DISTILLATE_FUEL_OIL,
        "DFO" => ThermalFuels.DISTILLATE_FUEL_OIL,
        "SYNC_COND" => ThermalFuels.OTHER,
        "GEOTHERMAL " => ThermalFuels.GEOTHERMAL,
        "AG_BIPRODUCT"=> ThermalFuels.AG_BIPRODUCT
    ),
)

const STRING2PRIMEMOVER = Dict((string(x) => x) for x in instances(PrimeMovers))
merge!(
    STRING2PRIMEMOVER,
    Dict(
        "W2" => PrimeMovers.WT,
        "WIND" => PrimeMovers.WT,
        "PV" => PrimeMovers.PVe,
        "PVe" => PrimeMovers.PVe,
        "SOLAR" => PrimeMovers.PVe,
        "RTPV" => PrimeMovers.PVe,
        "NB" => PrimeMovers.ST,
        "STEAM" => PrimeMovers.ST,
        "HYDRO" => PrimeMovers.HY,
        "ROR" => PrimeMovers.HY,
        "PUMP" => PrimeMovers.PS,
        "PUMPED_HYDRO" => PrimeMovers.PS,
        "NUCLEAR" => PrimeMovers.ST,
        "SYNC_COND" => PrimeMovers.OT,
        "CSP" => PrimeMovers.CP,
        "UN" => PrimeMovers.OT,
        "STORAGE" => PrimeMovers.BA,
        "ICE" => PrimeMovers.IC,


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

    mappings = Dict{NamedTuple, DataType}()
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
function get_generator_type(fuel, unit_type, mappings::Dict{NamedTuple, DataType})
    fuel = isnothing(fuel) ? "" : uppercase(fuel)
    unit_type = uppercase(unit_type)
    generator = nothing

    # Try to match the unit_type if it's defined. If it's nothing then just match on fuel.
    for ut in (unit_type, nothing), fu in (fuel, nothing)
        key = (fuel = fu, unit_type = ut)
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

function get_branch_type(
    tap::Union{Float64, Int},
    alpha::Union{Float64, Int},
    is_transformer::Union{Bool, Nothing} = nothing,
)
    if isnothing(is_transformer)
        is_transformer = (tap != 0.0) & (tap != 1.0)
    end
    if is_transformer
        if tap == 1.0
            branch_type = Transformer2W
        elseif alpha == 0.0
            branch_type = TapTransformer
        else
            branch_type = PhaseShiftingTransformer
        end
    else
        branch_type = Line
    end

    return branch_type
end

function calculate_rating(
    active_power_limits::Union{Min_Max, Nothing},
    reactive_power_limits::Union{Min_Max, Nothing},
)
    reactive_power_max = isnothing(reactive_power_limits) ? 0.0 : reactive_power_limits.max
    return calculate_rating(active_power_limits.max, reactive_power_max)
end

function calculate_rating(active_power_max::Float64, reactive_power_max::Float64)
    return sqrt(active_power_max^2 + reactive_power_max^2)
end

function string_compare(str1, str2; casefold = true)
    return normalize(str1, casefold = casefold) === normalize(str2, casefold = casefold)
end

function string_occursin(str1, str2; casefold = true)
    return occursin(
        normalize(str1, casefold = casefold),
        normalize(srt2, casefold = casefold),
    )
end

function convert_units!(
    value::Float64,
    unit_conversion::NamedTuple{(:From, :To), Tuple{String, String}},
)
    if string_compare(unit_conversion.From, "degree") &&
       string_compare(unit_conversion.To, "radian")
        value = deg2rad(value)
    elseif string_compare(unit_conversion.From, "radian") &&
           string_compare(unit_conversion.To, "degree")
        value = rad2deg(value)
    elseif string_compare(unit_conversion.From, "TW") &&
           string_compare(unit_conversion.To, "MW")
        value *= 1e6
    elseif string_compare(unit_conversion.From, "TWh") &&
           string_compare(unit_conversion.To, "MWh")
        value *= 1e6
    elseif string_compare(unit_conversion.From, "GW") &&
           string_compare(unit_conversion.To, "MW")
        value *= 1000
    elseif string_compare(unit_conversion.From, "GWh") &&
           string_compare(unit_conversion.To, "MWh")
        value *= 1000
    elseif string_compare(unit_conversion.From, "kW") &&
           string_compare(unit_conversion.To, "MW")
        value /= 1000
    elseif string_compare(unit_conversion.From, "kWh") &&
           string_compare(unit_conversion.To, "MWh")
        value /= 1000
    elseif string_compare(unit_conversion.From, "hour") &&
           string_compare(unit_conversion.To, "second")
        value *= 3600
    elseif string_compare(unit_conversion.From, "minute") &&
           string_compare(unit_conversion.To, "second")
        value *= 60
    elseif string_compare(unit_conversion.From, "hour") &&
           string_compare(unit_conversion.To, "minute")
        value *= 60
    elseif string_compare(unit_conversion.From, "minute") &&
           string_compare(unit_conversion.To, "hour")
        value /= 60
    elseif string_compare(unit_conversion.From, "second") &&
           string_compare(unit_conversion.To, "minute")
        value /= 60
    elseif string_compare(unit_conversion.From, "second") &&
           string_compare(unit_conversion.To, "hour")
        value /= 3600
    else
        throw(
            DataFormatError(
                "Unit conversion from $(unit_conversion.From) to $(unit_conversion.To) not supported",
            ),
        )
    end
    return value
end

function convert_units!(
    value::Int,
    unit_conversion::NamedTuple{(:From, :To), Tuple{String, String}},
)
    return convert_units!(convert(Float64, value), unit_conversion)
end

function parse_enum_mapping(::Type{ThermalFuels}, fuel::AbstractString)
    return STRING2FUEL[uppercase(fuel)]
end

function parse_enum_mapping(::Type{ThermalFuels}, fuel::Symbol)
    return parse_enum_mapping(ThermalFuels, string(fuel))
end

function parse_enum_mapping(::Type{PrimeMovers}, prime_mover::AbstractString)
    return STRING2PRIMEMOVER[uppercase(prime_mover)]
end

function parse_enum_mapping(::Type{PrimeMovers}, prime_mover::Symbol)
    return parse_enum_mapping(PrimeMovers, string(prime_mover))
end
