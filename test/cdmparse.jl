@testset "PowerSystems dict parsing" begin
    data_dict = PowerSystems.read_csv_data(RTS_GMLC_DIR, 100.0)
    @test haskey(data_dict, "timeseries_pointers")
end

@testset "CDM parsing" begin
    cdm_dict = nothing
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    @test cdm_dict isa Dict && haskey(cdm_dict, "loadzone")

    sys_rts = System(cdm_dict)
    @test sys_rts isa System

    rts_da = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["DA"])
    @test length(rts_da[1].data) == 24
    @test length(rts_da) == 141

    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])
    @test length(rts_rt[1].data) == 288
    @test length(rts_rt) == 134

    PowerSystems.add_forecast!(sys_rts,:DA=>rts_da)
    PowerSystems.add_forecast!(sys_rts,:RT=>rts_rt)
    @test length(sys_rts.forecasts) == 2

    cs_rts = System(cdm_dict)
    @test cs_rts isa System

    rts_da_cs = PowerSystems.make_forecast_array(cs_rts, cdm_dict["forecasts"]["DA"])
    @test length(rts_da[1].data) == 24
    @test length(rts_da) == 141 # TODO: seems to be missing service forecasts

    rts_rt_cs = PowerSystems.make_forecast_array(cs_rts, cdm_dict["forecasts"]["RT"])
    @test length(rts_rt[1].data) == 288
    @test length(rts_rt) == 134
end

@testset "CDM parsing invalid directory" begin
    baddir = abspath(joinpath(RTS_GMLC_DIR, "../../test"))
    @test_throws ErrorException PowerSystems.csv2ps_dict(baddir, 100.0)
end

"""Allows comparison of structs that were created from different parsers which causes them
to have different UUIDs."""
function compare_values_without_uuids(x::T, y::T)::Bool where T <: PowerSystemType
    match = true

    for (fieldname, fieldtype) in zip(fieldnames(T), fieldtypes(T))
        if fieldname == :internal
            continue
        end

        val1 = getfield(x, fieldname)
        val2 = getfield(y, fieldname)

        # Recurse if this is a PowerSystemType.
        if val1 isa PowerSystemType
            if !compare_values_without_uuids(val1, val2)
                match = false
            end
            continue
        end

        if val1 != val2
            @error "values do not match" fieldname val1 val2
            match = false
        end
    end

    return match
end

@testset "consistency between CDM and standardfiles" begin
    mp_dict  = parsestandardfiles(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    pm_dict = parse_file(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    pmmp_dict = PowerSystems.pm2ps_dict(pm_dict)
    mpmmpsys = System(pmmp_dict)

    mpsys = System(mp_dict)

    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    cdmsys = System(cdm_dict)

    cdmgen = collect(get_components(ThermalGen, cdmsys))[1]
    mpgen = collect(get_components(ThermalGen, mpsys))[1]
    @test cdmgen.tech.activepowerlimits == mpgen.tech.activepowerlimits
    @test cdmgen.tech.reactivepowerlimits == mpgen.tech.reactivepowerlimits
    @test cdmgen.tech.ramplimits == mpgen.tech.ramplimits

    @test cdmgen.econ.capacity == mpgen.econ.capacity
    @test [isapprox(cdmgen.econ.variablecost[i][1], mpgen.econ.variablecost[i][1], atol= .1) 
                        for i in 1:4] == [true, true, true, true]

    cdmgen = collect(get_components(HydroGen, cdmsys))[1]
    mpgen = collect(get_components(HydroGen, mpsys))[1]
    @test cdmgen.tech.activepowerlimits == mpgen.tech.activepowerlimits
    @test cdmgen.tech.reactivepowerlimits == mpgen.tech.reactivepowerlimits
    @test cdmgen.tech.installedcapacity == mpgen.tech.installedcapacity
    @test cdmgen.tech.ramplimits == mpgen.tech.ramplimits # this gets adjusted in the pm2ps_dict 
    @test compare_values_without_uuids(cdmgen.econ, mpgen.econ)

    cdmbranches = collect(get_components(Branch,cdmsys))
    @test cdmbranches[2].rate ==
        [b for b in collect(get_components(Branch,mpsys)) if 
            (b.connectionpoints.from.name == uppercase(cdmbranches[2].connectionpoints.from.name)) 
                & (b.connectionpoints.to.name == uppercase(cdmbranches[2].connectionpoints.to.name))][1].rate

    @test cdmbranches[6].rate ==
        [b for b in collect(get_components(Branch,mpsys))  if 
            (b.connectionpoints.from.name == uppercase(cdmbranches[6].connectionpoints.from.name)) 
                & (b.connectionpoints.to.name == uppercase(cdmbranches[6].connectionpoints.to.name))][1].rate

    @test cdmbranches[120].rate == [b for b in collect(get_components(Branch,mpsys)) if 
            (b.connectionpoints.from.name == uppercase(cdmbranches[120].connectionpoints.from.name)) 
                & (b.connectionpoints.to.name == uppercase(cdmbranches[120].connectionpoints.to.name))][1].rate

    cdmgen = collect(get_components(RenewableGen, cdmsys))[1]
    mpgen = collect(get_components(RenewableGen, mpsys))[1]
    @test compare_values_without_uuids(cdmgen.tech, mpgen.tech)
    @test compare_values_without_uuids(cdmgen.econ, mpgen.econ)
end
