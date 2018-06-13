struct GenericBattery <: Storage
    name::String
    status::Bool
    bus::Bus
    energy::Float64
    capacity::@NT(min::Float64, max::Float64)
    realpower::Float64 # [MW]
    inputrealpowerlimit::Float64
    outputrealpowerlimit::Float64
    efficiency::@NT(in::Float64, out::Float64)
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing}
end

GenericBattery(; name = "init",
                status = false,
                bus = Bus(),
                energy = 0.0,
                capacity = @NT(min = 0.0, max = 0.0),
                realpower = 0.0,
                inputrealpowerlimit = 0.0,
                outputrealpowerlimit = 0.0,
                efficiency = @NT(in = 0.0, out = 0.0),
                reactivepower = 0.0,
                reactivepowerlimits = @NT(min = 0.0, max = 0.0)
                ) = GenericBattery(name, status, bus, energy, capacity, realpower, inputrealpowerlimit,
                                    outputrealpowerlimit, efficiency, reactivepower, reactivepowerlimits)
