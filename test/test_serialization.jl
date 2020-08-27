#=
import JSON2

function validate_serialization(sys::System; time_series_read_only = false)
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

        sys2 = System(path; time_series_read_only = time_series_read_only)
        sys_ext2 = get_ext(sys2)
        sys_ext2["data"] != 5 && return false
        bus = PSY.get_component(PSY.Bus, sys2, ext_test_bus_name)
        ext = PSY.get_ext(bus)
        ext["test_field"] != 1 && return false
        return sys2, IS.compare_values(sys, sys2)
    finally
        cd(orig_dir)
    end
end

@testset "Test JSON serialization of RTS data with mutable time series" begin
    sys = create_rts_system()

    # Add an AGC service to cover its special serialization.
    control_area = get_component(Area, sys, "1")
    AGC_service = PSY.AGC(
        name = "AGC_Area1",
        available = true,
        bias = 739.0,
        K_p = 2.5,
        K_i = 0.1,
        K_d = 0.0,
        delta_t = 4,
        area = control_area,
    )
    initial_time = Dates.DateTime("2020-01-01T00:00:00")
    end_time = Dates.DateTime("2020-01-01T23:00:00")
    dates = collect(initial_time:Dates.Hour(1):end_time)
    data = collect(1:24)
    label = "get_active_power"
    contributing_devices = Vector{Device}()
    for g in get_components(
        ThermalStandard,
        sys,
        x -> (x.prime_mover ∈ [PrimeMovers.ST, PrimeMovers.CC, PrimeMovers.CT]),
    )
        if get_area(get_bus(g)) != control_area
            continue
        end
        ta = TimeSeries.TimeArray(dates, data, [Symbol(get_name(g))])
        forecast = IS.Deterministic(label, ta)
        add_forecast!(sys, g, forecast)

        t = RegulationDevice(g, participation_factor = (up = 1.0, dn = 1.0), droop = 0.04)
        add_component!(sys, t)
        @test isnothing(get_component(ThermalStandard, sys, get_name(g)))
        push!(contributing_devices, t)
    end
    add_service!(sys, AGC_service, contributing_devices)

    sys2, result = validate_serialization(sys; time_series_read_only = false)
    @test result

    # Ensure the forecasts attached to the ThermalStandard got deserialized.
    for rd in get_components(RegulationDevice, sys2)
        @test get_forecast(Deterministic, rd, initial_time, label) isa Deterministic
    end

    clear_forecasts!(sys2)
end

@testset "Test JSON serialization of RTS data with immutable time series" begin
    sys = create_rts_system()
    sys2, result = validate_serialization(sys; time_series_read_only = true)
    @test result
    @test_throws ErrorException clear_forecasts!(sys2)
    # Full error checking is done in IS.
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

    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of ACTIVSg2000 data" begin
    path = joinpath(DATA_DIR, "ACTIVSg2000", "ACTIVSg2000.m")
    sys = System(PowerSystems.PowerModelsData(path))
    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of dynamic inverter" begin
    sys = create_system_with_dynamic_inverter()
    # Add a dynamic branch to test that code.
    branch = collect(get_components(Branch, sys))[1]
    dynamic_branch = DynamicBranch(branch)
    add_component!(sys, dynamic_branch)
    _, result = validate_serialization(sys)
    @test result
end

@testset "Test JSON serialization of StaticGroupReserve" begin
    sys = System(100)
    devices = []
    for i in 1:2
        bus = Bus(nothing)
        bus.name = "bus" * string(i)
        bus.number = i
        # This prevents an error log message.
        bus.bustype = BusTypes.REF
        add_component!(sys, bus)
        gen = ThermalStandard(nothing)
        gen.bus = bus
        gen.name = "gen" * string(i)
        add_component!(sys, gen)
        push!(devices, gen)
    end

    service = StaticReserve{ReserveDown}(nothing)
    add_service!(sys, service, devices)

    groupservice = StaticReserveGroup{ReserveDown}(nothing)
    add_service!(sys, groupservice)
    members = Vector{Service}()
    push!(members, service)
    set_contributing_services!(sys, groupservice, members)
    _, result = validate_serialization(sys)
    @test result
end

@testset "Test deepcopy of a system" begin
    sys = create_rts_system()
    sys2 = deepcopy(sys)
    clear_forecasts!(sys2)
    @test !isempty(collect(PSY.iterate_forecasts(sys)))
end
=#