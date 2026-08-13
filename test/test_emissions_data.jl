@testset "EmissionsData" begin
    # Helper to create the expected IncrementalCurve for a constant rate
    _const_rate(r) = IS.IncrementalCurve(LinearFunctionData(0.0, r), nothing, nothing)

    @testset "Construction smoke test" begin
        co2 = EmissionsData(;
            name = "co2_fuel",
            pollutant = PollutantType.CO2,
            emission_rate = 117.6,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test get_name(co2) == "co2_fuel"
        @test get_pollutant(co2) == PollutantType.CO2
        @test get_emission_rate(co2) == _const_rate(117.6)
        @test get_basis(co2) == EmissionBasis.FUEL_INPUT
        @test get_start_up_adder(co2) == 0.0
        @test get_mass_unit(co2) == MassUnit.KG
        @test get_energy_unit(co2) == EnergyUnit.MMBTU
        @test get_gwp(co2) == 1.0
        @test get_available(co2) == true

        nox = EmissionsData(;
            name = "nox_fuel",
            pollutant = PollutantType.NOX,
            emission_rate = 0.01,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            start_up_adder = 5.0,
        )
        @test get_emission_rate(nox) == _const_rate(0.01)
        @test get_start_up_adder(nox) == 5.0

        so2 = EmissionsData(;
            name = "so2_output",
            pollutant = PollutantType.SO2,
            emission_rate = 0.5,
            basis = EmissionBasis.POWER_OUTPUT,
            energy_unit = EnergyUnit.MWH,
            mass_unit = MassUnit.LB,
        )
        @test get_energy_unit(so2) == EnergyUnit.MWH
        @test get_mass_unit(so2) == MassUnit.LB
    end

    @testset "Construction with ValueCurve" begin
        # IncrementalCurve with linearly varying rate
        linear_rate = IS.IncrementalCurve(
            LinearFunctionData(0.001, 0.5), nothing, nothing,
        )
        co2_linear = EmissionsData(;
            name = "co2_linear",
            pollutant = PollutantType.CO2,
            emission_rate = linear_rate,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test get_emission_rate(co2_linear) == linear_rate

        # PiecewiseIncrementalCurve for step-wise rates
        pw_rate = IS.IncrementalCurve(
            PiecewiseStepData([0.0, 100.0, 200.0], [50.0, 60.0]),
            0.0,
            nothing,
        )
        co2_pw = EmissionsData(;
            name = "co2_piecewise",
            pollutant = PollutantType.CO2,
            emission_rate = pw_rate,
            basis = EmissionBasis.POWER_OUTPUT,
            energy_unit = EnergyUnit.MWH,
        )
        @test get_emission_rate(co2_pw) == pw_rate
    end

    @testset "Validation" begin
        # Negative emission_rate (scalar constructor)
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = -1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        # Negative start_up_adder
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            start_up_adder = -0.5,
        )

        # Zero gwp is allowed (e.g. a pollutant excluded from CO2-equivalent accounting)
        zero_gwp = EmissionsData(;
            name = "zero_gwp",
            pollutant = PollutantType.SO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            gwp = 0.0,
        )
        @test get_gwp(zero_gwp) == 0.0

        # Negative gwp is rejected
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            gwp = -1.0,
        )

        # MWH with FUEL_INPUT
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MWH,
        )

        # MMBTU with POWER_OUTPUT
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.POWER_OUTPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        # NaN and Inf values
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = NaN,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = Inf,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            start_up_adder = NaN,
        )
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            gwp = Inf,
        )

        # Setter validation for NaN/Inf
        e = EmissionsData(;
            name = "setter_test",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test_throws ArgumentError set_emission_rate!(e, NaN)
        @test_throws ArgumentError set_emission_rate!(e, Inf)
        @test_throws ArgumentError set_start_up_adder!(e, NaN)
        @test_throws ArgumentError set_gwp!(e, Inf)
    end

    @testset "ValueCurve emission_rate validation" begin
        # Negative constant rate (rate at zero input < 0)
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = IS.IncrementalCurve(
                LinearFunctionData(0.0, -5.0), nothing, nothing,
            ),
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        # Non-finite slope
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = IS.IncrementalCurve(
                LinearFunctionData(Inf, 1.0), nothing, nothing,
            ),
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        # Negative piecewise step rate
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.SO2,
            emission_rate = IS.IncrementalCurve(
                PiecewiseStepData([0.0, 100.0, 200.0], [50.0, -10.0]),
                0.0,
                nothing,
            ),
            basis = EmissionBasis.POWER_OUTPUT,
            energy_unit = EnergyUnit.MWH,
        )

        # A decreasing-but-non-negative-at-origin linear rate is allowed
        ok = EmissionsData(;
            name = "ok",
            pollutant = PollutantType.NOX,
            emission_rate = IS.IncrementalCurve(
                LinearFunctionData(-0.001, 5.0), nothing, nothing,
            ),
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test get_emission_rate(ok) ==
              IS.IncrementalCurve(LinearFunctionData(-0.001, 5.0), nothing, nothing)

        # Setter rejects an invalid ValueCurve too
        e = EmissionsData(;
            name = "setter_curve",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test_throws ArgumentError set_emission_rate!(
            e,
            IS.IncrementalCurve(LinearFunctionData(0.0, -1.0), nothing, nothing),
        )
    end

    @testset "Validated setters for enum fields" begin
        e = EmissionsData(;
            name = "setters",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        set_pollutant!(e, PollutantType.NOX)
        @test get_pollutant(e) == PollutantType.NOX

        set_mass_unit!(e, MassUnit.LB)
        @test get_mass_unit(e) == MassUnit.LB

        # Valid energy_unit change within FUEL_INPUT (MMBTU -> GJ)
        set_energy_unit!(e, EnergyUnit.GJ)
        @test get_energy_unit(e) == EnergyUnit.GJ

        # Individual setters enforce the basis/energy_unit invariant
        @test_throws ArgumentError set_basis!(e, EmissionBasis.POWER_OUTPUT)
        @test_throws ArgumentError set_energy_unit!(e, EnergyUnit.MWH)

        # Combined setter is the supported way to switch basis + energy_unit atomically
        set_basis_and_energy_unit!(e, EmissionBasis.POWER_OUTPUT, EnergyUnit.MWH)
        @test get_basis(e) == EmissionBasis.POWER_OUTPUT
        @test get_energy_unit(e) == EnergyUnit.MWH

        # Combined setter still rejects an inconsistent pair
        @test_throws ArgumentError set_basis_and_energy_unit!(
            e, EmissionBasis.FUEL_INPUT, EnergyUnit.MWH,
        )
    end

    @testset "Default mass_unit is KG" begin
        e = EmissionsData(;
            name = "test_defaults",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test get_mass_unit(e) == MassUnit.KG
    end

    @testset "Default start_up_adder" begin
        e = EmissionsData(;
            name = "test",
            pollutant = PollutantType.NOX,
            emission_rate = 0.5,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test get_start_up_adder(e) == 0.0
    end

    @testset "Attachment to a single component" begin
        sys = PSB.build_system(PSITestSystems, "c_sys5_uc"; add_forecasts = false)
        thermal = first(get_components(ThermalStandard, sys))

        co2 = EmissionsData(;
            name = "co2_thermal",
            pollutant = PollutantType.CO2,
            emission_rate = 117.6,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        add_supplemental_attribute!(sys, thermal, co2)
        attrs = collect(get_supplemental_attributes(EmissionsData, thermal))
        @test length(attrs) == 1
        @test get_emission_rate(attrs[1]) == _const_rate(117.6)

        remove_supplemental_attribute!(sys, thermal, co2)
        attrs = collect(get_supplemental_attributes(EmissionsData, thermal))
        @test length(attrs) == 0
    end

    @testset "Attachment to multiple components (shared reference)" begin
        sys = PSB.build_system(PSITestSystems, "c_sys5_uc"; add_forecasts = false)
        thermals = collect(get_components(ThermalStandard, sys))
        t1 = thermals[1]
        t2 = thermals[2]

        co2 = EmissionsData(;
            name = "shared_co2",
            pollutant = PollutantType.CO2,
            emission_rate = 100.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            start_up_adder = 2.0,
        )

        begin_supplemental_attributes_update(sys) do
            add_supplemental_attribute!(sys, t1, co2)
            add_supplemental_attribute!(sys, t2, co2)
        end

        attrs1 = collect(get_supplemental_attributes(EmissionsData, t1))
        attrs2 = collect(get_supplemental_attributes(EmissionsData, t2))
        @test length(attrs1) == 1
        @test length(attrs2) == 1
        @test attrs1[1] === attrs2[1]  # same object

        # Modify shared attribute with scalar (wraps in IncrementalCurve)
        set_emission_rate!(co2, 200.0)
        @test get_emission_rate(attrs1[1]) == _const_rate(200.0)
        @test get_emission_rate(attrs2[1]) == _const_rate(200.0)

        # Modify shared attribute with ValueCurve
        linear_curve = IS.IncrementalCurve(LinearFunctionData(0.01, 1.0), nothing, nothing)
        set_emission_rate!(co2, linear_curve)
        @test get_emission_rate(attrs1[1]) == linear_curve
        @test get_emission_rate(attrs2[1]) == linear_curve

        set_start_up_adder!(co2, 10.0)
        @test get_start_up_adder(attrs1[1]) == 10.0
        @test get_start_up_adder(attrs2[1]) == 10.0
    end

    @testset "JSON round trip" begin
        sys = PSB.build_system(PSITestSystems, "c_sys5_uc"; add_forecasts = false)
        thermals = collect(get_components(ThermalStandard, sys))
        t1 = thermals[1]
        t2 = thermals[2]

        co2 = EmissionsData(;
            name = "shared_co2_json",
            pollutant = PollutantType.CO2,
            emission_rate = 117.6,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            start_up_adder = 3.5,
            gwp = 1.0,
        )

        begin_supplemental_attributes_update(sys) do
            add_supplemental_attribute!(sys, t1, co2)
            add_supplemental_attribute!(sys, t2, co2)
        end

        begin
            sys2 = roundtrip_system(sys)
            t1_name = get_name(t1)
            t2_name = get_name(t2)
            t1_2 = get_component(ThermalStandard, sys2, t1_name)
            t2_2 = get_component(ThermalStandard, sys2, t2_name)

            attrs1 = collect(get_supplemental_attributes(EmissionsData, t1_2))
            attrs2 = collect(get_supplemental_attributes(EmissionsData, t2_2))
            @test length(attrs1) == 1
            @test length(attrs2) == 1
            @test get_emission_rate(attrs1[1]) == _const_rate(117.6)
            @test get_start_up_adder(attrs1[1]) == 3.5
            @test get_pollutant(attrs1[1]) == PollutantType.CO2
            # Same attribute instance (by UUID)
            @test IS.get_id(attrs1[1]) == IS.get_id(attrs2[1])
        end
    end

    @testset "JSON round trip with ValueCurve variants" begin
        sys = PSB.build_system(PSITestSystems, "c_sys5_uc"; add_forecasts = false)
        thermals = collect(get_components(ThermalStandard, sys))
        t1 = thermals[1]
        t2 = thermals[2]

        # Linear varying emission rate
        linear_rate = IS.IncrementalCurve(
            LinearFunctionData(0.001, 0.5), nothing, nothing,
        )
        nox = EmissionsData(;
            name = "nox_linear_json",
            pollutant = PollutantType.NOX,
            emission_rate = linear_rate,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.GJ,
            mass_unit = MassUnit.LB,
            start_up_adder = 2.5,
            gwp = 1.0,
        )

        # Piecewise step emission rate
        pw_rate = IS.IncrementalCurve(
            PiecewiseStepData([0.0, 100.0, 200.0], [50.0, 60.0]),
            0.0,
            nothing,
        )
        so2 = EmissionsData(;
            name = "so2_piecewise_json",
            pollutant = PollutantType.SO2,
            emission_rate = pw_rate,
            basis = EmissionBasis.POWER_OUTPUT,
            energy_unit = EnergyUnit.MWH,
            mass_unit = MassUnit.METRIC_TON,
            gwp = 2.5,
        )

        begin_supplemental_attributes_update(sys) do
            add_supplemental_attribute!(sys, t1, nox)
            add_supplemental_attribute!(sys, t1, so2)
            add_supplemental_attribute!(sys, t2, nox)
        end

        begin
            sys2 = roundtrip_system(sys)
            t1_name = get_name(t1)
            t2_name = get_name(t2)
            t1_2 = get_component(ThermalStandard, sys2, t1_name)
            t2_2 = get_component(ThermalStandard, sys2, t2_name)

            # Check t1 has both attributes
            attrs_t1 = collect(get_supplemental_attributes(EmissionsData, t1_2))
            @test length(attrs_t1) == 2

            # Find the NOX and SO2 attributes
            nox_attr = first(a for a in attrs_t1 if get_pollutant(a) == PollutantType.NOX)
            so2_attr = first(a for a in attrs_t1 if get_pollutant(a) == PollutantType.SO2)

            # Verify NOX linear rate round-tripped
            @test get_emission_rate(nox_attr) == linear_rate
            @test get_basis(nox_attr) == EmissionBasis.FUEL_INPUT
            @test get_energy_unit(nox_attr) == EnergyUnit.GJ
            @test get_mass_unit(nox_attr) == MassUnit.LB
            @test get_start_up_adder(nox_attr) == 2.5

            # Verify SO2 piecewise rate round-tripped
            @test get_emission_rate(so2_attr) == pw_rate
            @test get_basis(so2_attr) == EmissionBasis.POWER_OUTPUT
            @test get_energy_unit(so2_attr) == EnergyUnit.MWH
            @test get_mass_unit(so2_attr) == MassUnit.METRIC_TON
            @test get_gwp(so2_attr) == 2.5

            # Verify shared NOX attribute on t2
            attrs_t2 = collect(get_supplemental_attributes(EmissionsData, t2_2))
            nox_t2 = first(a for a in attrs_t2 if get_pollutant(a) == PollutantType.NOX)
            @test IS.get_id(nox_attr) == IS.get_id(nox_t2)
            @test get_emission_rate(nox_t2) == linear_rate
        end
    end

    @testset "Multiple pollutants on one component" begin
        sys = PSB.build_system(PSITestSystems, "c_sys5_uc"; add_forecasts = false)
        thermal = first(get_components(ThermalStandard, sys))

        co2 = EmissionsData(;
            name = "co2_multi",
            pollutant = PollutantType.CO2,
            emission_rate = 117.6,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        nox = EmissionsData(;
            name = "nox_multi",
            pollutant = PollutantType.NOX,
            emission_rate = 0.01,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            start_up_adder = 5.0,
        )
        so2 = EmissionsData(;
            name = "so2_multi",
            pollutant = PollutantType.SO2,
            emission_rate = 0.005,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.GJ,
        )

        begin_supplemental_attributes_update(sys) do
            add_supplemental_attribute!(sys, thermal, co2)
            add_supplemental_attribute!(sys, thermal, nox)
            add_supplemental_attribute!(sys, thermal, so2)
        end

        attrs = collect(get_supplemental_attributes(EmissionsData, thermal))
        @test length(attrs) == 3
    end

    @testset "Iteration returns unique instances" begin
        sys = PSB.build_system(PSITestSystems, "c_sys5_uc"; add_forecasts = false)
        thermals = collect(get_components(ThermalStandard, sys))
        t1 = thermals[1]
        t2 = thermals[2]

        co2 = EmissionsData(;
            name = "shared_iter",
            pollutant = PollutantType.CO2,
            emission_rate = 100.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )

        begin_supplemental_attributes_update(sys) do
            add_supplemental_attribute!(sys, t1, co2)
            add_supplemental_attribute!(sys, t2, co2)
        end

        all_attrs = collect(get_supplemental_attributes(EmissionsData, sys))
        @test length(all_attrs) == 1
    end
end
