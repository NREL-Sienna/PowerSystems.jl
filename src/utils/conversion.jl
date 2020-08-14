"Convert Tuple to Min Max Named Tuple"
Base.convert(::Type{Min_Max}, input::Tuple{Float64, Float64}) = (min = input[1], max = input[2])

"Convert Tuple to Up Down Named Tuple"
Base.convert(::Type{Up_Down}, input::Tuple{Float64, Float64}) = (up = input[1], down = input[2])