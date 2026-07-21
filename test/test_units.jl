# Tests of the power-domain unit machinery: categories, convert_units across
# per-unit/natural-unit boundaries, serialization, and custom Unitful units.
# The RelativeQuantity arithmetic/comparison/display tests live in IS
# (test/test_relative_units.jl) since those types are domain-agnostic.

import Unitful
using Unitful: @u_str

# Mock components so we can exercise convert_units without building a full System.
struct MockGen
    active_power::Float64
    base_power::Float64
end

struct MockLine
    r::Float64
    x::Float64
end

PSY._get_device_base_power(g::MockGen) = g.base_power
PSY._get_system_base_power(::MockGen) = 100.0
PSY.get_base_voltage(::MockGen) = 230.0

PSY._get_device_base_power(::MockLine) = 100.0
PSY._get_system_base_power(::MockLine) = 100.0
PSY.get_base_voltage(::MockLine) = 230.0

@testset "Unit categories" begin
    @test natural_unit(POWER) == u"MW"
    @test natural_unit(IMPEDANCE) == u"Ω"
    @test natural_unit(ADMITTANCE) == u"S"
    @test natural_unit(VOLTAGE) == u"kV"
    @test natural_unit(CURRENT) == u"kA"
end

@testset "base_value and system_base_value" begin
    gen = MockGen(0.6, 50.0)  # 50 MVA device, 100 MVA system

    @test base_value(gen, POWER) == 50.0
    @test system_base_value(gen, POWER) == 100.0

    # Impedance: V² / S
    @test base_value(gen, IMPEDANCE) ≈ 230.0^2 / 50.0
    @test system_base_value(gen, IMPEDANCE) ≈ 230.0^2 / 100.0

    # Admittance: S / V²
    @test base_value(gen, ADMITTANCE) ≈ 50.0 / 230.0^2
    @test system_base_value(gen, ADMITTANCE) ≈ 100.0 / 230.0^2

    @test base_value(gen, VOLTAGE) == 230.0
    @test system_base_value(gen, VOLTAGE) == 230.0
end

@testset "convert_units: DU → other" begin
    gen = MockGen(0.6, 50.0)

    result = convert_units(gen, 0.6, POWER, DU, MW)
    @test result isa Unitful.Quantity
    @test Unitful.ustrip(result) ≈ 30.0

    result = convert_units(gen, 0.6, POWER, DU, SU)
    @test result isa RelativeQuantity{Float64, SystemBaseUnit}
    @test ustrip(result) ≈ 0.3

    result = convert_units(gen, 0.6, POWER, DU, DU)
    @test ustrip(result) ≈ 0.6

    result = convert_units(gen, 0.6, POWER, DU, Float64)
    @test result isa Float64
    @test result ≈ 0.3
end

@testset "convert_units: SU → other" begin
    gen = MockGen(0.6, 50.0)

    result = convert_units(gen, 0.3, POWER, SU, MW)
    @test Unitful.ustrip(result) ≈ 30.0

    result = convert_units(gen, 0.3, POWER, SU, DU)
    @test ustrip(result) ≈ 0.6

    result = convert_units(gen, 0.3, POWER, SU, SU)
    @test ustrip(result) ≈ 0.3
end

@testset "convert_units: natural → per-unit" begin
    gen = MockGen(0.6, 50.0)

    result = convert_units(gen, 30.0MW, POWER, MW, DU)
    @test ustrip(result) ≈ 0.6

    result = convert_units(gen, 30.0MW, POWER, MW, SU)
    @test ustrip(result) ≈ 0.3
end

@testset "convert_units: impedance" begin
    line = MockLine(0.01, 0.1)
    z_base = 230.0^2 / 100.0

    result = convert_units(line, 0.01, IMPEDANCE, DU, OHMS)
    @test Unitful.ustrip(result) ≈ 0.01 * z_base

    # device base == system base, so DU → Float64 ratio = 1.0
    result = convert_units(line, 0.01, IMPEDANCE, DU, Float64)
    @test result ≈ 0.01
end

@testset "convert_units: nothing passthrough" begin
    gen = MockGen(0.6, 50.0)
    @test convert_units(gen, nothing, POWER, DU, MW) === nothing
end

@testset "convert_units: round-trip consistency" begin
    gen = MockGen(0.6, 50.0)
    original = 0.6

    mw = convert_units(gen, original, POWER, DU, MW)
    back = convert_units(gen, mw, POWER, MW, DU)
    @test ustrip(back) ≈ original

    su = convert_units(gen, original, POWER, DU, SU)
    back = convert_units(gen, ustrip(su), POWER, SU, DU)
    @test ustrip(back) ≈ original
end

@testset "convert_units: ComplexF64 support" begin
    line = MockLine(0.01, 0.1)
    z = 0.01 + 0.1im

    result = convert_units(line, z, IMPEDANCE, DU, Float64)
    @test result isa ComplexF64
    @test result ≈ z  # ratio is 1.0 since device == system base
end

@testset "convert_units: NU (natural units)" begin
    gen = MockGen(0.6, 50.0)

    result = convert_units(gen, 0.6, POWER, DU, NU)
    @test result isa Unitful.Quantity
    @test Unitful.ustrip(result) ≈ 30.0

    result = convert_units(gen, 0.01, IMPEDANCE, DU, NU)
    @test Unitful.dimension(Unitful.unit(result)) == Unitful.dimension(u"Ω")

    result = convert_units(gen, 30.0MW, POWER, NU, DU)
    @test ustrip(result) ≈ 0.6
end

@testset "Serialization: RelativeQuantity" begin
    q = 0.6DU
    d = PSY.serialize_quantity(q)
    @test d["value"] == 0.6
    @test d["unit"] == "DU"
    @test PSY.deserialize_quantity(d) == q

    q = 0.3SU
    d = PSY.serialize_quantity(q)
    @test d["value"] == 0.3
    @test d["unit"] == "SU"
    @test PSY.deserialize_quantity(d) == q

    q = (0.01 + 0.1im) * SU
    d = PSY.serialize_quantity(q)
    @test d["value"]["re"] == 0.01
    @test d["value"]["im"] == 0.1
    @test d["unit"] == "SU"
    @test PSY.deserialize_quantity(d) == q
end

@testset "Serialization: Unitful Quantity" begin
    q = 30.0MW
    d = PSY.serialize_quantity(q)
    @test d["value"] == 30.0
    @test d["unit"] == "MW"
    @test PSY.deserialize_quantity(d) ≈ q

    q = 529.0OHMS
    d = PSY.serialize_quantity(q)
    @test d["value"] == 529.0
    @test d["unit"] == "Ω"
    @test PSY.deserialize_quantity(d) ≈ q
end

@testset "Serialization: JSON string round-trip" begin
    q = 0.3SU
    json = JSON.json(PSY.serialize_quantity(q))
    @test PSY.deserialize_quantity(json) == q

    q = 30.0MW
    json = JSON.json(PSY.serialize_quantity(q))
    @test PSY.deserialize_quantity(json) ≈ q
end

@testset "_du_to_su_ratio agrees with base_value ratio for every category" begin
    gen = MockGen(0.6, 50.0)  # 50 MVA device base, 100 MVA system base, 230 kV
    for cat in (POWER, IMPEDANCE, ADMITTANCE, VOLTAGE, CURRENT)
        @test PSY._du_to_su_ratio(gen, cat) ≈
              base_value(gen, cat) / system_base_value(gen, cat)
        # DU → Float64 must agree with the value of DU → SU
        @test convert_units(gen, 0.6, cat, DU, Float64) ≈
              ustrip(convert_units(gen, 0.6, cat, DU, SU))
    end
end

@testset "Ω/S getters error when base voltage is missing" begin
    line = Line(nothing)  # demo line: buses carry base_voltage = nothing
    @test_throws ErrorException get_x(line, OHMS)
    @test_throws ErrorException get_b(line, SIEMENS)
end

@testset "Custom Unitful units" begin
    @test 1.0Mvar == 1.0u"MW"  # same dimension
    @test 1.0MVA == 1.0u"MW"
    @test sprint(show, 1.0Mvar) == "1.0 Mvar"
    @test sprint(show, 1.0MVA) == "1.0 MVA"
end

@testset "base_value lifecycle" begin
    # sys_a: 100 MVA base; gen stored at device base (250 MVA default from _sys_with_thermal)
    sys_a, gen = _sys_with_thermal()
    p_a = get_active_power(gen, SU)

    remove_component!(sys_a, gen)
    @test_throws ErrorException get_active_power(gen, SU)

    # Transfer to sys_b (50 MVA base). Same stored DU value ⇒ SU value doubles.
    sys_b = System(50.0)
    bus_b = ACBus(;
        number = 1, name = "b1", available = true,
        bustype = ACBusTypes.REF, angle = 0.0, magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1), base_voltage = 138.0,
    )
    add_component!(sys_b, bus_b)
    set_bus!(gen, bus_b)
    add_component!(sys_b, gen)
    @test get_active_power(gen, SU) ≈ 2.0 * p_a
end

@testset "deepcopy preserves each component's base value" begin
    sys, gen = _sys_with_thermal()

    sys2 = deepcopy(sys)
    gen2 = get_component(ThermalStandard, sys2, get_name(gen))
    @test IS.get_base_value(gen2) == sys2.base_power
    @test IS.get_base_value(gen2) == IS.get_base_value(gen)
end

@testset "deserialized components carry the system's base value" begin
    sys, gen = _sys_with_thermal()
    path = joinpath(mktempdir(), "sys.json")
    to_json(sys, path)
    sys2 = System(path)
    gen2 = get_component(ThermalStandard, sys2, get_name(gen))
    @test IS.get_base_value(gen2) == sys2.base_power
    @test get_active_power(gen2, SU) ≈ get_active_power(gen, SU)
end

@testset "HybridSystem attach/detach propagates base value to subcomponents" begin
    sys = System(100.0)
    bus = ACBus(;
        number = 1, name = "b1", available = true,
        bustype = ACBusTypes.REF, angle = 0.0, magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1), base_voltage = 138.0,
    )
    add_component!(sys, bus)
    h_sys = HybridSystem(;
        name = "h1", available = true, status = true, bus = bus,
        active_power = 1.0, reactive_power = 1.0,
        thermal_unit = ThermalStandard(nothing),
        electric_load = PowerLoad(nothing),
        storage = EnergyReservoirStorage(nothing),
        renewable_unit = RenewableDispatch(nothing),
        base_power = 100.0,
        operation_cost = MarketBidCost(nothing),
    )
    subcomponents = collect(PSY._get_components(h_sys))
    @test length(subcomponents) == 4
    add_component!(sys, h_sys)
    @test all(c -> IS.get_base_value(c) !== nothing, subcomponents)

    remove_component!(sys, h_sys)
    @test all(c -> IS.get_base_value(c) === nothing, subcomponents)
end

@testset "convert_units rejects marker/value mismatches" begin
    sys, gen = _sys_with_thermal()

    @test_throws ArgumentError convert_units(gen, 30.0 * MW, POWER, SU, DU)
    @test_throws ArgumentError convert_units(gen, 30.0 * MW, POWER, DU, SU)
    @test_throws ArgumentError convert_units(gen, 0.5 * DU, POWER, SU, NU)
    @test_throws ArgumentError convert_units(gen, 0.5, POWER, MW, SU)
end

# ---- Task 5 helpers ----

# Build a minimal System + Line (100 MVA base, 138 kV buses) for impedance/
# admittance inference tests. rating_b is set to a non-nothing value so
# get_rating_b returns Float64 (the small-union contract under test).
function _sys_with_line()
    sys = System(100.0)
    bus_from = ACBus(;
        number = 1, name = "f1", available = true,
        bustype = ACBusTypes.REF, angle = 0.0, magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1), base_voltage = 138.0,
    )
    bus_to = ACBus(;
        number = 2, name = "t1", available = true,
        bustype = ACBusTypes.PQ, angle = 0.0, magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1), base_voltage = 138.0,
    )
    add_component!(sys, bus_from)
    add_component!(sys, bus_to)
    line = Line(;
        name = "l1", available = true,
        active_power_flow = 0.0, reactive_power_flow = 0.0,
        arc = Arc(; from = bus_from, to = bus_to),
        r = 0.01, x = 0.05,
        b = (from = 0.01, to = 0.01),
        rating = 1.0,
        angle_limits = (min = -0.7, max = 0.7),
        rating_b = 0.9,
    )
    add_component!(sys, line)
    return sys, line
end

# Local copy of the Transformer3W fixture from test_base_power.jl, reproduced
# here so test_units.jl remains self-contained when run in isolation
# (test_base_power.jl is included first alphabetically in the full suite, but
# the name-filter run — `julia --project=test test/runtests.jl test_units` —
# only includes test_units.jl itself).
function _local_make_test_3w_xfmr(; system_base = 100.0)
    xfmr = Transformer3W(nothing)
    IS.set_base_value!(xfmr, system_base)
    set_base_power_12!(xfmr, 15.0)
    set_base_power_23!(xfmr, 20.0)
    set_base_power_13!(xfmr, 25.0)
    set_base_voltage_primary!(xfmr, 230.0)
    set_base_voltage_secondary!(xfmr, 138.0)
    set_base_voltage_tertiary!(xfmr, 69.0)
    setproperty!(xfmr, :r_primary, 0.01)
    setproperty!(xfmr, :r_secondary, 0.02)
    return xfmr
end

@testset "getter chain is inferable per unit-system marker" begin
    sys, gen = _sys_with_thermal()
    sys_l, line = _sys_with_line()
    xfmr3w = _local_make_test_3w_xfmr()

    # power category (Val{:mva})
    @inferred get_active_power(gen, SU)
    @inferred get_active_power(gen, DU)
    @inferred get_active_power(gen, NU)
    @inferred get_active_power_unitful(gen, SU)
    @test typeof(get_active_power_unitful(gen, SU)) ==
          IS.RelativeQuantity{Float64, IS.RelativeUnits.SystemBaseUnit}

    # impedance / admittance categories (Val{:ohm} / Val{:siemens})
    @inferred get_r(line, SU)
    @inferred get_x(line, DU)
    @inferred get_b(line, SU)

    # compound NamedTuple fields
    @inferred get_active_power_limits(gen, SU)

    # Union{Nothing, Float64} descriptor field: small-union return is the contract
    # rating_b is set to 0.9 in _sys_with_line so the non-nothing branch executes
    @inferred Union{Nothing, Float64} get_rating_b(line, SU)

    # three-winding per-winding bases
    @inferred get_r_primary(xfmr3w, SU)
    @inferred get_r_secondary(xfmr3w, DU)

    # setter chain: returns the stored DU Float64
    @inferred set_active_power!(gen, 0.4 * SU)
end

# NOTE: three testsets were dropped here as part of this merge, because each exercised a
# mechanism the other branch removed. Neither is a regression in coverage of live code:
#
#  - "conversions ignore the display unit_system" and "_set_units_base! errors on detached
#    component" (from feat/rust-time-series-store) drove `set_units_base_system!` /
#    `with_units_base`, i.e. the stateful units system that psy6 retired in "remove last
#    pieces of stateful units system". Unit selection is now an explicit per-call argument
#    (`get_active_power(gen, SU)`), which the testsets above already cover.
#
#  - "time series multiplier units default to SU" (from psy6) drove
#    `scaling_factor_multiplier` and the `units` kwarg on `get_time_series_values`, both of
#    which this branch removed. Time series now store actual per-device quantities, so
#    there is no multiplier to resolve.
