using Logging
using PowerSystems



basedir = abspath(joinpath(dirname(dirname(Base.find_package("PowerSystems"))), "data/RTS_GMLC"))
cdm_dict = nothing
sys_rts_da = nothing
sys_rts_rt = nothing

@test try
    @info "parsing data from $basedir"
    global cdm_dict = PowerSystems.csv2ps_dict(basedir)
    true
finally
end

@test (cdm_dict isa Dict) & haskey(cdm_dict,"load_zone") == true

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

@test try
    basedir = "."
    @info "testing bad directory"
    global cdm_dict = PowerSystems.csv2ps_dict(basedir);
    true
finally
end

@test cdm_dict == Dict{String,Any}("baseMVA"=>100.0,"gen"=>nothing,"branch"=>nothing,"load"=>nothing)