
const DESCRIPTORS = joinpath(RTS_GMLC_DIR, "user_descriptors.yaml")

function create_rts_system(forecast_resolution = Dates.Hour(1))
    data = PowerSystemTableData(RTS_GMLC_DIR, 100.0, DESCRIPTORS)
    return System(data; forecast_resolution = forecast_resolution)
end

"""Allows comparison of structs that were created from different parsers which causes them
to have different UUIDs."""
function compare_values_without_uuids(x::T, y::T)::Bool where {T <: PowerSystemType}
    match = true

    for (fieldname, fieldtype) in zip(fieldnames(T), fieldtypes(T))
        if fieldname == :internal
            continue
        end

        val1 = getfield(x, fieldname)
        val2 = getfield(y, fieldname)

        # Recurse if this is a PowerSystemType.
        if val1 isa PowerSystemType
            if !compare_values_without_uuids(val1, val2)
                match = false
            end
            continue
        end

        if val1 != val2
            @error "values do not match" fieldname repr(val1) repr(val2)
            match = false
        end
    end

    return match
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
        Bus(
            1, #number
            "Bus 1", #Name
            "REF", #BusType (REF, PV, PQ)
            0, #Angle in radians
            1.06, #Voltage in pu
            (min = 0.94, max = 1.06), #Voltage limits in pu
            69,
            nothing,
            nothing,
        ), #Base voltage in kV
        Bus(2, "Bus 2", "PV", 0, 1.045, (min = 0.94, max = 1.06), 69, nothing, nothing),
    ]

    battery = GenericBattery(
        name = "Battery",
        primemover = PrimeMovers.BA,
        available = true,
        bus = nodes_OMIB[2],
        energy = 5.0,
        capacity = (min = 5.0, max = 100.0),
        rating = 0.0275, #Value in per_unit of the system
        activepower = 0.01375,
        inputactivepowerlimits = (min = 0.0, max = 50.0),
        outputactivepowerlimits = (min = 0.0, max = 50.0),
        reactivepower = 0.0,
        reactivepowerlimits = (min = -50.0, max = 50.0),
        efficiency = (in = 0.80, out = 0.90),
        machine_basepower = 100.0,
    )
    converter = AverageConverter(
        138.0, #Rated Voltage
        100.0,
    ) #Rated MVA

    branch_OMIB = [Line(
        "Line1", #name
        true, #available
        0.0, #active power flow initial condition (from-to)
        0.0, #reactive power flow initial condition (from-to)
        Arc(from = nodes_OMIB[1], to = nodes_OMIB[2]), #Connection between buses
        0.01, #resistance in pu
        0.05, #reactance in pu
        (from = 0.0, to = 0.0), #susceptance in pu
        18.046, #rate in MW
        1.04,
    )]  #angle limits (-min and max)

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

    vsc = CurrentControl(
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

    sys = System(100)
    for bus in nodes_OMIB
        add_component!(sys, bus)
    end
    for lines in branch_OMIB
        add_component!(sys, lines)
    end
    add_component!(sys, battery)

    test_inverter = DynamicInverter(
        battery,
        1.0, #ω_ref
        100.0, #MVABase
        converter, #Converter
        outer_control, #OuterControl
        vsc, #Voltage Source Controller
        dc_source, #DC Source
        pll, #Frequency Estimator
        filt,
    ) #Output Filter

    @test get_V_ref(test_inverter) == 1.045
    @test get_P_ref(test_inverter) == 0.01375
    @test get_Q_ref(test_inverter) == 0.0
    add_component!(sys, test_inverter)

    return sys
end
