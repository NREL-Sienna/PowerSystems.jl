#Bus Constructor
@test try tBus = Bus(); true finally end

#Generation Constructors
@test try tEconThermal = EconThermal(); true finally end
@test try tTechThermal = TechThermal(); true finally end
@test try tThermalGen = ThermalDispatch(); true finally end
@test try tThermalGenSeason = ThermalGenSeason(); true finally end
@test try tTechHydro = TechHydro(); true finally end
@test try tEconHydro = EconHydro(); true finally end
@test try tHydroFix = HydroFix(); true finally end
@test try tHydroCurtailment = HydroCurtailment(); true finally end
@test try tHydroStorage = HydroStorage(); true finally end
@test try tTechRenewable=TechRenewable(); true finally end
@test try tEconRenewable = EconRenewable(); true finally end
@test try tRenewableFix = RenewableFix(); true finally end
@test try tRenewableCurtailment = RenewableCurtailment(); true finally end

#Storage Constructots
@test try tStorage = GenericBattery(); true finally end

#Load Constructos
@test try tPowerLoad = PowerLoad(); true finally end 
@test try tPowerLoadPF = PowerLoadPF(); true finally end
@test try tPowerLoad = PowerLoad("init", true, Bus(), 0.0, 0.0); true finally end 
@test try tPowerLoadPF = PowerLoadPF("init", true, Bus(), 0.0, 1.0); true finally end
@test try tLoad = InterruptibleLoad(); true finally end

#Branch Constructors
@test try tLine = Line(); true finally end
@test try tMonitoredLine = MonitoredLine(); true finally end
@test try tHVDCLine = HVDCLine(); true finally end
@test try tVSCDCLine = VSCDCLine(); true finally end
@test try tTransformer2W = Transformer2W(); true finally end
@test try tTapTransformer = TapTransformer(); true finally end
@test try tPhaseShiftingTransformer = PhaseShiftingTransformer(); true finally end

#Product Constructors
@test try tProportionalReserve = ProportionalReserve(); true finally end
@test try tStaticReserve = StaticReserve(); true finally end


