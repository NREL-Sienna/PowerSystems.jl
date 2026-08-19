@testset "to_file/from_file: bundle round trip" begin
    sys = _file_io_fixture()
    mktempdir() do dir
        bundle = joinpath(dir, "case")
        to_file(sys, bundle; unit_system = :device_base)

        # All members present, and nothing else. The InfraStore sidecar is a pair: the
        # arrays in `.h5` and its catalog in the `.sqlite` sibling.
        @test sort(readdir(bundle)) ==
              ["system.json", "time_series.h5", "time_series.h5.sqlite"]

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

@testset "ext is passthrough: any key survives a document round trip" begin
    doc_dict = make_openapi_test_doc()

    empty_ext = copy(doc_dict)
    empty_ext["ext"] = Dict{String, Any}()
    @test isempty(
        get_ext(
            get_component(ACBus, PSY.from_openapi(System, to_test_document(empty_ext)),
                "bus1"),
        ),
    )

    # Id 3 is bus1. No key is privileged: PowerSystems stores whatever the producer emitted
    # and never reads it, so an arbitrary name and a mix of value types must both survive.
    extras = Dict{String, Any}("Whatsit MW" => 1.0, "Source Label" => "zone-a", "Tol" => 3)
    with_ext = copy(doc_dict)
    with_ext["ext"] = Dict{String, Any}("3" => extras)

    sys = PSY.from_openapi(System, to_test_document(with_ext))
    @test get_ext(get_component(ACBus, sys, "bus1")) == extras
    @test isempty(get_ext(get_component(ACBus, sys, "bus2")))

    # And back out again, unchanged. A component's document id is its IS component id, which
    # import set from the document, so bus1 is id 3 on the way out as well.
    exported = to_openapi(sys; unit_system = :natural_units)
    @test PSY.PC.get_ext(exported, 3) == extras
    @test isempty(PSY.PC.get_ext(exported, 4))
end
