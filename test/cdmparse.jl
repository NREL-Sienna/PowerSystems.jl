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

    @info "making RTS System"
    sys_rts = PowerSystem(cdm_dict)
    @test sys_rts_da isa PowerSystem

    @info "making forecasts array for DA"
    rts_da = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["DA"])
    @test length(rts_da[1].data) == 24
    @test length(rts_da) == 131

    @info "assigning time series data for RT"
    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])
    @test length(rts_rt[1].data) == 288
    @test length(rts_rt) == 131

    @info "adding forecasts to System"
    PowerSystems.pushforecast!(sys_rts,:DA=>rts_da)
    PowerSystems.pushforecast!(sys_rts,:RT=>rts_rt)
    @test length(sys_rts.forecasts) == 2

end

@testset "CDM parsing invalid directory" begin
    baddir = joinpath(RTS_GMLC_DIR, "../../test")
    @info "testing bad directory"
    data = Dict{String, Any}("dcline" => nothing, "baseMVA"=> 100.0, "gen" => nothing,
                             "branch" => nothing, "services"=> nothing)
    @test PowerSystems.csv2ps_dict(baddir) == data
end
