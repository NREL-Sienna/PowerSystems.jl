"Convert Tuple to Min Max Named Tuple"
Base.convert(::Type{MinMax}, input::Tuple{Float64, Float64}) =
    (min = input[1], max = input[2])

"Convert Tuple to Up Down Named Tuple"
Base.convert(::Type{UpDown}, input::Tuple{Float64, Float64}) =
    (up = input[1], down = input[2])
