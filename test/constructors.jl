@testset "Bus Constructors" begin
    tBus = Bus()
    tLoadZones = LoadZones()
end

@testset "Generation Constructors" begin
    tEconThermal = EconThermal()
    @test tEconThermal isa PowerSystems.PowerSystemComponent
    tTechThermal = TechThermal()
    @test tTechThermal isa PowerSystems.PowerSystemComponent
    tThermalGen = ThermalDispatch()
    @test tThermalGen isa PowerSystems.PowerSystemComponent
    tThermalGenSeason = ThermalGenSeason()
    @test tThermalGenSeason isa PowerSystems.PowerSystemComponent
    tTechHydro = TechHydro()
    @test tTechHydro isa PowerSystems.PowerSystemComponent
    tEconHydro = EconHydro()
    @test tEconHydro isa PowerSystems.PowerSystemComponent
    tHydroFix = HydroFix()
    @test tHydroFix isa PowerSystems.PowerSystemComponent
    tHydroCurtailment = HydroCurtailment()
    @test tHydroCurtailment isa PowerSystems.PowerSystemComponent
    tHydroStorage = HydroStorage()
    @test tHydroStorage isa PowerSystems.PowerSystemComponent
    tTechRenewable = TechRenewable()
    @test tTechRenewable isa PowerSystems.PowerSystemComponent
    tEconRenewable = EconRenewable()
    @test tEconRenewable isa PowerSystems.PowerSystemComponent
    tRenewableFix = RenewableFix()
    @test tRenewableFix isa PowerSystems.PowerSystemComponent
    tRenewableFullDispatch = RenewableFullDispatch()
    @test tRenewableFullDispatch isa PowerSystems.PowerSystemComponent
    tRenewableCurtailment = RenewableCurtailment()
    @test tRenewableCurtailment isa PowerSystems.PowerSystemComponent
end

@testset "Storage Constructors" begin
    tStorage = GenericBattery()
    @test tStorage isa PowerSystems.PowerSystemComponent
end

@testset "Load Constructors" begin
    tPowerLoad = PowerLoad()
    @test tPowerLoad isa PowerSystems.PowerSystemComponent
    tPowerLoadPF = PowerLoadPF()
    @test tPowerLoadPF isa PowerSystems.PowerSystemComponent
    tPowerLoad = PowerLoad("init", true, Bus(), 0.0, 0.0)
    @test tPowerLoad isa PowerSystems.PowerSystemComponent
    tPowerLoadPF = PowerLoadPF("init", true, Bus(), 0.0, 1.0)
    @test tPowerLoadPF isa PowerSystems.PowerSystemComponent
    tLoad = InterruptibleLoad()
    @test tLoad isa PowerSystems.PowerSystemComponent
end

@testset "Branch Constructors" begin
    tLine = Line()
    @test tLine isa PowerSystems.PowerSystemComponent
    tMonitoredLine = MonitoredLine()
    @test tMonitoredLine isa PowerSystems.PowerSystemComponent
    tHVDCLine = HVDCLine()
    @test tHVDCLine isa PowerSystems.PowerSystemComponent
    tVSCDCLine = VSCDCLine()
    @test tVSCDCLine isa PowerSystems.PowerSystemComponent
    tTransformer2W = Transformer2W()
    @test tTransformer2W isa PowerSystems.PowerSystemComponent
    tTapTransformer = TapTransformer()
    @test tTapTransformer isa PowerSystems.PowerSystemComponent
    tPhaseShiftingTransformer = PhaseShiftingTransformer()
    @test tPhaseShiftingTransformer isa PowerSystems.PowerSystemComponent
end

@testset "Product Constructors" begin
    tProportionalReserve = ProportionalReserve()
    @test tProportionalReserve isa PowerSystems.Service
    tStaticReserve = StaticReserve()
    @test tStaticReserve isa PowerSystems.Service
end

@testset "Forecast Constructors" begin
    tg = RenewableFix()
    tDeterministicForecast = Deterministic(tg,:installedcapacity,Hour(1),DateTime("01-01-01"),24)
    @test tDeterministicForecast isa PowerSystems.Forecast
    tDeterministicForecast = Deterministic(tg,:installedcapacity,PowerSystems.TimeSeries.TimeArray([DateTime("01-01-01"),DateTime("01-01-02")],ones(2)))
    @test tDeterministicForecast isa PowerSystems.Forecast
end