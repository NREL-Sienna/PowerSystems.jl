export update_data!

"recursively applies new_data to data, overwriting information"
function update_data!(data::Dict{String,<:Any}, new_data::Dict{String,<:Any})
    if haskey(data, "per_unit") && haskey(new_data, "per_unit")
        if data["per_unit"] != new_data["per_unit"]
            error("update_data requires datasets in the same units, try make_per_unit and make_mixed_units")
        end
    else
        @warn "running update_data with data that does not include per_unit field, units may be incorrect"
    end
    _update_data!(data, new_data)
end


"recursive call of _update_data"
function _update_data!(data::Dict{String,<:Any}, new_data::Dict{String,<:Any})
    for (key, new_v) in new_data
        if haskey(data, key)
            v = data[key]
            if isa(v, Dict) && isa(new_v, Dict)
                _update_data!(v, new_v)
            else
                data[key] = new_v
            end
        else
            data[key] = new_v
        end
    end
end

"checks if a given network data is a multinetwork"
ismultinetwork(data::Dict{String,<:Any}) =
    (haskey(data, "multinetwork") && data["multinetwork"] == true)

"Transforms a single network into a multinetwork with several deepcopies of the original network"
function im_replicate(sn_data::Dict{String,<:Any}, count::Int, global_keys::Set{String})
    @assert count > 0
    if ismultinetwork(sn_data)
        error("replicate can only be used on single networks")
    end

    name = get(sn_data, "name", "anonymous")

    mn_data = Dict{String,Any}("nw" => Dict{String,Any}())

    mn_data["multinetwork"] = true

    sn_data_tmp = deepcopy(sn_data)
    for k in global_keys
        if haskey(sn_data_tmp, k)
            mn_data[k] = sn_data_tmp[k]
        end

        # note this is robust to cases where k is not present in sn_data_tmp
        delete!(sn_data_tmp, k)
    end

    mn_data["name"] = "$(count) replicates of $(name)"

    for n in 1:count
        mn_data["nw"]["$n"] = deepcopy(sn_data_tmp)
    end

    return mn_data
end



#=
"Attempts to determine if the given data is a component dictionary"
function _iscomponentdict(data::Dict)
    return all( typeof(comp) <: Dict for (i, comp) in data )
end
=#

"Makes a string bold in the terminal"
function _bold(s::String)
    return "\033[1m$(s)\033[0m"
end

"""
Makes a string grey in the terminal, does not seem to work well on Windows terminals
more info can be found at https://en.wikipedia.org/wiki/ANSI_escape_code
"""
function _grey(s::String)
    return "\033[38;5;239m$(s)\033[0m"
end

"converts any value to a string, summarizes arrays and dicts"
function _value2string(v, float_precision::Int)
    if typeof(v) <: AbstractFloat
        return _float2string(v, float_precision)
    end
    if typeof(v) <: Array
        return "[($(length(v)))]"
    end
    if typeof(v) <: Dict
        return "{($(length(v)))}"
    end

    return "$(v)"
end


"""
converts a float value into a string of fixed precision

sprintf would do the job but this work around is needed because
sprintf cannot take format strings during runtime
"""
function _float2string(v::AbstractFloat, float_precision::Int)
    #str = "$(round(v; digits=float_precision))"
    str = "$(round(v; digits=float_precision))"
    lhs = length(split(str, '.')[1])
    return rpad(str, lhs + 1 + float_precision, "0")
end



"tests if two dicts are equal, up to floating point precision"
function compare_dict(d1, d2)
    for (k1, v1) in d1
        if !haskey(d2, k1)
            #println(k1)
            return false
        end
        v2 = d2[k1]

        if isa(v1, Number)
            if !_compare_numbers(v1, v2)
                return false
            end
        elseif isa(v1, Array)
            if length(v1) != length(v2)
                return false
            end
            for i in 1:length(v1)
                if isa(v1[i], Number)
                    if !_compare_numbers(v1[i], v2[i])
                        return false
                    end
                else
                    if v1 != v2
                        #println(v1, " ", v2)
                        return false
                    end
                end
            end
        elseif isa(v1, Dict)
            if !compare_dict(v1, v2)
                #println(v1, " ", v2)
                return false
            end
        else
            #println("2")
            if !isapprox(v1, v2)
                #println(v1, " ", v2)
                return false
            end
        end
    end
    return true
end


"tests if two numbers are equal, up to floating point precision"
function _compare_numbers(v1, v2)
    if isnan(v1)
        #println("1.1")
        if !isnan(v2)
            #println(v1, " ", v2)
            return false
        end
    else
        #println("1.2")
        if !isapprox(v1, v2)
            #println(v1, " ", v2)
            return false
        end
    end
    return true
end
