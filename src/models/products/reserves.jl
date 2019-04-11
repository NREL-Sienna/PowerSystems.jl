
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
requirement - the required quantity of the product

# Examples

```jldoctest


"""
struct ProportionalReserve <: Reserve
    name::String
    contributingdevices::Array{Device}
    timeframe::Float64
    requirement::TimeSeries.TimeArray
end

function ProportionalReserve(name::String,
                            contributingdevices::Array{G},
                            timeframe::Float64,
                            requirement::Float64,
                            loads::Array{T}) where {G <: Device, T <: ElectricLoad}

    totalload = zeros(0)
    for i in TimeSeries.timestamp(loads[1].scalingfactor)
        t = zeros(0)
        for load in loads
            push!(t,(load.maxactivepower*values(load.scalingfactor[i]))[1])
        end
        push!(totalload,sum(t))
    end
    requirement = TimeSeries.TimeArray(TimeSeries.timestamp(loads[1].scalingfactor),totalload*requirement)

    ProportionalReserve(name, contributingdevices, timeframe, requirement)
end


ProportionalReserve(;name = "init",
        contributingdevices = [ThermalDispatch()],
        timeframe = 0.0,
        requirement = 0.03,
        loads = [ PowerLoad()]) = ProportionalReserve(name, contributingdevices, timeframe, requirement, loads)


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
    contributingdevices::Array{Device}
    timeframe::Float64
    requirement::Float64

    function StaticReserve(name::String,
                                contributingdevices::Array{Q},
                                timeframe::Float64,
                                generators::Array{G}) where {Q <: Device, G <: TechThermal}

        requirement = maximum([gen.activepowerlimits[:max] for gen in generators])

        new(name, contributingdevices, timeframe, requirement)
    end
end

StaticReserve(;name = "init",
        contributingdevices = [ThermalDispatch()],
        timeframe = 0.0,
        generators = [TechThermal()]) = StaticReserve(name, contributingdevices, timeframe, generators)
