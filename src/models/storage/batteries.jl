export GenericBattery

struct GenericBattery <: Storage
    name::String
    status::Bool
    bus::Bus
    capacity::@NT(min::Float64, max::Float64)
    realpower::Float64 # [MW]
    inputrealpowerlimits::@NT(min::Float64, max::Float64)
    outputrealpowerlimits::@NT(min::Float64, max::Float64)
    efficiency::@NT(in::Float64, out::Float64)
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing}
end

GenericBattery(; name = "init",
                status = false,
                bus = Bus(),
                capacity = @NT(min = 0.0, max = 0.0),
                realpower = 0.0,
                inputrealpowerlimits = @NT(min = 0.0, max = 0.0),
                outputrealpowerlimits = @NT(min = 0.0, max = 0.0),
                efficiency = @NT(in = 0.0, out = 0.0),
                reactivepower = 0.0,
                reactivepowerlimits = @NT(min = 0.0, max = 0.0)
                ) = GenericBattery(name, status, bus, capacity, realpower, inputrealpowerlimits,
                                    outputrealpowerlimits, efficiency, reactivepower, reactivepowerlimits)
