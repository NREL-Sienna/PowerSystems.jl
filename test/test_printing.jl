
function are_type_and_fields_in_output(obj::T) where {T <: Component}
    match = true
    normal = repr(obj)
    io = IOBuffer()
    show(io, "text/plain", obj)
    custom = String(take!(io))
    fields = fieldnames(T)

    # Type must always be present. name should be also, if the type defines it.
    #for text in (normal, custom)
    for text in (custom,)
        if !occursin(string(T), text)
            @error "type name is not in output" string(T) text
            match = false
        end
        if :name in fields
            if !occursin(obj.name, text)
                @error "name is not in output" name text
                match = false
            end
        end
    end

    for (name, type) in zip(fields, fieldtypes(T))
        val = getfield(obj, name)
        if val === nothing || type <: IS.InfrastructureSystemsInternal
            continue
        end

        # Account for the fact that type may be abstract.
        actual_type = typeof(val)
        if actual_type <: IS.InfrastructureSystemsType ||
           actual_type <: IS.Forecasts ||
           actual_type <: Vector{<:Service}
            expected = string(actual_type)
        else
            expected = string(val)
        end

        if !occursin(expected, custom)
            @error "field's value is not in custom output" name custom
            match = false
        end
    end

    return match
end

sys = create_rts_system()
@test are_type_and_fields_in_output(iterate(get_components(Bus, sys))[1])
@test are_type_and_fields_in_output(iterate(get_components(Generator, sys))[1])
@test are_type_and_fields_in_output(iterate(get_components(ThermalGen, sys))[1])
@test are_type_and_fields_in_output(iterate(get_components(Branch, sys))[1])
@test are_type_and_fields_in_output(iterate(get_components(ElectricLoad, sys))[1])

# Just make sure nothing blows up.
for component in iterate_components(sys)
    print(devnull, component)
    print(devnull, MIME"text/plain")
    @test !isempty(summary(component))
end
for forecast in iterate_forecasts(sys)
    show(devnull, forecast)
    show(devnull, MIME"text/plain")
    @test !isempty(summary(forecast))
end

@test !isempty(summary(sys))

@test isnothing(show(
    IOBuffer(),
    "text/plain",
    PowerSystemTableData(RTS_GMLC_DIR, 100.0, DESCRIPTORS),
))
