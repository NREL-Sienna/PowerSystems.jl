@time @testset "PSSE Parsing " begin
    files = readdir(PSSE_RAW_DIR)
    if length(files) == 0
        error("No test files in the folder")
    end

    for f in files[1:1]
        @info "Parsing $f ..."
        pm_dict = PowerSystems.parse_file(joinpath(PSSE_RAW_DIR, f))
        @info "Successfully parsed $f to PowerModels dict"
        PowerSystems.make_mixed_units(pm_dict)
        @info "Successfully converted $f to mixed_units"
        sys = PowerSystems.pm2ps_dict(pm_dict)
        @info "Successfully parsed $f to System struct"
    end

    # Test bad input
    pm_dict = PowerSystems.parse_file(joinpath(PSSE_RAW_DIR, files[1]))
    pm_dict["bus"] = Dict{String, Any}()
    @test_throws PowerSystems.DataFormatError PowerSystems.pm2ps_dict(pm_dict)
end
