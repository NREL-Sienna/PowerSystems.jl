struct FixedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    Y::Complex64 # [Z]
end
