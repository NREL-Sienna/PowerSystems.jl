import UUIDs

"""Recursively validates that the object and fields have UUIDs."""
function validate_uuids(obj::T) where {T}
    if !(obj isa Component)
        return true
    end

    result = true
    if !(IS.get_uuid(obj) isa Base.UUID)
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

function validate_uuids(obj::T) where {T <: AbstractArray}
    result = true
    for elem in obj
        if !validate_uuids(elem)
            result = false
        end
    end

    return result
end

function validate_uuids(obj::T) where {T <: AbstractDict}
    result = true
    for elem in values(obj)
        if !validate_uuids(elem)
            result = false
        end
    end
    return result
end

@testset "Test internal values" begin
    sys_rts = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    @test validate_uuids(sys_rts)
end

# Regression: the `Base.convert(::Type{E}, ::AbstractString)` methods are generated from
# `ENUMS`, so the list is stated once. Restating it by hand is what let `ReservoirDataType`
# and `UnitSystem` sit in `ENUMS` with no conversion method.
@testset "Every enum in ENUMS converts from its member name" begin
    for enum in PSY.ENUMS
        for member in instances(enum)
            name = string(member)
            @test convert(enum, name) == member
            # Lookup is case insensitive.
            @test convert(enum, lowercase(name)) == member
        end
        @test_throws ArgumentError convert(enum, "not_a_member_of_$(enum)")
    end
end
