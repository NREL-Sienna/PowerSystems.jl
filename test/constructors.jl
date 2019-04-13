@testset "Bus Constructors" begin
    tBus = Bus()
    tLoadZones = LoadZones()
end

@testset "Generation Constructors" begin
    tEconThermal = EconThermal()
    @test tEconThermal isa PowerSystems.Component
    tTechThermal = TechThermal()
    @test tTechThermal isa PowerSystems.Component
    tThermalGen = ThermalDispatch()
    @test tThermalGen isa PowerSystems.Component
    tThermalGenSeason = ThermalGenSeason()
    @test tThermalGenSeason isa PowerSystems.Component
    tTechHydro = TechHydro()
    @test tTechHydro isa PowerSystems.Component
    tEconHydro = EconHydro()
    @test tEconHydro isa PowerSystems.Component
    tHydroFix = HydroFix()
    @test tHydroFix isa PowerSystems.Component
    tHydroCurtailment = HydroCurtailment()
    @test tHydroCurtailment isa PowerSystems.Component
    tHydroStorage = HydroStorage()
    @test tHydroStorage isa PowerSystems.Component
    tTechRenewable = TechRenewable()
    @test tTechRenewable isa PowerSystems.Component
    tEconRenewable = EconRenewable()
    @test tEconRenewable isa PowerSystems.Component
    tRenewableFix = RenewableFix()
    @test tRenewableFix isa PowerSystems.Component
    tRenewableFullDispatch = RenewableFullDispatch()
    @test tRenewableFullDispatch isa PowerSystems.Component
    tRenewableCurtailment = RenewableCurtailment()
    @test tRenewableCurtailment isa PowerSystems.Component
end

@testset "Storage Constructors" begin
    tStorage = GenericBattery()
    @test tStorage isa PowerSystems.Component
end

@testset "Load Constructors" begin
    tPowerLoad = PowerLoad()
    @test tPowerLoad isa PowerSystems.Component
    tPowerLoadPF = PowerLoadPF()
    @test tPowerLoadPF isa PowerSystems.Component
    tPowerLoad = PowerLoad("init", true, Bus(), 0.0, 0.0)
    @test tPowerLoad isa PowerSystems.Component
    tPowerLoadPF = PowerLoadPF("init", true, Bus(), 0.0, 1.0)
    @test tPowerLoadPF isa PowerSystems.Component
    tLoad = InterruptibleLoad()
    @test tLoad isa PowerSystems.Component
end

@testset "Branch Constructors" begin
    tLine = Line()
    @test tLine isa PowerSystems.Component
    tMonitoredLine = MonitoredLine()
    @test tMonitoredLine isa PowerSystems.Component
    tHVDCLine = HVDCLine()
    @test tHVDCLine isa PowerSystems.Component
    tVSCDCLine = VSCDCLine()
    @test tVSCDCLine isa PowerSystems.Component
    tTransformer2W = Transformer2W()
    @test tTransformer2W isa PowerSystems.Component
    tTapTransformer = TapTransformer()
    @test tTapTransformer isa PowerSystems.Component
    tPhaseShiftingTransformer = PhaseShiftingTransformer()
    @test tPhaseShiftingTransformer isa PowerSystems.Component
end

@testset "Product Constructors" begin
    #tProportionalReserve = ProportionalReserve()
    #@test tProportionalReserve isa PowerSystems.Service
    tStaticReserve = StaticReserve()
    @test tStaticReserve isa PowerSystems.Service
end

@testset "Forecast Constructors" begin
    tg = RenewableFix()
    tDeterministicForecast = Deterministic(tg,"scalingfactor",Hour(1),DateTime("01-01-01"),24)
    @test tDeterministicForecast isa PowerSystems.Forecast
    tDeterministicForecast = Deterministic(tg,"scalingfactor",PowerSystems.TimeSeries.TimeArray([DateTime("01-01-01"),DateTime("01-01-02")],ones(2)))
    @test tDeterministicForecast isa PowerSystems.Forecast
end