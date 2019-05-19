
abstract type
    Reserve <: Service
end

"""
ProportionalReserve(name::String,
        contributingdevices::Device,
        timeframe::Float64,
        requirement::Dict{Any,Dict{Int,TimeSeries.TimeArray}})

Data Structure for a proportional reserve product for system simulations.
The data structure can be called calling all the fields directly or using named fields.
name - description
contributingdevices - devices from which the product can be procured
timeframe - the relative saturation timeframe
requirement - the required quantity of the product should be scaled by a Forecast

# Examples

```jldoctest


"""
struct ProportionalReserve <: Reserve
    name::String
    contributingdevices::Vector{Device}
    timeframe::Float64
    internal::PowerSystemInternal
end

function ProportionalReserve(name, contributingdevices, timeframe)
    return ProportionalReserve(name, contributingdevices, timeframe, PowerSystemInternal())
end

ProportionalReserve(;name = "init",
        contributingdevices = [StandardThermal()],
        timeframe = 0.0) = ProportionalReserve(name, contributingdevices, timeframe)


"""
StaticReserve(name::String,
        contributingdevices::Device,
        timeframe::Float64,
        requirement::Float64})

Data Structure for the procurement products for system simulations.
The data structure can be called calling all the fields directly or using named fields.
name - description
contributingdevices - devices from which the product can be procured
timeframe - the relative saturation timeframe
requirement - the required quantity of the product

# Examples

```jldoctest


"""
struct StaticReserve <: Reserve
    name::String
    contributingdevices::Vector{Device}
    timeframe::Float64
    requirement::Float64
    internal::PowerSystemInternal
end

function StaticReserve(
                       name,
                       contributingdevices,
                       timeframe,
                       generators,
                      )

    requirement = maximum([gen.activepowerlimits[:max] for gen in generators])

    return StaticReserve(name, contributingdevices, timeframe, requirement,
                         PowerSystemInternal())
end

StaticReserve(;name = "init",
        contributingdevices = [StandardThermal()],
        timeframe = 0.0,
        generators = [TechThermal()]) = StaticReserve(name, contributingdevices, timeframe, generators)
