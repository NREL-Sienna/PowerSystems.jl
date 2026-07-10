@testset "Test zero base power correction" begin
    # The zero-base-power correction (and its warning) now happens inside the
    # parser packages; the invariant PSY cares about is that no component
    # arrives with a zero device base.
    sys = build_system(PSISystems, "RTS_GMLC_DA_sys"; force_build = true)
    for comp in get_components(PSY.SynchronousCondenser, sys)
        @test abs(get_base_power(comp, NU)) > eps()
    end
end

function thermal_with_base_power(bus::PSY.Bus, name::String, base_power::Float64)
    return ThermalStandard(;
        name = name,
        available = true,
        status = true,
        bus = bus,
        active_power = 1.0,
        reactive_power = 0.0,
        rating = 2.0,
        active_power_limits = (min = 0, max = 2),
        reactive_power_limits = (min = -2, max = 2),
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(nothing),
        base_power = base_power,
        time_limits = nothing,
        prime_mover_type = PrimeMovers.OT,
        fuel = ThermalFuels.OTHER,
        services = Device[],
        dynamic_injector = nothing,
        ext = Dict{String, Any}(),
    )
end

# Used to build via `PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")` and pull
# `322_CT_6`, but PSB isn't compatible with the new units API yet.
@testset "Test unit-aware get_base_power" begin
    sys, gen = _sys_with_thermal(; system_base = 100.0, device_base = 250.0)
    device_base = PSY._get_base_power(gen)
    system_base = PSY._get_base_power(sys)
    @test device_base != system_base

    # base_power is always natural units: the 1-arg form returns the stored MVA.
    @test get_base_power(gen) isa Float64
    @test get_base_power(gen) ≈ device_base

    # Bare-number getter returns Float64 in the requested unit; companion
    # `_unitful` keeps the Unitful wrapper.
    @test get_base_power(gen, NU) isa Float64
    @test get_base_power(gen, NU) ≈ device_base
    bp_nu = get_base_power_unitful(gen, NU)
    @test bp_nu isa Unitful.Quantity
    @test Unitful.ustrip(bp_nu) ≈ device_base
    # Not double-wrapped: no `device_base * MVA * MVA`.
    @test Unitful.unit(bp_nu) == Unitful.unit(1.0 * MVA)
    # 1-arg unitful form mirrors `(c, NU)`.
    @test get_base_power_unitful(gen) ≈ bp_nu

    @test get_base_power(gen, MW) isa Float64
    @test get_base_power(gen, MW) ≈ device_base
    bp_mw = get_base_power_unitful(gen, MW)
    @test bp_mw isa Unitful.Quantity
    @test Unitful.ustrip(MW, bp_mw) ≈ device_base

    @test get_base_power(gen, MVA) ≈ device_base

    # Per-unit bases are circular for base_power and are rejected.
    @test_throws ArgumentError get_base_power(gen, SU)
    @test_throws ArgumentError get_base_power_unitful(gen, SU)
    @test_throws ArgumentError get_base_power(gen, DU)
    @test_throws ArgumentError get_base_power_unitful(gen, DU)
    # Non-power units fail dimensionally.
    @test_throws Unitful.DimensionError get_base_power(gen, kV)

    # Components with no base_power field fall back to the system base.
    bus = first(get_components(ACBus, sys))
    @test get_base_power(bus) ≈ system_base
    @test get_base_power(bus, NU) ≈ system_base
    @test get_base_power_unitful(bus, NU) isa Unitful.Quantity
    @test_throws ArgumentError get_base_power(bus, SU)

    # System-level getter mirrors the component version.
    @test get_base_power(sys) ≈ system_base
    @test get_base_power(sys, NU) ≈ system_base
    @test get_base_power_unitful(sys, NU) isa Unitful.Quantity
    @test_throws ArgumentError get_base_power(sys, SU)
    @test_throws ArgumentError get_base_power_unitful(sys, SU)
end

# Used to build via `PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")` and pull
# `322_CT_6`, but PSB isn't compatible with the new units API yet.
@testset "Generated getters: bare vs _unitful, NU path" begin
    sys, gen = _sys_with_thermal(; system_base = 100.0, device_base = 250.0)
    device_base = PSY._get_base_power(gen)
    system_base = PSY._get_base_power(sys)
    p_du = PSY.get_value(gen, Val(:active_power), Val(:mva), DU) |> ustrip

    # Plain Float64 across all unit args.
    @test get_active_power(gen, NU) isa Float64
    @test get_active_power(gen, NU) ≈ p_du * device_base
    @test get_active_power(gen, MW) isa Float64
    @test get_active_power(gen, MW) ≈ p_du * device_base
    @test get_active_power(gen, SU) isa Float64
    @test get_active_power(gen, SU) ≈ p_du * device_base / system_base
    @test get_active_power(gen, DU) isa Float64
    @test get_active_power(gen, DU) ≈ p_du

    # `_unitful` companions retain wrappers.
    p_nu_u = get_active_power_unitful(gen, NU)
    @test p_nu_u isa Unitful.Quantity
    @test Unitful.unit(p_nu_u) == Unitful.unit(1.0 * MW)
    @test Unitful.ustrip(MW, p_nu_u) ≈ p_du * device_base

    @test get_active_power_unitful(gen, MW) isa Unitful.Quantity
    @test get_active_power_unitful(gen, SU) isa RelativeQuantity
    @test get_active_power_unitful(gen, DU) isa RelativeQuantity

    # Compound NamedTuple field (MinMax): bare strips per-element, unitful keeps.
    lim = get_active_power_limits(gen, NU)
    @test lim.min isa Float64 && lim.max isa Float64
    lim_u = get_active_power_limits_unitful(gen, NU)
    @test lim_u.min isa Unitful.Quantity && lim_u.max isa Unitful.Quantity

    # Nothing-valued field: both forms pass nothing through.
    set_ramp_limits!(gen, nothing)
    @test get_ramp_limits(gen, NU) === nothing
    @test get_ramp_limits_unitful(gen, NU) === nothing
end

# Regression guard for the explicit-units performance contract (PR #1695):
# the internal per-unit conversions must compile away so that a literal unit
# argument yields a type-stable, allocation-free `Float64`, and `ustrip` of the
# `_unitful` companion must be a no-op equal to the bare getter.
@testset "Generated getters: type-stable and allocation-free" begin
    sys, gen = _sys_with_thermal(; system_base = 100.0, device_base = 250.0)

    # (1)+(4) Conversions compile away: each literal unit arg infers to Float64.
    for u in (SU, DU, NU, MW)
        @test (@inferred get_active_power(gen, u)) isa Float64
    end

    # (2) `ustrip` is a no-op equal to the bare getter for relative-unit wrappers.
    for u in (SU, DU, NU)
        wrapped = get_active_power_unitful(gen, u)
        @test (@inferred Unitful.ustrip(wrapped)) == get_active_power(gen, u)
    end

    # (3) A sum loop over the getter is allocation-free once compiled.
    gens = collect(get_components(ThermalStandard, sys))
    sum_strip(gs, u) = (s = 0.0; for g in gs
            s += Unitful.ustrip(get_active_power_unitful(g, u))
        end; s)
    for u in (SU, DU, NU)
        sum_strip(gens, u)  # warm up
        @test (@inferred sum_strip(gens, u)) isa Float64
        @test (@allocated sum_strip(gens, u)) == 0
    end
end

@testset "Unit-aware set_base_power!" begin
    sys, gen = _sys_with_thermal(; system_base = 100.0, device_base = 250.0)
    system_base = PSY._get_base_power(sys)

    # Bare Float64 — interpreted and stored as MVA.
    set_base_power!(gen, 75.0)
    @test PSY._get_base_power(gen) ≈ 75.0
    @test get_base_power(gen) ≈ 75.0

    # Unitful.Quantity in MW (MVA and MW share dimensions; storage is MVA).
    set_base_power!(gen, 80.0 * MW)
    @test PSY._get_base_power(gen) ≈ 80.0

    # Unitful.Quantity in MVA.
    set_base_power!(gen, 90.0 * MVA)
    @test PSY._get_base_power(gen) ≈ 90.0

    # Per-unit bases are circular for base_power and are rejected.
    @test_throws ArgumentError set_base_power!(gen, 0.5 * SU)
    @test_throws ArgumentError set_base_power!(gen, 1.25 * SU)
    @test_throws ArgumentError set_base_power!(gen, 1.0 * DU)
    @test_throws ArgumentError set_base_power!(gen, 0.5 * DU)

    # Dimensionally wrong inputs fail at conversion time.
    @test_throws Unitful.DimensionError set_base_power!(gen, 1.0 * kV)
end

@testset "Plain get/set for ThreeWindingTransformer base_power_{12,23,13}" begin
    # base_power_12/23/13 are plain MVA `Float64` fields with no unit-conversion
    # path: a three-winding transformer has three independent per-pair bases, so
    # there is no single `base_power` to route through the MW/SU/DU-aware
    # component-level wrapper (contrast with `get_base_power`/`set_base_power!`
    # on ordinary components, and with the per-winding `base_power` accessed via
    # `TransformerWinding`, which is likewise plain).
    xfmr = ThreeWindingTransformer(nothing)
    for (setter, getter) in (
        (set_base_power_12!, get_base_power_12),
        (set_base_power_23!, get_base_power_23),
        (set_base_power_13!, get_base_power_13),
    )
        setter(xfmr, 75.0)
        @test getter(xfmr) isa Float64
        @test getter(xfmr) ≈ 75.0
        setter(xfmr, 15.0)
        @test getter(xfmr) ≈ 15.0
    end
end

# Detached ThreeWindingTransformer with seeded base_value (system base 100), distinct
# per-winding/per-pair base powers (15/20/25 MVA), and base voltages (230/138/69 kV) —
# deliberately all different so a wrong-base selection is caught. Mirrors `_test_t3w`
# in test_transformer_windings.jl.
function _make_test_3w_xfmr(; system_base = 100.0)
    xfmr = ThreeWindingTransformer(nothing)
    IS.set_base_value!(xfmr, system_base)
    set_base_power_12!(xfmr, 15.0)
    set_base_power_23!(xfmr, 20.0)
    set_base_power_13!(xfmr, 25.0)
    set_base_power!(get_primary_winding(xfmr), 15.0)
    set_base_power!(get_secondary_winding(xfmr), 20.0)
    set_base_power!(get_tertiary_winding(xfmr), 25.0)
    set_base_voltage!(get_primary_winding(xfmr), 230.0)
    set_base_voltage!(get_secondary_winding(xfmr), 138.0)
    set_base_voltage!(get_tertiary_winding(xfmr), 69.0)
    return xfmr
end

@testset "Pairwise impedance getters on ThreeWindingTransformer use the pair base" begin
    # Regression guard for a silent units bug. The getters must honor the explicit
    # `units` argument and resolve the CORRECT pair base. Each pairwise impedance
    # has its own `base_power_XX` and is referenced to a specific winding's base
    # voltage (12/13 -> primary, 23 -> secondary; see the descriptor docstring).
    # Distinct per-pair bases catch a wrong-pair-base selection.
    system_base = 100.0
    xfmr = _make_test_3w_xfmr(; system_base = system_base)

    # (setter, getter, stored DU value, pair base power, reference base voltage)
    cases = (
        (set_r_12!, get_r_12, 0.01, 15.0, 230.0),
        (set_x_12!, get_x_12, 0.10, 15.0, 230.0),
        (set_r_23!, get_r_23, 0.02, 20.0, 138.0),
        (set_x_23!, get_x_23, 0.20, 20.0, 138.0),
        (set_r_13!, get_r_13, 0.03, 25.0, 230.0),
        (set_x_13!, get_x_13, 0.30, 25.0, 230.0),
    )
    for (setter, getter, dev_val, base_power, base_voltage) in cases
        setter(xfmr, dev_val * DU)  # seed device-base storage directly

        @test getter(xfmr, DU) ≈ dev_val
        # System base: Z_su = Z_du * (system_base / pair_base).
        @test getter(xfmr, SU) ≈ dev_val * (system_base / base_power)
        # The units argument must change the result (the bug made SU == DU).
        @test getter(xfmr, SU) != getter(xfmr, DU)
        # Natural units (Ω): Z_nu = Z_du * (V² / pair_base).
        @test getter(xfmr, NU) ≈ dev_val * (base_voltage^2 / base_power)
        # Cross-unit invariant: the physical Ω value is independent of which unit
        # system it is read through (this fails outright if `units` is ignored).
        @test getter(xfmr, NU) ≈ getter(xfmr, SU) * (base_voltage^2 / system_base)
    end

    # Magnetizing shunt (device base on base_power_12, referenced to the primary
    # winding's base voltage): Y_su = Y_du * (pair_base / system_base).
    set_magnetizing_shunt!(xfmr, 0.05 * DU)
    @test get_magnetizing_shunt(xfmr, DU) ≈ 0.05
    @test get_magnetizing_shunt(xfmr, SU) ≈ 0.05 * (15.0 / system_base)
    @test get_magnetizing_shunt(xfmr, SU) != get_magnetizing_shunt(xfmr, DU)
    @test get_magnetizing_shunt(xfmr, NU) ≈ 0.05 * (15.0 / 230.0^2)
end

@testset "ThreeWindingTransformer Unitful-target getters use the correct bases" begin
    system_base = 100.0
    xfmr = _make_test_3w_xfmr(; system_base = system_base)
    primary = get_primary_winding(xfmr)

    set_rating!(primary, 2.0 * DU)
    # MW must scale by the PRIMARY WINDING base (15), not the system base (100).
    @test get_rating(primary, MW) ≈ 2.0 * 15.0
    @test get_rating(primary, MW) ≈ get_rating(primary, NU)
    @test get_rating_unitful(primary, MW) isa Unitful.Quantity

    set_r_12!(xfmr, 0.01 * DU)
    # Ω target must agree with the NU path and use base_power_12 / primary voltage
    # (and must not crash looking for a single transformer-wide arc/base voltage).
    @test get_r_12(xfmr, OHMS) ≈ 0.01 * (230.0^2 / 15.0)
    @test get_r_12(xfmr, OHMS) ≈ get_r_12(xfmr, NU)

    set_magnetizing_shunt!(xfmr, 0.05 * DU)
    @test get_magnetizing_shunt(xfmr, SIEMENS) ≈ 0.05 * (15.0 / 230.0^2)
    @test get_magnetizing_shunt(xfmr, SIEMENS) ≈ get_magnetizing_shunt(xfmr, NU)
end

@testset "ThreeWindingTransformer/TransformerWinding setters round-trip against the correct base" begin
    system_base = 100.0
    xfmr = _make_test_3w_xfmr(; system_base = system_base)
    primary = get_primary_winding(xfmr)
    secondary = get_secondary_winding(xfmr)
    tertiary = get_tertiary_winding(xfmr)

    # Power: MW input divides by the WINDING base, not the system base.
    set_rating!(primary, 30.0 * MW)
    @test get_rating(primary, DU) ≈ 2.0    # 30 MW / 15 MVA winding base
    @test get_rating(primary, MW) ≈ 30.0
    # SU: 0.4 SU = 40 MW on the system base = 2.0 DU on the 20 MVA winding.
    set_rating!(secondary, 0.4 * SU)
    @test get_rating(secondary, DU) ≈ 2.0
    @test get_rating(secondary, SU) ≈ 0.4
    # DU input is identity.
    set_rating!(tertiary, 1.5 * DU)
    @test get_rating(tertiary, DU) ≈ 1.5

    # Impedance: Ω divides by the pair impedance base V²/S (pair 12: primary base
    # voltage, base_power_12 = 15).
    z_base_12 = 230.0^2 / 15.0
    set_r_12!(xfmr, 0.01 * z_base_12 * OHMS)
    @test get_r_12(xfmr, DU) ≈ 0.01
    @test get_r_12(xfmr, OHMS) ≈ 0.01 * z_base_12
    # SU impedance on pair 23 (base_power_23 = 20): Z_du = Z_su * (pair_base / system_base).
    set_x_23!(xfmr, 0.6 * SU)
    @test get_x_23(xfmr, DU) ≈ 0.6 * (20.0 / system_base)
    @test get_x_23(xfmr, SU) ≈ 0.6

    # Admittance (magnetizing shunt, device base on base_power_12): S divides by
    # the pair admittance base S/V².
    y_base_12 = 15.0 / 230.0^2
    set_magnetizing_shunt!(xfmr, 2.0 * y_base_12 * SIEMENS)
    @test get_magnetizing_shunt(xfmr, DU) ≈ 2.0
    @test get_magnetizing_shunt(xfmr, SIEMENS) ≈ 2.0 * y_base_12
    # SU admittance round-trip.
    set_magnetizing_shunt!(xfmr, 0.3 * SU)
    @test get_magnetizing_shunt(xfmr, DU) ≈ 0.3 * (system_base / 15.0)
    @test get_magnetizing_shunt(xfmr, SU) ≈ 0.3

    # Bare floats remain rejected.
    @test_throws ArgumentError set_rating!(primary, 1.0)
end

@testset "TwoWindingTransformer Ω/S set→get round-trip uses one base voltage" begin
    t2w = TwoWindingTransformer(nothing)  # winding base_power = 100.0
    winding = get_winding(t2w)
    set_base_voltage!(winding, 230.0)
    # Arc endpoint voltage deliberately different from the winding's base voltage:
    # both conversion directions must resolve the same voltage or the round-trip
    # drifts by (230/115)².
    set_base_voltage!(get_arc(t2w).from, 115.0)

    set_x!(t2w, 105.8 * OHMS)
    @test get_x(t2w, DU) ≈ 105.8 / (230.0^2 / 100.0)
    @test get_x(t2w, OHMS) ≈ 105.8

    y_nat = 3.0 * (100.0 / 230.0^2)
    set_magnetizing_shunt!(t2w, y_nat * SIEMENS)
    @test get_magnetizing_shunt(t2w, DU) ≈ 3.0
    @test get_magnetizing_shunt(t2w, SIEMENS) ≈ y_nat
end

@testset "Test adding component with zero base power" begin
    sys = build_system(PSISystems, "RTS_GMLC_DA_sys")
    bus = first(get_components(PSY.Bus, sys))
    gen = thermal_with_base_power(bus, "Test Gen with Zero Base Power", 0.0)
    @test_logs (:warn, "Invalid range") match_mode = :any add_component!(sys, gen)
    gen2 = thermal_with_base_power(bus, "Test Gen with Non-Zero Base Power", 100.0)
    @test_nowarn add_component!(sys, gen2)
end
