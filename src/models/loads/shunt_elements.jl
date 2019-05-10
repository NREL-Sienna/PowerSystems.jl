struct FixedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    Y::Complex{Float64} # [Z]
    internal::PowerSystemInternal
end

function FixedAdmittance(name, available, bus, Y)
    return FixedAdmittance(name, available, bus, Y, PowerSystemInternal())
end
