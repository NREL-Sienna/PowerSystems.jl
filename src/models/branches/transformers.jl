"""
The 2-W transformer model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer.
The model allocates the iron losses and magnetezing suceptance to the primary side
"""
struct Transformer2W <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    r::Float64 #[pu]
    x::Float64 #[pu]
    primaryshunt::Float64 #[pu]
    rate::Union{Nothing,Float64} #[MVA]
    internal::PowerSystemInternal
end

function Transformer2W(name, available, connectionpoints, r, x, primaryshunt, rate)
    return Transformer2W(name, available, connectionpoints, r, x, primaryshunt, rate,
                         PowerSystemInternal())
end

Transformer2W(; name = "init",
                available = false,
                connectionpoints = (from = Bus(), to =Bus()),
                r = 0.0,
                x = 0.0,
                primaryshunt = 0.0,
                rate = nothing
            ) = Transformer2W(name, available, connectionpoints, r, x, primaryshunt, rate)

struct TapTransformer <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    r::Float64 #[pu]
    x::Float64 #[pu]
    primaryshunt::Float64 #[pu]
    tap::Float64 # [0 - 2]
    rate::Union{Float64,Nothing} #[MVA]
    internal::PowerSystemInternal
end

function TapTransformer(name, available, connectionpoints, r, x, primaryshunt, tap, rate)
    return TapTransformer(name, available, connectionpoints, r, x, primaryshunt, tap, rate,
                          PowerSystemInternal())
end

TapTransformer(; name = "init",
                available = false,
                connectionpoints = (from=Bus(), to=Bus()),
                r = 0.0,
                x = 0.0,
                primaryshunt = 0.0,
                tap = 1.0,
                rate = nothing
            ) = TapTransformer(name, available, connectionpoints, r, x, primaryshunt, tap, rate)

#=
struct Transformer3W <: Branch
    name::String
    available::Bool
    transformer::Transformer2W
    line::Line
end

Transformer3W(; name = "init",
                available = false,
                transformer = Transformer2W(),
                line = Line()
            ) = Transformer3W(name, available, transformer, line)
=#

struct PhaseShiftingTransformer <: Branch
    name::String
    available::Bool
    connectionpoints::From_To_Bus
    r::Float64 #[pu]
    x::Float64 #[pu]
    primaryshunt::Float64 #[pu]
    tap::Float64 #[0 - 2]
    α::Float64 # [radians]
    rate::Float64 #[MVA]
    internal::PowerSystemInternal
end

function PhaseShiftingTransformer(name, available, connectionpoints, r, x, primaryshunt, tap, α, rate)
    PhaseShiftingTransformer(name, available, connectionpoints, r, x, primaryshunt, tap, α,
                             rate, PowerSystemInternal())
end

PhaseShiftingTransformer(; name = "init",
                available = false,
                connectionpoints = (from=Bus(), to=Bus()),
                r = 0.0,
                x = 0.0,
                primaryshunt=0.0,
                tap = 1.0,
                α = 0.0,
                rate = 0.0
            ) = PhaseShiftingTransformer(name, available, connectionpoints, r, x, primaryshunt, tap, α, rate)
