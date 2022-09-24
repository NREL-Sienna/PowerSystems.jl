
mutable struct TestDevice <: Device
    name::String
end

mutable struct TestRenDevice <: RenewableGen
    name::String
end

"""Return the first component of type component_type that matches the name of other."""
function get_component_by_name(sys::System, component_type, other::Component)
    for component in get_components(component_type, sys)
        if get_name(component) == get_name(other)
            return component
        end
    end

    error("Did not find component $component")
end

"""Return the Branch in the system that matches another by case-insensitive arc
names."""
function get_branch(sys::System, other::Branch)
    for branch in get_components(Branch, sys)
        if lowercase(other.arc.from.name) == lowercase(branch.arc.from.name) &&
           lowercase(other.arc.to.name) == lowercase(branch.arc.to.name)
            return branch
        end
    end

    error("Did not find branch with buses $(other.arc.from.name) ", "$(other.arc.to.name)")
end

function test_accessors(component)
    ps_type = typeof(component)

    for (field_name, field_type) in zip(fieldnames(ps_type), fieldtypes(ps_type))
        if field_name === :name || field_name === :time_series_container
            func = getfield(InfrastructureSystems, Symbol("get_" * string(field_name)))
            _func! =
                getfield(InfrastructureSystems, Symbol("set_" * string(field_name) * "!"))
        else
            getter_name = Symbol("get_" * string(field_name))
            if !hasproperty(PowerSystems, getter_name)
                continue
            end
            func = getfield(PowerSystems, getter_name)
            if !hasmethod(func, (ps_type,))
                continue
            end
            setter_name = Symbol("set_" * string(field_name) * "!")
            # In some cases there is a getter but no setter.
            if hasproperty(PowerSystems, setter_name)
                _func! = getfield(PowerSystems, setter_name)
            else
                _func! = nothing
            end
        end

        val = func(component)
        @test val isa field_type
        try
            if typeof(val) == Float64 || typeof(val) == Int
                if !isnan(val)
                    aux = val + 1
                    if _func! !== nothing
                        _func!(component, aux)
                        @test func(component) == aux
                    end
                end
            elseif typeof(val) == String
                aux = val * "1"
                if _func! !== nothing
                    _func!(component, aux)
                    @test func(component) == aux
                end
            elseif typeof(val) == Bool
                aux = !val
                if _func! !== nothing
                    _func!(component, aux)
                    @test func(component) == aux
                end
            else
                _func! !== nothing && _func!(component, val)
            end
        catch MethodError
            continue
        end
    end
end

function validate_serialization(
    sys::System;
    time_series_read_only = false,
    runchecks = nothing,
    assign_new_uuids = false,
)
    if runchecks === nothing
        runchecks = PSY.get_runchecks(sys)
    end
    test_dir = mktempdir()
    orig_dir = pwd()
    cd(test_dir)

    try
        path = joinpath(test_dir, "test_system_serialization.json")
        @info "Serializing to $path"
        sys_ext = get_ext(sys)
        sys_ext["data"] = 5
        ext_test_bus_name = ""
        IS.prepare_for_serialization!(sys.data, path; force = true)
        bus = collect(get_components(PSY.Bus, sys))[1]
        ext_test_bus_name = PSY.get_name(bus)
        ext = PSY.get_ext(bus)
        ext["test_field"] = 1
        to_json(sys, path)

        data = open(path, "r") do io
            JSON3.read(io)
        end
        @test data["data_format_version"] == PSY.DATA_FORMAT_VERSION

        sys2 = System(
            path;
            time_series_read_only = time_series_read_only,
            runchecks = runchecks,
            assign_new_uuids = assign_new_uuids,
        )
        isempty(get_bus_numbers(sys2)) && return false
        sys_ext2 = get_ext(sys2)
        sys_ext2["data"] != 5 && return false
        bus = PSY.get_component(PSY.Bus, sys2, ext_test_bus_name)
        ext = PSY.get_ext(bus)
        ext["test_field"] != 1 && return false
        return sys2, PSY.compare_values(sys, sys2, compare_uuids = !assign_new_uuids)
    finally
        cd(orig_dir)
    end
end
