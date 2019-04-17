
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

sys5 = System(nodes5, generators5, loads5_DA, branches5, nothing, 100.0, forecasts5,
              nothing, nothing)
@test are_type_and_fields_in_output(sys5)
@test are_type_and_fields_in_output(sys5.buses[1])
@test are_type_and_fields_in_output(sys5.generators)
@test are_type_and_fields_in_output(sys5.generators.thermal[1])
@test are_type_and_fields_in_output(sys5.generators.renewable[1])
@test are_type_and_fields_in_output(sys5.branches[1])
@test are_type_and_fields_in_output(sys5.loads[1])
@test are_type_and_fields_in_output(sys5.forecasts[:DA][1])

# scalingfactor (a TimeArray)
@test repr(sys5.forecasts[:DA][1].data) ==
    "24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00"
show(io, "text/plain", sys5.forecasts[:DA][1].data)
@test_skip String(take!(io)) == 
    "24×1 TimeArray{Float64,1,DateTime,Array{Float64,1}} 2024-01-01T00:00:00 to 2024-01-01T23:00:00\n│                     │ A      │\n├─────────────────────┼────────┤\n│ 2024-01-01T00:00:00 │ 0.0    │\n│ 2024-01-01T01:00:00 │ 0.0    │\n│ 2024-01-01T02:00:00 │ 0.0    │\n│ 2024-01-01T03:00:00 │ 0.0    │\n│ 2024-01-01T04:00:00 │ 0.0    │\n│ 2024-01-01T05:00:00 │ 0.0    │\n│ 2024-01-01T06:00:00 │ 0.0    │\n│ 2024-01-01T07:00:00 │ 0.0    │\n│ 2024-01-01T08:00:00 │ 0.0    │\n   ⋮\n│ 2024-01-01T16:00:00 │ 0.1551 │\n│ 2024-01-01T17:00:00 │ 0.0409 │\n│ 2024-01-01T18:00:00 │ 0.0    │\n│ 2024-01-01T19:00:00 │ 0.0    │\n│ 2024-01-01T20:00:00 │ 0.0    │\n│ 2024-01-01T21:00:00 │ 0.0    │\n│ 2024-01-01T22:00:00 │ 0.0    │\n│ 2024-01-01T23:00:00 │ 0.0    │"

# line
@test repr(sys5.branches[1]) == "Line(name=\"1\")"
show(io, "text/plain", sys5.branches[1])
@test_skip String(take!(io)) ==
    "Line:\n   name: 1\n   available: true\n   connectionpoints: (from = Bus(name=\"nodeA\"), to = Bus(name=\"nodeB\"))\n   r: 0.00281\n   x: 0.0281\n   b: (from = 0.00356, to = 0.00356)\n   rate: 38.038742043967325\n   anglelimits: (min = -0.7853981633974483, max = 0.7853981633974483)"
