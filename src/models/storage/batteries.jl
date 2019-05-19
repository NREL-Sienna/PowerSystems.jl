struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    energy::Float64 # [MWh]
    capacity::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MWh]
    rating::Float64 #
    activepower::Float64 # [MW]
    inputactivepowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MW]
    outputactivepowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MW]
    efficiency::NamedTuple{(:in, :out),Tuple{Float64,Float64}}  # [%]
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [MVAr]
    internal::PowerSystemInternal
end

function GenericBattery(name,
                        available,
                        bus,
                        energy,
                        capacity,
                        rating,
                        activepower,
                        inputactivepowerlimits,
                        outputactivepowerlimits,
                        efficiency,
                        reactivepower,
                        reactivepowerlimits)
    return GenericBattery(name, available, bus, energy, capacity, rating, activepower,
                          inputactivepowerlimits, outputactivepowerlimits, efficiency,
                          reactivepower, reactivepowerlimits, PowerSystemInternal())
end

GenericBattery(; name = "init",
                available = false,
                bus = Bus(),
                energy = 0.0,
                capacity = (min = 0.0, max = 0.0),
                rating = 0.0,
                activepower = 0.0,
                inputactivepowerlimits = (min = 0.0, max = 0.0),
                outputactivepowerlimits = (min = 0.0, max = 0.0),
                efficiency = (in = 0.0, out = 0.0),
                reactivepower = 0.0,
                reactivepowerlimits = (min = 0.0, max = 0.0)
                ) = GenericBattery(name, status, bus, energy, capacity, rating, activepower, inputactivepowerlimits,
                                    outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits)
