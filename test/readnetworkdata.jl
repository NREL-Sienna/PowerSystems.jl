
if is_linux() || is_apple()
    include("../data/data_5bus.jl")
    include("../data/data_14bus.jl")
end

if is_windows()
    include("..\\data\\data_5bus.jl")
    include("..\\data\\data_14bus.jl")
end

true

