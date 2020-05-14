@testset "Test get_ctm_buses" begin
    sys = create_rts_system()
    buses = get_components(Bus, sys)
    ctm_buses = PSY.get_ctm_buses(sys)
    @test length(buses) == length(ctm_buses)
    @test collect(ctm_buses)[1] isa CTM.Bus
end

@testset "Test list_buses" begin
    sys = create_rts_system()
    buses = get_components(Bus, sys)
    api_buses = JSON.parse(PSY.list_buses(sys))
    @test length(buses) == length(api_buses)
    #@test collect(ctm_buses)[1] isa CTM.Bus
end
