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
    @test length(rts_da) == 138

    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])
    @test length(rts_rt[1].data) == 288
    @test length(rts_rt) == 131

    PowerSystems.pushforecast!(sys_rts,:DA=>rts_da)
    PowerSystems.pushforecast!(sys_rts,:RT=>rts_rt)
    @test length(sys_rts.forecasts) == 2

    @info "making RT System"
    sys_rts_rt = System(cdm_dict)
    @test sys_rts_rt isa System

    # Verify functionality of the concrete version of System.
    # TODO: Refactor once the ConcreteSystem implementation is finalized.
    sys = ConcreteSystem(sys_rts)
    @test length(sys_rts_rt.branches) == length(collect(get_components(Branch, sys)))
    @test length(sys_rts_rt.loads) == length(collect(get_components(ElectricLoad, sys)))
    @test length(sys_rts_rt.storage) == length(collect(get_components(Storage, sys)))
    @test length(sys_rts_rt.generators.thermal) == length(collect(get_components(ThermalGen, sys)))
    @test length(sys_rts_rt.generators.renewable) == length(collect(get_components(RenewableGen, sys)))
    @test length(sys_rts_rt.generators.hydro) == length(collect(get_components(HydroGen, sys)))
    @test length(get_components(Bus, sys)) > 0
    @test length(get_components(ThermalDispatch, sys)) > 0
    summary(devnull, sys)
end

@testset "CDM parsing invalid directory" begin
    baddir = joinpath(RTS_GMLC_DIR, "../../test")
    @test_throws ErrorException PowerSystems.csv2ps_dict(baddir, 100.0)
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
