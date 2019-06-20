
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

# TODO: forecasts are in old format, and so are disabled for now.
sys5 = PowerSystems.System(nodes5, thermal_generators5, loads5, branches5, nothing, 100.0,
        nothing, nothing, nothing)
        #forecasts5, nothing, nothing)
@test are_type_and_fields_in_output(collect(get_components(Bus,sys5))[1])
@test are_type_and_fields_in_output(collect(get_components(Generator,sys5))[1])
@test are_type_and_fields_in_output(collect(get_components(ThermalGen,sys5))[1])
@test are_type_and_fields_in_output(collect(get_components(Branch,sys5))[1])
@test are_type_and_fields_in_output(collect(get_components(ElectricLoad,sys5))[1])
#for initial_time in get_forecast_initial_times(sys5)
#    for forecast in get_forecasts(Forecast, sys5, initial_time)
#        @test are_type_and_fields_in_output(forecast)
#        # Just test one forecast per initial_time.
#        break
#    end
#end
