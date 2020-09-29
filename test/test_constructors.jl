@testset "Bus Constructors" begin
    tBus = Bus(nothing)
    tLoadZone = LoadZone(nothing)

    bus = Bus(
        1,
        "test",
        BusTypes.SLACK,
        0.0,
        0.0,
        (min = 0.0, max = 0.0),
        nothing,
        nothing,
        nothing,
    )
    @test PowerSystems.get_bustype(bus) == BusTypes.REF

    @test_throws(
        PowerSystems.DataFormatError,
        Bus(
            1,
            "test",
            BusTypes.ISOLATED,
            0.0,
            0.0,
            (min = 0.0, max = 0.0),
            nothing,
            nothing,
            nothing,
        )
    )
end

@testset "Generation Constructors" begin
    tThreePartCost = ThreePartCost(nothing)
    @test tThreePartCost isa IS.InfrastructureSystemsType
    tTwoPartCost = TwoPartCost(nothing)
    @test tTwoPartCost isa IS.InfrastructureSystemsType
    tThermalGen = ThermalStandard(nothing)
    @test tThermalGen isa PowerSystems.Component
    tHydroDispatch = HydroDispatch(nothing)
    @test tHydroDispatch isa PowerSystems.Component
    tHydroEnergyReservoir = HydroEnergyReservoir(nothing)
    @test tHydroEnergyReservoir isa PowerSystems.Component
    tRenewableFix = RenewableFix(nothing)
    @test tRenewableFix isa PowerSystems.Component
    tRenewableDispatch = RenewableDispatch(nothing)
    @test tRenewableDispatch isa PowerSystems.Component
    tRenewableDispatch = RenewableDispatch(nothing)
    @test tRenewableDispatch isa PowerSystems.Component
end

@testset "Source Constructors" begin
    tSource = Source(nothing)
    @test tSource isa PowerSystems.Component
end

@testset "Storage Constructors" begin
    tStorage = GenericBattery(nothing)
    @test tStorage isa PowerSystems.Component
end

@testset "Load Constructors" begin
    tPowerLoad = PowerLoad(nothing)
    @test tPowerLoad isa PowerSystems.Component
    tPowerLoadPF = PowerLoadPF(nothing)
    @test tPowerLoadPF isa PowerSystems.Component
    tPowerLoad = PowerLoad("init", true, Bus(nothing), nothing, 0.0, 0.0, 100.0, 0.0, 0.0)
    @test tPowerLoad isa PowerSystems.Component
    tPowerLoadPF = PowerLoadPF("init", true, Bus(nothing), nothing, 0.0, 0.0, 1.0, 100.0)
    @test tPowerLoadPF isa PowerSystems.Component
    tLoad = InterruptibleLoad(nothing)
    @test tLoad isa PowerSystems.Component
end

@testset "Branch Constructors" begin
    tLine = Line(nothing)
    @test tLine isa PowerSystems.Component
    tMonitoredLine = MonitoredLine(nothing)
    @test tMonitoredLine isa PowerSystems.Component
    tHVDCLine = HVDCLine(nothing)
    @test tHVDCLine isa PowerSystems.Component
    tVSCDCLine = VSCDCLine(nothing)
    @test tVSCDCLine isa PowerSystems.Component
    tTransformer2W = Transformer2W(nothing)
    @test tTransformer2W isa PowerSystems.Component
    tTapTransformer = TapTransformer(nothing)
    @test tTapTransformer isa PowerSystems.Component
    tPhaseShiftingTransformer = PhaseShiftingTransformer(nothing)
    @test tPhaseShiftingTransformer isa PowerSystems.Component
end

@testset "Service Constructors" begin
    tStaticReserve = StaticReserve{ReserveUp}(nothing)
    @test tStaticReserve isa PowerSystems.Service
    tVariableReserve = VariableReserve{ReserveDown}(nothing)
    @test tVariableReserve isa PowerSystems.Service
end

@testset "Forecast Constructors" begin
    tg = RenewableFix(nothing)
    forecast_data = PowerSystems.TimeSeries.TimeArray(
        [DateTime("01-01-01"), DateTime("01-01-01") + Hour(1)],
        [1.0, 1.0],
    )
    #Deterministic Tests
    tDeterministicForecast =
        PSY.Deterministic("scalingfactor", Hour(1), DateTime("01-01-01"), 24)
    @test tDeterministicForecast isa PowerSystems.Forecast
    tDeterministicForecast = PSY.Deterministic("scalingfactor", forecast_data)
    @test tDeterministicForecast isa PowerSystems.Forecast
    #Probabilistic Tests
    tProbabilisticForecast =
        PSY.Probabilistic("scalingfactor", Hour(1), DateTime("01-01-01"), [0.5, 0.5], 24)
    @test tProbabilisticForecast isa PowerSystems.Forecast
    tProbabilisticForecast = PSY.Probabilistic("scalingfactor", [1.0], forecast_data)
    @test tProbabilisticForecast isa PowerSystems.Forecast
    #Scenario Tests
    tScenarioForecast =
        PSY.ScenarioBased("scalingfactor", Hour(1), DateTime("01-01-01"), 2, 24)
    @test tScenarioForecast isa PowerSystems.Forecast
    tScenarioForecast = PSY.ScenarioBased("scalingfactor", forecast_data)
    @test tScenarioForecast isa PowerSystems.Forecast
end

@testset "Regulation Device" begin
    original_device = ThermalStandard(nothing)
    regulation = RegulationDevice(original_device)
    @test get_rating(regulation) == 0.0
    set_rating!(regulation, 10.0)
    @test get_rating(regulation) == 10.0
    regulation = RegulationDevice(original_device, droop = 0.5)
    @test get_droop(regulation) == 0.5
    @test get_participation_factor(regulation) == (up = 0.0, dn = 0.0)
    @test get_reserve_limit_up(regulation) == 0.0
    @test get_reserve_limit_dn(regulation) == 0.0
    @test get_inertia(regulation) == 0.0
end
