#Additional constants for repeated structs
const TGOV1DU = SteamTurbineGov1

"""
Parse .dyr file into a dictionary indexed by bus number.
Each bus number key has a dictionary indexed by component type and id.

Comments in .dyr files are not supported (beginning of lines with //).

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
        text = strip(dyr_text[start:(val - 1)])
        if !isempty(text)
            line = replace(text, "\'" => "")
            line = replace(line, "," => " ")
            val_array = strip.(split(line))
            bus = parse(Int, val_array[1])
            model = string(val_array[2])
            id = string(val_array[3])
            component_dict = get!(parsed_values, bus, Dict{Tuple{String, String}, Array}())
            component_dict[(model, id)] = parse.(Float64, val_array[4:end])
        end
        start = val + 1
    end
    return parsed_values
end

function _parse_input_types(_v, val)
    #If the parameter is a Float64, then use the value directly as the argument.
    #Typically uses for the resistance that is not available in .dyr files.
    if isa(_v, Float64)
        if isnan(_v)
            error("nan for $(_v)")
        end
        return _v
        #If the parameter is an Int, then use the integer as the key of the value in the dictionary.
    elseif isa(_v, Int)
        return val[_v]
    elseif _v == "NaN"
        return NaN
        #If the parameter is a tuple (as a string), then construct the tuple directly.
    elseif isa(_v, String)
        m = match(r"^\((\d+)\s*,\s*(\d+)\)$", _v)
        if m !== nothing
            _tuple_ix = parse.(Int, m.captures)
            return Tuple(val[_tuple_ix])
        else
            error("String $(_v) not recognized for parsing")
        end
    else
        error("invalid input value $val")
    end
    return
end

"""
Populate arguments in a vector for each dynamic component (except Shafts).
Returns a vector with the parameter values of the argument of each component.

"""
function _populate_args(param_map::Vector, val)
    struct_args = Vector{Any}(undef, length(param_map))
    _populate_args!(struct_args, param_map, val, "")
    return struct_args
end

function _populate_args!(struct_args, param_map::Vector, val, ::String)
    for (ix, _v) in enumerate(param_map)
        parameter_value = _parse_input_types(_v, val)
        if !all(isnan.(parameter_value))
            struct_args[ix] = parameter_value
        end
    end
    return
end

function _populate_args!(struct_args, param_dic::Dict, val, id::String)
    param_map = param_dic[id]
    _populate_args!(struct_args, param_map, val, id)
    return
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

function _assign_missing_components!(
    bus_dict,
    component_table,
    ::Type{T},
) where {T <: DynamicGenerator}
    for va in values(bus_dict)
        if ismissing(va[component_table["AVR"]])
            va[component_table["AVR"]] = AVRFixed(1.0)
        end
        if ismissing(va[component_table["TurbineGov"]])
            va[component_table["TurbineGov"]] = TGFixed(1.0)
        end
        if ismissing(va[component_table["PSS"]])
            va[component_table["PSS"]] = PSSFixed(0.0)
        end
    end
    return
end

function _assign_missing_components!(
    va,
    component_table,
    ::Type{T},
) where {T <: DynamicInverter}
    if ismissing(va[component_table["Converter"]])
        va[component_table["Converter"]] = AverageConverter(750.0, 2.75)
    end
    if ismissing(va[component_table["Filter"]])
        va[component_table["Filter"]] = RLFilter(0.0, 0.0)
    end
    if ismissing(va[component_table["FrequencyEstimator"]])
        va[component_table["FrequencyEstimator"]] = FixedFrequency()
    end
    if ismissing(va[component_table["DCSource"]])
        va[component_table["DCSource"]] = FixedDCSource(750.0)
    end
    return
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
The function receives the parsed dictionary and constructs a dictionary indexed by bus, that contains a
dictionary with each dynamic generator and dynamic inverter components (indexed via its id).

For Generators, each dictionary indexed by id contains a vector with 5 of its components:
* Machine
* Shaft
* AVR
* TurbineGov
* PSS

For Inverters, each dictionary indexed by id contains a vector with 7 of its components:
* Converter
* ActivePowerControl
* ReactivePowerControl
* InnerControl
* DCSource
* FrequencyEstimator
* Filter

"""
function _parse_dyr_components(data::Dict)
    yaml_mapping = open(PSSE_DYR_MAPPING_FILE) do io
        aux = YAML.load(io)
        return aux
    end
    #param_map contains the mapping between struct params and dyr file.
    param_map = yaml_mapping["parameter_mapping"][1]
    #gen_map contains all the supported structs for generators
    gen_map = yaml_mapping["generator_mapping"][1]
    #inv_map contains al the supported structs for inverters
    inv_map = yaml_mapping["inverter_mapping"][1]
    #dic will contain the dictionary index by bus.
    #Each entry will be a dictionary, with id as keys, that contains the vector of components
    dic = Dict{Int, Any}()
    _parse_dyr_generator_components!(dic, data, gen_map, param_map)
    _parse_dyr_inverter_components!(dic, data, inv_map, param_map)
    return dic
end

"""
Parse dictionary of data (from `_parse_dyr_file`) into a dictionary of struct components.
The function receives the parsed dictionary and constructs a dictionary indexed by bus, that contains a
dictionary with each dynamic generator indexed by its id.

"""
function _parse_dyr_generator_components!(
    dic::Dict,
    data::Dict,
    gen_map::Dict,
    param_map::Dict,
)
    component_table =
        Dict("Machine" => 1, "Shaft" => 2, "AVR" => 3, "TurbineGov" => 4, "PSS" => 5)
    for (bus_num, bus_data) in data #bus_data is a dictionary with values per component (key)
        bus_dict = Dict{String, Any}()
        for (componentID, componentValues) in bus_data
            #Fill array of 5 components per generator
            temp = get!(bus_dict, componentID[2], fill!(Vector{Any}(undef, 5), missing))
            #Only create if name is in the supported keys in the mapping
            if componentID[1] in keys(gen_map)
                #Get the component dictionary
                components_dict = gen_map[componentID[1]]
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
                            InteractiveUtils.getfield(PowerSystems, Symbol(struct_as_str))(
                                args...,
                            )
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
        _assign_missing_components!(bus_dict, component_table, DynamicGenerator)
        #Store dictionary of components in a dictionary indexed by bus
        dic[bus_num] = bus_dict
    end
end

"""
Parse dictionary of data (from `_parse_dyr_file`) into a dictionary of struct components.
The function receives the parsed dictionary and constructs a dictionary indexed by bus, that contains a
dictionary with each dynamic inverter indexed by its id.

"""
function _parse_dyr_inverter_components!(
    dic::Dict,
    data::Dict,
    inv_map::Dict,
    param_map::Dict,
)
    component_table = Dict(
        "Converter" => 1,
        "ActivePowerControl" => 2,
        "ReactivePowerControl" => 3,
        "InnerControl" => 4,
        "DCSource" => 5,
        "FrequencyEstimator" => 6,
        "Filter" => 7,
    )
    for (bus_num, bus_data) in data #bus_data is a dictionary with values per component (key is a tuple of PSSE name and number ID)
        #bus_dict will add a vector of components structs for each generator ID on the bus_num key of the master dictionary 'dic'
        #bus_dict_values will only contain the vector of parameters that will be used to construct the structs
        bus_dict_values = Dict{String, Any}()
        for (componentID, componentValues) in bus_data
            #ComponentID is a tuple:
            #ComponentID[1] is the PSSE name
            #ComponentID[2] is the number ID of the generator/inverter
            #Fill array of 7 components per inverter
            #Only create if name is in the supported keys in the mapping
            if componentID[1] in keys(inv_map)
                #Get the component dictionary
                temp = get!(bus_dict_values, componentID[2], Dict{Any, Vector{Any}}())
                components_dict = inv_map[componentID[1]]
                for (inv_field, struct_as_str) in components_dict
                    param_vec = get!(
                        temp,
                        (inv_field, struct_as_str),
                        _instantiate_param_vector_size(struct_as_str, param_map),
                    )
                    params_ix = param_map[struct_as_str]
                    _populate_args!(param_vec, params_ix, componentValues, componentID[1])
                end
            end
        end
        #Store vector of components in a dictionary indexed by bus
        for (device_id, device_info) in bus_dict_values
            temp_vec = fill!(Vector{Any}(undef, 7), missing)
            for (k, struct_args) in device_info
                component_type, struct_as_str = k
                _convert_argument_types!(struct_as_str, struct_args)
                component_constructor =
                    (args...) ->
                        InteractiveUtils.getfield(PowerSystems, Symbol(struct_as_str))(
                            args...,
                        )
                temp_vec[component_table[component_type]] =
                    component_constructor(struct_args...)
            end
            _assign_missing_components!(temp_vec, component_table, DynamicInverter)
            dic[bus_num][device_id] = temp_vec
        end
    end
end

"""
Construct appropiate vector size for components that collect parameters from
more than 2 PSS/E components

"""
function _instantiate_param_vector_size(str::AbstractString, param_map::Dict)
    if str == "ActiveRenewableControllerAB"
        return fill!(Vector{Any}(undef, 17), missing)
    elseif str == "ReactiveRenewableControllerAB"
        return fill!(Vector{Any}(undef, 25), missing)
    elseif str == "RECurrentControlB"
        return fill!(Vector{Any}(undef, 12), missing)
    elseif str in keys(param_map)
        return fill!(Vector{Any}(undef, length(param_map[str])), missing)
    else
        error("String $(str) not supported in the parser")
    end
end

"""
Convert specific parameters to types that are not Float64 for
specific inverter components

"""
function _convert_argument_types!(str::AbstractString, struct_args::Vector)
    if str == "ActiveRenewableControllerAB"
        struct_args[1:5] .= Int.(struct_args[1:5])
        struct_args[4] = string(struct_args[4])
    elseif str == "ReactiveRenewableControllerAB"
        struct_args[1:8] .= Int.(struct_args[1:8])
        struct_args[4] = string(struct_args[4])
    elseif str == "RECurrentControlB"
        struct_args[1:2] .= Int.(struct_args[1:2])
    elseif str == "RenewableEnergyConverterTypeA"
        #No changes to struct_args
    else
        error("$str not defined for dynamic component arguments")
    end
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
    bus_dict_gen = _parse_dyr_components(dyr_file)
    add_dyn_injectors!(sys, bus_dict_gen)
    return
end

function add_dyn_injectors!(sys::System, bus_dict_gen::Dict)
    @info "Generators provided in .dyr, without a generator in .raw file will be skipped."
    for g in collect(get_components(ThermalStandard, sys))
        _num = get_number(get_bus(g))
        _name = get_name(g)
        _id = split(_name, "-")[end]
        temp_dict = get(bus_dict_gen, _num, nothing)
        if temp_dict === nothing
            @warn "Generator at bus $(_num), id $(_id), not found in Dynamic Data.\nVoltage Source will be used to model it."
            r, x = get_ext(g)["z_source"]
            if x == 0.0
                @warn "No series reactance found. Setting it to 1e-6"
                x = 1e-6
            end
            s = _make_source(g, r, x)
            remove_component!(typeof(g), sys, _name)
            add_component!(sys, s)
        elseif all(.!ismissing.(temp_dict[_id]))
            if length(temp_dict[_id]) == 5 #Generator has 5 components
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
            elseif length(temp_dict[_id]) == 7 #Inverter has 7 components (6 if Outer is put together)
                dyn_inv = DynamicInverter(get_name(g), 1.0, temp_dict[_id]...)
                add_component!(sys, dyn_inv, g)
            else
                @assert false
            end
        else
            error("Generator at bus $(_num), id $(_id), name $(_name), not supported")
        end
    end
end
