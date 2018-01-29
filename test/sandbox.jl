const LOCAL_PACKAGES = expanduser("~/Dropbox/Remote Code Rep/PowerSchema/src")
push!(LOAD_PATH, LOCAL_PACKAGES)
using PowerSchema

include("data_files/data_5bus.jl")
include("data_files/data_14bus.jl")

struct GenSimple 
    WN::Float64
    H::Float64
    model::Function
    function GenSimple(WN,H) 
        new(WN, H, x-> x*WN^2+ x^2)
    end
end