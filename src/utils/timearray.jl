# Utilities for `TimeArray`.


"""
Align two timeseries according to their times, padding values from earlier times.

# Arguments
- `x: TimeArray{X,1,T,Array{X,1}}`: the first timeseries
- `y: TimeArray{Y,1,T,Array{Y,1}}`: the first timeseries

# Example
```
x = TimeArray(
    [Time(0), Time(1), Time(3), Time(5)],
    [    0.1,     1.1,     3.1,     5.1]
)
y = TimeArray(
    [Time(0), Time(1), Time(2), Time(5), Time(6)],
    [    0.1,     1.1,     2.1,     5.1,     6.1]
)
z = align(x, y)
```
"""
function align(x :: TimeArray{X,1,T,Array{X,1}}, y :: TimeArray{Y,1,T,Array{Y,1}}) :: TimeArray{Tuple{X,Y},1,T,Array{Tuple{X,Y},1}} where X where Y where T <: TimeType
    nx = length(x)
    ny = length(y)
    ix = 1
    iy = 1
    xt = timestamp(x)
    yt = timestamp(y)
    zt = Array{T,1}()
    xv = values(x)
    yv = values(y)
    zv = Array{Tuple{X,Y},1}()
    if nx == 0 || ny == 0
        throw(ArgumentError("align: TimeArrays must not be empty."))
    elseif xt[1] != yt[1]
        throw(ArgumentError("align: TimeArrays must start at the same timestamp."))
    end
    while ix <= nx || iy <= ny
        if ix <= nx && (iy > ny || xt[ix] < yt[iy])
            push!(zt, xt[ix])
            push!(zv, (xv[ix], yv[iy-1]))
            ix = ix + 1
        elseif iy <= ny && (ix > nx || xt[ix] > yt[iy])
            push!(zt, yt[iy])
            push!(zv, (xv[ix-1], yv[iy]))
            iy = iy + 1
        else
            push!(zt, xt[ix])
            push!(zv, (xv[ix], yv[iy]))
            ix = ix + 1
            iy = iy + 1
        end
    end
    TimeArray(zt, zv)
end
