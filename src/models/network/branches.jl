export Branch
export Line
export Transformer2W
export PhaseShiftingTransformer
export Transformer3W

abstract type
    Branch
end

struct Line <: Branch
    name::String
    status::Bool
    connectionpoints::Tuple{Bus,Bus}
    r::Float64 #[pu]
    x::Float64 #[pu]Co
    b::Float64 #[pu]
    rate::Union{Float64,Nothing} #[MVA]
    #Pending a proper calculation of the rates
    anglelimits::Union{Tuple{Float64,Float64},Nothing}
end

Line(;  name = "init",
        status = false,
        connectionpoints = (Bus(), Bus()),
        r = 0.0,
        x = 0.0,
        b = 0.0,
        rate = nothing,
        anglelimits = nothing
    ) = Line(name, status, connectionpoints, r, x, b, rate, anglelimits)

"""
The 2-W transformer model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer.
The model allocates the iron losses and magnetezing suceptance to the primary side
"""

struct PhaseShiftingTransformer <: Branch
    name::String
    status::Bool
    connectionpoints::Tuple{Bus,Bus}
    r::Float64 #[pu]
    x::Float64 #[pu]
    zb::Float64 #[pu]
    tap::Float64 # [0 - 2]
    α::Float64 # [radians]
    rate::Union{Float64,Nothing} #[MVA]
end

PhaseShiftingTransformer(; name = "init",
                status = false,
                connectionpoints = (Bus(), Bus()),
                r = 0.0,
                x = 0.0,
                zb = 0.0,
                tap = 1.0,
                α = 0.0,
                rate = nothing
            ) = Transformer2W(name, status, connectionpoints, r, x, zb, tap, α, rate)

struct Transformer2W <: Branch
    name::String
    status::Bool
    connectionpoints::Tuple{Bus,Bus}
    r::Float64 #[pu]
    x::Float64 #[pu]
    zb::Float64 #[pu]
    tap::Float64 # [0 - 2]
    rate::Union{Float64,Nothing} #[MVA]
end

Transformer2W(; name = "init",
                status = false,
                connectionpoints = (Bus(), Bus()),
                r = 0.0,
                x = 0.0,
                zb = 0.0,
                tap = 1.0,
                rate = nothing
            ) = Transformer2W(name, status, connectionpoints, r, x, zb, tap, α, rate)

struct Transformer3W <: Branch
    name::String
    status::Bool
    transformer::Transformer2W
    line::Line
end

Transformer3W(; name = "init",
                status = false,
                transformer = Transformer2W(),
                line = Line()
            ) = Transformer3W(name, status, transformer, line)



