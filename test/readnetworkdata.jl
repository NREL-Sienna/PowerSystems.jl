
if is_linux() || is_apple()
    include("../data_files/data_5bus.jl")
    include("../data_files/data_14bus.jl")
end

if is_windows()
    include("..\\data_files\\data_5bus.jl")
    include("..\\data_files\\data_14bus.jl")
end

true

