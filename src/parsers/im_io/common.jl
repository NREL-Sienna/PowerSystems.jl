
"turns top level arrays into dicts"
function arrays_to_dicts!(data::Dict{String, <:Any})
    # update lookup structure
    for (k, v) in data
        if isa(v, Array) && length(v) > 0 && isa(v[1], Dict)
            #println("updating $(k)")
            dict = Dict{Int, Any}()
            for (i, item) in enumerate(v)
                if haskey(item, "index")
                    key = item["index"]
                else
                    key = i
                end

                if !(haskey(dict, key))
                    dict[key] = item
                else
                    @warn "skipping component $(item["index"]) from the $(k) table because a component with the same id already exists"
                end
            end
            data[k] = dict
        end
    end
end

"takes a row from a matrix and assigns the values names and types"
function row_to_typed_dict(row_data, columns)
    dict_data = Dict{String, Any}()
    for (i, v) in enumerate(row_data)
        if i <= length(columns)
            name, typ = columns[i]
            dict_data[name] = check_type(typ, v)
        else
            dict_data["col_$(i)"] = v
        end
    end
    return dict_data
end

"takes a row from a matrix and assigns the values names"
function row_to_dict(row_data, columns)
    dict_data = Dict{String, Any}()
    for (i, v) in enumerate(row_data)
        if i <= length(columns)
            dict_data[columns[i]] = v
        else
            dict_data["col_$(i)"] = v
        end
    end
    return dict_data
end

row_to_dict(row_data) = row_to_dict(row_data, [])
