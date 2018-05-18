export Storage
export GenericBattery

abstract type
    Storage
end

struct GenericBattery <: Storage
    name::String
    status::Bool
    bus::Bus
    capacity::NamedTuple{(:min, :max),Tuple{Float64,Float64}}
    realpower::Float64 # [MW]
    inputrealpowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}}
    outputrealpowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}}
    efficiency::NamedTuple{(:in, :out),Tuple{Float64,Float64}}
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
end

GenericBattery(; name = "init",
                status = false,
                bus = Bus(),
                capacity = (min = 0.0, max = 0.0),
                realpower = 0.0,
                inputrealpowerlimits = (min = 0.0, max = 0.0),
                outputrealpowerlimits = (min = 0.0, max = 0.0),
                efficiency = (in = 0.0, out = 0.0),
                reactivepower = 0.0,
                reactivepowerlimits = (min = 0.0, max = 0.0)
                ) = GenericBattery(name, status, bus, capacity, realpower, inputrealpowerlimits,
                                    outputrealpowerlimits, efficiency, reactivepower, reactivepowerlimits)
