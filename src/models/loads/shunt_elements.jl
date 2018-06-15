struct FixedAdmittance <: ShuntElement
    name::String
    available::Bool
    bus::Bus
    Y::Complex
end
