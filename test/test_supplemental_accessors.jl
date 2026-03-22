@testset "Test supplemental voltage accessors" begin
    @testset "get_base_voltage for Line and MonitoredLine" begin
        sys = PSB.build_system(PSB.PSITestSystems, "c_sys5")
        lines = collect(get_components(Line, sys))
        @test !isempty(lines)
        for line in lines
            from_bus = get_from(get_arc(line))
            expected = get_base_voltage(from_bus)
            @test get_base_voltage(line) == expected
            @test get_base_voltage(line) isa Union{Nothing, Float64}
        end
    end

    @testset "get_high_voltage and get_low_voltage for TapTransformer" begin
        sys = PSB.build_system(PSB.PSITestSystems, "c_sys14")
        taps = collect(get_components(TapTransformer, sys))
        @test !isempty(taps)
        for t in taps
            v_primary = get_base_voltage_primary(t)
            v_secondary = get_base_voltage_secondary(t)
            @test get_high_voltage(t) == max(v_primary, v_secondary)
            @test get_low_voltage(t) == min(v_primary, v_secondary)
            @test get_high_voltage(t) >= get_low_voltage(t)
            @test get_high_voltage(t) isa Float64
            @test get_low_voltage(t) isa Float64
        end
    end

    @testset "get_high_voltage and get_low_voltage for Transformer2W" begin
        sys = PSB.build_system(PSB.PSITestSystems, "c_sys14")
        t2ws = collect(get_components(Transformer2W, sys))
        @test !isempty(t2ws)
        for t in t2ws
            v_primary = get_base_voltage_primary(t)
            v_secondary = get_base_voltage_secondary(t)
            @test get_high_voltage(t) == max(v_primary, v_secondary)
            @test get_low_voltage(t) == min(v_primary, v_secondary)
            @test get_high_voltage(t) >= get_low_voltage(t)
        end
    end
end
