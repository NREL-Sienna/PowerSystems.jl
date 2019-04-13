
function validate_serialization(sys::ConcreteSystem)
    path, io = mktemp()
    @info "Serializing to $path"

    try
        to_json(io, sys)
    catch
        close(io)
        rm(path)
        rethrow()
    end
    close(io)

    try
        sys2 = ConcreteSystem(path)
        return PowerSystems.compare_values(sys, sys2)
    finally
        rm(path)
    end
end

@testset "Test JSON serialization" begin
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    cdm_dict = PowerSystems.assign_ts_data(cdm_dict, cdm_dict["forecast"]["DA"])
    sys_rts_da = System(cdm_dict)
    sys = ConcreteSystem(sys_rts_da)
    @test validate_serialization(sys)

    line1 = sys.data[Line][1]
    json_string = to_json(line1)
    line2 = from_json(json_string, Line)
    @test PowerSystems.compare_values(line1, line2)
end
