@testset "PowerSystems dict parsing" begin
    @info "parsing data from $RTS_GMLC_DIR into ps_dict"
    data_dict = PowerSystems.read_csv_data(RTS_GMLC_DIR)
    @test haskey(data_dict, "timeseries_pointers")
end

@testset "CDM parsing" begin
    cdm_dict = nothing
    @info "parsing data from $RTS_GMLC_DIR into ps_dict"
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR)
    @test cdm_dict isa Dict && haskey(cdm_dict, "loadzone")

    @info "assigning time series data for DA"
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict, cdm_dict["forecast"]["DA"])
    @test length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"]) == 24

    @info "making DA System"
    sys_rts_da = PowerSystem(cdm_dict)
    @test sys_rts_da isa PowerSystem

    @info "assigning time series data for RT"
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict, cdm_dict["forecast"]["RT"])
    @test length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"]) == 288

    @info "making RT System"
    sys_rts_rt = PowerSystem(cdm_dict)
    @test sys_rts_rt isa PowerSystem
end

@testset "CDM parsing invalid directory" begin
    baddir = joinpath(RTS_GMLC_DIR, "../../test")
    @info "testing bad directory"
    data = Dict{String, Any}("dcline" => nothing, "baseMVA"=> 100.0, "gen" => nothing,
                             "branch" => nothing, "services"=> nothing)
    @test PowerSystems.csv2ps_dict(baddir) == data
end
