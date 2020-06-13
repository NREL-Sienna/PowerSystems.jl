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

const supported_types = ["GENROU", "GENROE", "GENSAL", "GENSAE"]

function parse_dyr_components(data::Dict, yaml_file::String)
    yaml_mapping = read_yaml(yaml_file)
    type_mapping = yaml_mapping["Machine"][1]
    param_mapping = yaml_mapping["parameter_mapping"][1]

    dic = Dict{Int64, Any}()
    #sizehint!(dic, 435)
    component_table = Dict(
        PSY.Machine => 1,
        PSY.Shaft => 2,
        PSY.AVR => 3,
        PSY.TurbineGov => 4,
        PSY.PSS => 5,
    )
    for (k, v) in data
        bus_dict = Dict{Int64, Any}()
        for (key, val) in v
            temp = get!(bus_dict, key[2], Vector{Any}(undef, 5))
            #TO DO: Only create if name is in supported_types
            if key[1] in supported_types
                _s = type_mapping[key[1]]
                if occursin("Shaft", _s)
                    _struct_as_str = lstrip.(strip.(split(_s, ','), ['(', ')']))
                    temp[2] = make_shaft(param_mapping[_struct_as_str[2]], val)
                    struct_as_str = _struct_as_str[1]
                else
                    struct_as_str = _s
                end
                param_map = param_mapping[struct_as_str]
                component_constructor =
                    (args...) ->
                        InteractiveUtils.getfield(PowerSystems, Symbol(struct_as_str))(args...)

                struct_args = populate_args(param_map, val)
                aux = component_constructor(struct_args...)
                temp[component_table[supertype(typeof(aux))]] = aux
            end
        end
        for (ka, va) in bus_dict
            !isassigned(va, 3) && (va[3] = PSY.AVRFixed(1.0))
            !isassigned(va, 4) && (va[4] = PSY.TGFixed(1.0))
            !isassigned(va, 5) && (va[5] = PSY.PSSFixed(0.0))
        end
        dic[k] = bus_dict
    end
    return dic
end

function make_generator(Dict)
    genmap = open(filename) do file
        YAML.load(file)
    end
end
