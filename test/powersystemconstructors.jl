
include("../data/data_5bus.jl")
include("../data/data_14bus.jl")

@test try tPowerSystem = PowerSystem(); true finally end

@test try sys5 = PowerSystem(nodes5, generators5, loads5_DA, nothing, nothing,  1000.0); true finally end
@test try sys5 = PowerSystem(nodes5, generators5, loads5_DA, branches5, nothing,  1000.0); true finally end

battery5 = [GenericBattery(name = "Bat",
                status = true,
                bus = nodes5[2],
                activepower = 10.0,
                energy = 5.0,
                capacity = (min = 0.0, max = 0.0),
                inputactivepowerlimits = (min = 0.0, max = 50.0),
                outputactivepowerlimits = (min = 0.0, max = 50.0),
                efficiency = (in = 0.90, out = 0.80),
                )];

@test try sys5b = PowerSystem(nodes5, generators5, loads5_DA, nothing, battery5,  1000.0); true finally end

generators_hg5 = [
    HydroFix("HydroFix",true,nodes5[2],
        TechHydro(60.0, 15.0, (min = 0.0, max = 60.0), nothing, nothing, nothing, nothing),
        TimeSeries.TimeArray(DayAhead,solar_ts_DA)
    ),
    HydroCurtailment("HydroCurtailment",true,nodes5[3],
        TechHydro(60.0, 10.0, (min = 0.0, max = 60.0), nothing, nothing, (up = 10.0, down = 10.0), nothing),
        1000.0,TimeSeries.TimeArray(DayAhead,wind_ts_DA) )
]

@test try sys5bh = PowerSystem(nodes5, append!(generators5, generators_hg5), loads5_DA, branches5, battery5,  1000.0); true finally end

 #Test Data for 14 Bus

@test try sys14 = PowerSystem(nodes14, generators14, loads14, nothing, nothing,  1000.0); true finally end
@test try sys14 = PowerSystem(nodes14, generators14, loads14, branches14, nothing,  1000.0); true finally end

battery14 = [GenericBattery(name = "Bat",
                status = true,
                bus = nodes14[2],
                activepower = 10.0,
                energy = 5.0,
                capacity = (min = 0.0, max = 0.0),
                inputactivepowerlimits = (min = 0.0, max = 50.0),
                outputactivepowerlimits = (min = 0.0, max = 50.0),
                efficiency = (in = 0.90, out = 0.80),
                )];




@test try sys14b = PowerSystem(nodes14, generators14, loads14, nothing, battery14,  1000.0); true finally end
@test try sys14b = PowerSystem(nodes14, generators14, loads14, branches14, battery14,  1000.0); true finally end

@test try 
    ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower/case5_re.m")));
    sys = PowerSystems.PowerSystem(ps_dict)
true finally end
