
abstract type Product
end

"""
ReserveProduct(name::String,
        contributingdevices::PowerSystemDevice,
        timeframe::Float64,
        requirement::Dict{Any,Dict{Int,TimeSeries.TimeArray}})

Data Structure for the procurement products for system simulations.
The data structure can be called calling all the fields directly or using named fields.
name - description
contributingdevices - devices from which the product can be procured
timeframe - the relative saturation timeframe 
requirement - the required quantity of the product

# Examples

```jldoctest


"""
struct ReserveProduct <: Product
    name::String
    contributingdevices::Array{PowerSystemDevice}
    timeframe::Float64
    requirement::TimeSeries.TimeArray

    function ReserveProduct(name::String,
                            contributingdevices::Array{G},
                            timeframe::Float64,
                            requirement::Float64,
                            loads::Array{T}) where {G <: PowerSystemDevice, T <: ElectricLoad}
        
        totalload = zeros(0)
        for i in timestamp(loads[1].scalingfactor)
            t = zeros(0)
            for load in loads
                push!(t,(load.maxrealpower*values(load.scalingfactor[i]))[1])
            end
            push!(totalload,sum(t))
        end
        requirement = TimeSeries.TimeArray(timestamp(loads[1].scalingfactor),totalload*requirement)

        new(name, contributingdevices, timeframe, requirement)
    end
end

ReserveProduct(;name = "init",
        contributingdevices = [ThermalDispatch()],
        timeframe = 0.0,
        requirement = 0.03,
        loads = [StaticLoad()]) = ReserveProduct(name, contributingdevices, timeframe, requirement, loads)
