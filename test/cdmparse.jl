using Logging
using PowerSystems


@test try

    basedir = abspath(joinpath(dirname(dirname(Base.find_package("PowerSystems"))), "data/RTS_GMLC"))

    @info "parsing data from $basedir"
    cdm_dict = PowerSystems.csv2ps_dict(basedir)

    @info "assigning time series data for DA"
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict,cdm_dict["forecast"]["DA"])
    
    @info "making DA System"
    sys_rts_da = PowerSystem(cdm_dict)

    @info "assigning time series data for RT"
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict,cdm_dict["forecast"]["RT"])
    
    @info "making RT System"
    sys_rts_rt = PowerSystem(cdm_dict)

    true
finally
end