export update_data!

"recursively applies new_data to data, overwriting information"
function update_data!(data::Dict{String,Any}, new_data::Dict{String,Any})
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
function _update_data!(data::Dict{String,Any}, new_data::Dict{String,Any})
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
ismultinetwork(data::Dict{String,Any}) = (haskey(data, "multinetwork") && data["multinetwork"] == true)

"Transforms a single network into a multinetwork with several deepcopies of the original network"
function im_replicate(sn_data::Dict{String,Any}, count::Int; global_keys::Set{String} = Set{String}())
    @assert count > 0
    if ismultinetwork(sn_data)
        error("replicate can only be used on single networks")
    end

    if length(global_keys) <= 0
        @warn "deprecation warning, calls to replicate should explicitly specify a set of global_keys"
        # old default
        for (k,v) in sn_data
             if !(typeof(v) <: Dict)
                @warn "adding global key $(k)"
                push!(global_keys, k)
             end
        end
    end

    name = get(sn_data, "name", "anonymous")

    mn_data = Dict{String,Any}(
        "nw" => Dict{String,Any}()
    )

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



"builds a table of component data"
function component_table(data::Dict{String,Any}, component::String, fields::Vector{String})
    if ismultinetwork(data)
        return Dict((i, _component_table(nw_data, component, fields)) for (i,nw_data) in data["nw"])
    else
        return _component_table(data, component, fields)
    end
end
component_table(data::Dict{String,Any}, component::String, field::String) = component_table(data, component, [field])

function _component_table(data::Dict{String,Any}, component::String, fields::Vector{String})
    comps = data[component]
    if !_iscomponentdict(comps)
        @error "$(component) does not appear to refer to a component list"
    end

    items = []
    sorted_comps = sort(collect(comps); by=x->parse(Int, x[1]))
    for (i,comp) in sorted_comps
        push!(items, parse(Int, i))
    end
    for key in fields
        for (i,comp) in sorted_comps
            if haskey(comp, key)
                push!(items, comp[key])
            else
                push!(items, NaN)
            end
        end
    end

    return reshape(items, length(comps), length(fields)+1)
end

#=
"prints the text summary for a data dictionary to stdout"
function print_summary(obj::Dict{String,Any}; kwargs...)
    summary(stdout, obj; kwargs...)
end


"prints the text summary for a data dictionary to IO"
function summary(io::IO, data::Dict{String,Any};
    float_precision::Int = 3,
    component_types_order = Dict(),
    component_parameter_order = Dict(),
    max_parameter_value = 999.0,
    component_status_parameters = Set(["status"])
    )

    if ismultinetwork(data)
        error("summary does not yet support multinetwork data")
    end

    component_types = []
    other_types = []

    println(io, _bold("Metadata"))
    for (k,v) in sort(collect(data); by=x->x[1])
        if typeof(v) <: Dict && _iscomponentdict(v)
            push!(component_types, k)
            continue
        end

        println(io, "  $(k): $(_value2string(v, float_precision))")
    end


    if length(component_types) > 0
        println(io, "")
        println(io, _bold("Table Counts"))
    end
    for k in sort(component_types, by=x->get(component_types_order, x, max_parameter_value))
        println(io, "  $(k): $(length(data[k]))")
    end

    for comp_type in sort(component_types, by=x->get(component_types_order, x, max_parameter_value))
        if length(data[comp_type]) <= 0
            continue
        end
        println(io, "")
        println(io, "")
        println(io, _bold("Table: $(comp_type)"))

        components = data[comp_type]

        display_components = Dict()
        active_components = Set()
        for (i, component) in components
            disp_comp = copy(component)

            status_found = false
            for (k, v) in disp_comp
                if k in component_status_parameters
                    status_found = true
                    if !(v == 0)
                        push!(active_components, i)
                    end
                end

                disp_comp[k] = _value2string(v, float_precision)
            end
            if !status_found
                push!(active_components, i)
            end

            display_components[i] = disp_comp
        end


        comp_key_sizes = Dict{String, Int}()
        default_values = Dict{String, Any}()
        for (i, component) in display_components
            # a special case for "index", for example when reading solution data
            if haskey(comp_key_sizes, "index")
                comp_key_sizes["index"] = max(comp_key_sizes["index"], length(i))
            else
                comp_key_sizes["index"] = length(i)
            end

            for (k, v) in component
                if haskey(comp_key_sizes, k)
                    comp_key_sizes[k] = max(comp_key_sizes[k], length(v))
                else
                    comp_key_sizes[k] = length(v)
                end

                if haskey(default_values, k)
                    if default_values[k] != v
                        default_values[k] = nothing
                    end
                else
                    default_values[k] = v
                end
            end
        end

        # when there is only one component nothing is default
        if length(display_components) == 1
            default_values = Dict{String, Any}()
        else
            default_values = Dict{String, Any}([x for x in default_values if !isa(x.second, Nothing)])
        end

        #display(default_values)

        # account for header width
        for (k, v) in comp_key_sizes
            comp_key_sizes[k] = max(length(k), v)
        end

        comp_id_pad = comp_key_sizes["index"] # not clear why this is offset so much
        delete!(comp_key_sizes, "index")
        comp_keys_ordered = sort([k for k in keys(comp_key_sizes) if !(haskey(default_values, k))], by=x->(get(component_parameter_order, x, max_parameter_value), x))

        header = join([lpad(k, comp_key_sizes[k]) for k in comp_keys_ordered], ", ")

        pad = " "^(comp_id_pad+2)
        println(io, "  $(pad)$(header)")
        for k in sort([k for k in keys(display_components)]; by=x->parse(Int, x))
            comp = display_components[k]
            items = []
            for ck in comp_keys_ordered
                if haskey(comp, ck)
                    push!(items, lpad("$(comp[ck])", comp_key_sizes[ck]))
                else
                    push!(items, lpad("--", comp_key_sizes[ck]))
                end
            end
            line = "  $(lpad(k, comp_id_pad)): $(join(items, ", "))"
            if k in active_components
                println(io, line)
            else
                println(io, _grey(line))
            end
        end

        if length(default_values) > 0
            println(io, "")
            println(io, "  default values:")
            for k in sort([k for k in keys(default_values)], by=x->(get(component_parameter_order, x, max_parameter_value), x))
                println(io, "    $(k): $(default_values[k])")
            end
        end
    end

end
=#

"Attempts to determine if the given data is a component dictionary"
function _iscomponentdict(data::Dict)
    return all( typeof(comp) <: Dict for (i, comp) in data )
end

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
    for (k1,v1) in d1
        if !haskey(d2, k1)
            #println(k1)
            return false
        end
        v2 = d2[k1]

        if isa(v1, Number)
            if !compare_numbers(v1, v2)
                return false
            end
        elseif isa(v1, Array)
            if length(v1) != length(v2)
                return false
            end
            for i in 1:length(v1)
                if isa(v1[i], Number)
                    if !compare_numbers(v1[i], v2[i])
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

#function Base.isapprox(a::Any, b::Any; kwargs...)
#    return a == b
#end

"tests if two numbers are equal, up to floating point precision"
function compare_numbers(v1, v2)
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

