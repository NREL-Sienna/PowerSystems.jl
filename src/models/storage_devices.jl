export Storage
export GenericBattery

abstract type 
    Storage
end

struct GenericBattery <: Storage
    name::String
    status::Bool
    bus::Bus
    realpower::Real # [MW]
    inputrealpowerlimits::NamedTuple
    outputrealpowerlimits::NamedTuple
    efficiency::NamedTuple
    reactivepower::Union{Real,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple,Nothing}
end