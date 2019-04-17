
include(joinpath(DATA_DIR,"data_5bus_pu.jl"))


# test printing of System type
sys5 = System(nodes5, thermal_generators5, loads5, branches5, nothing, 100.0, forecasts5, nothing, nothing);
# short output
@test repr(sys5) == "System(buses:5,GenClasses(T:5,R:2,H:0),loads:4,branches:6,nothing)"
# long output
io = IOBuffer()
show(io, "text/plain", sys5)
@test String(take!(io)) ==
    "System:\n   buses: Bus[Bus(name=\"nodeA\"), Bus(name=\"nodeB\"), Bus(name=\"nodeC\"), Bus(name=\"nodeD\"), Bus(name=\"nodeE\")]\n   generators: \n     GenClasses(T:5,R:2,H:0):\n   thermal: ThermalDispatch[ThermalDispatch(name=\"Alta\"), ThermalDispatch(name=\"Park City\"), ThermalDispatch(name=\"Solitude\"), ThermalDispatch(name=\"Sundance\"), ThermalDispatch(name=\"Brighton\")]\n   renewable: RenewableGen[RenewableFix(name=\"SolarBusC\"), RenewableCurtailment(name=\"WindBusA\")]\n   hydro: nothing\n     (end generators)\n   loads: ElectricLoad[PowerLoad(name=\"Bus2\"), PowerLoad(name=\"Bus3\"), PowerLoad(name=\"Bus4\"), InterruptibleLoad(name=\"IloadBus4\")]\n   branches: Line[Line(name=\"1\"), Line(name=\"2\"), Line(name=\"3\"), Line(name=\"4\"), Line(name=\"5\"), Line(name=\"6\")]\n   storage: nothing\n   basepower: 100.0\n   forecasts: Dict{Symbol,Array{#s43,1} where #s43<:Forecast}(:DA=>Deterministic[Deterministic{RenewableFix}(RenewableFix(name=\"SolarBusC\"), \"scalingfactor\", 1 hour, 2024-01-01T00:00:00, 24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00), Deterministic{RenewableCurtailment}(RenewableCurtailment(name=\"WindBusA\"), \"scalingfactor\", 1 hour, 2024-01-01T00:00:00, 24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00), Deterministic{PowerLoad}(PowerLoad(name=\"Bus2\"), \"scalingfactor\", 1 hour, 2024-01-01T00:00:00, 24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00), Deterministic{PowerLoad}(PowerLoad(name=\"Bus3\"), \"scalingfactor\", 1 hour, 2024-01-01T00:00:00, 24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00), Deterministic{PowerLoad}(PowerLoad(name=\"Bus4\"), \"scalingfactor\", 1 hour, 2024-01-01T00:00:00, 24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00), Deterministic{InterruptibleLoad}(InterruptibleLoad(name=\"IloadBus4\"), \"scalingfactor\", 1 hour, 2024-01-01T00:00:00, 24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00)])\n   services: nothing\n   annex: nothing"# test printing of a few component types

# bus
@test repr(sys5.buses[1]) == "Bus(name=\"nodeA\")"
show(io, "text/plain", sys5.buses[1])
@test String(take!(io)) ==
    "Bus:\n   number: 1\n   name: nodeA\n   bustype: PV\n   angle: 0.0\n   voltage: 1.0\n   voltagelimits: (min = 0.9, max = 1.05)\n   basevoltage: 230.0"

# generators
@test repr(sys5.generators) == "GenClasses(T:5,R:2,H:0)"
show(io, "text/plain", sys5.generators)
@test String(take!(io)) ==
    "GenClasses(T:5,R:2,H:0):\n   thermal: ThermalDispatch[ThermalDispatch(name=\"Alta\"), ThermalDispatch(name=\"Park City\"), ThermalDispatch(name=\"Solitude\"), ThermalDispatch(name=\"Sundance\"), ThermalDispatch(name=\"Brighton\")]\n   renewable: RenewableGen[RenewableFix(name=\"SolarBusC\"), RenewableCurtailment(name=\"WindBusA\")]\n   hydro: nothing"

# Generator
@test repr(sys5.generators.thermal[1]) == "ThermalDispatch(name=\"Alta\")"
show(io, "text/plain", sys5.generators.thermal[1])
@test_skip String(take!(io)) ==
    "ThermalDispatch:\n   name: Alta\n   available: true\n   bus: Bus(name=\"nodeA\")\n   tech: TechThermal(40.0, (min = 0.0, max = 40.0), 10.0, (min = -30.0, max = 30.0), nothing, nothing)\n   econ: EconThermal(40.0, getfield(Main, Symbol(\"##131#135\"))(), 0.0, 0.0, 0.0, nothing)"

# generator technology
@test repr(sys5.generators.thermal[1].tech) == "TechThermal(40.0, (min = 0.0, max = 40.0), 10.0, (min = -30.0, max = 30.0), nothing, nothing)"
show(io, "text/plain", sys5.generators.thermal[1].tech)
@test_skip String(take!(io)) ==
    "TechThermal(40.0, (min = 0.0, max = 40.0), 10.0, (min = -30.0, max = 30.0), nothing, nothing)"

# load
@test repr(sys5.loads[1]) == "PowerLoad(name=\"Bus2\")"
show(io, "text/plain", sys5.branches[1])
@test_skip String(take!(io)) ==
    "Line:\n   name: 1\n   available: true\n   connectionpoints: (from = Bus(name=\"nodeA\"), to = Bus(name=\"nodeB\"))\n   r: 0.00281\n   x: 0.0281\n   b: (from = 0.00356, to = 0.00356)\n   rate: 38.038742043967325\n   anglelimits: (min = -0.7853981633974483, max = 0.7853981633974483)"

# scalingfactor (a TimeArray)
@test repr(sys5.forecasts[:DA][1].data) ==
    "24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00"
show(io, "text/plain", sys5.forecasts[:DA][1].data)
@test_skip String(take!(io)) == 
    "24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00\n│                     │ A      │\n├─────────────────────┼────────┤\n│ 2024-01-01T00:00:00 │ 0.0    │\n│ 2024-01-01T01:00:00 │ 0.0    │\n│ 2024-01-01T02:00:00 │ 0.0    │\n│ 2024-01-01T03:00:00 │ 0.0    │\n│ 2024-01-01T04:00:00 │ 0.0    │\n│ 2024-01-01T05:00:00 │ 0.0    │\n│ 2024-01-01T06:00:00 │ 0.0    │\n│ 2024-01-01T07:00:00 │ 0.0    │\n│ 2024-01-01T08:00:00 │ 0.0    │\n   ⋮\n│ 2024-01-01T16:00:00 │ 0.1551 │\n│ 2024-01-01T17:00:00 │ 0.0409 │\n│ 2024-01-01T18:00:00 │ 0.0    │\n│ 2024-01-01T19:00:00 │ 0.0    │\n│ 2024-01-01T20:00:00 │ 0.0    │\n│ 2024-01-01T21:00:00 │ 0.0    │\n│ 2024-01-01T22:00:00 │ 0.0    │\n│ 2024-01-01T23:00:00 │ 0.0    │"

# line
@test repr(sys5.branches[1]) == "Line(name=\"1\")"
show(io, "text/plain", sys5.branches[1])
@test_skip String(take!(io)) ==
    "Line:\n   name: 1\n   available: true\n   connectionpoints: (from = Bus(name=\"nodeA\"), to = Bus(name=\"nodeB\"))\n   r: 0.00281\n   x: 0.0281\n   b: (from = 0.00356, to = 0.00356)\n   rate: 38.038742043967325\n   anglelimits: (min = -0.7853981633974483, max = 0.7853981633974483)"