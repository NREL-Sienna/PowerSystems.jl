import InfrastructureSystems
import Unitful
# PSY no longer exports `ustrip`; Unitful's generic handles both quantity kinds
# (PSY extends it for `RelativeQuantity`).
using Unitful: ustrip

# Strip unit wrappers so accessor return values can be compared against the
# raw struct field type. Compound values (NamedTuple of units) are unwrapped
# element-wise.
_unwrap_units(x) = x
_unwrap_units(x::RelativeQuantity) = ustrip(x)
_unwrap_units(x::Unitful.Quantity) = Unitful.ustrip(x)
_unwrap_units(x::NamedTuple) = map(_unwrap_units, x)

mutable struct TestDevice <: Device
    name::String
end

mutable struct TestRenDevice <: RenewableGen
    name::String
end

mutable struct TestInjector <: StaticInjection
    name::String
end

struct NonexistentComponent <: StaticInjection end

"""Build a minimal `System` + `ThermalStandard` with the requested device base
so unit-conversion tests don't depend on PSB-built fixtures."""
function _sys_with_thermal(; system_base = 100.0, device_base = 250.0)
    sys = System(system_base)
    bus = ACBus(;
        number = 1, name = "b1", available = true,
        bustype = ACBusTypes.REF, angle = 0.0, magnitude = 1.0,
        voltage_limits = (min = 0.9, max = 1.1), base_voltage = 138.0,
    )
    add_component!(sys, bus)
    gen = ThermalStandard(;
        name = "g1", available = true, status = true, bus = bus,
        active_power = 0.5, reactive_power = 0.1, rating = 1.0,
        active_power_limits = (min = 0.0, max = 1.0),
        reactive_power_limits = (min = -1.0, max = 1.0),
        ramp_limits = nothing,
        operation_cost = ThermalGenerationCost(nothing),
        base_power = device_base,
    )
    add_component!(sys, gen)
    return sys, gen
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

function create_system_with_dynamic_inverter()
    nodes_OMIB = [
        ACBus(
            1, #number
            "Bus 1", #Name
            true, #available
            "REF", #ACBusType (REF, PV, PQ)
            0, #Angle in radians
            1.06, #Voltage in pu
            (min = 0.94, max = 1.06), #Voltage limits in pu
            69,
            nothing,
            nothing,
        ), #Base voltage in kV
        ACBus(
            2,
            "Bus 2",
            true,
            "PV",
            0,
            1.045,
            (min = 0.94, max = 1.06),
            69,
            nothing,
            nothing,
        ),
    ]

    battery = EnergyReservoirStorage(;
        name = "Battery",
        prime_mover_type = PrimeMovers.BA,
        storage_technology_type = StorageTech.OTHER_CHEM,
        available = true,
        bus = nodes_OMIB[2],
        initial_energy = 5.0,
        state_of_charge_limits = (min = 5.0, max = 100.0),
        rating = 0.0275, #Value in per_unit of the system
        active_power = 0.01375,
        input_active_power_limits = (min = 0.0, max = 50.0),
        output_active_power_limits = (min = 0.0, max = 50.0),
        reactive_power = 0.0,
        reactive_power_limits = (min = -50.0, max = 50.0),
        efficiency = (in = 0.80, out = 0.90),
        base_power = 100.0,
    )
    converter = AverageConverter(
        138.0, #Rated Voltage
        100.0,
    ) #Rated MVA

    branch_OMIB = [
        Line(
            "Line1", #name
            true, #available
            0.0, #active power flow initial condition (from-to)
            0.0, #reactive power flow initial condition (from-to)
            Arc(; from = nodes_OMIB[1], to = nodes_OMIB[2]), #Connection between buses
            0.01, #resistance in pu
            0.05, #reactance in pu
            (from = 0.0, to = 0.0), #susceptance in pu
            18.046, #rate in MW
            1.04,
        ),
    ]  #angle limits (-min and max)

    dc_source = FixedDCSource(1500.0) #Not in the original data, guessed.

    filt = LCLFilter(
        0.08, #Series inductance lf in pu
        0.003, #Series resitance rf in pu
        0.074, #Shunt capacitance cf in pu
        0.2, #Series reactance rg to grid connection (#Step up transformer or similar)
        0.01,
    ) #Series resistance lg to grid connection (#Step up transformer or similar)

    pll = KauraPLL(
        500.0, #ω_lp: Cut-off frequency for LowPass filter of PLL filter.
        0.084, #k_p: PLL proportional gain
        4.69,
    ) #k_i: PLL integral gain

    virtual_H = VirtualInertia(
        2.0, #Ta:: VSM inertia constant
        400.0, #kd:: VSM damping coefficient
        20.0, #kω:: Frequency droop gain in pu
        2 * pi * 50.0,
    ) #ωb:: Rated angular frequency

    Q_control = ReactivePowerDroop(
        0.2, #kq:: Reactive power droop gain in pu
        1000.0,
    ) #ωf:: Reactive power cut-off low pass filter frequency

    outer_control = OuterControl(virtual_H, Q_control)

    vsc = VoltageModeControl(
        0.59, #kpv:: Voltage controller proportional gain
        736.0, #kiv:: Voltage controller integral gain
        0.0, #kffv:: Binary variable enabling the voltage feed-forward in output of current controllers
        0.0, #rv:: Virtual resistance in pu
        0.2, #lv: Virtual inductance in pu
        1.27, #kpc:: Current controller proportional gain
        14.3, #kiv:: Current controller integral gain
        0.0, #kffi:: Binary variable enabling the current feed-forward in output of current controllers
        50.0, #ωad:: Active damping low pass filter cut-off frequency
        0.2,
    ) #kad:: Active damping gain

    sys = System(100.0)
    for bus in nodes_OMIB
        add_component!(sys, bus)
    end
    for lines in branch_OMIB
        add_component!(sys, lines)
    end
    add_component!(sys, battery)

    test_inverter = DynamicInverter(
        get_name(battery),
        1.0, #ω_ref
        converter, #Converter
        outer_control, #OuterControl
        vsc, #Voltage Source Controller
        dc_source, #DC Source
        pll, #Frequency Estimator
        filt,
    ) #Output Filter

    add_component!(sys, test_inverter, battery)

    return sys
end

"""
Create a system with supplemental attributes with the criteria below.

- Two GeographicInfo instances each assigned to multiple components.
- Two ThermalStandards each with two ForcedOutage instances and two PlannedOutage instances.
- Each outage has time series.
"""
function create_system_with_outages()
    sys = PSB.build_system(
        PSITestSystems,
        "c_sys5_uc";
        add_forecasts = true,
    )
    gens = collect(get_components(ThermalStandard, sys))
    gen1 = gens[1]
    gen2 = gens[2]
    geo1 = GeographicInfo(; geo_json = Dict("type" => "Point", "coordinates" => [1.0, 2.0]))
    geo2 = GeographicInfo(; geo_json = Dict("type" => "Point", "coordinates" => [3.0, 4.0]))
    begin_time_series_update(sys) do
        begin_supplemental_attributes_update(sys) do
            add_supplemental_attribute!(sys, gen1, geo1)
            add_supplemental_attribute!(sys, gen1.bus, geo1)
            add_supplemental_attribute!(sys, gen2, geo2)
            add_supplemental_attribute!(sys, gen2.bus, geo2)
            initial_time = Dates.DateTime("2020-01-01T00:00:00")
            end_time = Dates.DateTime("2020-01-01T23:00:00")
            dates = collect(initial_time:Dates.Hour(1):end_time)
            fo1 = GeometricDistributionForcedOutage(;
                mean_time_to_recovery = 1.0,
                outage_transition_probability = 0.5,
            )
            fo2 = GeometricDistributionForcedOutage(;
                mean_time_to_recovery = 2.0,
                outage_transition_probability = 0.5,
            )
            po1 = PlannedOutage(; outage_schedule = "1")
            po2 = PlannedOutage(; outage_schedule = "2")
            add_supplemental_attribute!(sys, gen1, fo1)
            add_supplemental_attribute!(sys, gen1, po1)
            add_supplemental_attribute!(sys, gen2, fo2)
            add_supplemental_attribute!(sys, gen2, po2)
            for (i, outage) in enumerate((fo1, fo2, po1, po2))
                data = collect(i:(i + 23))
                ta = TimeSeries.TimeArray(dates, data, ["1"])
                name = "ts_$(i)"
                ts = SingleTimeSeries(; name = name, data = ta)
                add_time_series!(sys, outage, ts)
            end
        end
    end

    return sys
end

# NOTE: This helper builds `test_RTS_GMLC_sys` which depends on PSY.PowerSystemTableData
# (removed in PSY 6). All callers are currently disabled until PSB no longer requires PSY parsers.
function create_system_with_subsystems()
    sys = PSB.build_system(
        PSITestSystems,
        "test_RTS_GMLC_sys";
        add_forecasts = true,
        time_series_read_only = false,
    )
    add_subsystem!(sys, "subsystem_1")
    for component in iterate_components(sys)
        add_component_to_subsystem!(sys, "subsystem_1", component)
    end

    # TODO: Replace with multiple valid subsystems
    return sys
end

function test_accessors(component)
    ps_type = typeof(component)

    for (field_name, field_type) in zip(fieldnames(ps_type), fieldtypes(ps_type))
        if field_name === :name
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

        # Unit-aware getters are tagged via `display_units_arg`. For unattached
        # test components, call with `DU` (device base) so the SU conversion
        # path — which needs system attachment — is skipped. Getters tagged `NU`
        # (e.g. `get_base_power`, which is only meaningful in natural units and
        # rejects `DU`/`SU`) are called with their own `NU` tag instead.
        units_arg = IS.display_units_arg(func, ps_type)
        val = if ismissing(units_arg)
            func(component)
        elseif units_arg == NU
            func(component, NU)
        else
            func(component, DU)
        end
        # Getters now wrap values (e.g. `0.5 SU` instead of raw `0.5`), so
        # compare the unwrapped value's type to `field_type`.
        @test _unwrap_units(val) isa field_type
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

"""
Round-trip `sys` through a `to_file`/`from_file` bundle and return the rebuilt system.

Replaces the old `validate_serialization`, which asserted on machinery that no longer exists:
`DATA_FORMAT_VERSION`, UUID-preserving `compare_values`, and component `ext` surviving the
write. A document carries component ids rather than UUIDs and does not carry component `ext`,
so none of those are properties to check any more.

The serde itself is tested once, in `test_openapi_file_io.jl`. Use this only where a test needs
a restored system to check that some *component* survives conversion — that is converter
coverage, which is this package's job.
"""
function roundtrip_system(sys::System; unit_system = :device_base, kwargs...)
    dir = mktempdir()
    bundle = joinpath(dir, "case")
    to_file(sys, bundle; unit_system = unit_system, force = true)
    return from_file(System, bundle; kwargs...)
end

"""Round-trip a PO/PC struct through JSON, the same shape `JSON.parsefile` would hand to
`PowerCoreOpenAPIModels.document_from_json` — avoids hand-writing nested `oneOf` cost-curve
JSON."""
openapi_raw(po) = JSON.parse(JSON.json(po); dicttype = Dict{String, Any})

"""
Parse a JSON-shaped test document into the `SystemDocument` `from_openapi` takes.

The fixtures build plain `Dict`s because that is the shape a document has on disk and it is
easy to mutate for negative tests; this is the same step `from_file` performs via
`read_document`.
"""
to_test_document(doc::AbstractDict) = PSY.PC.document_from_json(doc)

"""
Errors a malformed document can raise.

Which one fires depends on where the defect is caught: `PowerCoreOpenAPIModels` raises
`DocumentFormatError` for structural problems it can see on its own (an unregistered type name,
an unresolved id, a duplicate id), while PowerSystems `error()`s for semantic ones only it can
judge (a component type with no converter, an unmapped time series type or multiplier).
"""
const DocumentError = Union{ErrorException, PSY.PC.DocumentFormatError}

"""A minimal, internally-consistent OpenAPI document: Area/LoadZone, two buses, an arc, a
thermal generator with a real cost curve, a load, and an online reserve the generator
contributes to. Shared by test_openapi_document.jl and test_openapi_export.jl;
`bus1_bustype = "SLACK"` exercises the SLACK->REF normalization the export round-trip
asserts, and `include_fixed_admittance = false` drops the shunt row the export round-trip
predates."""
function make_openapi_test_doc(;
    bus1_bustype = "REF",
    include_fixed_admittance = true,
)
    area_po = PSY.PO.Area(;
        id = 1, name = "area1", peak_active_power = 100.0, peak_reactive_power = 20.0,
        load_response = 0.0,
    )
    lz_po = PSY.PO.LoadZone(;
        id = 2, name = "lz1", peak_active_power = 100.0, peak_reactive_power = 20.0,
    )
    bus1_po = PSY.PO.ACBus(;
        id = 3, number = 1, name = "bus1", available = true, bustype = bus1_bustype,
        angle = 0.0, magnitude = 1.0,
        voltage_limits = PSY.PC.MinMax(; min = 0.9, max = 1.1),
        base_voltage = 138.0, area = 1, load_zone = 2,
    )
    bus2_po = PSY.PO.ACBus(;
        id = 4, number = 2, name = "bus2", available = true, bustype = "PQ",
        angle = 0.0, magnitude = 1.0,
        voltage_limits = PSY.PC.MinMax(; min = 0.9, max = 1.1),
        base_voltage = 138.0, area = 1, load_zone = 2,
    )
    arc_po = PSY.PO.Arc(; id = 5, from_id = 3, to_id = 4)

    cost_po = PSY.PC.ThermalGenerationCost(;
        fixed = 100.0, shut_down = 50.0, start_up = 200.0,
        variable = PSY.PC.ProductionVariableCostCurve(
            PSY.PC.CostCurve(;
                power_units = "NATURAL_UNITS",
                value_curve = PSY.PC.ValueCurve(
                    PSY.PC.InputOutputCurve(;
                        function_data = PSY.PC.InputOutputCurveFunctionData(
                            PSY.PC.LinearFunctionData(;
                                proportional_term = 10.0, constant_term = 5.0,
                            ),
                        ),
                    ),
                ),
            ),
        ),
    )
    thermal_po = PSY.PO.ThermalStandard(;
        id = 6, name = "gen1", available = true, status = true, bus = 4,
        active_power = 50.0, reactive_power = 10.0, rating = 100.0,
        active_power_limits = PSY.PC.MinMax(; min = 10.0, max = 100.0),
        reactive_power_limits = PSY.PC.MinMax(; min = -50.0, max = 50.0),
        ramp_limits = PSY.PC.UpDown(; up = 20.0, down = 20.0),
        operation_cost = cost_po, base_power = 100.0,
        time_limits = PSY.PC.UpDown(; up = 2.0, down = 2.0),
        must_run = false, prime_mover_type = "OT", fuel = "NATURAL_GAS",
        time_at_status = 100.0,
    )
    load_po = PSY.PO.PowerLoad(;
        id = 7, name = "load1", available = true, bus = 4,
        active_power = 30.0, reactive_power = 5.0, base_power = 100.0,
        max_active_power = 50.0, max_reactive_power = 10.0, conformity = "CONFORMING",
    )
    reserve_po = PSY.PO.OnlineReserve(;
        id = 8, name = "spin_up", available = true, time_frame = 10.0,
        requirement = 100.0, variable = nothing, sustained_time = 60.0,
        max_output_fraction = 1.0, max_participation_factor = 1.0,
        deployed_fraction = 1.0, reserve_direction = "UP",
    )

    components = Dict{String, Any}(
        "Area" => [openapi_raw(area_po)],
        "LoadZone" => [openapi_raw(lz_po)],
        "ACBus" => [openapi_raw(bus1_po), openapi_raw(bus2_po)],
        "Arc" => [openapi_raw(arc_po)],
        "ThermalStandard" => [openapi_raw(thermal_po)],
        "PowerLoad" => [openapi_raw(load_po)],
        "OnlineReserve" => [openapi_raw(reserve_po)],
    )
    if include_fixed_admittance
        shunt_po = PSY.PO.FixedAdmittance(;
            id = 9, name = "shunt1", available = true, bus = 4,
            admittance_units = "DEVICE_MVAR",
            Y = PSY.PC.ComplexNumber(; real = 0.0, imag = -50.0),
        )
        components["FixedAdmittance"] = [openapi_raw(shunt_po)]
    end

    # Every field the SystemDocument schema marks required is present, including the empty
    # ones: a real producer always emits all of them, so a fixture that omits some would let
    # a reader regress into tolerating incomplete documents.
    return Dict{String, Any}(
        "base_power" => 100.0,
        "unit_system" => "NATURAL_UNITS",
        "components" => components,
        "supplemental_attributes" => [],
        # D10: service membership is a row in the unified table, with attribute_id naming
        # the service component (spin_up) and attribute_type its own type name.
        "supplemental_attribute_associations" => [
            Dict{String, Any}(
                "attribute_id" => 8, "entity_id" => 6,
                "attribute_type" => "OnlineReserve",
            ),
        ],
        "time_series_associations" => [],
        "ext" => Dict{String, Any}(),
        "time_series_storage_file" => nothing,
    )
end

"""
A small System exercising every member of a serialized bundle: topology, an injector, a
supplemental attribute, and (unless `with_time_series = false`) a time series so the HDF5
sidecar is written.

Shared by test_openapi_file_io.jl.
"""
function _file_io_fixture(; with_time_series = true)
    sys = System(100.0)
    PSY.set_name!(sys, "bundle-fixture")
    PSY.set_description!(sys, "round-trip check")

    area = Area(nothing)
    area.name = "a1"
    add_component!(sys, area)
    zone = LoadZone(nothing)
    zone.name = "z1"
    add_component!(sys, zone)

    bus = ACBus(nothing)
    bus.name = "b1"
    bus.number = 1
    bus.bustype = ACBusTypes.REF
    bus.base_voltage = 230.0
    bus.area = area
    bus.load_zone = zone
    add_component!(sys, bus)

    gen = ThermalStandard(nothing)
    set_bus!(gen, bus)
    gen.name = "g1"
    add_component!(sys, gen)

    add_supplemental_attribute!(
        sys,
        gen,
        EmissionsData(;
            name = "g1_CO2", pollutant = PollutantType.CO2,
            emission_rate = IncrementalCurve(;
                function_data = LinearFunctionData(0.0, 1.5), initial_input = 0.0,
            ),
            basis = EmissionBasis.FUEL_INPUT, start_up_adder = 0.0,
            mass_unit = MassUnit.LB, energy_unit = EnergyUnit.MMBTU, gwp = 1.0,
            available = true,
        ),
    )

    if with_time_series
        add_time_series!(
            sys,
            gen,
            SingleTimeSeries(
                "max_active_power",
                TimeSeries.TimeArray(
                    collect(
                        Dates.DateTime(2024, 1, 1):Dates.Hour(1):Dates.DateTime(
                            2024, 1, 1, 5,
                        ),
                    ),
                    collect(0.1:0.1:0.6),
                );
                scaling_factor_multiplier = get_max_active_power,
            ),
        )
    end
    return sys
end
