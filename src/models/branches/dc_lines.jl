# TODO: Implement more complex DC Line models including control angle and transformers
#abstract type DCLine <: Branch end

struct DCLine <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    realpowerlimits_from::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MW
    realpowerlimits_to::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MW
    reactivepowerlimits_from::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MVar
    reactivepowerlimits_to::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MVar
    loss::NamedTuple{(:l0, :l1),Tuple{Float64,Float64}}
end

DCLine(; name ="init",
        available = true,
        connectionpoints = (from = Bus(), to = Bus()),
        realpowerlimits_from = (min=0.0, max=0.0),
        realpowerlimits_to = (min=0.0, max=0.0),
        reactivepowerlimits_from = (min=0.0, max=0.0),
        reactivepowerlimits_to = (min=0.0, max=0.0),
        loss = (l0=0.0, l1=0.0)
    ) = DCLine(name, available, connectionpoints, realpowerlimits_from, realpowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to,loss )


"""
As implemented in Milano's Book Page 397
"""
struct VSCDCLine <: DCLine
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    rectifier_taplimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #pu
    rectifier_xrc::Float64
    rectifier_firingangle::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #radians
    inverter_taplimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #pu
    inverter_xrc::Float64
    inverter_firingangle::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #radians
end
