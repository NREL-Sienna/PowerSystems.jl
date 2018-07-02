# TODO: proper calculation of the rates using the SIL formula

struct Line <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::@NT(from::Float64, to::Float64) #[pu]
    # TODO: add a rate and angle consistency check
    rate::Float64 #[MVA]
    anglelimits::@NT(max::Float64, min::Float64)
end

Line(;  name = "init",
        available = false,
        connectionpoints = @NT(from = Bus(), to = Bus()),
        r = 0.0,
        x = 0.0,
        b = @NT(from = 0.0, to = 0.0),
        rate = 0.0,
        anglelimits = @NT(max = 60.0, min = -60.0)
    ) = Line(name, status, connectionpoints, r, x, b, rate, anglelimits)

struct DCLine <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    realpowerlimits_from:: @NT(min::Float64, max::Float64),
    realpowerlimits_to:: @NT(min::Float64, max::Float64),
    reactivepowerlimits_from:: @NT(min::Float64, max::Float64),
    reactivepowerlimits_to::@NT(min::Float64, max::Float64),
    loss::@NT(l0::Float64, l1::Float64)
end

DCLine(; name ="init",
        available = true,
        connectionpoints = @NT(from = Bus(), to = Bus()),
        realpowerlimits = @NT(min=0.0, max=0.0),
        reactivepowerlimits_from = @NT(min=0.0, max=0.0),
        reactivepowerlimits_to = @NT(min=0.0, max=0.0),
        loss = @NT(l0::Float64, l1::Float64)
        )