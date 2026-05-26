@testset "EmissionsData" begin
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
        @test get_emission_rate(co2) == LinearFunctionData(117.6)
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
        @test get_emission_rate(nox) == LinearFunctionData(0.01)
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

    @testset "Construction with FunctionData" begin
        # QuadraticFunctionData for nonlinear emission rates
        quad_rate = QuadraticFunctionData(0.001, 0.5, 0.0)
        co2_quad = EmissionsData(;
            name = "co2_quad",
            pollutant = PollutantType.CO2,
            emission_rate = quad_rate,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
        )
        @test get_emission_rate(co2_quad) == quad_rate

        # PiecewiseLinearData
        pw_rate = PiecewiseLinearData([(0.0, 0.0), (100.0, 50.0), (200.0, 120.0)])
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

        # Zero gwp
        @test_throws ArgumentError EmissionsData(;
            name = "bad",
            pollutant = PollutantType.CO2,
            emission_rate = 1.0,
            basis = EmissionBasis.FUEL_INPUT,
            energy_unit = EnergyUnit.MMBTU,
            gwp = 0.0,
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
        @test get_emission_rate(attrs[1]) == LinearFunctionData(117.6)

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

        # Modify shared attribute with scalar (wraps in LinearFunctionData)
        set_emission_rate!(co2, 200.0)
        @test get_emission_rate(attrs1[1]) == LinearFunctionData(200.0)
        @test get_emission_rate(attrs2[1]) == LinearFunctionData(200.0)

        # Modify shared attribute with FunctionData
        quad = QuadraticFunctionData(0.01, 1.0, 0.0)
        set_emission_rate!(co2, quad)
        @test get_emission_rate(attrs1[1]) == quad
        @test get_emission_rate(attrs2[1]) == quad

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

        mktempdir() do path
            json_path = joinpath(path, "test_emissions.json")
            to_json(sys, json_path)

            sys2 = System(json_path)
            t1_name = get_name(t1)
            t2_name = get_name(t2)
            t1_2 = get_component(ThermalStandard, sys2, t1_name)
            t2_2 = get_component(ThermalStandard, sys2, t2_name)

            attrs1 = collect(get_supplemental_attributes(EmissionsData, t1_2))
            attrs2 = collect(get_supplemental_attributes(EmissionsData, t2_2))
            @test length(attrs1) == 1
            @test length(attrs2) == 1
            @test get_emission_rate(attrs1[1]) == LinearFunctionData(117.6)
            @test get_start_up_adder(attrs1[1]) == 3.5
            @test get_pollutant(attrs1[1]) == PollutantType.CO2
            # Same attribute instance (by UUID)
            @test IS.get_uuid(attrs1[1]) == IS.get_uuid(attrs2[1])
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
