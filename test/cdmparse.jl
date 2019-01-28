using Logging
using PowerSystems



basedir = abspath(joinpath(dirname(dirname(Base.find_package("PowerSystems"))), "data/RTS_GMLC"))
data_dict = nothing
cdm_dict = nothing
sys_rts_da = nothing
sys_rts_rt = nothing

@test try
    @info "parsing data from $basedir into ps_dict"
    global data_dict = PowerSystems.read_csv_data(basedir)
    true
finally
end

@test haskey(data_dict,"timeseries_pointers")

@test try
    @info "parsing data from $basedir into ps_dict"
    global cdm_dict = PowerSystems.csv2ps_dict(basedir)
    true
finally
end

@test (cdm_dict isa Dict) & haskey(cdm_dict,"loadzone") == true

@test try
    @info "assigning time series data for DA"
    global cdm_dict = PowerSystems.assign_ts_data(cdm_dict,cdm_dict["forecast"]["DA"])
    true
finally
end

@test length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"])==24

@test try
    @info "making DA System"
    global sys_rts_da = PowerSystem(cdm_dict)
    true
finally
end

@test sys_rts_da isa PowerSystem

@test try
    @info "assigning time series data for RT"
    global cdm_dict = PowerSystems.assign_ts_data(cdm_dict,cdm_dict["forecast"]["RT"])
    true
finally
end 

@test length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"])==288

@test try
    @info "making RT System"
    global sys_rts_rt = PowerSystem(cdm_dict)
    true
finally
end

@test (sys_rts_rt isa PowerSystem) == true


basedir = joinpath(basedir,"../../test")
@info "testing bad directory"
@test PowerSystems.csv2ps_dict(basedir) == Dict{String,Any}("dcline"=>nothing,"baseMVA"=>100.0,"gen"=>nothing,"branch"=>nothing,"services"=>nothing)
