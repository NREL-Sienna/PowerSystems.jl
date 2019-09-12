


#=
# Parse json to dict
#TODO : fix broken data formats
function parse_json(filename,device_names)
    Devices =Dict{String,Any}()
    for name in device_names
        if isfile("$filename/x$name.json")
            temp = Dict()
            open("$filename/x$name.json", "r") do f
            global temp
            dicttxt = readstring(f)  # file information to string
            temp=JSON2.read(dicttxt,Dict{Any,Array{Dict}})  # parse and transform data
            Devices[name] = temp
            end
        end
    end
    return Devices
end
=#
