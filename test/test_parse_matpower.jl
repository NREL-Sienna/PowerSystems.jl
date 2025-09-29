# TODO: Reviewers: Is this a correct list of keys to verify?
POWER_MODELS_KEYS = [
    "baseMVA",
    "branch",
    "bus",
    "dcline",
    "gen",
    "load",
    "name",
    "per_unit",
    "shunt",
    "source_type",
    "source_version",
    "storage",
]

badfiles = Dict("case30.m" => PSY.InvalidValue)
voltage_inconsistent_files = ["RTS_GMLC_original.m", "case5_re.m", "case5_re_uc.m"]
error_log_files = ["ACTIVSg2000.m", "case_ACTIVSg10k.m"]

@testset "Parse Matpower data files" begin
    files = [x for x in readdir(joinpath(MATPOWER_DIR)) if splitext(x)[2] == ".m"]
    if length(files) == 0
        @error "No test files in the folder"
    end

    for f in files
        @info "Parsing $f..."
        path = joinpath(MATPOWER_DIR, f)

        if f in voltage_inconsistent_files
            continue
        else
            pm_dict = PowerSystems.parse_file(path)
        end

        for key in POWER_MODELS_KEYS
            @test haskey(pm_dict, key)
        end
        @info "Successfully parsed $path to PowerModels dict"

        if f in keys(badfiles)
            @test_logs(
                (:error, r"cannot create Line"),
                match_mode = :any,
                @test_throws(badfiles[f], System(PowerSystems.PowerModelsData(pm_dict)))
            )
        else
            sys = System(PowerSystems.PowerModelsData(pm_dict))
            @info "Successfully parsed $path to System struct"
        end
    end
end

@testset "Parse PowerModel Matpower data files" begin
    files = [
        x for x in readdir(MATPOWER_DIR) if
              splitext(x)[2] == ".m"
    ]
    if length(files) == 0
        @error "No test files in the folder"
    end

    for f in files
        @info "Parsing $f..."
        path = joinpath(MATPOWER_DIR, f)

        if f in voltage_inconsistent_files
            continue
        else
            pm_dict = PowerSystems.parse_file(path)
        end

        for key in POWER_MODELS_KEYS
            @test haskey(pm_dict, key)
        end
        @info "Successfully parsed $path to PowerModels dict"

        if f in keys(badfiles)
            @test_logs(
                (:error, r"cannot create Line"),
                match_mode = :any,
                @test_throws(badfiles[f], System(PowerSystems.PowerModelsData(pm_dict)))
            )
        else
            sys = System(PowerSystems.PowerModelsData(pm_dict))
            @info "Successfully parsed $path to System struct"
        end
    end
end

@testset "Parse Matpower files with voltage inconsistencies" begin
    test_parse = (path) -> begin
        pm_dict = PowerSystems.parse_file(path)

        for key in POWER_MODELS_KEYS
            @test haskey(pm_dict, key)
        end
        @info "Successfully parsed $path to PowerModels dict"
        sys = System(PowerSystems.PowerModelsData(pm_dict))
        @info "Successfully parsed $path to System struct"
        @test isa(sys, System)
    end
    for f in voltage_inconsistent_files
        @info "Parsing $f..."
        path = joinpath(BAD_DATA, f)
        @test_logs (:error,) match_mode = :any test_parse(path)
    end
end
