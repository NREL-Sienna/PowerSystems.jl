""""
Data Structure for the economical parameters of renewable generation technologies.
    The data structure can be called calling all the fields directly or using named fields.
    All the limits are defined by NamedTuples and some fields can take ```nothing```

    ## Examples




"""
struct EconRenewable <: TechnicalParams
    curtailpenalty::Float64 # [$/MWh]
    variablecost::Union{Float64, Nothing} # [$/MWh]
    internal::PowerSystemInternal
end

function EconRenewable(curtailpenalty, variablecost)
    return EconRenewable(curtailpenalty, variablecost, PowerSystemInternal())
end

EconRenewable(; curtailcost = 0.0, variablecost = nothing) = EconRenewable(curtailcost, variablecost)


""""
Data Structure for the economical parameters of thermal generation technologies.
    The data structure can be called calling all the fields directly or using named fields.
    All the limits are defined by NamedTuples and some fields can take ```nothing```

    ## Examples




"""
struct EconThermal <: TechnicalParams
    capacity::Float64 # [MW]
    variablecost::Union{Tuple{Float64, Float64},Array{Tuple{Float64, Float64}}} # [$/MWh]
    fixedcost::Float64            # [$/h]
    startupcost::Float64          # [$]
    shutdncost::Float64           # [$]
    annualcapacityfactor::Union{Float64,Nothing}  # [0-1]
    internal::PowerSystemInternal
end

function EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor)
    return EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost,
                       annualcapacityfactor, PowerSystemInternal())
end

EconThermal(;   capacity = 0.0,
            variablecost = [(0.0,1.0)],
            fixedcost = 0.0,
            startupcost = 0.0,
            shutdncost = 0.0,
            annualcapacityfactor = nothing
        ) = EconThermal(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor)

"""Enables deserialization of EconThermal. The default implementation can't figure out the
variablecost Union.
"""
function JSON2.read(io::IO, ::Type{T}) where {T <: EconThermal}
    data = JSON2.read(io)
    @assert length(data.variablecost) > 0
    if data.variablecost[1] isa Array
        variablecost = Vector{Tuple{Float64, Float64}}()
        for array in data.variablecost
            push!(variablecost, Tuple{Float64, Float64}(array))
        end
    else
        variablecost = Tuple{Float64, Float64}(data.variablecost)
    end

    internal = convert_type(PowerSystemInternal, data.internal)
    return EconThermal(data.capacity, variablecost, data.fixedcost, data.startupcost,
                       data.shutdncost, data.annualcapacityfactor, internal)
end
