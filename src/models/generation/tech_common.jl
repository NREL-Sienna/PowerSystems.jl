# DOCTODO  add docstring for TechRenewable
struct TechRenewable <: TechnicalParams
    installedcapacity::Float64 # [MW]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [MVar]
    powerfactor::Union{Float64,Nothing} # [-1. -1]
end

# DOCTODO document this constructor for TechRenewable
TechRenewable(; InstalledCapacity = 0,
                reactivepowerlimits = nothing,
                powerfactor = nothing
              ) = TechRenewable(InstalledCapacity, reactivepowerlimits,
                                powerfactor)


"""
    TechThermal(activepower::Float64,
            activepowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}},
            reactivepower::Union{Float64,Nothing},
            reactivepowerlimits::Union{(min::Float64,max::Float64),Nothing},
            ramplimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing},
            timelimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing})

Data Structure for the economical parameters of thermal generation technologies.
    The data structure can be called calling all the fields directly or using named fields.
    Two examples [DOCTODO only one example exists below] are provided one with minimal data definition and a more comprenhensive one

    # Examples

    ```jldoctest

    julia> Tech = TechThermal(activepower = 100.0, activepowerlimits = (min = 50.0, max = 200.0))
   [ Info: 'Reactive Power' limits defined as nothing
    TechThermal:
       activepower: 100.0
       activepowerlimits: (min = 50.0, max = 200.0)
       reactivepower: nothing
       reactivepowerlimits: nothing
       ramplimits: nothing
       timelimits: nothing

"""
struct TechThermal <: TechnicalParams
    activepower::Float64 # [MW]
    activepowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MW]
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [MVAr]
    ramplimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing} #MW/Hr
    timelimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing} #Hr
    function TechThermal(activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

        new(activepower, PowerSystems.orderedlimits(activepowerlimits, "Real Power"), reactivepower, PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"), ramplimits, timelimits)

    end
end

# DOCTODO document this constructor 
TechThermal(; activepower = 0.0,
            activepowerlimits = (min = 0.0, max = 0.0),
            reactivepower = nothing,
            reactivepowerlimits = nothing,
            ramplimits = nothing,
            timelimits = nothing
            ) = TechThermal(activepower, activepowerlimits, reactivepower,
                            reactivepowerlimits, ramplimits, timelimits)
