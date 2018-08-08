struct FixedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    Y::Complex{Float64} # [Z]
end
