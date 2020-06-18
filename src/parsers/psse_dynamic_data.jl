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

function add_dynamics(system::System, file::AbstractString)
    parsed_values = parse_dyr_file(file)
    for g in get_components(Generator, system)
        bus_no = get_number(get_bus(g))
        for dev in parsed_values(bus_no)
            dyn_gen = make_generator(dev)
            set_dynamic_injector!(g, dyn_gen)
        end
    end
    return
end

function read_yaml(file)
    open(file) do io
        data = YAML.load(io)
        return data
    end
end


function parse_dyr_components(data::Dict, yaml_file::String)
    yaml_mapping = read_yaml(yaml_file)
    param_mapping = yaml_mapping["parameter_mapping"][1]

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
            #Only create if name is in supported_types
            if componentID[1] in keys(yaml_mapping)
                components_dict = yaml_mapping[componentID[1]][1]
                for (gen_field, struct_as_str) in components_dict
                    params_ix = param_map[struct_as_str]
                     if occursin("Shaft", struct_as_str)
                        temp[2] = make_shaft(params_ix, componentValues)
                        continue
                     end
                    component_constructor = (args...) -> InteractiveUtils.getfield(
                                        PowerSystems, Symbol(struct_as_str))(args...)
                    struct_args = populate_args(params_ix, componentValues)
                    temp[component_table[gen_field]] = component_constructor(struct_args...)
                end
            #else
            #    @warn "$(componentID[1]) not supported yet"                
            end
            for va in values(bus_dict)
               !isassigned(va, component_table["AVR"]) && (va[component_table["AVR"]] = PSY.AVRFixed(1.0))
                !isassigned(va, component_table["TurbineGov"]) && (va[component_table["TurbineGov"]] = PSY.TGFixed(1.0))
               !isassigned(va, component_table["PSS"]) && (va[component_table["PSS"]] = PSY.PSSFixed(0.0))
            end
        end
        temp2 = Dict()
        for (ix, g) in bus_dict
            temp2[ix] = DynamicGenerator(
                    ThermalStandard(nothing),
                    1.0,
                    g...)
        end
        dic[k] = temp2
    end
    return dic
end

function make_generator(Dict)
    genmap = open(filename) do file
        YAML.load(file)
    end
end
