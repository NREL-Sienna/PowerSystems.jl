export ShuntElement

abstract type 
    ShuntElement
end

struct FixedAdmitance <: ShuntElement
    name::String
    status::Bool
    bus::Bus
    Y::Complex
end
