using Logging
using PowerSystems



basedir = abspath(joinpath(dirname(dirname(Base.find_package("PowerSystems"))), "data/RTS_GMLC"))
data_dict = nothing
cdm_dict = nothing
sys_rts_da = nothing
sys_rts_rt = nothing

@test_skip try
    @info "parsing data from $basedir into ps_dict"
    global data_dict = PowerSystems.read_csv_data(basedir)
    true
finally
end

@test_skip haskey(data_dict,"timeseries_pointers")

@test_skip try
    @info "parsing data from $basedir into ps_dict"
    global cdm_dict = PowerSystems.csv2ps_dict(basedir)
    true
finally
end

@test_skip (cdm_dict isa Dict) & haskey(cdm_dict,"load_zone") == true

@test_skip try
    @info "assigning time series data for DA"
    global cdm_dict = PowerSystems.assign_ts_data(cdm_dict,cdm_dict["forecast"]["DA"])
    true
finally
end

@test_skip length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"])==24

@test_skip try
    @info "making DA System"
    global sys_rts_da = PowerSystem(cdm_dict)
    true
finally
end

@test_skip sys_rts_da isa PowerSystem

@test_skip try
    @info "assigning time series data for RT"
    global cdm_dict = PowerSystems.assign_ts_data(cdm_dict,cdm_dict["forecast"]["RT"])
    true
finally
end 

@test_skip length(cdm_dict["gen"]["Renewable"]["PV"]["102_PV_1"]["scalingfactor"])==288

@test_skip try
    @info "making RT System"
    global sys_rts_rt = PowerSystem(cdm_dict)
    true
finally
end

@test_skip (sys_rts_rt isa PowerSystem) == true


basedir = "."
@info "testing bad directory"
@test_skip PowerSystems.csv2ps_dict(basedir) == Dict{String,Any}("baseMVA"=>100.0,"gen"=>nothing,"branch"=>nothing,"load"=>nothing)