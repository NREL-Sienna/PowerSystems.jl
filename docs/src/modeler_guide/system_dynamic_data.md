# Creating a System with Dynamic devices

You can access example data in the [Power Systems Test Data Repository](https://github.com/NREL-Sienna/PowerSystemsTestData)
the data can be downloaded with the submodule `UtilsData`

```@repl dynamic_data
using PowerSystems
const PSY = PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "test_data")
```

Although `PowerSystems.jl` is not constrained to only PSS/e files, commonly the data available
comes in a pair of files: One for the static data power flow case and a second one with the
dynamic components information. However, `PowerSystems.jl` is able to take any power flow case
and specify dynamic components to it.

The following describes the system creation for the one machine infinite bus case using custom
component specifications.

## One Machine Infinite Bus Example

First load data from any format (see [Constructing a System from RAW data](@ref parsing) for
details. In this example we will load a [PTI power flow data format](https://labs.ece.uw.edu/pstca/formats/pti.txt)
(`.raw` file) as follows:

```raw
0, 100, 33, 0, 0, 60  / 24-Apr-2020 17:05:49 - MATPOWER 7.0.1-dev


     101, 'BUS 1       ',       230, 3,    1,    1, 1,        1.05,           0, 1.06, 0.94, 1.06, 0.94
     102, 'BUS 2       ',       230, 2,    1,    1, 1,        1.04,           0, 1.06, 0.94, 1.06, 0.94
0 / END OF BUS DATA, BEGIN LOAD DATA
0 / END OF LOAD DATA, BEGIN FIXED SHUNT DATA
0 / END OF FIXED SHUNT DATA, BEGIN GENERATOR DATA
     102,  1,        50,         0,       100,      -100,     1.00, 0,     100, 0, 1, 0, 0, 1, 1, 100,       100,         0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1
0 / END OF GENERATOR DATA, BEGIN BRANCH DATA
     101,      102, 1,    0.00,     0.05,   0.000,     100,     100,     100, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1
0 / END OF BRANCH DATA, BEGIN TRANSFORMER DATA
0 / END OF TRANSFORMER DATA, BEGIN AREA DATA
0 / END OF AREA DATA, BEGIN TWO-TERMINAL DC DATA
0 / END OF TWO-TERMINAL DC DATA, BEGIN VOLTAGE SOURCE CONVERTER DATA
0 / END OF VOLTAGE SOURCE CONVERTER DATA, BEGIN IMPEDANCE CORRECTION DATA
0 / END OF IMPEDANCE CORRECTION DATA, BEGIN MULTI-TERMINAL DC DATA
0 / END OF MULTI-TERMINAL DC DATA, BEGIN MULTI-SECTION LINE DATA
0 / END OF MULTI-SECTION LINE DATA, BEGIN ZONE DATA
0 / END OF ZONE DATA, BEGIN INTER-AREA TRANSFER DATA
0 / END OF INTER-AREA TRANSFER DATA, BEGIN OWNER DATA
0 / END OF OWNER DATA, BEGIN FACTS CONTROL DEVICE DATA
0 / END OF FACTS CONTROL DEVICE DATA, BEGIN SWITCHED SHUNT DATA
0 / END OF SWITCHED SHUNT DATA, BEGIN GNE DEVICE DATA
0 / END OF GNE DEVICE DATA, BEGIN INDUCTION MACHINE DATA
0 / END OF INDUCTION MACHINE DATA
Q
```

Based on the description provided in PTI files, this is a two-bus system, on which the bus
101 (bus 1) is the reference bus at 1.05 pu, and bus 102 (bus 2) is PV bus, to be set at
1.04 pu. There is one 100 MVA generator connected at bus 2, producing 50 MW. There is an
equivalent line connecting buses 1 and 2 with a reactance of ``0.05`` pu.

We can load this data file first

```@repl dynamic_data
omib_sys = System(joinpath(file_dir, "OMIB.raw"), runchecks = false)
```

### Dynamic Generator

We are now interested in attaching to the system the dynamic component that will be modeling
our dynamic generator. The data can be added by directly passing a `.dyr` file, but in this
example we want to add custom dynamic data.

Dynamic generator devices are composed by 5 components, namely, `machine`, `shaft`, `avr`,
`tg` and `pss` (see [`DynamicGenerator`](@ref)). So we will be adding functions to create all
of its components and the generator itself. The example code  creates all the components
for a [`DynamicGenerator`](@ref) based on specific models for its components. This result
will be a classic machine model without AVR, Turbine Governor and PSS.

```@repl dynamic_data
#Machine
machine_classic = BaseMachine(
    R = 0.0,
    Xd_p = 0.2995,
    eq_p = 0.7087,
)

#Shaft
shaft_damping = SingleMass(
    H = 3.148,
    D = 2.0,
)

#AVR
avr_none = AVRFixed(Vf = 0.0)

#TurbineGovernor
tg_none = TGFixed(efficiency = 1.0)

#PSS
pss_none = PSSFixed(V_pss = 0.0);
```

Then we can collect all the dynamic components and create the dynamic generator and assign it
to a static generator of choice. In this example we will add it to the generator "generator-102-1"
as follows:

```@repl dynamic_data
#Collect the static gen in the system
static_gen = get_component(Generator, omib_sys, "generator-102-1")
#Creates the dynamic generator
dyn_gen = DynamicGenerator(
            name = get_name(static_gen),
            ω_ref = 1.0,
            machine = machine_classic,
            shaft = shaft_damping,
            avr = avr_none,
            prime_mover = tg_none,
            pss = pss_none,
        )
#Add the dynamic generator the system
add_component!(omib_sys, dyn_gen, static_gen)
```

Once the data is created, we can export our system data such that it can be reloaded later:

```julia
to_json(omib_sys, "YOUR_DIR/omib_sys.json")
```

## Example with Dynamic Inverter

We will now create a three bus system with one inverter and one generator. In order to do so,
we will parse the following file `ThreebusInverter.raw`:

```raw
0, 100, 33, 0, 0, 60  / 24-Apr-2020 19:28:39 - MATPOWER 7.0.1-dev


     101, 'BUS 1       ',       138, 3,    1,    1, 1,           1.02,        0,  1.1,  0.9,  1.1,  0.9
     102, 'BUS 2       ',       138, 2,    1,    1, 1,           1.0142,           0,  1.1,  0.9,  1.1,  0.9
     103, 'BUS 3       ',       138, 2,    1,    1, 1,           1.0059,           0,  1.1,  0.9,  1.1,  0.9
0 / END OF BUS DATA, BEGIN LOAD DATA
     101,  1, 1,    1,    1,       50,       10, 0, 0, 0, 0, 1, 1, 0
     102,  1, 1,    1,    1,       100,      30, 0, 0, 0, 0, 1, 1, 0
     103,  1, 1,    1,    1,       30,       10, 0, 0, 0, 0, 1, 1, 0
0 / END OF LOAD DATA, BEGIN FIXED SHUNT DATA
0 / END OF FIXED SHUNT DATA, BEGIN GENERATOR DATA
     102,  1,       70,         0,       100,      -100,   1.0142, 0,     100, 0, 1, 0, 0, 1, 1, 100,       318,         0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1
     103,  1,       80,         0,       100,      -100,   1.0059, 0,     100, 0, 1, 0, 0, 1, 1, 100,       318,         0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1
0 / END OF GENERATOR DATA, BEGIN BRANCH DATA
     101,      103, 1,  0.01000,     0.12,      0.2,     250,     250,     250, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1
     101,      102, 1,  0.01000,     0.12,      0.2,     250,     250,     250, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1
     102,      103, 1,  0.02000,     0.9,      1.0,     250,     250,     250, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1
0 / END OF BRANCH DATA, BEGIN TRANSFORMER DATA
0 / END OF TRANSFORMER DATA, BEGIN AREA DATA
0 / END OF AREA DATA, BEGIN TWO-TERMINAL DC DATA
0 / END OF TWO-TERMINAL DC DATA, BEGIN VOLTAGE SOURCE CONVERTER DATA
0 / END OF VOLTAGE SOURCE CONVERTER DATA, BEGIN IMPEDANCE CORRECTION DATA
0 / END OF IMPEDANCE CORRECTION DATA, BEGIN MULTI-TERMINAL DC DATA
0 / END OF MULTI-TERMINAL DC DATA, BEGIN MULTI-SECTION LINE DATA
0 / END OF MULTI-SECTION LINE DATA, BEGIN ZONE DATA
0 / END OF ZONE DATA, BEGIN INTER-AREA TRANSFER DATA
0 / END OF INTER-AREA TRANSFER DATA, BEGIN OWNER DATA
0 / END OF OWNER DATA, BEGIN FACTS CONTROL DEVICE DATA
0 / END OF FACTS CONTROL DEVICE DATA, BEGIN SWITCHED SHUNT DATA
0 / END OF SWITCHED SHUNT DATA, BEGIN GNE DEVICE DATA
0 / END OF GNE DEVICE DATA, BEGIN INDUCTION MACHINE DATA
0 / END OF INDUCTION MACHINE DATA
Q
```

That describes a three bus connected system, with generators connected at bus 2 and 3, and
loads in three buses. We can load the system and attach an infinite source on the reference bus:

```@repl dynamic_data
threebus_sys = System(joinpath(file_dir, "ThreeBusInverter.raw"), runchecks = false)
```

We will connect a [`OneDOneQMachine`](@ref) machine at bus 102, and a Virtual Synchronous Generator Inverter
at bus 103. An inverter is composed by a `converter`, `outer control`, `inner control`,
`dc source`, `frequency estimator` and a `filter` (see [`DynamicInverter`](@ref)).

### Dynamic Inverter definition

We will create specific components of the inverter as follows:

```@repl dynamic_data
#Define converter as an AverageConverter
converter_high_power = AverageConverter(rated_voltage = 138.0, rated_current = 100.0)

#Define Outer Control as a composition of Virtual Inertia + Reactive Power Droop
outer_cont = OuterControl(
    active_power_control = VirtualInertia(Ta = 2.0, kd = 400.0, kω = 20.0),
    reactive_power_control = ReactivePowerDroop(kq = 0.2, ωf = 1000.0),
)

#Define an Inner Control as a Voltage+Current Controler with Virtual Impedance:
inner_cont = VoltageModeControl(
    kpv = 0.59,     #Voltage controller proportional gain
    kiv = 736.0,    #Voltage controller integral gain
    kffv = 0.0,     #Binary variable enabling the voltage feed-forward in output of current controllers
    rv = 0.0,       #Virtual resistance in pu
    lv = 0.2,       #Virtual inductance in pu
    kpc = 1.27,     #Current controller proportional gain
    kic = 14.3,     #Current controller integral gain
    kffi = 0.0,     #Binary variable enabling the current feed-forward in output of current controllers
    ωad = 50.0,     #Active damping low pass filter cut-off frequency
    kad = 0.2,      #Active damping gain
)

#Define DC Source as a FixedSource:
dc_source_lv = FixedDCSource(voltage = 600.0)

#Define a Frequency Estimator as a PLL based on Vikram Kaura and Vladimir Blaskoc 1997 paper:
pll = KauraPLL(
    ω_lp = 500.0, #Cut-off frequency for LowPass filter of PLL filter.
    kp_pll = 0.084,  #PLL proportional gain
    ki_pll = 4.69,   #PLL integral gain
)

#Define an LCL filter:
filt = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01)
```

Similarly we will construct a dynamic generator as follows:

```@repl dynamic_data
#Create the machine
machine_oneDoneQ = OneDOneQMachine(
    R = 0.0,
    Xd = 1.3125,
    Xq = 1.2578,
    Xd_p = 0.1813,
    Xq_p = 0.25,
    Td0_p = 5.89,
    Tq0_p = 0.6,
)

#Shaft
shaft_no_damping = SingleMass(
    H = 3.01,
    D = 0.0,
)

#AVR: Type I: Resembles a DC1 AVR
avr_type1 = AVRTypeI(
    Ka = 20.0,
    Ke = 0.01,
    Kf = 0.063,
    Ta = 0.2,
    Te = 0.314,
    Tf = 0.35,
    Tr = 0.001,
    Va_lim = (min = -5.0, max = 5.0),
    Ae = 0.0039, #1st ceiling coefficient
    Be = 1.555, #2nd ceiling coefficient
)

#No TG
tg_none = TGFixed(efficiency = 1.0)

#No PSS
pss_none = PSSFixed(V_pss = 0.0);
```

### Add the components to the System

```@repl dynamic_data
for g in get_components(Generator, threebus_sys)
    #Find the generator at bus 102
    if get_number(get_bus(g)) == 102
        #Create the dynamic generator
        case_gen = DynamicGenerator(
            name = get_name(g),
            ω_ref = 1.0,
            machine = machine_oneDoneQ,
            shaft = shaft_no_damping,
            avr = avr_type1,
            prime_mover = tg_none,
            pss = pss_none,
        )
        #Attach the dynamic generator to the system
        add_component!(threebus_sys, case_gen, g)
    #Find the generator at bus 103
    elseif get_number(get_bus(g)) == 103
        #Create the dynamic inverter
        case_inv = DynamicInverter(
            name = get_name(g),
            ω_ref = 1.0,
            converter = converter_high_power,
            outer_control = outer_cont,
            inner_control = inner_cont,
            dc_source = dc_source_lv,
            freq_estimator = pll,
            filter = filt,
        )
        #Attach the dynamic inverter to the system
        add_component!(threebus_sys, case_inv, g)
    end
end

# We can check that the system has the Dynamic Inverter and Generator
threebus_sys
```

Finally we can seraliaze the system data for later reloading

```julia
to_json(threebus_sys, "YOUR_DIR/threebus_sys.json")
```
