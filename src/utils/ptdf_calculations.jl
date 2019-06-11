function _buildptdf(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1]) where {T<:ACBranch}

    buscount = length(nodes)
    linecount = length(branches)
    num_bus = Dict{Int,Int}()

    for (ix,b) in enumerate(nodes)
        num_bus[b.number] = ix
    end

    A = zeros(Float64,buscount,linecount);
    inv_X = zeros(Float64,linecount,linecount);

   #build incidence matrix
   #incidence_matrix = A

    for (ix,b) in enumerate(branches)

        if isa(b,DCBranch)
            @warn("PTDF construction ignores DC-Lines")
            continue
        end

        A[num_bus[b.connectionpoints.from.number], ix] =  1;

        A[num_bus[b.connectionpoints.to.number], ix] = -1;

        if isa(b,Transformer2W)
            inv_X[ix,ix] = 1/b.x;

        elseif isa(b,TapTransformer)
            inv_X[ix,ix] = 1/(b.x*b.tap);

        elseif isa(b, Line)
            inv_X[ix,ix] = 1/b.x;

        elseif isa(b,PhaseShiftingTransformer)
            y = 1 / (b.r + b.x * 1im)
            y_a = y / (b.tap * exp(b.α * 1im * (π / 180)))
            inv_X[ix,ix] = 1/imag(y_a)
        end

    end
    slacks = [num_bus[n.number] for n in nodes if n.bustype == SF::BusType]
    slack_position = slacks[1]
    B = gemm('N','T', gemm('N','N',A[setdiff(1:end, slack_position),1:end] ,inv_X), A[setdiff(1:end, slack_position),1:end])
    if dist_slack[1] == 0.1 && length(dist_slack) ==1
        (B, bipiv, binfo) = getrf!(B)
        S_ = gemm('N','N', gemm('N','T', inv_X, A[setdiff(1:end, slack_position), :]), getri!(B, bipiv) )
        S = hcat(S_[:,1:slack_position-1],zeros(linecount,),S_[:,slack_position:end])

    elseif dist_slack[1] != 0.1 && length(dist_slack)  == buscount
        @info "Distributed bus"
        (B, bipiv, binfo) = getrf!(B)
        S_ = gemm('N','N', gemm('N','T', inv_X, A[setdiff(1:end, slack_position), :]), getri!(B, bipiv) )
        S = hcat(S_[:,1:slack_position-1],zeros(linecount,),S_[:,slack_position:end])
        slack_array =dist_slack/sum(dist_slack)
        slack_array = reshape(slack_array,buscount,1)
        S = S - gemm('N','N',gemm('N','N',S,slack_array),ones(1,buscount))

    elseif length(slack_position) == 0
        @warn("Slack bus not identified in the Bus/Nodes list, can't build PTDF")
        S = Array{Float64,2}(undef,linecount,buscount)
    end

    return  S, A

end


#  The container code for PTDF is based in JuMP's PTDFContainer in order to
#  remove the limitations of AxisArrays and the doubts about long term maintenance
#  https://github.com/JuliaOpt/JuMP.jl/blob/master/src/Containers/DenseAxisArray.jl
#  JuMP'sCopyright 2017, Iain Dunning, Joey Huchette, Miles Lubin, and contributors
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0.

function _make_ax_ref(ax::Vector)
    ref = Dict{eltype(ax),Int}()
    for (ix,el) in enumerate(ax)
        if haskey(ref, el)
            @error("Repeated index element $el. Index sets must have unique elements.")
        end
        ref[el] = ix
    end
    return ref
end


struct PTDF <: AbstractArray{Float64,2}
    data::Array{Float64,2}
    axes::NTuple{2,Array}
    lookup::NTuple{2,Dict}
end

function PTDF(branches::Array{T}, nodes::Array{Bus}, dist_slack::Array{Float64}=[0.1]) where {T<:ACBranch}

    #Get axis names
    line_ax = [branch.name for branch in branches]
    bus_ax = [bus.number for bus in nodes]
    S, A = _buildptdf(branches, nodes, dist_slack)

    axes = (line_ax, bus_ax)
    look_up = (_make_ax_ref(line_ax),_make_ax_ref(bus_ax))

    return PTDF(S, axes, look_up)

end

# AbstractArray interface
Base.isempty(A::PTDF) = isempty(A.data)
Base.size(A::PTDF) = size(A.data)
Base.LinearIndices(A::PTDF) = error("PTDF does not support this operation.")
Base.axes(A::PTDF) = A.axes
Base.CartesianIndices(a::PTDF) = error("PTDF does not support this operation.")

############
# Indexing #
############

Base.eachindex(A::PTDF) = CartesianIndices(size(A.data))

lookup_index(i, lookup::Dict) = isa(i, Colon) ? Colon() : lookup[i]

# Lisp-y tuple recursion trick to handle indexing in a nice type-
# stable way. The idea here is that `_to_index_tuple(idx, lookup)`
# performs a lookup on the first element of `idx` and `lookup`,
# then recurses using the remaining elements of both tuples.
# The compiler knows the lengths and types of each tuple, so
# all of the types are inferable.
function _to_index_tuple(idx::Tuple, lookup::Tuple)
    tuple(lookup_index(first(idx), first(lookup)),
          _to_index_tuple(Base.tail(idx), Base.tail(lookup))...)
end

# Handle the base case when we have more indices than lookups:
function _to_index_tuple(idx::NTuple{N}, ::NTuple{0}) where {N}
    ntuple(k -> begin
        i = idx[k]
        (i == 1) ? 1 : error("invalid index $i")
    end, Val(N))
end

# Handle the base case when we have fewer indices than lookups:
_to_index_tuple(idx::NTuple{0}, lookup::Tuple) = ()

# Resolve ambiguity with the above two base cases
_to_index_tuple(idx::NTuple{0}, lookup::NTuple{0}) = ()

to_index(A::PTDF, idx...) = _to_index_tuple(idx, A.lookup)

# Doing `Colon() in idx` is relatively slow because it involves
# a non-unrolled loop through the `idx` tuple which may be of
# varying element type. Another lisp-y recursion trick fixes that
has_colon(idx::Tuple{}) = false
has_colon(idx::Tuple) = isa(first(idx), Colon) || has_colon(Base.tail(idx))

# TODO: better error (or just handle correctly) when user tries to index with a range like a:b
# The only kind of slicing we support is dropping a dimension with colons
function Base.getindex(A::PTDF, idx...)
    #=
    if has_colon(idx)
        PTDF(A.data[to_index(A,idx...)...], (ax for (i,ax) in enumerate(A.axes) if idx[i] == Colon())...)
    else
        return A.data[to_index(A,idx...)...]
    end
    =#
    return A.data[to_index(A,idx...)...]
end
Base.getindex(A::PTDF, idx::CartesianIndex) = A.data[idx]
Base.setindex!(A::PTDF, v, idx...) = A.data[to_index(A,idx...)...] = v
Base.setindex!(A::PTDF, v, idx::CartesianIndex) = A.data[idx] = v

Base.IndexStyle(::Type{PTDF}) = IndexAnyCartesian()


########
# Keys #
########

struct PTDFKey{T<:Tuple}
    I::T
end
Base.getindex(k::PTDFKey, args...) = getindex(k.I, args...)

struct PTDFKeys{T<:Tuple}
    product_iter::Base.Iterators.ProductIterator{T}
end
Base.length(iter::PTDFKeys) = length(iter.product_iter)
function Base.eltype(iter::PTDFKeys)
    return PTDFKey{eltype(iter.product_iter)}
end
function Base.iterate(iter::PTDFKeys)
    next = iterate(iter.product_iter)
    return next == nothing ? nothing : (PTDFKey(next[1]), next[2])
end
function Base.iterate(iter::PTDFKeys, state)
    next = iterate(iter.product_iter, state)
    return next == nothing ? nothing : (PTDFKey(next[1]), next[2])
end
function Base.keys(a::PTDF)
    return PTDFKeys(Base.Iterators.product(a.axes...))
end
Base.getindex(a::PTDF, k::PTDFKey) = a[k.I...]

########
# Show #
########

# Adapted printing from JuMP's implementation of the Julia's show.jl
# used in PTDFs

# Copyright (c) 2009-2016: Jeff Bezanson, Stefan Karpinski, Viral B. Shah,
# and other contributors:
#
# https://github.com/JuliaLang/julia/contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

function Base.summary(io::IO, A::PTDF)
    _summary(io, A)
    for (k,ax) in enumerate(A.axes)
        print(io, "    Dimension $k, ")
        show(IOContext(io, :limit=>true), ax)
        println(io)
    end
    print(io, "And data, a ", size(A.data))
end
_summary(io::IO, A::PTDF) = println(io, "PTDF Matrix")

function Base.summary(io::IOContext{Base.GenericIOBuffer{Array{UInt8,1}}}, ::PTDF)
    println(io, "PTDF Matrix")
end

function Base.summary(A::PTDF)
    io = IOBuffer()
    Base.summary(io, A)
    String(take!(io))
end

if isdefined(Base, :print_array) # 0.7 and later
    Base.print_array(io::IO, X::PTDF) = Base.print_matrix(io, X.data)
end

# n-dimensional arrays
function Base.show_nd(io::IO, a::PTDF, print_matrix::Function, label_slices::Bool)
    limit::Bool = get(io, :limit, false)
    if isempty(a)
        return
    end
    tailinds = Base.tail(Base.tail(axes(a.data)))
    nd = ndims(a)-2
    for I in CartesianIndices(tailinds)
        idxs = I.I
        if limit
            for i = 1:nd
                ii = idxs[i]
                ind = tailinds[i]
                if length(ind) > 10
                    if ii == ind[4] && all(d->idxs[d]==first(tailinds[d]),1:i-1)
                        for j=i+1:nd
                            szj = size(a.data,j+2)
                            indj = tailinds[j]
                            if szj>10 && first(indj)+2 < idxs[j] <= last(indj)-3
                                @goto skip
                            end
                        end
                        #println(io, idxs)
                        print(io, "...\n\n")
                        @goto skip
                    end
                    if ind[3] < ii <= ind[end-3]
                        @goto skip
                    end
                end
            end
        end
        if label_slices
            print(io, "[:, :, ")
            for i = 1:(nd-1); show(io, a.axes[i+2][idxs[i]]); print(io,", "); end
            show(io, a.axes[end][idxs[end]])
            println(io, "] =")
        end
        slice = view(a.data, axes(a.data,1), axes(a.data,2),
                     idxs...)
        Base.print_matrix(io, slice)
        print(io, idxs == map(last,tailinds) ? "" : "\n\n")
        @label skip
    end
end

function Base.show(io::IO, array::PTDF)
    summary(io, array)
    isempty(array) && return
    println(io, ":")
    Base.print_array(io, array)
end
