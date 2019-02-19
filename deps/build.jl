
include(joinpath(@__DIR__, "../src/utils/data.jl"))
import .UtilsData: TestData

download(TestData)
