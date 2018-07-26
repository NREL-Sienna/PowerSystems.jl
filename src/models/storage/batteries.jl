struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    energy::Float64 # [MWh]
    capacity::@NT(min::Float64, max::Float64) # [MWh]
    realpower::Float64 # [MW]
    inputrealpowerlimits::@NT(min::Float64, max::Float64) # [MW]
    outputrealpowerlimits::@NT(min::Float64, max::Float64) # [MW]
    efficiency::@NT(in::Float64, out::Float64)  # [%]
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing} # [MVAr]
end

GenericBattery(; name = "init",
                status = false,
                bus = Bus(),
                energy = 0.0,
                capacity = @NT(min = 0.0, max = 0.0),
                realpower = 0.0,
                inputrealpowerlimits = @NT(min = 0.0, max = 0.0),
                outputrealpowerlimits = @NT(min = 0.0, max = 0.0),
                efficiency = @NT(in = 0.0, out = 0.0),
                reactivepower = 0.0,
                reactivepowerlimits = @NT(min = 0.0, max = 0.0)
                ) = GenericBattery(name, status, bus, energy, capacity, realpower, inputrealpowerlimits,
                                    outputrealpowerlimits, efficiency, reactivepower, reactivepowerlimits)
