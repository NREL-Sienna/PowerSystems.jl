function TapCheck(tap, alpha, x, zb)

    assert(zb == )

end

"""
The 2-W transformer model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer.
The model allocates the iron losses and magnetezing suceptance to the primary side
"""

struct Transformer2W <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]
    primaryshunt::Float64
    rate::Union{Float64,Nothing} #[MVA]
end

Transformer2W(; name = "init",
                status = false,
                connectionpoints = @NT(from::Bus(), to::Bus()),
                r = 0.0,
                x = 0.0,
                primaryshunt = 0.0,
                rate = nothing
            ) = Transformer2W(name, status, connectionpoints, r, x, zb, tap, α, rate)

struct TapTransformer <: Branch
    name::String
    available::Bool
    connectionpoints::@NT(from::Bus, to::Bus)
    r::Float64 #[pu]
    x::Float64 #[pu]
    # TODO: Define if transformer requires having a full z = r + x in the shunt
    xb::@NT(primary::Float64, secondary::Float64) #[pu]
    tap::Float64 # [0 - 2]
    rate::Union{Float64,Nothing} #[MVA]
end

TapTransformer(; name = "init",
                status = false,
                connectionpoints = @NT(from::Bus(), to::Bus()),
                r = 0.0,
                x = 0.0,
                zb = @NT(from::0.0, to::0.0),
                tap = 1.0,
                rate = nothing
            ) = Transformer2W(name, status, connectionpoints, r, x, zb, tap, α, rate)

struct Transformer3W <: Branch
    name::String
    available::Bool
    transformer::Transformer2W
    line::Line
end

Transformer3W(; name = "init",
                status = false,
                transformer = Transformer2W(),
                line = Line()
            ) = Transformer3W(name, status, transformer, line)

            struct PhaseShiftingTransformer <: Branch
                name::String
                available::Bool
                connectionpoints::@NT(from::Bus, to::Bus)
                r::Float64 #[pu]
                x::Float64 #[pu]
                zb::@NT(primary::Complex64, secondary::Complex64) #[pu]
                tap::Float64 # [0 - 2]
                α::Float64 # [radians]
                rate::Union{Float64,Nothing} #[MVA]

                function PhaseShiftingTransformer(name, available, connectionpoints, r, x, zb, tap, α, rate)

                    TapCheck(tap, alpha, x, zb)

                    new(name, available, connectionpoints, r, x, zb, tap, α, rate)

                end
            end

PhaseShiftingTransformer(; name = "init",
                status = false,
                connectionpoints = @NT(from::Bus(), to::Bus()),
                r = 0.0,
                x = 0.0,
                zb = @NT(from::0.0, to::0.0),
                tap = 1.0,
                α = 0.0,
                rate = nothing
            ) = Transformer2W(name, status, connectionpoints, r, x, zb, tap, α, rate)