@testset "Bus Constructors" begin
    tBus = ACBus(nothing)
    tLoadZone = LoadZone(nothing)

    bus = ACBus(
        1,
        "test",
        ACBusTypes.SLACK,
        0.0,
        0.0,
        (min = 0.0, max = 0.0),
        nothing,
        nothing,
        nothing,
    )

    @test PowerSystems.get_bustype(bus) == ACBusTypes.REF
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
    tStandardLoad = StandardLoad(nothing)
    @test tStandardLoad isa PowerSystems.Component
    tPowerLoad = PowerLoad("init", true, ACBus(nothing), 0.0, 0.0, 100.0, 0.0, 0.0)
    @test tPowerLoad isa PowerSystems.Component
    tLoad = InterruptiblePowerLoad(nothing)
    @test tLoad isa PowerSystems.Component
end

@testset "Branch Constructors" begin
    tLine = Line(nothing)
    @test tLine isa PowerSystems.Component
    tMonitoredLine = MonitoredLine(nothing)
    @test tMonitoredLine isa PowerSystems.Component
    tTwoTerminalTwoTerminalHVDCLine = TwoTerminalHVDCLine(nothing)
    @test tTwoTerminalHVDCLine isa PowerSystems.Component
    tTwoTerminalVSCDCLine = TwoTerminalVSCDCLine(nothing)
    @test tTwoTerminalVSCDCLine isa PowerSystems.Component
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

@testset "TimeSeriesData Constructors" begin
    tg = RenewableFix(nothing)
    data = PowerSystems.TimeSeries.TimeArray(
        [DateTime("01-01-01"), DateTime("01-01-01") + Hour(1)],
        [1.0, 1.0],
    )
    #SingleTimeSeries Tests
    ts = SingleTimeSeries("scalingfactor", Hour(1), DateTime("01-01-01"), 24)
    @test ts isa PowerSystems.TimeSeriesData
    ts = SingleTimeSeries(; name = "scalingfactor", data = data)
    @test ts isa PowerSystems.TimeSeriesData

    #Probabilistic Tests
    data = SortedDict(
        DateTime("01-01-01") => [1.0 1.0; 2.0 2.0],
        DateTime("01-01-01") + Hour(1) => [1.0 1.0; 2.0 2.0],
    )
    ts = Probabilistic("scalingfactor", data, [0.5, 0.5], Hour(1))
    @test ts isa PowerSystems.TimeSeriesData
    ts = Probabilistic(; name = "scalingfactor", percentiles = [1.0], data = data)
    @test ts isa PowerSystems.TimeSeriesData
    ##Scenario Tests
    ts = Scenarios("scalingfactor", data, Hour(1))
    @test ts isa PowerSystems.TimeSeriesData
end

@testset "Regulation Device" begin
    original_device = ThermalStandard(nothing)
    regulation = RegulationDevice(original_device)
    @test get_rating(regulation) == 0.0
    set_rating!(regulation, 10.0)
    @test get_rating(regulation) == 10.0
    regulation = RegulationDevice(original_device; droop = 0.5)
    @test get_droop(regulation) == 0.5
    @test get_participation_factor(regulation) == (up = 0.0, dn = 0.0)
    @test get_reserve_limit_up(regulation) == 0.0
    @test get_reserve_limit_dn(regulation) == 0.0
    @test get_inertia(regulation) == 0.0
end
