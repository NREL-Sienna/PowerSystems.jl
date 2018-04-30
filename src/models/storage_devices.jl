export Storage
export GenericBattery

abstract type 
    Storage
end

struct GenericBattery <: Storage
    name::String
    status::Bool
    bus::Bus
    capacity::NamedTuple
    realpower::Float64 # [MW]
    inputrealpowerlimits::NamedTuple
    outputrealpowerlimits::NamedTuple
    efficiency::NamedTuple
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple,Nothing}
end

GenericBattery(; name = "init",
                status = false,
                bus = Bus(),
                capacity = @NT(max = 0.0, min = 0.0),
                realpower = 0.0,
                inputrealpowerlimits = @NT(max = 0.0, min = 0.0),
                outputrealpowerlimits = @NT(max = 0.0, min = 0.0),
                efficiency = @NT(in = 0.0, out = 0.0), 
                reactivepower = 0.0, 
                reactivepowerlimits = @NT(max = 0.0, min = 0.0)
                ) = GenericBattery(name, status, bus, capacity, realpower, inputrealpowerlimits, 
                                    outputrealpowerlimits, efficiency, reactivepower, reactivepowerlimits)