function parse_dyr_file(file::AbstractString)
    dyr_text = read(file, String)
    start = 1
    parsed_values = Dict{Int, Dict}()
    models = Vector{String}()
    while start < length(dyr_text)
        val = findnext('/', dyr_text, start)
        if isnothing(val)
            break
        end
        line = replace(dyr_text[start:(val - 1)], "\'" => "")
        val_array = strip.(split(line))
        bus = parse(Int, val_array[1])
        model = string(val_array[2])
        id = parse(Int, val_array[3])
        component_dict = get!(parsed_values, bus, Dict{Tuple{String, Int}, Array}())
        component_dict[(model, id)] = parse.(Float64, val_array[4:end])
        start = val + 1
    end
    return parsed_values
end

function populate_args(param_map, val)
    struct_args = Vector{Any}(undef, length(param_map))
    for (ix, _v) in enumerate(param_map)
        if isa(_v, Float64)
            struct_args[ix] = _v
        elseif isa(_v, Int64)
            struct_args[ix] = val[_v]
        else
            _t = strip(_v, ['(', ')'])
            _t2int = parse.(Int64, split(_t, ','))
            struct_args[ix] = (val[_t2int[1]], val[_t2int[2]])
        end
    end
    return struct_args
end

function make_shaft(param_map, val)
    constructor_shaft =
        (args...) -> InteractiveUtils.getfield(PowerSystems, :SingleMass)(args...)
    shaft_args = populate_args(param_map, val)
    return constructor_shaft(shaft_args...)
end

function parse_dyr_components(dyr_file::AbstractString)
    data = parse_dyr_file(dyr_file)
    return parse_dyr_components(data)
end

function parse_dyr_components(data::Dict)
    yaml_mapping = open(PSSE_DYR_MAPPING_FILE) do io
        aux = YAML.load(io)
        return aux
    end
    param_map = yaml_mapping["parameter_mapping"][1]

    dic = Dict{Int64, Any}()
    #sizehint!(dic, 435)
    component_table = Dict("Machine" => 1,
         "Shaft" => 2,
         "AVR" => 3,
         "TurbineGov" => 4,
         "PSS" => 5,
        )
    for (k, v) in data
        bus_dict = Dict{Int64, Any}()    
        for (componentID, componentValues) in v
            #Fill array of 5 components per generator
            temp = get!(bus_dict, componentID[2], Vector{Any}(undef, 5))
            #Only create if name is in the supported keys in the mapping
            if componentID[1] in keys(yaml_mapping)
                #Get the component dictionary
                components_dict = yaml_mapping[componentID[1]][1]
                for (gen_field, struct_as_str) in components_dict
                    #Get the parameter indices w/r to componentValues
                    params_ix = param_map[struct_as_str]
                    #Construct Shaft if it appears
                     if occursin("Shaft", struct_as_str)
                        temp[2] = make_shaft(params_ix, componentValues)
                        continue
                     end
                    #Construct Components
                    component_constructor = (args...) -> InteractiveUtils.getfield(
                                        PowerSystems, Symbol(struct_as_str))(args...)
                    struct_args = populate_args(params_ix, componentValues)
                    temp[component_table[gen_field]] = component_constructor(struct_args...)
                end               
            end
            #Assign generic components if there were not provided in Dynamic Data
            for va in values(bus_dict)
                !isassigned(va, component_table["AVR"]) && (va[component_table["AVR"]] = AVRFixed(1.0))
                !isassigned(va, component_table["TurbineGov"]) && (va[component_table["TurbineGov"]] = TGFixed(1.0))
                !isassigned(va, component_table["PSS"]) && (va[component_table["PSS"]] = PSSFixed(0.0))
            end
        end
        #Store dictionary of components in a dictionary indexed by bus
        dic[k] = bus_dict
    end
    return dic
end

function add_dyn_injectors!(sys_file::AbstractString, dyr_file::AbstractString)
    sys = System(sys_file)
    bus_dict_gen = parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
end

function add_dyn_injectors!(sys::System, dyr_file::AbstractString)
    bus_dict_gen = parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
end

function add_dyn_injectors!(sys::System, bus_dict_gen::Dict)
    for g in get_components(ThermalStandard, sys)
        _num = get_number(get_bus(g))
        _name = get_name(g) 
        _id = parse(Int64, split(_name, "-")[end])
        temp_dict = get(bus_dict_gen, _num, nothing)
        if isnothing(temp_dict)
             @warn "Generator at bus $(_num) not found in DynData"
         else
             dyn_gen = DynamicGenerator(
                 g,
                 1.0,
                 temp_dict[_id]...
             )
             add_component!(sys, dyn_gen)
        end
    end
end

