"""
Parse .dyr file into a dictionary indexed by bus number.
Each bus number key has a dictionary indexed by component type and id.

"""
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

"""
Populate arguments in a vector for each dynamic component (except Shafts).
Returns a vector with the parameter values of the argument of each component.

"""
function populate_args(param_map, val)
    struct_args = Vector{Any}(undef, length(param_map))
    for (ix, _v) in enumerate(param_map)
        #If the parameter is a Float64, then use the value directly as the argument.
        #Typically uses for the resistance that is not available in .dyr files.
        if isa(_v, Float64)
            struct_args[ix] = _v
            #If the parameter is an Int64, then use the integer as the key of the value in the dictionary.
        elseif isa(_v, Int64)
            struct_args[ix] = val[_v]
            #If the parameter is a tuple (as a string), then construct the tuple directly.
        else
            _t = strip(_v, ['(', ')'])
            _t2int = parse.(Int64, split(_t, ','))
            struct_args[ix] = (val[_t2int[1]], val[_t2int[2]])
        end
    end
    return struct_args
end

"""
Create a SingleMass shaft struct directly using the parameter mapping.

"""
function make_shaft(param_map, val)
    constructor_shaft =
        (args...) -> InteractiveUtils.getfield(PowerSystems, :SingleMass)(args...)
    shaft_args = populate_args(param_map, val)
    return constructor_shaft(shaft_args...)
end

"""
Parse a .dyr file directly from its name by constructing its dictionary of dictionaries.

"""
function parse_dyr_components(dyr_file::AbstractString)
    data = parse_dyr_file(dyr_file)
    return parse_dyr_components(data)
end

"""
Parse dictionary of dictionaries of data (from `parse_dyr_file`) into a dictionary of struct components.
The function receives the parsed dictionary and construct a dictionary indexed by bus, that containts a 
dictionary with each dynamic generator components (indexed via its id).

Each dictionary indexed by id contains a vector with 5 of its components:
* Machine
* Shaft
* AVR
* TurbineGov
* PSS

"""
function parse_dyr_components(data::Dict)
    yaml_mapping = open(PSSE_DYR_MAPPING_FILE) do io
        aux = YAML.load(io)
        return aux
    end
    #param_map contains the mapping between struct params and dyr file.
    param_map = yaml_mapping["parameter_mapping"][1]
    #dic will contain the dictionary index by bus.
    #Each entry will be a dictionary, with id as keys, that contains the vector of components
    dic = Dict{Int64, Any}()
    component_table =
        Dict("Machine" => 1, "Shaft" => 2, "AVR" => 3, "TurbineGov" => 4, "PSS" => 5)
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
                    component_constructor =
                        (args...) ->
                            InteractiveUtils.getfield(PowerSystems, Symbol(struct_as_str))(args...)
                    struct_args = populate_args(params_ix, componentValues)
                    if struct_as_str == "BaseMachine"
                        struct_args = [
                            0.0,    #R
                            1e-5,   #X
                            1.0,    #eq_p
                        ]
                    end
                    temp[component_table[gen_field]] = component_constructor(struct_args...)
                end
            end
            #Assign generic components if there were not provided in Dynamic Data
            for va in values(bus_dict)
                !isassigned(va, component_table["AVR"]) &&
                    (va[component_table["AVR"]] = AVRFixed(1.0))
                !isassigned(va, component_table["TurbineGov"]) &&
                    (va[component_table["TurbineGov"]] = TGFixed(1.0))
                !isassigned(va, component_table["PSS"]) &&
                    (va[component_table["PSS"]] = PSSFixed(0.0))
            end
        end
        #Store dictionary of components in a dictionary indexed by bus
        dic[k] = bus_dict
    end
    return dic
end

"""
Parse dictionary of dictionaries of data (from `parse_dyr_file`) into a dictionary of struct components.
The function receives the parsed dictionary and construct a dictionary indexed by bus, that containts a 
dictionary with each dynamic generator components (indexed via its id).

Each dictionary indexed by id contains a vector with 5 of its components:
* Machine
* Shaft
* AVR
* TurbineGov
* PSS

Files must be parsed from a .raw file (PTI data format) and a .dyr file.

## Examples:
```julia
raw_file = "Example.raw"
dyr_file = "Example.dyr"
sys = parse_dyn_system(raw_file, dyr_file)
```

"""
function parse_dyn_system(sys_file::AbstractString, dyr_file::AbstractString)
    sys = System(sys_file)
    bus_dict_gen = parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
    return sys
end

"""
Add to a system already created the dynamic components. 
The system should already be parsed from a .raw file.

## Examples:
```julia
dyr_file = "Example.dyr"
add_dyn_injectors!(sys, dyr_file)
```

"""
function add_dyn_injectors!(sys::System, dyr_file::AbstractString)
    bus_dict_gen = parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
end

function add_dyn_injectors!(sys::System, bus_dict_gen::Dict)
    @info "Generators provided in .dyr, without a generator in .raw file will be skipped."
    for g in get_components(ThermalStandard, sys)
        _num = get_number(get_bus(g))
        _name = get_name(g)
        _id = parse(Int64, split(_name, "-")[end])
        temp_dict = get(bus_dict_gen, _num, nothing)
        if isnothing(temp_dict)
            @warn "Generator at bus $(_num), id $(_id), not found in Dynamic Data.\nVoltage Source will be used to model it."
            r, x = get_ext(g)["z_source"]
            if x == 0.0
                @warn "No series reactance found. Setting it to 1e-6"
                x = 1e-6
            end
            s = Source(
                name = _name,
                available = true,
                bus = get_bus(g),
                active_power = get_active_power(g),
                reactive_power = get_reactive_power(g),
                R_th = r,
                X_th = x,
            )
            #Remove ThermalGenerator
            remove_component!(typeof(g), sys, _name)
            #Add Source
            add_component!(sys, s)
        else
            #Obtain Machine from Dictionary
            machine = temp_dict[_id][1]
            #Update R,X from RSORCE and XSORCE from RAW file
            r, x = get_ext(g)["z_source"]
            set_R!(machine, r)
            #Obtain Shaft from dictionary
            shaft = temp_dict[_id][2]
            if typeof(machine) == BaseMachine
                if x == 0.0
                    @warn "No series reactance found. Setting it to 1e-6"
                    x = 1e-6
                end
                set_Xd_p!(machine, x)
                if get_H(shaft) == 0.0
                    @info "Machine at bus $(_num), id $(_id) has zero inertia. Modeling it as Voltage Source"
                    s = Source(
                        name = _name,
                        available = true,
                        bus = get_bus(g),
                        active_power = get_active_power(g),
                        reactive_power = get_reactive_power(g),
                        R_th = r,
                        X_th = x,
                    )
                    #Remove ThermalGenerator
                    remove_component!(typeof(g), sys, _name)
                    #Add Source
                    add_component!(sys, s)
                    #Don't add DynamicComponent in case of adding Source
                    continue
                end
            end
            #Add Dynamic Generator
            dyn_gen = DynamicGenerator(g, 1.0, temp_dict[_id]...)
            add_component!(sys, dyn_gen)
        end
    end
end
