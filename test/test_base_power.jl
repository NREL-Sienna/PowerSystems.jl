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

    # 1-arg form is gone — public getter requires explicit units.
    @test_throws MethodError get_base_power(gen)

    # Bare-number getter returns Float64 in the requested unit; companion
    # `_unitful` keeps the Unitful/RelativeQuantity wrapper.
    @test get_base_power(gen, NU) isa Float64
    @test get_base_power(gen, NU) ≈ device_base
    bp_nu = get_base_power_unitful(gen, NU)
    @test bp_nu isa Unitful.Quantity
    @test Unitful.ustrip(bp_nu) ≈ device_base
    # Not double-wrapped: no `device_base * MVA * MVA`.
    @test Unitful.unit(bp_nu) == Unitful.unit(1.0 * MVA)

    @test get_base_power(gen, MW) isa Float64
    @test get_base_power(gen, MW) ≈ device_base
    bp_mw = get_base_power_unitful(gen, MW)
    @test bp_mw isa Unitful.Quantity
    @test Unitful.ustrip(MW, bp_mw) ≈ device_base

    @test get_base_power(gen, SU) isa Float64
    @test get_base_power(gen, SU) ≈ device_base / system_base
    bp_su = get_base_power_unitful(gen, SU)
    @test bp_su isa RelativeQuantity
    @test ustrip(bp_su) ≈ device_base / system_base

    # DU is self-referential: base_power in device-base pu is always 1.
    @test get_base_power(gen, DU) == 1.0
    bp_du = get_base_power_unitful(gen, DU)
    @test bp_du isa RelativeQuantity
    @test ustrip(bp_du) == 1.0

    # Components with no base_power field fall back to system base, so DU == SU == 1.
    bus = first(get_components(ACBus, sys))
    @test get_base_power(bus, SU) ≈ 1.0
    @test get_base_power(bus, NU) ≈ system_base
    @test get_base_power_unitful(bus, NU) isa Unitful.Quantity

    # System-level getter mirrors the component version.
    @test_throws MethodError get_base_power(sys)
    @test get_base_power(sys, NU) ≈ system_base
    @test get_base_power_unitful(sys, NU) isa Unitful.Quantity
    @test get_base_power(sys, SU) == 1.0
    @test get_base_power_unitful(sys, SU) isa RelativeQuantity
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
