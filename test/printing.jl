
base_dir = string(dirname(dirname(@__FILE__)))
@info joinpath(base_dir,"data/data_5bus.jl")
include(joinpath(base_dir,"data/data_5bus.jl"))


# test printing of PowerSystem type
sys5 = PowerSystem(nodes5, generators5, loads5_DA, branches5, nothing,  100.0);
# short output
@test repr(sys5) == "PowerSystem(buses:5,GenClasses(T:5,R:2,H:0),loads:4,branches:6,nothing)"
# long output
io = IOBuffer()
show(io, "text/plain", sys5)
@test_skip String(take!(io)) ==
    "PowerSystem:\n   buses: Bus[Bus(name=\"nodeA\"), Bus(name=\"nodeB\"), Bus(name=\"nodeC\"), Bus(name=\"nodeD\"), Bus(name=\"nodeE\")]\n   generators: \n     GenClasses(T:5,R:2,H:0):\n   thermal: ThermalDispatch[ThermalDispatch(name=\"Alta\"), ThermalDispatch(name=\"Park City\"), ThermalDispatch(name=\"Solitude\"), ThermalDispatch(name=\"Sundance\"), ThermalDispatch(name=\"Brighton\")]\n   renewable: RenewableGen[RenewableFix(name=\"SolarBusC\"), RenewableCurtailment(name=\"WindBusA\")]\n   hydro: nothing\n     (end generators)\n   loads: ElectricLoad[StaticLoad(name=\"Bus2\"), StaticLoad(name=\"Bus3\"), StaticLoad(name=\"Bus4\"), InterruptibleLoad(name=\"IloadBus4\")]\n   branches: Line[Line(name=\"1\"), Line(name=\"2\"), Line(name=\"3\"), Line(name=\"4\"), Line(name=\"5\"), Line(name=\"6\")]\n   storage: nothing\n   basepower: 1000.0\n   time_periods: 24"


# test printing of a few component types

# bus
@test repr(sys5.buses[1]) == "Bus(name=\"nodeA\")"
show(io, "text/plain", sys5.buses[1])
@test_skip String(take!(io)) == 
    "Bus:\n   number: 1\n   name: nodeA\n   bustype: PV\n   angle: 0.0\n   voltage: 1.0\n   voltagelimits: (min = 0.9, max = 1.05)\n   basevoltage: 230.0"

# generators
@test repr(sys5.generators) == "GenClasses(T:5,R:2,H:0)"
show(io, "text/plain", sys5.generators)
@test_skip String(take!(io)) ==
    "GenClasses(T:5,R:2,H:0):\n   thermal: ThermalDispatch[ThermalDispatch(name=\"Alta\"), ThermalDispatch(name=\"Park City\"), ThermalDispatch(name=\"Solitude\"), ThermalDispatch(name=\"Sundance\"), ThermalDispatch(name=\"Brighton\")]\n   renewable: RenewableGen[RenewableFix(name=\"SolarBusC\"), RenewableCurtailment(name=\"WindBusA\")]\n   hydro: nothing"

# Generator
@test repr(sys5.generators.thermal[1]) == "ThermalDispatch(name=\"Alta\")"
show(io, "text/plain", sys5.generators.thermal[1])
@test_skip String(take!(io)) ==
    "ThermalDispatch:\n   name: Alta\n   available: true\n   bus: Bus(name=\"nodeA\")\n   tech: TechThermal\n   econ: EconThermal"

# generator technology
@test repr(sys5.generators.thermal[1].tech) == "TechThermal"
show(io, "text/plain", sys5.generators.thermal[1].tech)
@test_skip String(take!(io)) ==
    "TechThermal:\n   activepower: 40.0\n   activepowerlimits: (min = 0.0, max = 40.0)\n   reactivepower: 10.0\n   reactivepowerlimits: (min = -30.0, max = 30.0)\n   ramplimits: nothing\n   timelimits: nothing"

# load
@test repr(sys5.loads[1]) == "StaticLoad(name=\"Bus2\")"
show(io, "text/plain", sys5.branches[1])
@test_skip String(take!(io)) ==
    "Line:\n   name: 1\n   available: true\n   connectionpoints: (from = Bus(name=\"nodeA\"), to = Bus(name=\"nodeB\"))\n   r: 0.00281\n   x: 0.0281\n   b: (from = 0.00356, to = 0.00356)\n   rate: 38.038742043967325\n   anglelimits: (min = -0.7853981633974483, max = 0.7853981633974483)"

# scalingfactor (a TimeArray)
@test repr(sys5.loads[1].scalingfactor) ==
    "24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00\n"
show(io, "text/plain", sys5.loads[1].scalingfactor)
@test_skip String(take!(io)) ==
    "24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00\n│                     │ A      │\n├─────────────────────┼────────┤\n│ 2024-01-01T00:00:00 │ 0.7927 │\n│ 2024-01-01T01:00:00 │ 0.7232 │\n│ 2024-01-01T02:00:00 │ 0.711  │\n│ 2024-01-01T03:00:00 │ 0.6777 │\n│ 2024-01-01T04:00:00 │ 0.6682 │\n│ 2024-01-01T05:00:00 │ 0.6717 │\n│ 2024-01-01T06:00:00 │ 0.6876 │\n│ 2024-01-01T07:00:00 │ 0.7118 │\n│ 2024-01-01T08:00:00 │ 0.7563 │\n   ⋮\n│ 2024-01-01T16:00:00 │ 0.8241 │\n│ 2024-01-01T17:00:00 │ 0.9057 │\n│ 2024-01-01T18:00:00 │ 0.99   │\n│ 2024-01-01T19:00:00 │ 1.0    │\n│ 2024-01-01T20:00:00 │ 0.9912 │\n│ 2024-01-01T21:00:00 │ 0.9608 │\n│ 2024-01-01T22:00:00 │ 0.9215 │\n│ 2024-01-01T23:00:00 │ 0.837  │"

# line
@test repr(sys5.branches[1]) == "Line(name=\"1\")"
show(io, "text/plain", sys5.branches[1])
@test_skip String(take!(io)) ==
    "Line:\n   name: 1\n   available: true\n   connectionpoints: (from = Bus(name=\"nodeA\"), to = Bus(name=\"nodeB\"))\n   r: 0.00281\n   x: 0.0281\n   b: (from = 0.00356, to = 0.00356)\n   rate: 38.038742043967325\n   anglelimits: (min = -0.7853981633974483, max = 0.7853981633974483)"
