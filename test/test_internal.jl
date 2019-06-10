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
    sys_rts = create_rts_system()
    @test validate_uuids(sys)
end
