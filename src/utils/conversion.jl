"Convert Tuple to Min Max Named Tuple"
Base.convert(::Type{Min_Max}, input::Tuple{Float64, Float64}) = Min_Max(input[1], input[2])

"Convert Tuple to Up Down Named Tuple"
Base.convert(::Type{Up_Down}, input::Tuple{Float64, Float64}) = Up_Down(input[1], input[2])
