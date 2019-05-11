import UUIDs

"""Recursively validates that the object and fields have UUIDs."""
function validate_uuids(obj::T) where T
    if !(obj isa PowerSystemType)
        return true
    end

    result = true
    if !(PowerSystems.get_uuid(obj) isa Base.UUID)
        result = false
        @error "object does not have a UUID" obj
    end

    for fieldname in fieldnames(T)
        val = getfield(obj, fieldname)
        if !validate_uuids(val)
            result = false
        end
    end

    return result
end

function validate_uuids(obj::T) where T <: AbstractArray
    result = true
    for elem in obj
        if !validate_uuids(elem)
            result = false
        end
    end
    return result
end

function validate_uuids(obj::T) where T <: AbstractDict
    result = true
    for elem in values(obj)
        if !validate_uuids(elem)
            result = false
        end
    end
    return result
end

@testset "Test internal values" begin
    cdm_dict = PowerSystems.csv2ps_dict(RTS_GMLC_DIR, 100.0)
    sys_rts = System(cdm_dict)
    rts_da = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["DA"])
    rts_rt = PowerSystems.make_forecast_array(sys_rts, cdm_dict["forecasts"]["RT"])

    PowerSystems.add_forecast!(sys_rts, :DA=>rts_da)
    PowerSystems.add_forecast!(sys_rts, :RT=>rts_rt)

    sys = System(cdm_dict)

    @test validate_uuids(sys)
end
