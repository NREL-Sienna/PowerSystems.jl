cd(string(homedir(),"/.julia/v0.6/PowerSystems/data/matpower"))

files = readdir()
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

cd(string(homedir(),"/.julia/v0.6/PowerSystems/data/psse_raw"))

files = readdir()
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
        ("Error while parsing $f")
        catch_stacktrace()
    end
end

true