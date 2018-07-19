files = readdir(joinpath(Pkg.dir(),"PowerSystems/data/matpower"))
file_ext = r".*?\.(\w+)"

if length(files) == 0
    error("No test files in the folder")
end

for f in files
    try
        ext = match(file_ext, f)
        print("Parsing $f ...\n")
        pm_dict = ParseStandardFiles(joinpath(Pkg.dir(),"PowerSystems/data/matpower",f))
        println("Successfully parsed $f to PowerModels dict")
        ps_dict = PowerSystems.pm2ps_dict(pm_dict)
        println("Successfully parsed $f to PowerSystems dict")
        Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts = PowerSystems.ps_dict2ps_struct(ps_dict)
        println("Successfully parsed $f to PowerSystems devices")
        sys_test = PowerSystem(Buses, Generators,Loads,Branches,Storage,230.0,ps_dict["baseMVA"]) # TODO: Add DClines, Shunts , LoadZones
        println("Successfully parsed $f to PowerSystem struct")
    catch
        warn("Error while parsing $f")
        catch_stacktrace()
    end
end

files = readdir(joinpath(Pkg.dir(),"PowerSystems/data/psse_raw"))
file_ext = r".*?\.(\w+)"

if length(files) == 0
    error("No test files in the folder")
end

for f in files
    try
        ext = match(file_ext, f)
        print("Parsing $f ...\n")
        ParseStandardFiles(joinpath(Pkg.dir(),"PowerSystems/data/psse_raw",f))
        println("Successfully parsed $f")
    catch
        warn("Error while parsing $f")
        catch_stacktrace()
    end
end

true