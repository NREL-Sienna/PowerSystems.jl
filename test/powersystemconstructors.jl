
include("../data/data_5bus.jl")
include("../data/data_14bus.jl")


@time sys5 = PowerSystem(nodes5, generators5, loads5_DA, 230.0, 1000.0)
@time sys14 = PowerSystem(nodes14, generators14, loads14, 69.0, 1000.0)

#add network

@time sys5 = PowerSystem(nodes5, generators5, loads5_DA, branches5, 230.0, 1000.0)
@time sys14 = PowerSystem(nodes14, generators14, loads14, branches14, 69.0, 1000.0)

# Add storage to powersystembuild

battery = GenericBattery(name = "Bat",
                status = true,
                realpower = 10.0,
                energy = 100.0,
                capacity = @NT(min = 0.0, max = 0.0,),
                inputrealpowerlimit = 10.0,
                outputrealpowerlimit = 10.0,
                efficiency = @NT(in = 0.90, out = 0.80),
                );

generators_hg = [
    HydroFix("HydroFix",true,nodes5[2],
        TechHydro(60.0, 15.0, @NT(min = 0.0, max = 60.0), nothing, nothing, nothing, nothing),
        TimeSeries.TimeArray(DayAhead,solar_ts_DA)
    ),
    HydroCurtailment("HydroCurtailment",true,nodes5[3],
        TechHydro(60.0, 10.0, @NT(min = 0.0, max = 60.0), nothing, nothing, @NT(up = 10.0, down = 10.0), nothing),
        1000.0,TimeSeries.TimeArray(DayAhead,wind_ts_DA) )
]

@time sys5b = PowerSystem(nodes5, generators5, loads5_DA, branches5, [battery], 230.0, 1000.0)
@time sys14b = PowerSystem(nodes14, generators14, loads14, branches14, [battery], 69.0, 1000.0)

true