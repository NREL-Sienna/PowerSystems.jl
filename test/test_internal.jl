import UUIDs

"""Recursively validates that the object and fields have integer ids."""
function validate_ids(obj::T) where {T}
    if !(obj isa Component)
        return true
    end

    result = true
    if !(IS.get_id(obj) isa Int)
        result = false
        @error "object does not have an integer id" obj
    end

    for fieldname in fieldnames(T)
        val = getfield(obj, fieldname)
        if !validate_ids(val)
            result = false
        end
    end

    return result
end

function validate_ids(obj::T) where {T <: AbstractArray}
    result = true
    for elem in obj
        if !validate_ids(elem)
            result = false
        end
    end

    return result
end

function validate_ids(obj::T) where {T <: AbstractDict}
    result = true
    for elem in values(obj)
        if !validate_ids(elem)
            result = false
        end
    end
    return result
end

@testset "Test internal values" begin
    sys_rts = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    @test validate_ids(sys_rts)
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
