export ShuntElement

abstract type
    ShuntElement
end

struct FixedAdmittance <: ShuntElement
    name::String
    status::Bool
    bus::Bus
    Y::Complex
end
