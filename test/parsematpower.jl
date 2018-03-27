cd(string(homedir(),"/.julia/v0.6/PowerSchema/data_files/matpower"))

files = readdir()
file_ext = r".*?\.(\w+)"

if length(files) == 0
    error("No test files in the folder")
end

for f in files
    try
        ext = match(file_ext, f)
        print("Parsing $f ...\n")
        dict_to_struct(matpower_parser(f))
        println("Successfully parsed $f and converted it to the type structure!")
    catch
        warn("Error while parsing $f and converting to the type structure!")
        catch_stacktrace()
    end
end

true