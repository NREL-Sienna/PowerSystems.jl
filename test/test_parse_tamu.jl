@testset "TAMU Parsing " begin
    files = readdir(TAMU_DIR)
    if length(files) == 0
        error("No test files in the folder")
    end

    sys = PSB.build_system(PSB.PSYTestSystems, "tamu_ACTIVSg2000_sys")
    @info "Successfully parsed $TAMU_DIR to System struct"

    # Test bad input
    @test_throws PowerSystems.DataFormatError TamuSystem("")
end
