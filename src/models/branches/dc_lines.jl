# TODO: Implement more complex DC Line models including control angle and transformers
abstract type DCLine <: Branch end

struct HVDCLine <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    activepowerlimits_from::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MW
    activepowerlimits_to::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MW
    reactivepowerlimits_from::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MVar
    reactivepowerlimits_to::NamedTuple{(:min, :max),Tuple{Float64,Float64}} #MVar
    loss::NamedTuple{(:l0, :l1),Tuple{Float64,Float64}}
end

HVDCLine(; name ="init",
        available = true,
        connectionpoints = (from = Bus(), to = Bus()),
        activepowerlimits_from = (min=0.0, max=0.0),
        activepowerlimits_to = (min=0.0, max=0.0),
        reactivepowerlimits_from = (min=0.0, max=0.0),
        reactivepowerlimits_to = (min=0.0, max=0.0),
        loss = (l0=0.0, l1=0.0)
    ) = HVDCLine(name, available, connectionpoints, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to,loss )


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

VSCDCLine(; name ="init",
        available = true,
        connectionpoints = (from = Bus(), to = Bus()),
        rectifier_taplimits = (min=0.0, max=0.0),
        rectifier_xrc = 0.0,
        rectifier_firingangle = (min=0.0, max=0.0),
        inverter_taplimits = (min=0.0, max=0.0),
        inverter_xrc = 0.0,
        inverter_firingangle = (min=0.0, max=0.0),
    ) = VSCDCLine(name, available, connectionpoints,rectifier_taplimits, rectifier_xrc, rectifier_firingangle, inverter_taplimits, inverter_xrc, inverter_firingangle)