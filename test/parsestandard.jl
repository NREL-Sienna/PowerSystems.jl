setlevel!(getlogger(InfrastructureModels), "error")
setlevel!(getlogger(PowerModels), "error")

files = readdir(joinpath(Pkg.dir(),"PowerSystems/data/matpower"))
file_ext = r".*?\.(\w+)"

if length(files) == 0
    error("No test files in the folder")
end

for f in files
    try
        ext = match(file_ext, f)
        print("Parsing $f ...\n")
        ParseStandardFiles(f)
        println("Successfully parsed $f")
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
        ParseStandardFiles(f)
        println("Successfully parsed $f")
    catch
        warn("Error while parsing $f")
        catch_stacktrace()
    end
end

true