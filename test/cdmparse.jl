using Logging
using PowerSystems


@test try

    basedir = abspath(joinpath(dirname(dirname(Base.find_package("PowerSystems"))), "data/RTS_GMLC"))

    @info "parsing data from $basedir"
    cdm_dict = PowerSystems.csv2ps_dict(basedir)

    @info "making System"
    sys_rts = PowerSystem(cdm_dict)

    true
finally
end