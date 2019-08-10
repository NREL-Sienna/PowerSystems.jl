
include(joinpath(@__DIR__, "../src/utils/data.jl"))
import .UtilsData: TestData

download(TestData; branch = "improve-timeseries")

@show abspath(".")

script_name = joinpath(@__DIR__, "../bin", "generate_valid_config_file.py")

config_name = joinpath(@__DIR__, "../src", "descriptors", "validation_config.json")

descriptor_name = joinpath(@__DIR__, "../src", "descriptors", "power_system_structs.json")

#read(`python3 $script_name $config_name $descriptor_name`)
