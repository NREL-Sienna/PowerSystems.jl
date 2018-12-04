# Reduce the output for "short" print of TimeArray. Because the "show" method
# defined in TimeSeries does not differentiate, the entire function needs to be
# reimplemented here (mostly a direct copy from TimeArray.jl). I suppose we
# could submit a PR upstream. License / acknowledgment needed? JJS 12/4/18


@inline _showval(v::Any) = repr(v)
@inline _showval(v::Number) = string(v)
@inline _showval(v::AbstractFloat) =
    ifelse(isnan(v), "NaN", string(round(v, digits=4)))

"""
calculate the paging

```
> using MarketData
> AAPL  # this function will return `UnitRange{Int64}[1:9, 10:12]`
```
"""
@inline function _showpages(dcol::Int, timewidth::Int, colwidth::Array{Int})
    ret = UnitRange{Int}[]
    c = dcol - timewidth - 4
    last_i = 1
    for i in eachindex(colwidth)
        w = colwidth[i] + 3
        if c - w < 0
            push!(ret, last_i:i-1)
            # next page
            c = dcol - timewidth - 4 - w
            last_i = i
        elseif i == length(colwidth)
            push!(ret, last_i:i)
        else
            c -= w
        end
    end
    ret
end


function printTA(ta::TimeArray, short=false, io::IO=stdout)
    # summary line
    nrow = size(values(ta), 1)
    ncol = size(values(ta), 2)
    print(io, "$(nrow)×$(ncol) $(typeof(ta))")
    if nrow != 0
        println(io, " $(timestamp(ta)[1]) to $(timestamp(ta)[end])")
    else  # e.g. TimeArray(Date[], [])
        return
    end

    if !short
        # calculate column withs
        drow, dcol = displaysize(io)
        res_row    = 7  # number of reserved rows: summary line, lable line
                        # ... etc
        half_row   = floor(Int, (drow - res_row) / 2)
        add_row    = (drow - res_row) % 2

        if nrow > (drow - res_row)
            tophalf = 1:(half_row + add_row)
            bothalf = (nrow - half_row + 1):nrow
            strs = _showval.(@view values(ta)[[tophalf; bothalf], :])
            ts   = @view timestamp(ta)[[tophalf; bothalf]]
        else
            strs = _showval.(values(ta))
            ts   = timestamp(ta)
        end

        colwidth = maximum(
            [textwidth.(string.(colnames(ta)))'; textwidth.(strs);
             fill(5, ncol)'],
            dims = 1)

        # paging
        spacetime = textwidth(string(ts[1]))
        pages = _showpages(dcol, spacetime, colwidth)

        for p ∈ pages
            # row label line
            ## e.g. | Open  | High  | Low   | Close  |
            print(io, "│", " "^(spacetime + 2))
            for (name, w) in zip(colnames(ta)[p], colwidth[p])
                print(io, "│ ", rpad(name, w + 1))
            end
            println(io, "│")
            ## e.g. ├───────┼───────┼───────┼────────┤
            print(io, "├", "─"^(spacetime + 2))
            for w in colwidth[p]
                print(io, "┼", "─"^(w + 2))
            end
            print(io, "┤")

            # timestamp and values line
            if nrow > (drow - res_row)
                for i in tophalf
                    println(io)
                    print(io, "│ ", ts[i], " ")
                    for j in p
                        print(io, "│ ", rpad(strs[i, j], colwidth[j] + 1))
                    end
                    print(io, "│")
                end

                print(io, "\n   \u22EE")

                for i in (length(bothalf) - 1):-1:0
                    i = size(strs, 1) - i
                    println(io)
                    print(io, "│ ", ts[i], " ")
                    for j in p
                        print(io, "│ ", rpad(strs[i, j], colwidth[j] + 1))
                    end
                    print(io, "│")
                end

            else
                for i in 1:nrow
                    println(io)
                    print(io, "│ ", ts[i], " ")
                    for j in p
                        print(io, "│ ", rpad(strs[i, j], colwidth[j] + 1))
                    end
                    print(io, "│")
                end
            end

            if length(pages) > 1 && p != pages[end]
                print(io, "\n\n")
            end
        end  # for p ∈ pages
    end
end
Base.show(io::IO, ta::TimeArray) = printTA(ta, true, io)
Base.show(io::IO, ::MIME"text/plain", ta::TimeArray) = printTA(ta, false, io)
 
