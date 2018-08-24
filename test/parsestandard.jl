using Memento
Memento.config!(Memento.getlogger("PowerModels.parse_file"), "error")

files = readdir(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower")))
file_ext = r".*?\.(\w+)"

if length(files) == 0
    @error("No test files in the folder")
end

for f in files
    @test @time  try
        ext = match(file_ext, f)
        print("Parsing $f ...\n")
        pm_dict = parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower",f)))
        println("Successfully parsed $f to PowerModels dict")
        ps_dict = PowerSystems.pm2ps_dict(pm_dict)
        println("Successfully parsed $f to PowerSystems dict")
        Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts = PowerSystems.ps_dict2ps_struct(ps_dict)
        println("Successfully parsed $f to PowerSystems devices")
        sys_test = PowerSystem(Buses, Generators,Loads,Branches,Storage,float(ps_dict["baseMVA"])) # TODO: Add DClines, Shunts 
        println("Successfully parsed $f to PowerSystem struct")
        true
    catch
        @warn("error while parsing $f")
    end
end

files = readdir(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/psse_raw")))
file_ext = r".*?\.(\w+)"

if length(files) == 0
    @error("No test files in the folder")
end

for f in files
    @test @time  try
        ext = match(file_ext, f)
        print("Parsing $f ...\n")
        pm_dict = parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower",f)))
        println("Successfully parsed $f to PowerModels dict")
        ps_dict = PowerSystems.pm2ps_dict(pm_dict)
        println("Successfully parsed $f to PowerSystems dict")
        Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts = PowerSystems.ps_dict2ps_struct(ps_dict)
        println("Successfully parsed $f to PowerSystems devices")
        sys_test = PowerSystem(Buses, Generators,Loads,Branches,Storage,float(ps_dict["baseMVA"])) # TODO: Add DClines, Shunts 
        println("Successfully parsed $f to PowerSystem struct")
        true
    catch
        @warn("error while parsing $f")
    end
end

true