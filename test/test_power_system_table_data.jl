
import PowerSystems: LazyDictFromIterator

@testset "PowerSystemTableData parsing" begin
    resolutions = (
        (resolution = Dates.Minute(5), len = 288),
        (resolution = Dates.Minute(60), len = 24),
    )

    for (resolution, len) in resolutions
        create_func = [create_rts_system, create_rts_multistart_system]
        for f in create_func
            sys = f(resolution)
            for time_series in get_time_series_multiple(sys)
                @test length(time_series) == len
            end
        end
    end
end

@testset "PowerSystemTableData parsing invalid directory" begin
    baddir = abspath(joinpath(RTS_GMLC_DIR, "../../test"))
    @test_throws ErrorException PowerSystemTableData(baddir, 100.0, DESCRIPTORS)
end

@testset "consistency between PowerSystemTableData and standardfiles" begin
    mpsys = System(PSY.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
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
        gen_dat = (
            structname = nothing,
            fields = (
                :active_power,
                :reactive_power,
                :rating,
                :active_power_limits,
                :reactive_power_limits,
                :ramp_limits,
            ),
        )
        function check_fields(chk_dat)
            for field in chk_dat.fields
                n = get(chk_dat, :structname, nothing)
                (cdmd, mpd) =
                    isnothing(n) ? (cdmgen, mpgen) :
                    (getfield(cdmgen, n), getfield(mpgen, n))
                cdmgen_val = getfield(cdmd, field)
                mpgen_val = getfield(mpd, field)
                if isnothing(cdmgen_val) || isnothing(mpgen_val)
                    @warn "Skip value with nothing" repr(cdmgen_val) repr(mpgen_val)
                    continue
                end
                @test cdmgen_val == mpgen_val
            end
        end
        check_fields(gen_dat)
    end

    mp_iter = get_components(ThermalGen, mpsys)
    mp_generators = LazyDictFromIterator(String, ThermalGen, mp_iter, get_name)
    for cdmgen in get_components(ThermalGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        @test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        for field in (:active_power_limits, :reactive_power_limits, :ramp_limits)
            cdmgen_val = getfield(cdmgen, field)
            mpgen_val = getfield(mpgen, field)
            if isnothing(cdmgen_val) || isnothing(mpgen_val)
                @warn "Skip value with nothing" repr(cdmgen_val) repr(mpgen_val)
                continue
            end
            @test cdmgen_val == mpgen_val
        end

        if length(mpgen.operation_cost.variable) == 4
            @test [
                isapprox(
                    cdmgen.operation_cost.variable[i][1],
                    mpgen.operation_cost.variable[i][1],
                    atol = 0.1,
                ) for i in 1:4
            ] == [true, true, true, true]
            #@test compare_values_without_uuids(cdmgen.operation_cost, mpgen.operation_cost)
        end
    end

    mp_iter = get_components(RenewableGen, mpsys)
    mp_generators = LazyDictFromIterator(String, RenewableGen, mp_iter, get_name)
    for cdmgen in get_components(RenewableGen, cdmsys)
        mpgen = get(mp_generators, uppercase(get_name(cdmgen)))
        # Disabled since data is inconsisten between sources
        #@test cdmgen.available == mpgen.available
        @test lowercase(cdmgen.bus.name) == lowercase(mpgen.bus.name)
        for field in (:rating, :power_factor)
            cdmgen_val = getfield(cdmgen, field)
            mpgen_val = getfield(mpgen, field)
            if isnothing(cdmgen_val) || isnothing(mpgen_val)
                @warn "Skip value with nothing" repr(cdmgen_val) repr(mpgen_val)
                continue
            end
            @test cdmgen_val == mpgen_val
        end
        #@test compare_values_without_uuids(cdmgen.operation_cost, mpgen.operation_cost)
    end

    cdm_ac_branches = collect(get_components(ACBranch, cdmsys))
    @test get_rate(cdm_ac_branches[2]) == get_rate(get_branch(mpsys, cdm_ac_branches[2]))
    @test get_rate(cdm_ac_branches[6]) == get_rate(get_branch(mpsys, cdm_ac_branches[6]))
    @test get_rate(cdm_ac_branches[120]) ==
          get_rate(get_branch(mpsys, cdm_ac_branches[120]))

    cdm_dc_branches = collect(get_components(DCBranch, cdmsys))
    @test get_active_power_limits_from(cdm_dc_branches[1]) ==
          get_active_power_limits_from(get_branch(mpsys, cdm_dc_branches[1]))
end

@testset "Test reserve direction" begin
    @test PSY.get_reserve_direction("Up") == ReserveUp
    @test PSY.get_reserve_direction("Down") == ReserveDown

    for invalid in ("up", "down", "right", "left")
        @test_throws PSY.DataFormatError PSY.get_reserve_direction(invalid)
    end
end
