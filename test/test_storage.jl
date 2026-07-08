# Tests for the EnergyReservoirStorage fields added for interoperability (issue
# #1683): `self_discharge` (dimensionless pu/hr standing loss) and `ramp_limits`
# (which mimics the ThermalStandard MVA-based unit system).

# Minimal System + EnergyReservoirStorage at the requested device base so the
# ramp_limits unit conversions don't depend on PSB-built fixtures (mirrors
# `_sys_with_thermal` in common.jl).
function _sys_with_storage(;
    system_base = 100.0,
    device_base = 250.0,
    ramp_limits = nothing,
)
    sys = System(system_base)
    bus = ACBus(;
        number = 1, name = "b1", available = true,
        bustype = ACBusTypes.REF, angle = 0.0, magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1), base_voltage = 138.0,
    )
    add_component!(sys, bus)
    storage = EnergyReservoirStorage(;
        name = "storage1", available = true, bus = bus,
        prime_mover_type = PrimeMovers.BA,
        storage_technology_type = StorageTech.OTHER_CHEM,
        storage_capacity = 1.0,
        storage_level_limits = (min = 0.0, max = 1.0),
        initial_storage_capacity_level = 0.5,
        rating = 1.0, active_power = 0.0,
        input_active_power_limits = (min = 0.0, max = 1.0),
        output_active_power_limits = (min = 0.0, max = 1.0),
        efficiency = (in = 0.9, out = 0.9),
        reactive_power = 0.0, reactive_power_limits = (min = -1.0, max = 1.0),
        base_power = device_base,
        ramp_limits = ramp_limits,
    )
    add_component!(sys, storage)
    return sys, storage
end

@testset "EnergyReservoirStorage self_discharge / ramp_limits defaults" begin
    s = EnergyReservoirStorage(nothing)
    @test get_self_discharge(s) == 0.0
    sys, storage = _sys_with_storage()
    @test isnothing(get_ramp_limits(storage, NU))
    @test isnothing(get_ramp_limits(storage, SU))
    @test get_self_discharge(storage) == 0.0
end

@testset "EnergyReservoirStorage self_discharge getter/setter" begin
    s = EnergyReservoirStorage(nothing)
    @test get_self_discharge(s) == 0.0
    set_self_discharge!(s, 0.02)
    @test get_self_discharge(s) == 0.02
end

@testset "EnergyReservoirStorage ramp_limits mimics ThermalStandard unit system" begin
    device_base = 250.0
    system_base = 100.0
    sys, storage =
        _sys_with_storage(; system_base, device_base, ramp_limits = (up = 0.5, down = 0.4))

    # Construction stores the raw value at the device base (DU).
    ramp_du = get_ramp_limits(storage, DU)
    @test ramp_du.up ≈ 0.5
    @test ramp_du.down ≈ 0.4

    # System base: DU * device_base / system_base.
    ramp_su = get_ramp_limits(storage, SU)
    @test ramp_su.up ≈ 0.5 * device_base / system_base
    @test ramp_su.down ≈ 0.4 * device_base / system_base

    # Natural units: DU * device_base.
    ramp_nu = get_ramp_limits(storage, NU)
    @test ramp_nu.up ≈ 0.5 * device_base
    @test ramp_nu.down ≈ 0.4 * device_base

    # Nothing passthrough for the bare and `_unitful` companion, mirroring the
    # ThermalStandard contract in test_base_power.jl.
    set_ramp_limits!(storage, nothing)
    @test isnothing(get_ramp_limits(storage, NU))
    @test isnothing(get_ramp_limits_unitful(storage, NU))
end

@testset "EnergyReservoirStorage negative ramp_limits fails validation" begin
    sys = System(100.0; runchecks = false)
    bad = EnergyReservoirStorage(;
        name = "bad_storage", available = true, bus = ACBus(nothing),
        prime_mover_type = PrimeMovers.BA,
        storage_technology_type = StorageTech.OTHER_CHEM,
        storage_capacity = 1.0,
        storage_level_limits = (min = 0.0, max = 1.0),
        initial_storage_capacity_level = 0.5,
        rating = 1.0, active_power = 0.0,
        input_active_power_limits = (min = 0.0, max = 1.0),
        output_active_power_limits = (min = 0.0, max = 1.0),
        efficiency = (in = 0.9, out = 0.9),
        reactive_power = 0.0, reactive_power_limits = (min = -1.0, max = 1.0),
        base_power = 100.0,
        ramp_limits = (up = -10.0, down = -3.0),
    )
    @test_logs (:error, r"Invalid range") match_mode = :any @test_throws IS.InvalidValue PowerSystems.check_component(
        sys,
        bad,
    )
end
