
import PowerSystems: LazyDictFromIterator

@testset "CDM parsing" begin
    resolutions = (
        (resolution=Dates.Minute(5), len=288),
        (resolution=Dates.Minute(60), len=24),
    )

    for (resolution, len) in resolutions
        sys = create_rts_system(resolution)
        for forecast in iterate_forecasts(sys)
            @test length(forecast) == len
        end
    end
end

@testset "CDM parsing invalid directory" begin
    baddir = abspath(joinpath(RTS_GMLC_DIR, "../../test"))
    @test_throws ErrorException PowerSystemRaw(baddir, 100.0, DESCRIPTORS)
end

@testset "consistency between CDM and standardfiles" begin
    mp_dict  = parsestandardfiles(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    pm_dict = parse_file(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    pmmp_dict = PowerSystems.pm2ps_dict(pm_dict)
    mpmmpsys = System(pmmp_dict)

    mpsys = System(mp_dict)
    cdmsys = create_rts_system()

    mp_iter = get_components(HydroGen, mpsys)
    mp_generators = LazyDictFromIterator(String, HydroGen, mp_iter, get_name)
    for cdmgen in get_components(HydroGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        if isnothing(mpgen)
            error("did not find $cdmgen")
        end
        @test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        @test cdmgen.tech.rating == mpgen.tech.rating
        @test cdmgen.tech.activepower == mpgen.tech.activepower
        @test cdmgen.tech.activepowerlimits == mpgen.tech.activepowerlimits
        @test cdmgen.tech.reactivepower == mpgen.tech.reactivepower
        @test cdmgen.tech.reactivepowerlimits == mpgen.tech.reactivepowerlimits
        @test cdmgen.tech.ramplimits == mpgen.tech.ramplimits
        #@test cdmgen.tech.timelimits == mpgen.tech.timelimits
    end

    mp_iter = get_components(ThermalGen, mpsys)
    mp_generators = LazyDictFromIterator(String, ThermalGen, mp_iter, get_name)
    for cdmgen in get_components(ThermalGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        @test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        @test cdmgen.tech.activepowerlimits == mpgen.tech.activepowerlimits
        @test cdmgen.tech.reactivepowerlimits == mpgen.tech.reactivepowerlimits
        @test cdmgen.tech.ramplimits == mpgen.tech.ramplimits
        @test cdmgen.econ.capacity == mpgen.econ.capacity

        # TODO: not all match
        #@test [isapprox(cdmgen.econ.variablecost[i][1],
        #                mpgen.econ.variablecost[i][1], atol= .1) 
        #                for i in 1:4] == [true, true, true, true]
        #@test compare_values_without_uuids(cdmgen.econ, mpgen.econ)
    end

    mp_iter = get_components(RenewableGen, mpsys)
    mp_generators = LazyDictFromIterator(String, RenewableGen, mp_iter, get_name)
    for cdmgen in get_components(RenewableGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        # TODO
        #@test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        @test cdmgen.tech.rating == mpgen.tech.rating
        @test cdmgen.tech.reactivepowerlimits == mpgen.tech.reactivepowerlimits
        @test cdmgen.tech.powerfactor == mpgen.tech.powerfactor
        #@test compare_values_without_uuids(cdmgen.econ, mpgen.econ)
    end

    cdm_branches = collect(get_components(Branch,cdmsys))
    @test cdm_branches[2].rate == get_branch(mpsys, cdm_branches[2]).rate
    @test cdm_branches[6].rate == get_branch(mpsys, cdm_branches[6]).rate
    @test cdm_branches[120].rate == get_branch(mpsys, cdm_branches[120]).rate

    cdmgen = collect(get_components(RenewableGen, cdmsys))[1]
    mpgen = get_component_by_name(mpsys, RenewableGen, cdmgen)
    @test compare_values_without_uuids(cdmgen.tech, mpgen.tech)
    @test compare_values_without_uuids(cdmgen.econ, mpgen.econ)
end
