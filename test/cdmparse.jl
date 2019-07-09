
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
    mpsys  = parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
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
        for field in (:rating, :activepower, :activepowerlimits, :reactivepower,
                      :reactivepowerlimits, :ramplimits)  # :timelimits
            cdmgen_val = getfield(cdmgen.tech, field)
            mpgen_val = getfield(mpgen.tech, field)
            if isnothing(cdmgen_val) || isnothing(mpgen_val)
                @warn "Skip value with nothing" repr(cdmgen_val) repr(mpgen_val)
                continue
            end
            @test cdmgen_val == mpgen_val
        end
    end

    mp_iter = get_components(ThermalGen, mpsys)
    mp_generators = LazyDictFromIterator(String, ThermalGen, mp_iter, get_name)
    for cdmgen in get_components(ThermalGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        @test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        for field in (:activepowerlimits, :reactivepowerlimits, :ramplimits)
            cdmgen_val = getfield(cdmgen.tech, field)
            mpgen_val = getfield(mpgen.tech, field)
            if isnothing(cdmgen_val) || isnothing(mpgen_val)
                @warn "Skip value with nothing" repr(cdmgen_val) repr(mpgen_val)
                continue
            end
            @test cdmgen_val == mpgen_val
        end

        if length(mpgen.op_cost.variable) == 4
            @test [isapprox(cdmgen.op_cost.variable[i][1],
                            mpgen.op_cost.variable[i][1], atol= .1)
                            for i in 1:4] == [true, true, true, true]
            #@test compare_values_without_uuids(cdmgen.op_cost, mpgen.op_cost)
        end
    end

    mp_iter = get_components(RenewableGen, mpsys)
    mp_generators = LazyDictFromIterator(String, RenewableGen, mp_iter, get_name)
    for cdmgen in get_components(RenewableGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        # TODO
        #@test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        for field in (:rating, :reactivepowerlimits, :powerfactor)
            cdmgen_val = getfield(cdmgen.tech, field)
            mpgen_val = getfield(mpgen.tech, field)
            if isnothing(cdmgen_val) || isnothing(mpgen_val)
                @warn "Skip value with nothing" repr(cdmgen_val) repr(mpgen_val)
                continue
            end
            @test cdmgen_val == mpgen_val
        end
        #@test compare_values_without_uuids(cdmgen.op_cost, mpgen.op_cost)
    end

    cdm_branches = collect(get_components(Branch,cdmsys))
    @test cdm_branches[2].rate == get_branch(mpsys, cdm_branches[2]).rate
    @test cdm_branches[6].rate == get_branch(mpsys, cdm_branches[6]).rate
    @test cdm_branches[120].rate == get_branch(mpsys, cdm_branches[120]).rate
end
