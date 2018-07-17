#Bus Constructor
tBus = Bus()

#Generation Constructors
tEconThermal = EconThermal()
tTechThermal = TechThermal()
tThermalGen = ThermalDispatch()
tTechHydro = TechHydro()
tEconHydro = EconHydro()
tHydroFix = HydroFix()
tHydroCurtailment = HydroCurtailment()
tHydroStorage = HydroStorage()
tTechRenewable=TechRenewable()
tEconRenewable = EconRenewable()
tRenewableFix = RenewableFix()
tRenewableCurtailment = RenewableCurtailment()

#Storage Constructots
tStorage = GenericBattery()

#Load Constructos
tLoad = InterruptibleLoad()

#Branch Constructors
tLine = Line()
tDCLine = DCLine()
tTransformer2W = Transformer2W()
tTapTransformer = TapTransformer()
tPhaseShiftingTransformer = PhaseShiftingTransformer()

#Product Constructors
tProportionalReserve = ProportionalReserve()

true