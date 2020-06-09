function parse_dyr_file(file::AbstractString)
    dyr_text = read(file, String);
    start = 1
    parsed_values = Dict{Int, Dict}()
    models = Vector{String}()
    while start < length(dyr_text)
        val = findnext('/', dyr_text, start)
        if isnothing(val)
            break
        end
        line = replace(dyr_text[start:val-1], "\'" => "")
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

function make_generator(Dict)
    genmap = open(filename) do file
        YAML.load(file)
    end
end
