function BusIslandCheck(buses::Array{Bus}, branches::Array{T,1}) where {T <: Branch}
    nb = length(buses)
    # lists of ints of indices for nonzero row and column entries
    # length(fr) = length(to) = length(os)
    fr = [branch.connectionpoints[1].number for branch in branches] # list of indices of branch sending-end buses
    to = [branch.connectionpoints[2].number for branch in branches] # list of indices of branch receiving-end buses
    if !(1 in fr)
        push!(fr, 1)
    end
    if !(1 in to)
        push!(to, 1)
    end
    if !(nb in fr)
        push!(fr, nb)
    end
    if !(nb in to)
        push!(to, nb)
    end
    os = ones(Int64, length(fr)) # should be nb

    #= Find islanded buses =#
    # SparseMatrixCSC{Float64, Int64}
    # print(to, fr, os)
    to_os = sparse(to, os, 1.0)
    fr_os = sparse(fr, os, 1.0)
    # print(to_os, '\n', fr_os)
    diag = full(to_os + fr_os)
    diag = reshape(diag, length(diag))
    # nib = length(diag) - countnz(diag)
    islanded_buses = []
    for bus_i in [1:nb;]
        if diag[bus_i] == 0
            push!(islanded_buses, bus_i)
        end
    end

    if !isempty(islanded_buses)
        error("Islands:\n")
        for bus in islanded_buses
            print(bus)
        end
    end

    #= Find islanded areas =#
    # temp = sparse(fr+to+fr+to, to+fr+fr+to, 1.0)
    # cons = temp[1, :]
    # nelm = length(cons.J)
    # conn = sparse([], [], [])
    # island_sets = []



end