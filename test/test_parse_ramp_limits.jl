const RAMP_TEST_PM = PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5.m"))
const RAMP_TEST_GEN_KEY = 1
const RAMP_TEST_GEN_NAME = "gen-1"

# Strip every ramp-related key so that `calculate_ramp_limit` falls all the way
# through to the pmax / `nothing` branch.
function _delete_ramp_keys!(g::Dict)
    for k in ("ramp_agc", "ramp_10", "ramp_30")
        delete!(g, k)
    end
    return g
end

# Hand each end-to-end case a fresh deep copy of the parsed dict so the
# matpower file is read and parsed exactly once across the whole testset.
_fresh_case5_dict() = deepcopy(RAMP_TEST_PM.data)

@testset "calculate_ramp_limit helper branches" begin
    bc = 0.4

    @testset "ramp_agc takes precedence and scales by base_conversion" begin
        d = Dict{String, Any}(
            "ramp_agc" => 0.5,
            "ramp_10" => 9.9,
            "ramp_30" => 9.9,
            "pmax" => 4.0,
        )
        r = PowerSystems.calculate_ramp_limit(d, "gen", bc)
        @test r.up ≈ 0.5 * bc
        @test r.down ≈ 0.5 * bc
    end

    @testset "ramp_10 used when ramp_agc absent" begin
        d = Dict{String, Any}("ramp_10" => 1.0, "ramp_30" => 9.9, "pmax" => 4.0)
        r = PowerSystems.calculate_ramp_limit(d, "gen", bc)
        @test r.up ≈ 1.0 * bc
        @test r.down ≈ 1.0 * bc
    end

    @testset "ramp_30 used when ramp_agc and ramp_10 absent" begin
        d = Dict{String, Any}("ramp_30" => 2.0, "pmax" => 4.0)
        r = PowerSystems.calculate_ramp_limit(d, "gen", bc)
        @test r.up ≈ 2.0 * bc
        @test r.down ≈ 2.0 * bc
    end

    @testset "pmax fallback when no ramp keys; abs() handles negative pmax" begin
        for pmax in (4.0, -4.0)
            d = Dict{String, Any}("pmax" => pmax)
            r = PowerSystems.calculate_ramp_limit(d, "gen", bc)
            @test r.up ≈ abs(pmax) * bc
            @test r.down ≈ abs(pmax) * bc
        end
    end

    @testset "returns nothing when no ramp keys and pmax == 0" begin
        d = Dict{String, Any}("pmax" => 0.0)
        @test PowerSystems.calculate_ramp_limit(d, "gen", bc) === nothing
    end
end

@testset "calculate_ramp_limit: parser forwards base_conversion at each call site" begin
    @testset "make_thermal_gen: pmax fallback at MBASE = 250 (symptom from #1706)" begin
        data = _fresh_case5_dict()
        g = data["gen"][RAMP_TEST_GEN_KEY]
        g["mbase"] = 250.0
        g["pmax"] = 4.0
        _delete_ramp_keys!(g)

        sys = System(PowerSystems.PowerModelsData(data))
        gen = get_component(ThermalStandard, sys, RAMP_TEST_GEN_NAME)
        @test gen !== nothing
        rl = get_ramp_limits(gen)
        @test rl !== nothing
        # Pre-fix ratio was MBASE / 100 = 2.5; after the fix it must be 1.0.
        @test rl.up ≈ get_max_active_power(gen)
        @test rl.down ≈ get_max_active_power(gen)
    end

    @testset "make_hydro_dispatch: pmax fallback at MBASE = 250 (HYDRO/ROR routing)" begin
        # The call site in `make_hydro_reservoir` uses identical scaffolding
        # around the same `calculate_ramp_limit` invocation.
        data = _fresh_case5_dict()
        g = data["gen"][RAMP_TEST_GEN_KEY]
        g["mbase"] = 250.0
        g["pmax"] = 4.0
        g["fuel"] = "HYDRO"
        g["type"] = "ROR"
        _delete_ramp_keys!(g)

        sys = System(PowerSystems.PowerModelsData(data))
        gen = get_component(HydroDispatch, sys, RAMP_TEST_GEN_NAME)
        @test gen !== nothing
        rl = get_ramp_limits(gen)
        @test rl !== nothing
        @test rl.up ≈ get_max_active_power(gen)
        @test rl.down ≈ get_max_active_power(gen)
    end
end
