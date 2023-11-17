
base_dir = dirname(dirname(pathof(PowerSystems)))

@testset "Check bus index" begin
    # This signature is used to capture expected error logs from parsing matpower
    test_bus_index =
        () -> begin
            sys = PSB.build_system(PSB.MatpowerTestSystems, "matpower_case5_re_sys")
            @test sort([b.number for b in collect(get_components(ACBus, sys))]) ==
                  [1, 2, 3, 4, 10]
            @test sort(
                collect(
                    Set([b.arc.from.number for b in collect(get_components(Branch, sys))]),
                ),
            ) == [1, 2, 3, 4]
            @test sort(
                collect(
                    Set([b.arc.to.number for b in collect(get_components(Branch, sys))]),
                ),
            ) == [2, 3, 4, 10]

            # TODO: add test for loadzones testing MAPPING_BUSNUMBER2INDEX
        end
    @test_logs min_level = Logging.Error match_mode = :any test_bus_index()
end

@testset "Test unique bus numbers" begin
    # This signature is used to capture expected error logs from parsing matpower
    test_bus_numbers =
        () -> begin
            sys = PSB.build_system(PSB.MatpowerTestSystems, "matpower_case5_re_sys")
            number = 100
            bus1 = ACBus(;
                number = number,
                name = "bus100",
                bustype = ACBusTypes.PV,
                angle = 1.0,
                magnitude = 1.0,
                voltage_limits = (min = -1.0, max = 1.0),
                base_voltage = 1.0,
            )
            bus2 = ACBus(;
                number = number,
                name = "bus101",
                bustype = ACBusTypes.PV,
                angle = 1.0,
                magnitude = 1.0,
                voltage_limits = (min = -1.0, max = 1.0),
                base_voltage = 1.0,
                area = nothing,
                load_zone = nothing,
            )

            add_component!(sys, bus1)
            @test_throws ArgumentError add_component!(sys, bus2)
        end
    @test_logs min_level = Logging.Error match_mode = :any test_bus_numbers()
end
