""""
Data Structure for the economical parameters of interruptible loads.
    The data structure can be called calling all the fields directly or using named fields.
    All the limits are defined by NamedTuples and some fields can take ```nothing```

    ## Examples


"""
struct EconLoad <: TechnicalParams
    curtailpenalty::Float64 # [$/event]
    variablecost::Union{Float64, Nothing} # [$/MWh]
    internal::PowerSystemInternal
end

function EconLoad(curtailpenalty, variablecost)
    return EconLoad(curtailpenalty, variablecost, PowerSystemInternal())
end

EconLoad(; curtailcost = 0.0, variablecost = 0.0) = EconLoad(curtailcost, variablecost)
