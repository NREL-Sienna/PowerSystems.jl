# TODO: proper calculation of the rates using the SIL formula

struct Line <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::Float64 #[pu]
    # TODO: add a rate and angle consistency check
    rate::Float64 #[MVA]
    anglelimits::@NT(max::Float64, min::Float64)
end

Line(;  name = "init",
        status = false,
        connectionpoints = @NT(from::Bus(), to::Bus()),
        r = 0.0,
        x = 0.0,
        b = 0.0,
        # TODO: Properly add the rating value of the line with an external constructor
        rate = 0.0,
        anglelimits = @NT(max = 60.0, min = -60.0)
    ) = Line(name, status, connectionpoints, r, x, b, rate, anglelimits)
