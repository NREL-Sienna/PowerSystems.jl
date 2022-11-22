@testset "PSSE Parsing" begin
    files = readdir(PSSE_RAW_DIR)
    if length(files) == 0
        error("No test files in the folder")
    end

    for f in files[1:1]
        @info "Parsing $f ..."
        pm_data = PowerSystems.PowerModelsData(joinpath(PSSE_RAW_DIR, f))
        @info "Successfully parsed $f to PowerModelsData"
        sys = System(pm_data)
        for g in get_components(Generator, sys)
            @test haskey(get_ext(g), "z_source")
        end
        @info "Successfully parsed $f to System struct"
    end

    # Test bad input
    pm_data = PowerSystems.PowerModelsData(joinpath(PSSE_RAW_DIR, files[1]))
    pm_data.data["bus"] = Dict{String, Any}()
    @test_throws PowerSystems.DataFormatError System(pm_data)
end

@testset "PSSE PowerModel Parsing" begin
    PM_PSSE_PATH = joinpath(DATA_DIR, "pm_data", "pti")
    files = readdir(PM_PSSE_PATH)
    if length(files) == 0
        error("No test files in the folder")
    end

    for f in files[1:1]
        @info "Parsing $f ..."
        sys = System(joinpath(PM_PSSE_PATH, f))
        for g in get_components(Generator, sys)
            @test haskey(get_ext(g), "z_source")
        end
        @info "Successfully parsed $f to System struct"
    end
end
