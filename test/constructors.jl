@testset "Bus Constructors" begin
    tBus = Bus(nothing)
    tLoadZones = LoadZones(nothing)

    bus = Bus(1, "test", PowerSystems.SLACK::BusType, 0.0, 0.0, (min=0.0, max=0.0), nothing)
    @test PowerSystems.get_bustype(bus) == PowerSystems.REF::BusType

    @test_throws(PowerSystems.DataFormatError,
                 Bus(1, "test", PowerSystems.ISOLATED::BusType, 0.0, 0.0,
                     (min=0.0, max=0.0), nothing))
end

@testset "Generation Constructors" begin
    tThreePartCost = ThreePartCost(nothing)
    @test tThreePartCost isa PowerSystemType
    tTwoPartCost = TwoPartCost(nothing)
    @test tTwoPartCost isa PowerSystemType
    tTechThermal = TechThermal(nothing)
    @test tTechThermal isa PowerSystemType
    tThermalGen = ThermalStandard(nothing)
    @test tThermalGen isa PowerSystems.Component
    tTechHydro = TechHydro(nothing)
    @test tTechHydro isa PowerSystemType
    tHydroFix = HydroFix(nothing)
    @test tHydroFix isa PowerSystems.Component
    tHydroDispatch = HydroDispatch(nothing)
    @test tHydroDispatch isa PowerSystems.Component
    tHydroStorage = HydroStorage(nothing)
    @test tHydroStorage isa PowerSystems.Component
    tTechRenewable = TechRenewable(nothing)
    @test tTechRenewable isa PowerSystemType
    tRenewableFix = RenewableFix(nothing)
    @test tRenewableFix isa PowerSystems.Component
    tRenewableDispatch = RenewableDispatch(nothing)
    @test tRenewableDispatch isa PowerSystems.Component
    tRenewableDispatch = RenewableDispatch(nothing)
    @test tRenewableDispatch isa PowerSystems.Component
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
    tPowerLoad = PowerLoad("init", true, Bus(nothing), 0.0, 0.0)
    @test tPowerLoad isa PowerSystems.Component
    tPowerLoadPF = PowerLoadPF("init", true, Bus(nothing), 0.0, 1.0)
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
    #tProportionalReserve = ProportionalReserve(nothing)
    #@test tProportionalReserve isa PowerSystems.Service
    tStaticReserve = StaticReserve(nothing)
    @test tStaticReserve isa PowerSystems.Service
end

@testset "Forecast Constructors" begin
    tg = RenewableFix(nothing)
    forecast_data = PowerSystems.TimeSeries.TimeArray([DateTime("01-01-01"), DateTime("01-01-01")+Hour(1)], [1.0, 1.0])
    #Deterministic Tests
    tDeterministicForecast = Deterministic(tg,"scalingfactor",Hour(1),DateTime("01-01-01"),24)
    @test tDeterministicForecast isa PowerSystems.Forecast
    tDeterministicForecast = Deterministic(tg,"scalingfactor",forecast_data)
    @test tDeterministicForecast isa PowerSystems.Forecast
    #Probabilistic Tests
    tProbabilisticForecast = Probabilistic(tg,"scalingfactor",Hour(1), DateTime("01-01-01"),[0.5, 0.5], 24)
    @test  tProbabilisticForecast isa PowerSystems.Forecast
    tProbabilisticForecast = Probabilistic(tg,"scalingfactor",[1.0], forecast_data)
    @test  tProbabilisticForecast isa PowerSystems.Forecast
end
