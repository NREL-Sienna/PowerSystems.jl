struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    energy::Float64 # [MWh]
    capacity::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MWh]
    realpower::Float64 # [MW]
    inputrealpowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MW]
    outputrealpowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MW]
    efficiency::NamedTuple{(:in, :out),Tuple{Float64,Float64}}  # [%]
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [MVAr]
end

GenericBattery(; name = "init",
                status = false,
                bus = Bus(),
                energy = 0.0,
                capacity = (min = 0.0, max = 0.0),
                realpower = 0.0,
                inputrealpowerlimits = (min = 0.0, max = 0.0),
                outputrealpowerlimits = (min = 0.0, max = 0.0),
                efficiency = (in = 0.0, out = 0.0),
                reactivepower = 0.0,
                reactivepowerlimits = (min = 0.0, max = 0.0)
                ) = GenericBattery(name, status, bus, energy, capacity, realpower, inputrealpowerlimits,
                                    outputrealpowerlimits, efficiency, reactivepower, reactivepowerlimits)
