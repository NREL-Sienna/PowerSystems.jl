@testset "TAMU Parsing " begin
    # Added due to inconsistencies in the incoming data. If the data is fixed, this test_logs call will fail
    sys = PSB.build_system(PSB.PSYTestSystems, "tamu_ACTIVSg2000_sys"; force_build = true)
    @test isa(sys, PSY.System)
    # Test bad input
    @test_throws PowerSystems.DataFormatError TamuSystem("")
end
