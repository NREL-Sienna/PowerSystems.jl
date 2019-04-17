
include(joinpath(DATA_DIR,"data_5bus_pu.jl"))

function are_type_and_fields_in_output(obj::T) where T <: PowerSystemType
    match = true
    short = repr(obj)
    io = IOBuffer()
    show(io, "text/plain", obj)
    long = String(take!(io))
    fields = fieldnames(T)

    # Type must always be present. name should be also, if the type defines it.
    for text in (short, long)
        if !occursin(string(T), text)
            @error "type name is not in output" string(T) text
            match = false
        end
        if :name in fields
            if !occursin("name", text)
                @error "name is not in output" text
                match = false
            end
        end
    end

    for field in fields
        if isnothing(getfield(obj, field))
            continue
        end

        if !occursin(string(getfield(obj, field)), long)
            @error "field's value is not in long output" field long
            match = false
        end
    end

    return match
end

sys5 = System(nodes5, thermal_generators5, loads5, branches5, nothing, 100.0, forecasts5,
              nothing, nothing)
@test are_type_and_fields_in_output(sys5)
@test are_type_and_fields_in_output(sys5.buses[1])
@test are_type_and_fields_in_output(sys5.generators)
@test are_type_and_fields_in_output(sys5.generators.thermal[1])
@test are_type_and_fields_in_output(sys5.branches[1])
@test are_type_and_fields_in_output(sys5.loads[1])
@test are_type_and_fields_in_output(sys5.forecasts[:DA][1])
