@testset "Test special accessors" begin

    cdmsys = create_rts_system()
    th = first(get_components(ThermalStandard, cdmsys))
    re = first(get_components(RenewableDispatch, cdmsys))

    @test get_max_active_power(th) == get_active_power_limits(th).max
    @test get_max_active_power(re) <= get_rating(re)

    mutable struct TestDevice <: Device
        name::String
    end

    mutable struct TestRenDevice <: RenewableGen
        name::String
    end

    @test_throws ArgumentError get_max_active_power(TestDevice("foo"))
    @test_throws ArgumentError get_max_active_power(TestRenDevice("foo"))
end
