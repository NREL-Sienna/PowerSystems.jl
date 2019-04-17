@testset "PowerSystems dict parsing" begin
    data_dict = PowerSystems.read_csv_data(RTS_GMLC_DIR, 100.0)
    @test haskey(data_dict, "timeseries_pointers")
end

@testset "CDM parsing" begin
    cdm_dict = nothing
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    @test cdm_dict isa Dict && haskey(cdm_dict, "loadzone")

    sys_rts = System(cdm_dict)
    @test sys_rts isa System

    rts_da = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["DA"])
    @test length(rts_da[1].data) == 24
    @test length(rts_da) == 141

    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])
    @test length(rts_rt[1].data) == 288
    @test length(rts_rt) == 134

    PowerSystems.add_forecast!(sys_rts,:DA=>rts_da)
    PowerSystems.add_forecast!(sys_rts,:RT=>rts_rt)
    @test length(sys_rts.forecasts) == 2

    cs_rts = ConcreteSystem(System(cdm_dict))
    @test cs_rts isa ConcreteSystem

    rts_da_cs = PowerSystems.make_forecast_array(cs_rts, cdm_dict["forecasts"]["DA"])
    @test length(rts_da[1].data) == 24
    @test length(rts_da) == 141

    rts_rt_cs = PowerSystems.make_forecast_array(cs_rts, cdm_dict["forecasts"]["RT"])
    @test length(rts_rt[1].data) == 288
    @test length(rts_rt) == 134

    PowerSystems.add_forecast!(cs_rts,:DA=>rts_da)
    PowerSystems.add_forecast!(cs_rts,:RT=>rts_rt)
    @test length(cs_rts.forecasts) == 2
    
end

@testset "CDM parsing invalid directory" begin
    baddir = joinpath(RTS_GMLC_DIR, "../../test")
    @test_throws SystemError PowerSystems.csv2ps_dict(baddir, 100.0)
end

@testset "consistency between CDM and standardfiles" begin
    mp_dict  = parsestandardfiles(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    pm_dict = parse_file(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    pmmp_dict = PowerSystems.pm2ps_dict(pm_dict)
    mpmmpsys = System(pmmp_dict)

    mpsys = System(mp_dict)

    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    cdmsys = System(cdm_dict)

    @test cdmsys.generators.thermal[1].tech.activepowerlimits == mpsys.generators.thermal[1].tech.activepowerlimits
    @test cdmsys.generators.thermal[1].tech.reactivepowerlimits == mpsys.generators.thermal[1].tech.reactivepowerlimits
    @test_skip cdmsys.generators.thermal[1].tech.ramplimits == mpsys.generators.thermal[1].tech.ramplimits

    @test cdmsys.generators.thermal[1].econ.capacity == mpsys.generators.thermal[1].econ.capacity
    @test_skip cdmsys.generators.thermal[1].econ.variablecost == mpsys.generators.thermal[1].econ.variablecost


    @test cdmsys.generators.hydro[1].tech.activepowerlimits == mpsys.generators.hydro[1].tech.activepowerlimits
    @test cdmsys.generators.hydro[1].tech.reactivepowerlimits == mpsys.generators.hydro[1].tech.reactivepowerlimits
    @test cdmsys.generators.hydro[1].tech.installedcapacity == mpsys.generators.hydro[1].tech.installedcapacity
    @test_skip cdmsys.generators.hydro[1].tech.ramplimits == mpsys.generators.hydro[1].tech.ramplimits # this gets adjusted in the pm2ps_dict 

    @test cdmsys.generators.hydro[1].econ == mpsys.generators.hydro[1].econ

    @test cdmsys.generators.renewable[1].tech == mpsys.generators.renewable[1].tech

    @test cdmsys.generators.renewable[1].econ == mpsys.generators.renewable[1].econ

    @test cdmsys.branches[1].rate ==
        [b for b in mpsys.branches if 
            (b.connectionpoints.from.name == uppercase(cdmsys.branches[1].connectionpoints.from.name)) 
                & (b.connectionpoints.to.name == uppercase(cdmsys.branches[1].connectionpoints.to.name))][1].rate

    @test cdmsys.branches[6].rate ==
        [b for b in mpsys.branches if 
            (b.connectionpoints.from.name == uppercase(cdmsys.branches[6].connectionpoints.from.name)) 
                & (b.connectionpoints.to.name == uppercase(cdmsys.branches[6].connectionpoints.to.name))][1].rate

    @test cdmsys.branches[120].rate == [b for b in mpsys.branches if 
            (b.connectionpoints.from.name == uppercase(cdmsys.branches[120].connectionpoints.from.name)) 
                & (b.connectionpoints.to.name == uppercase(cdmsys.branches[120].connectionpoints.to.name))][1].rate

end
