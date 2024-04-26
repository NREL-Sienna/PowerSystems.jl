
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
        if actual_type <: IS.TimeSeriesContainer
            continue
        elseif actual_type <: IS.InfrastructureSystemsType ||
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

@testset "Test printing of system and components" begin
    sys = PSB.build_system(PSITestSystems, "test_RTS_GMLC_sys")
    @test are_type_and_fields_in_output(iterate(get_components(ACBus, sys))[1])
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
    for time_series in get_time_series_multiple(sys)
        show(devnull, time_series)
        show(devnull, MIME"text/plain")
        @test !isempty(summary(time_series))
    end

    @test !isempty(summary(sys))

    @test isnothing(
        show(
            IOBuffer(),
            "text/plain",
            PowerSystemTableData(RTS_GMLC_DIR, 100.0, DESCRIPTORS),
        ),
    )

    @test isnothing(show(IOBuffer(), "text/plain", sys))
    @test isnothing(show(IOBuffer(), "text/html", sys))
    @test isnothing(show_components(IOBuffer(), sys, RenewableFix))
    @test isnothing(show_components(IOBuffer(), sys, RenewableFix, [:rating]))
    @test isnothing(
        show_components(
            IOBuffer(),
            sys,
            RenewableFix,
            Dict("ts" => x -> has_time_series(x)),
        ),
    )
end

@testset "Test printing of non-PowerSystems struct" begin
    struct MyComponent <: Component
        name::String
        internal::IS.InfrastructureSystemsInternal
    end

    PSY.get_internal(x::MyComponent) = x.internal
    PSY.get_name(x::MyComponent) = string(x.name)

    component = MyComponent("component1", IS.InfrastructureSystemsInternal())
    @test isnothing(show(IOBuffer(), component))
    @test isnothing(show(IOBuffer(), "text/plain", component))
end
