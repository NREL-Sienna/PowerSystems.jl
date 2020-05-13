import JSON2

function validate_serialization(sys::System)
    test_dir = mktempdir()
    orig_dir = pwd()
    cd(test_dir)

    try
        path = joinpath(test_dir, "test_system_serialization.json")
        io = open(path, "w")
        @info "Serializing to $path"
        sys_ext = get_ext(sys)
        sys_ext["data"] = 5
        ext_test_bus_name = ""
        try
            IS.prepare_for_serialization!(sys.data, path; force = true)
            bus = collect(get_components(PSY.Bus, sys))[1]
            ext_test_bus_name = PSY.get_name(bus)
            ext = PSY.get_ext(bus)
            ext["test_field"] = 1
            to_json(io, sys)
        finally
            close(io)
        end

        sys2 = System(path)
        sys_ext2 = get_ext(sys2)
        sys_ext2["data"] != 5 && return false
        bus = PSY.get_component(PSY.Bus, sys2, ext_test_bus_name)
        ext = PSY.get_ext(bus)
        ext["test_field"] != 1 && return false
        return IS.compare_values(sys, sys2)
    finally
        cd(orig_dir)
    end
end

@testset "Test JSON serialization of CDM data" begin
    sys = create_rts_system()
    @test validate_serialization(sys)
end

@testset "Test JSON serialization of matpower data" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))

    # Add a Probabilistic forecast to get coverage serializing it.
    bus = Bus(nothing)
    bus.name = "Bus1234"
    add_component!(sys, bus)
    tg = RenewableFix(nothing)
    tg.bus = bus
    add_component!(sys, tg)
    tProbabilisticForecast =
        PSY.Probabilistic("scalingfactor", Hour(1), DateTime("01-01-01"), [0.5, 0.5], 24)
    add_forecast!(sys, tg, tProbabilisticForecast)

    @test validate_serialization(sys)
end

@testset "Test JSON serialization of ACTIVSg2000 data" begin
    path = joinpath(DATA_DIR, "ACTIVSg2000", "ACTIVSg2000.m")
    sys = System(PowerSystems.PowerModelsData(path))
    validate_serialization(sys)
end

@testset "Test JSON serialization of dynamic inverter" begin
    sys = create_system_with_dynamic_inverter()
    @test validate_serialization(sys)
end

@testset "Test deepcopy of a system" begin
    sys = create_rts_system()
    sys2 = deepcopy(sys)
    clear_forecasts!(sys2)
    @test !isempty(collect(PSY.iterate_forecasts(sys)))
end
