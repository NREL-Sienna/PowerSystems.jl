@testset "to_file/from_file: bundle round trip" begin
    sys = _file_io_fixture()
    mktempdir() do dir
        bundle = joinpath(dir, "case")
        to_file(sys, bundle; unit_system = :device_base)

        # Both members present, and nothing else.
        @test sort(readdir(bundle)) == ["system.json", "time_series.h5"]

        sys2 = from_file(System, bundle)

        # System-level metadata, which the pre-OpenAPI path carried in a _metadata.json
        # sidecar and the first cut of to_openapi dropped entirely.
        @test get_name(sys2) == "bundle-fixture"
        @test get_description(sys2) == "round-trip check"
        @test get_base_power(sys2) == get_base_power(sys)

        @test length(collect(get_components(Component, sys2))) ==
              length(collect(get_components(Component, sys)))

        gen2 = get_component(ThermalStandard, sys2, "g1")
        @test get_name(gen2) == "g1"

        attrs = PSY.get_supplemental_attributes(gen2)
        @test length(attrs) == 1
        @test first(attrs) isa EmissionsData

        ts = get_time_series(SingleTimeSeries, gen2, "max_active_power")
        @test length(ts) == 6
        @test TimeSeries.values(PSY.get_data(ts)) == [0.1, 0.2, 0.3, 0.4, 0.5, 0.6]
        @test IS.get_scaling_factor_multiplier(ts) === get_max_active_power
    end
end

@testset "to_file: a system with no time series gets no sidecar" begin
    sys = _file_io_fixture(; with_time_series = false)
    mktempdir() do dir
        bundle = joinpath(dir, "case")
        to_file(sys, bundle; unit_system = :device_base)

        @test readdir(bundle) == ["system.json"]
        # The document must say so rather than name a file that is not there.
        doc = PSY.PC.read_document(joinpath(bundle, "system.json"))
        @test isnothing(PSY.PC.get_time_series_storage_file(doc))

        sys2 = from_file(System, bundle)
        @test isempty(collect(get_components(ThermalStandard, sys2))) == false
    end
end

@testset "to_file/from_file: loud errors" begin
    sys = _file_io_fixture(; with_time_series = false)

    # Writing twice without force must not silently clobber the first bundle.
    mktempdir() do dir
        bundle = joinpath(dir, "case")
        to_file(sys, bundle; unit_system = :device_base)
        @test_throws IS.DataFormatError to_file(sys, bundle; unit_system = :device_base)
        # ... and force makes it succeed.
        @test isnothing(to_file(sys, bundle; unit_system = :device_base, force = true))
    end

    # A directory that is not a bundle.
    mktempdir() do dir
        @test_throws IS.DataFormatError from_file(System, dir)
    end

    # A document naming a sidecar that is absent: refuse rather than return a System that is
    # quietly missing every time series the document declared.
    mktempdir() do dir
        bundle = joinpath(dir, "case")
        to_file(_file_io_fixture(), bundle; unit_system = :device_base)
        rm(joinpath(bundle, "time_series.h5"))
        @test_throws IS.DataFormatError from_file(System, bundle)
    end
end

@testset "to_openapi: one id space for components and supplemental attributes" begin
    # SiennaGridDB's entities table keys a row by id without its type, so an id must mean
    # exactly one thing. A private attribute counter previously issued attribute id 1
    # alongside component id 1.
    sys = _file_io_fixture(; with_time_series = false)
    doc = to_openapi(sys; unit_system = :device_base)

    component_ids = Int[]
    for type_name in PSY.PC.component_type_names(doc)
        for row in PSY.PC.get_components(doc, type_name)
            push!(component_ids, Int(row.id))
        end
    end
    attribute_ids = Int[Int(a.id) for a in doc.supplemental_attributes]

    @test !isempty(attribute_ids)
    @test isempty(intersect(Set(component_ids), Set(attribute_ids)))
    @test length(unique(component_ids)) == length(component_ids)
end

@testset "from_openapi: any ext key errors, naming it" begin
    doc_dict = make_openapi_test_doc()

    # An empty ext is the normal case: producers keep unmappable source columns on their own
    # side rather than emitting them.
    empty_ext = copy(doc_dict)
    empty_ext["ext"] = Dict{String, Any}()
    @test PSY.from_openapi(System, to_test_document(empty_ext)) isa System

    # Any key at all fails, naming it -- PowerSystems has nowhere to put it, and silently
    # dropping source data is what this replaces.
    unknown = copy(doc_dict)
    unknown["ext"] = Dict{String, Any}("3" => Dict{String, Any}("Whatsit MW" => 1.0))
    err = try
        PSY.from_openapi(System, to_test_document(unknown))
        nothing
    catch e
        e
    end
    @test err isa ErrorException
    @test occursin("Whatsit MW", err.msg)
end
