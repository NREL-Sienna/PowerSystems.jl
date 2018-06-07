# TODO: proper calculation of the rates using the SIL formula

struct Line <: Branch
    name::String
    status::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::Float64 #[pu]
    rate::Union{Float64,Nothing} #[MVA]
    anglelimits::Union{Tuple{Float64,Float64},Nothing}
end

Line(;  name = "init",
        status = false,
        connectionpoints = @NT(from::Bus(), to::Bus()),
        r = 0.0,
        x = 0.0,
        b = 0.0,
        rate = nothing,
        anglelimits = nothing
    ) = Line(name, status, connectionpoints, r, x, b, rate, anglelimits)
