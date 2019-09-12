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

badfiles = Dict("case30.m" => ArgumentError)

@testset "Parse Matpower data files" begin
    files = [x for x in readdir(joinpath(MATPOWER_DIR)) if splitext(x)[2] == ".m"]
    if length(files) == 0
        @error "No test files in the folder"
    end

    for f in files
        @info "Parsing $f..."
        path = joinpath(MATPOWER_DIR, f)

        pm_dict = PowerSystems.parse_file(path)
        for key in POWER_MODELS_KEYS
            @test haskey(pm_dict, key)
        end
        @info "Successfully parsed $path to PowerModels dict"

        if f in keys(badfiles)
            @test_throws badfiles[f] PowerSystems.pm2ps_dict(pm_dict)
        else
            sys = PowerSystems.pm2ps_dict(pm_dict)
            @info "Successfully parsed $path to System struct"
        end
    end
end

@testset "Parse PowerModel Matpower data files" begin
    files = [x for x in readdir(joinpath(DATA_DIR, "pm_data","matpower")) if splitext(x)[2] == ".m"]
    if length(files) == 0
        @error "No test files in the folder"
    end

    for f in files
        @info "Parsing $f..."
        path = joinpath(joinpath(DATA_DIR, "pm_data","matpower"), f)

        pm_dict = PowerSystems.parse_file(path)
        for key in POWER_MODELS_KEYS
            @test haskey(pm_dict, key)
        end
        @info "Successfully parsed $path to PowerModels dict"

        if f in keys(badfiles)
            @test_throws badfiles[f] PowerSystems.pm2ps_dict(pm_dict)
        else
            sys = PowerSystems.pm2ps_dict(pm_dict)
            @info "Successfully parsed $path to System struct"
        end
    end
end
