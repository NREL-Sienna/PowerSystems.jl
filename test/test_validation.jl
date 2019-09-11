import YAML
import PowerSystems

const WRONG_FORMAT_CONFIG_FILE = joinpath(dirname(pathof(PowerSystems)),
                                            "descriptors", "config.yml")
include(joinpath(DATA_DIR,"data_5bus_pu.jl"))

@testset "Test reading in config data" begin
    data = PowerSystems.read_validation_descriptor(PSY.POWER_SYSTEM_STRUCT_DESCRIPTOR_FILE)
    @test data isa Vector
    @test !isempty(data)
    function find_struct()
        for item in data
            if item["struct_name"] == "TechThermal"
                return true
            end
        end
        return false
    end
    @test find_struct()
    @test_throws(ErrorException, PowerSystems.read_validation_descriptor("badfile.toml"))
end

@testset "Test adding custom validation YAML file to System" begin
    sys_no_config = System(nodes5, thermal_generators5, loads5, nothing, nothing,
                            100.0, nothing, nothing, nothing; runchecks=true)
    @test !isempty(sys_no_config.validation_descriptor)

    sys_no_runchecks = System(nodes5, thermal_generators5, loads5, nothing, nothing,
                            100.0, nothing, nothing, nothing; runchecks=false)
    @test isempty(sys_no_runchecks.validation_descriptor)
end

@testset "Test extracting struct info from validation_descriptor vector" begin
    data =  [Dict("fields"=>Dict{Any,Any}[
            Dict("name"=>"curtailpenalty","valid_range"=>Dict{Any,Any}("max"=>nothing,"min"=>0.0)),
            Dict("name"=>"variablecost","valid_range"=>Dict{Any,Any}("max"=>nothing,"min"=>0.0)),
            Dict("name"=>"internal")],
                "struct_name"=>"EconHydro"),
            Dict("fields"=>Dict{Any,Any}[
            Dict("name"=>"curtailpenalty","valid_range"=>Dict{Any,Any}("max"=>nothing,"min"=>0.0)),
            Dict("name"=>"variablecost","valid_range"=>Dict{Any,Any}("max"=>nothing,"min"=>0.0)),
            Dict("name"=>"internal")],
                "struct_name"=>"EconLoad")]
    struct_name = "EconHydro"
    descriptor = PowerSystems.get_config_descriptor(data, struct_name)
    @test descriptor isa Dict{String,Any}
    @test haskey(descriptor, "struct_name")
    @test haskey(descriptor, "fields")
    @test descriptor["struct_name"] == struct_name

end

@testset "Test extracting field info from struct descriptor dictionary" begin
    config = Dict{Any,Any}("fields"=>Dict{Any,Any}[
                            Dict("name"=>"name","data_type"=>"String"),
                            Dict("name"=>"available","data_type"=>"Bool"),
                            Dict("name"=>"bus","data_type"=>"Bus"),
                            Dict("name"=>"tech","data_type"=>"Union{Nothing, TechThermal}"),
                            Dict("name"=>"econ","data_type"=>"Union{Nothing, EconThermal}"),
                            Dict("name"=>"internal","data_type"=>"PowerSystems.PowerSystemInternal")],
                            "struct_name"=>"ThermalStandard")
    field_name = "econ"
    field_descriptor = PowerSystems.get_field_descriptor(config, field_name)
    @test field_descriptor isa Dict{Any, Any}
    @test haskey(field_descriptor, "name")
    @test field_descriptor["name"] == field_name
end

@testset "Test retrieving validation action" begin
    warn_descriptor = Dict{Any,Any}("name"=>"ramplimits",
                        "valid_range"=>Dict{Any,Any}("max"=>5,"min"=>0),
                        "validation_action"=>"warn")
    error_descriptor = Dict{Any,Any}("name"=>"ramplimits",
                        "valid_range"=>Dict{Any,Any}("max"=>5,"min"=>0),
                        "validation_action"=>"error")
    typo_descriptor = Dict{Any,Any}("name"=>"ramplimits",
                        "valid_range"=>Dict{Any,Any}("max"=>5,"min"=>0),
                        "validation_action"=>"asdfasdfsd")
    @test PowerSystems.get_validation_action(warn_descriptor) == PowerSystems.validation_warning
    @test PowerSystems.get_validation_action(error_descriptor) == PowerSystems.validation_error
    @test_throws(ErrorException, PowerSystems.get_validation_action(typo_descriptor))
end

@testset "Test field validation" begin
    #test recursive call of validate_fields and a regular valid range
    bad_therm_gen_rating = deepcopy(thermal_generators5)
    bad_therm_gen_rating[1].tech.rating = -10
    @test_logs((:error, r"Invalid range"),
        @test_throws(PowerSystems.InvalidRange,
                        System(nodes5, bad_therm_gen_rating, loads5, nothing, nothing,
                               100.0, nothing, nothing, nothing; runchecks=true)
        )
    )

    #test custom range (activepower and activepowerlimits)
    bad_therm_gen_act_power = deepcopy(thermal_generators5)
    bad_therm_gen_act_power[1].activepower = 10
    @test_logs (:warn, r"Invalid range") System(nodes5, bad_therm_gen_act_power, loads5,
            nothing, nothing, 100.0, nothing, nothing, nothing; runchecks=true)

    #test validating named tuple
    bad_therm_gen_ramp_lim = deepcopy(thermal_generators5)
    bad_therm_gen_ramp_lim[1].tech.ramplimits = (up = -10, down = -3)
    @test_logs((:error, r"Invalid range"), match_mode=:any,
        @test_throws(PowerSystems.InvalidRange,
                     System(nodes5, bad_therm_gen_ramp_lim, loads5, nothing, nothing, 100.0,
                            nothing, nothing, nothing; runchecks=true)
        )
    )
end

@testset "Test field validation" begin
    sys = System(nodes5, thermal_generators5, loads5, nothing, nothing,
                               100.0, nothing, nothing, nothing; runchecks=true)

    add_component!(sys,Bus(11,"11",PSY.PQ,1,1,(min=.9,max=1.1),123))
    B = get_components(Bus,sys) |> collect
    a = Arc(B[1],B[6])
    badline = Line("badline",true,0.01,0.01,a,0.002,0.014,(from = 0.015, to = 0.015),5.0,(min = -1, max = 1))
    @test_throws PSY.InvalidParameter add_component!(sys, badline)

end
