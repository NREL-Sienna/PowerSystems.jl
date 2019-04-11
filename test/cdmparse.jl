@testset "PowerSystems dict parsing" begin
    @info "parsing data from $RTS_GMLC_DIR into ps_dict"
    data_dict = PowerSystems.read_csv_data(RTS_GMLC_DIR, 100.0)
    @test haskey(data_dict, "timeseries_pointers")
end

@testset "CDM parsing" begin
    cdm_dict = nothing
    @info "parsing data from $RTS_GMLC_DIR into ps_dict"
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    @test cdm_dict isa Dict && haskey(cdm_dict, "loadzone")

    @info "assigning time series data for DA"
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict, cdm_dict["forecast"]["DA"])
    @test length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"]) == 24

    @info "making DA System"
    sys_rts_da = System(cdm_dict)
    @test sys_rts_da isa System

    @info "assigning time series data for RT"
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict, cdm_dict["forecast"]["RT"])
    @test length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"]) == 288

    @info "making RT System"
    sys_rts_rt = System(cdm_dict)
    @test sys_rts_rt isa System

    # Verify functionality of the concrete version of System.
    # TODO: Refactor once the ConcreteSystem implementation is finalized.
    sys = ConcreteSystem(sys_rts_da)
    @test length(sys_rts_rt.branches) == length(collect(get_mixed_components(Branch, sys)))
    @test length(sys_rts_rt.loads) == length(collect(get_mixed_components(ElectricLoad, sys)))
    @test length(sys_rts_rt.storage) == length(collect(get_mixed_components(Storage, sys)))
    @test length(sys_rts_rt.generators.thermal) == length(collect(get_mixed_components(ThermalGen, sys)))
    @test length(sys_rts_rt.generators.renewable) == length(collect(get_mixed_components(RenewableGen, sys)))
    @test length(sys_rts_rt.generators.hydro) == length(collect(get_mixed_components(HydroGen, sys)))
    @test length(get_components(Bus, sys)) > 0
    @test length(get_components(ThermalDispatch, sys)) > 0
    for x in (true, false)
        show_component_counts(sys, devnull; show_hierarchy=x)
    end
end

@testset "CDM parsing invalid directory" begin
    baddir = joinpath(RTS_GMLC_DIR, "../../test")
    @info "testing bad directory"
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
