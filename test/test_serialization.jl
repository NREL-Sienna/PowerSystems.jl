
function validate_serialization(sys::ConcreteSystem)
    path, io = mktemp()
    io = open(path, "w")
    @info "Serializing to $path"
    try
        to_json(io, sys)
    finally
        close(io)
    end

    sys2 = nothing
    try
        sys2 = ConcreteSystem(path)
    finally
        rm(path)
    end

    match = true
    for key in keys(sys.data)
        lengths_match = length(sys.data[key]) == length(sys2.data[key])
        if lengths_match
            for i in range(1, length=length(sys.data[key]))
                val1 = sys.data[key][i]
                val2 = sys2.data[key][i]
                if !PowerSystems.compare_values(val1, val2)
                    match = false
                    @error "$(typeof(val1)) i=$i does not match" val1 val2
                end
            end
        else
            @error "lengths of component arrays do not match" key length(sys.data[key])
                                                              length(sys2.data[key])
            match = false
        end
    end

    return match
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
