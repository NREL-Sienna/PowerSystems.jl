import TimeSeries

include(joinpath(DATA_DIR, "../data/data_5bus.jl"))
include(joinpath(DATA_DIR, "data_14bus.jl"))


@testset "Test System constructors" begin
    tPowerSystem = System()

    sys5 = PowerSystem(nodes5, generators5, loads5_DA, nothing, nothing,  1000.0, nothing, nothing, nothing)
    sys5 = PowerSystem(nodes5, generators5, loads5_DA, branches5, nothing,  1000.0, nothing, nothing, nothing)

    battery5=[GenericBattery(name="Bat",
                             status=true,
                             bus=nodes5[2],
                             activepower=10.0,
                             energy=5.0,
                             capacity=(min=0.0, max=0.0),
                             inputactivepowerlimits=(min=0.0, max=50.0),
                             outputactivepowerlimits=(min=0.0, max=50.0),
                             efficiency=(in=0.90, out=0.80),
                            )]

    sys5b = PowerSystem(nodes5, generators5, loads5_DA, nothing, battery5,  1000.0, nothing, nothing, nothing)

    sys5b = PowerSystem(nodes5, generators5, loads5_DA, nothing, battery5,  1000.0, forecasts5, nothing, nothing)


    generators_hg5 = [
        HydroFix("HydroFix", true, nodes5[2],
                 TechHydro(60.0, 15.0, (min=0.0, max=60.0), nothing, nothing, nothing,
                           nothing)
        ),
        HydroCurtailment("HydroCurtailment", true, nodes5[3],
                         TechHydro(60.0, 10.0, (min=0.0, max=60.0), nothing, nothing,
                                   (up=10.0, down=10.0), nothing), 1000.0)
    ]

    sys5bh = PowerSystem(nodes5, append!(generators5, generators_hg5), loads5_DA, branches5,
                         battery5,  1000.0, nothing, nothing, nothing)

     #Test Data for 14 Bus

    sys14 = PowerSystem(nodes14, generators14, loads14, nothing, nothing, 1000.0, Dict{Symbol,Vector{<:Forecast}}(),nothing,nothing)
    sys14 = PowerSystem(nodes14, generators14, loads14, branches14, nothing, 1000.0, forecasts14, nothing, nothing)

    battery14 = [GenericBattery(name="Bat",
                                status=true,
                                bus=nodes14[2],
                                activepower=10.0,
                                energy=5.0,
                                capacity=(min=0.0, max=0.0),
                                inputactivepowerlimits=(min=0.0, max=50.0),
                                outputactivepowerlimits=(min=0.0, max=50.0),
                                efficiency=(in=0.90, out=0.80),
                               )]

    sys14b = PowerSystem(nodes14, generators14, loads14, nothing, battery14, 1000.0, nothing, nothing, nothing)
    sys14b = PowerSystem(nodes14, generators14, loads14, branches14, battery14, 1000.0, nothing, nothing, nothing)

    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "case5_re.m"))
    sys = PowerSystems.PowerSystem(ps_dict)
end
