#Additional constants for repeated structs
const TGOV1DU = SteamTurbineGov1

"""
Parse .dyr file into a dictionary indexed by bus number.
Each bus number key has a dictionary indexed by component type and id.

"""
function _parse_dyr_file(file::AbstractString)
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
function _populate_args(param_map, val)
    struct_args = Vector{Any}(undef, length(param_map))
    for (ix, _v) in enumerate(param_map)
        #If the parameter is a Float64, then use the value directly as the argument.
        #Typically uses for the resistance that is not available in .dyr files.
        if isa(_v, Float64)
            struct_args[ix] = _v
            #If the parameter is an Int, then use the integer as the key of the value in the dictionary.
        elseif isa(_v, Int)
            struct_args[ix] = val[_v]
            #If the parameter is a tuple (as a string), then construct the tuple directly.
        else
            _t = strip(_v, ['(', ')'])
            _t2int = parse.(Int, split(_t, ','))
            struct_args[ix] = (val[_t2int[1]], val[_t2int[2]])
        end
    end
    return struct_args
end

"""
Create a SingleMass shaft struct directly using the parameter mapping.

"""
function _make_shaft(param_map, val)
    constructor_shaft =
        (args...) -> InteractiveUtils.getfield(PowerSystems, :SingleMass)(args...)
    shaft_args = _populate_args(param_map, val)
    return constructor_shaft(shaft_args...)
end

function _make_source(g::StaticInjection, r::Float64, x::Float64)
    return Source(
        name = get_name(g),
        available = true,
        bus = get_bus(g),
        active_power = get_active_power(g),
        reactive_power = get_reactive_power(g),
        R_th = r,
        X_th = x,
    )
end

function _assign_missing_components!(bus_dict, component_table)
    for va in values(bus_dict)
        if !isassigned(va, component_table["AVR"])
            va[component_table["AVR"]] = AVRFixed(1.0)
        end
        if !isassigned(va, component_table["TurbineGov"])
            va[component_table["TurbineGov"]] = TGFixed(1.0)
        end
        if !isassigned(va, component_table["PSS"])
            va[component_table["PSS"]] = PSSFixed(0.0)
        end
    end
end

"""
Parse a .dyr file directly from its name by constructing its dictionary of dictionaries.

"""
function _parse_dyr_components(dyr_file::AbstractString)
    ext = splitext(dyr_file)[2]
    if lowercase(ext) in [".dyr"]
        data = _parse_dyr_file(dyr_file)
        return _parse_dyr_components(data)
    else
        throw(DataFormatError("$dyr_file is not a .dyr file type"))
    end
end

"""
Parse dictionary of dictionaries of data (from `_parse_dyr_file`) into a dictionary of struct components.
The function receives the parsed dictionary and construct a dictionary indexed by bus, that containts a
dictionary with each dynamic generator components (indexed via its id).

Each dictionary indexed by id contains a vector with 5 of its components:
* Machine
* Shaft
* AVR
* TurbineGov
* PSS

"""
function _parse_dyr_components(data::Dict)
    yaml_mapping = open(PSSE_DYR_MAPPING_FILE) do io
        aux = YAML.load(io)
        return aux
    end
    #param_map contains the mapping between struct params and dyr file.
    param_map = yaml_mapping["parameter_mapping"][1]
    #dic will contain the dictionary index by bus.
    #Each entry will be a dictionary, with id as keys, that contains the vector of components
    dic = Dict{Int, Any}()
    component_table =
        Dict("Machine" => 1, "Shaft" => 2, "AVR" => 3, "TurbineGov" => 4, "PSS" => 5)
    for (bus_num, bus_data) in data
        bus_dict = Dict{Int, Any}()
        for (componentID, componentValues) in bus_data
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
                        temp[2] = _make_shaft(params_ix, componentValues)
                        continue
                    end
                    #Construct Components
                    component_constructor =
                        (args...) ->
                            InteractiveUtils.getfield(PowerSystems, Symbol(struct_as_str))(args...)
                    struct_args = _populate_args(params_ix, componentValues)
                    if struct_as_str == "BaseMachine"
                        struct_args = [
                            0.0,    #R
                            1e-5,   #X
                            1.0,    #eq_p
                        ]
                    end
                    temp[component_table[gen_field]] = component_constructor(struct_args...)
                end
            else
                @warn "$(componentID[1]) at bus $bus_num, id $(componentID[2]), not supported in PowerSystems.jl. Skipping data."
            end
        end
        #Assign generic components if there were not provided in Dynamic Data
        _assign_missing_components!(bus_dict, component_table)
        #Store dictionary of components in a dictionary indexed by bus
        dic[bus_num] = bus_dict
    end
    return dic
end

"""
Parse dictionary of dictionaries of data (from `_parse_dyr_file`) into a dictionary of struct components.
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
```Julia
raw_file = "Example.raw"
dyr_file = "Example.dyr"
sys = System(raw_file, dyr_file)
```

"""
function System(sys_file::AbstractString, dyr_file::AbstractString; kwargs...)
    ext = splitext(sys_file)[2]
    if lowercase(ext) in [".raw"]
        pm_kwargs = Dict(k => v for (k, v) in kwargs if !in(k, SYSTEM_KWARGS))
        sys = System(PowerModelsData(sys_file; pm_kwargs...); kwargs...)
    else
        throw(DataFormatError("$sys_file is not a .raw file type"))
    end
    bus_dict_gen = _parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
    return sys
end

"""
Add to a system already created the dynamic components.
The system should already be parsed from a .raw file.

## Examples:
```Julia
dyr_file = "Example.dyr"
add_dyn_injectors!(sys, dyr_file)
```

"""
function add_dyn_injectors!(sys::System, dyr_file::AbstractString)
    bus_dict_gen = _parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
end

function add_dyn_injectors!(sys::System, bus_dict_gen::Dict)
    @info "Generators provided in .dyr, without a generator in .raw file will be skipped."
    for g in collect(get_components(ThermalStandard, sys))
        _num = get_number(get_bus(g))
        _name = get_name(g)
        _id = parse(Int, split(_name, "-")[end])
        temp_dict = get(bus_dict_gen, _num, nothing)
        if isnothing(temp_dict)
            @warn "Generator at bus $(_num), id $(_id), not found in Dynamic Data.\nVoltage Source will be used to model it."
            r, x = get_ext(g)["z_source"]
            if x == 0.0
                @warn "No series reactance found. Setting it to 1e-6"
                x = 1e-6
            end
            s = _make_source(g, r, x)
            remove_component!(typeof(g), sys, _name)
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
                    s = _make_source(g, r, x)
                    remove_component!(typeof(g), sys, _name)
                    add_component!(sys, s)
                    #Don't add DynamicComponent in case of adding Source
                    continue
                end
            end
            #Add Dynamic Generator
            dyn_gen = DynamicGenerator(get_name(g), 1.0, temp_dict[_id]...)
            add_component!(sys, dyn_gen, g)
        end
    end
end
