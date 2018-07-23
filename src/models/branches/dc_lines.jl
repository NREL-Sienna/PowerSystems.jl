# TODO: Implement more complex DC Line models including control angle and transformers
#abstract type DCLine <: Branch end

struct DCLine <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    realpowerlimits_from::@NT(min::Float64, max::Float64) #MW
    realpowerlimits_to::@NT(min::Float64, max::Float64) #MW
    reactivepowerlimits_from::@NT(min::Float64, max::Float64) #MVar
    reactivepowerlimits_to::@NT(min::Float64, max::Float64) #MVar
    loss::@NT(l0::Float64, l1::Float64)
end

DCLine(; name ="init",
        available = true,
        connectionpoints = @NT(from = Bus(), to = Bus()),
        realpowerlimits_from = @NT(min=0.0, max=0.0),
        realpowerlimits_to = @NT(min=0.0, max=0.0),
        reactivepowerlimits_from = @NT(min=0.0, max=0.0),
        reactivepowerlimits_to = @NT(min=0.0, max=0.0),
        loss = @NT(l0=0.0, l1=0.0)
    ) = DCLine(name, available, connectionpoints, realpowerlimits_from, realpowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to,loss )