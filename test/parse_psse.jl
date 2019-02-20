@time @testset "PSSE Parsing " begin
    files = readdir(PSSE_RAW_DIR)
    if length(files) == 0
        @error "No test files in the folder"
    end

    for f in files
        @info "Parsing $f ..."
        pm_dict = PowerSystems.parse_file(joinpath(PSSE_RAW_DIR, f))
        @info "Successfully parsed $f to PowerModels dict"
        PowerSystems.make_mixed_units(pm_dict)
        @info "Successfully converted $f to mixed_units"
        ps_dict = PowerSystems.pm2ps_dict(pm_dict)
        @info "Successfully parsed $f to PowerSystems dict"
        Buses, Generators, Storage, Branches, Loads, LoadZones, Shunts =
            PowerSystems.ps_dict2ps_struct(ps_dict)
        @info "Successfully parsed $f to PowerSystems devices"
        sys_test = PowerSystem(Buses, Generators, Loads, Branches, Storage,
            float(ps_dict["baseMVA"])) # TODO: Add DClines, Shunts
        @info "Successfully parsed $f to PowerSystem struct"
    end
end
