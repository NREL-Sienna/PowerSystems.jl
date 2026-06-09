# TODO: re-enable once PowerSystemCaseBuilder no longer relies on PSY parsers
# (PSB.build_system uses PSY.PowerSystemTableData internally for RTS_GMLC_DA_sys).
# @testset "Test zero base power correction" begin
#     sys = @test_logs(
#         (:warn, r".*changing device base power to match system base power.*"),
#         match_mode = :any,
#         build_system(PSISystems, "RTS_GMLC_DA_sys"; force_build = true)
#     )
#     for comp in get_components(PSY.SynchronousCondenser, sys)
#         @test abs(get_base_power(comp)) > eps()
#     end
# end

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

@testset "Unit-aware set_base_power_{12,23,13}! on ThreeWindingTransformer" begin
    system_base = 100.0
    xfmr = Transformer3W(nothing)
    # Stand in for system attachment: set units_info so SU dispatch can read the
    # system base without building a full three-bus star-topology system.
    IS.get_internal(xfmr).units_info =
        PSY.SystemUnitsSettings(system_base, IS.UnitSystem.SYSTEM_BASE)

    for (setter, getter, internal) in (
        (set_base_power_12!, get_base_power_12, PSY._get_base_power_12),
        (set_base_power_23!, get_base_power_23, PSY._get_base_power_23),
        (set_base_power_13!, get_base_power_13, PSY._get_base_power_13),
    )
        setter(xfmr, 75.0);
        @test internal(xfmr) ≈ 75.0
        setter(xfmr, 80.0 * MW);
        @test internal(xfmr) ≈ 80.0
        setter(xfmr, 90.0 * MVA);
        @test internal(xfmr) ≈ 90.0
        setter(xfmr, 0.5 * SU);
        @test internal(xfmr) ≈ 0.5 * system_base
        setter(xfmr, 1.25 * SU);
        @test getter(xfmr, SU) ≈ 1.25
        @test_throws ErrorException setter(xfmr, 1.0 * DU)
        @test_throws Unitful.DimensionError setter(xfmr, 1.0 * kV)
    end
end

@testset "Unit-aware get_base_power_{12,23,13} on ThreeWindingTransformer" begin
    system_base = 100.0
    device_base = 250.0
    xfmr = Transformer3W(nothing)
    IS.get_internal(xfmr).units_info =
        PSY.SystemUnitsSettings(system_base, IS.UnitSystem.SYSTEM_BASE)

    for (setter, getter, getter_unitful) in (
        (set_base_power_12!, get_base_power_12, get_base_power_12_unitful),
        (set_base_power_23!, get_base_power_23, get_base_power_23_unitful),
        (set_base_power_13!, get_base_power_13, get_base_power_13_unitful),
    )
        setter(xfmr, device_base)

        # Bare getter returns Float64 in the requested unit.
        @test getter(xfmr, NU) isa Float64
        @test getter(xfmr, NU) ≈ device_base
        @test getter(xfmr, MW) ≈ device_base
        @test getter(xfmr, MVA) ≈ device_base
        @test getter(xfmr, SU) isa Float64
        @test getter(xfmr, SU) ≈ device_base / system_base
        # DU is self-referential: per-winding base in its own device base is 1.
        @test getter(xfmr, DU) == 1.0

        # `_unitful` companions keep the wrapper.
        bp_nu = getter_unitful(xfmr, NU)
        @test bp_nu isa Unitful.Quantity
        @test Unitful.unit(bp_nu) == Unitful.unit(1.0 * MVA)
        @test Unitful.ustrip(bp_nu) ≈ device_base

        @test getter_unitful(xfmr, MW) isa Unitful.Quantity
        @test Unitful.ustrip(MW, getter_unitful(xfmr, MW)) ≈ device_base

        bp_su = getter_unitful(xfmr, SU)
        @test bp_su isa RelativeQuantity
        @test ustrip(bp_su) ≈ device_base / system_base

        bp_du = getter_unitful(xfmr, DU)
        @test bp_du isa RelativeQuantity
        @test ustrip(bp_du) == 1.0
    end
end

@testset "Unit-aware winding impedance/admittance getters on ThreeWindingTransformer" begin
    # Regression guard for a silent units bug. The winding getters must honor the
    # explicit `units` argument. Previously `get_r_primary(c, SU)` fell through to
    # the generic `Branch` conversion, which divides by the component-wide
    # `_get_base_power`; a 3W transformer has no single `base_power`, so that fell
    # back to the *system* base, collapsing the SU multiplier to 1.0. The getter
    # then returned device-base values for every unit system, and Ybus came out
    # scaled by system_base/winding_base. The bug is invisible unless the winding
    # base differs from the system base, so we set them deliberately apart — and
    # use distinct per-winding bases to also catch a wrong-winding base selection.
    system_base = 100.0
    xfmr = Transformer3W(nothing)
    IS.get_internal(xfmr).units_info =
        PSY.SystemUnitsSettings(system_base, IS.UnitSystem.SYSTEM_BASE)

    set_base_power_12!(xfmr, 15.0)
    set_base_power_23!(xfmr, 20.0)
    set_base_power_13!(xfmr, 25.0)
    set_base_voltage_primary!(xfmr, 230.0)
    set_base_voltage_secondary!(xfmr, 138.0)
    set_base_voltage_tertiary!(xfmr, 69.0)

    # (device-base field, getter, stored DU value, winding base power, base voltage)
    cases = (
        (:r_primary, get_r_primary, 0.01, 15.0, 230.0),
        (:x_primary, get_x_primary, 0.10, 15.0, 230.0),
        (:r_secondary, get_r_secondary, 0.02, 20.0, 138.0),
        (:x_secondary, get_x_secondary, 0.20, 20.0, 138.0),
        (:r_tertiary, get_r_tertiary, 0.03, 25.0, 69.0),
        (:x_tertiary, get_x_tertiary, 0.30, 25.0, 69.0),
    )
    for (field, getter, dev_val, base_power, base_voltage) in cases
        setproperty!(xfmr, field, dev_val)  # seed device-base storage directly

        @test getter(xfmr, DU) ≈ dev_val
        # System base: Z_su = Z_du * (system_base / winding_base).
        @test getter(xfmr, SU) ≈ dev_val * (system_base / base_power)
        # The units argument must change the result (the bug made SU == DU).
        @test getter(xfmr, SU) != getter(xfmr, DU)
        # Natural units (Ω): Z_nu = Z_du * (V² / winding_base).
        @test getter(xfmr, NU) ≈ dev_val * (base_voltage^2 / base_power)
        # Cross-unit invariant: the physical Ω value is independent of which unit
        # system it is read through (this fails outright if `units` is ignored).
        @test getter(xfmr, NU) ≈ getter(xfmr, SU) * (base_voltage^2 / system_base)
    end

    # Shunt susceptance (primary winding, Siemens): Y_su = Y_du * (winding_base / system_base).
    setproperty!(xfmr, :b, 0.05)
    @test get_b(xfmr, DU) ≈ 0.05
    @test get_b(xfmr, SU) ≈ 0.05 * (15.0 / system_base)
    @test get_b(xfmr, SU) != get_b(xfmr, DU)
    @test get_b(xfmr, NU) ≈ 0.05 * (15.0 / 230.0^2)
end

# TODO: re-enable once PowerSystemCaseBuilder no longer relies on PSY parsers
# (PSB.build_system uses PSY.PowerSystemTableData internally).
# @testset "Test adding component with zero base power" begin
#     sys = build_system(PSISystems, "RTS_GMLC_DA_sys")
#     bus = first(get_components(PSY.Bus, sys))
#     gen = thermal_with_base_power(bus, "Test Gen with Zero Base Power", 0.0)
#     @test_logs (:warn, "Invalid range") match_mode = :any add_component!(sys, gen)
#     gen2 = thermal_with_base_power(bus, "Test Gen with Non-Zero Base Power", 100.0)
#     @test_nowarn add_component!(sys, gen2)
#     # uncomment if we correct to non-zero base power.
#     #=
#     with_units_base(sys, "SYSTEM_BASE") do
#         gen_added = PSY.get_component(PSY.ThermalStandard, sys, "Test Gen with Zero Base Power")
#         PSY.set_reactive_power!(gen_added, 0.0)
#         @test !isnan(PSY.get_reactive_power(gen_added))
#     end
#     =#
# end
