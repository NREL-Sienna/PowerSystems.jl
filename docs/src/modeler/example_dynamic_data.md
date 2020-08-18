# Creating a Dynamic System

This tutorial briefly introduces how to create a system using `PowerSystems.jl` data structures. The tutorial will guide you to create the JSON data file for the tutorial 1. We start by calling `PowerSystems.jl`:

```julia
using PowerSystems
const PSY = PowerSystems
```

The following describes the system creation for the OMIB case.

## Static System creation

There are plenty of ways to define a static system (for Power Flow purposes), but the recommended option for users is to use a [PTI data format](https://labs.ece.uw.edu/pstca/formats/pti.txt) (`.raw` file) or a [Matpower data format](https://matpower.org/docs/manual.pdf) (`.m` file), since parsers are available. The following `OMIB.raw` file is used to create the OMIB system:
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
Based on the description provided in PTI files, this is a two-bus system, on which the bus 101 (bus 1) is the reference bus at 1.05 pu, and bus 102 (bus 2) is PV bus, to be set at 1.04 pu. There is one 100 MVA generator connected at bus 2, producing 50 MW. There is an equivalent line connecting buses 1 and 2 with a reactance of ``0.05`` pu.

```julia
#To create the system you need to pass the location of the RAW file
file_dir = "OMIB.raw"
omib_sys = System(omib_file_dir)
```
Note that this system does not have an injection device in bus 1 (the reference bus). We can add a source with small impedance directly using a function like:
```julia
function add_source_to_ref(sys::System)
    for g in get_components(StaticInjection, sys)
        isa(g, ElectricLoad) && continue
        g.bus.bustype == BusTypes.REF &&
            error("A device is already attached to the REF bus")
    end

    slack_bus = [b for b in get_components(Bus, sys) if b.bustype == BusTypes.REF][1]
    inf_source = Source(
        name = "InfBus", #name
        available = true, #availability
        active_power = 0.0,
        reactive_power = 0.0,
        bus = slack_bus, #bus
        R_th = 0.0, #Rth
        X_th = 5e-6, #Xth
    )
    add_component!(sys, inf_source)
    return
end

add_source_to_ref(omib_sys)
```
This function attempts to add a infinite source with ``X_{th} = 5\cdot 10^{-6}`` pu if no other device is already attached to the reference bus.

The system can be explored directly using functions like:
```julia
collect(get_components(Source, omib_sys))
collect(get_components(Generators, omib_sys))
```
By exploring those it can be seen that the generators are named as: `generator-bus_number-id`. Then, the generator attached at bus 2 is simply named `generator-102-1`.

### Dynamic Injections

We are now interested in attaching to the system the dynamic component that will be modeling our dynamic generator. Later versions will include a parser for `.dyr` files.

Dynamic generator devices are composed by 5 components, namely, `machine`, `shaft`, `avr`, `tg` and `pss`. So we will be adding functions to create all of its components and the generator itself:

```julia
#Machine
machine_classic() = BaseMachine(
    0.0, #R
    0.2995, #Xd_p
    0.7087, #eq_p
)

#Shaft
shaft_damping() = SingleMass(
    3.148, #H
    2.0, #D
)

#AVR
avr_none() = AVRFixed(0.0)
#TG
tg_none() = TGFixed(1.0) #efficiency
#PSS
pss_none() = PSSFixed(0.0)

function dyn_gen_classic(generator)
    return DynamicGenerator(
        generator,
        1.0, #ω_ref
        machine_classic(), #machine
        shaft_damping(), #shaft
        avr_none(), #avr
        tg_none(), #tg
        pss_none(), #pss
    )
end
```

The last function receives a static generator, and creates a `DynamicGenerator` based on that specific static generator, with the specific components defined previously. This is a classic machine model without AVR, Turbine Governor and PSS.

Then we can simply create the dynamic generator as:

```julia
#Collect the static gen in the system
static_gen = get_component(Generator, omib_sys, "generator-102-1")
#Creates the dynamic generator
dyn_gen = dyn_gen_classic(static_gen)
#Add the dynamic generator the system
add_component!(omib_sys, dyn_gen)
```

Then we can simply export our system data such that it can be later read as:
```julia
to_json(omib_sys, "YOUR_DICT/omib_sys.json")
```

## Dynamic Lines case: Data creation

We will now create a three bus system with one inverter and one generator. In order to do so, we will parse the following `ThreebusInverter.raw` network:

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
That describes a three bus connected system, with generators connected at bus 2 and 3, and loads in three buses. We can load the system and attach an infinite source on the reference bus:
```julia
sys_file_dir = "ThreeBusInverter.raw")
threebus_sys = System(sys_file_dir)
add_source_to_ref(threebus_sys)
```
We will connect a One-d-one-q machine at bus 102, and a Virtual Synchronous Generator Inverter at bus 103. An inverter is composed by a `converter`, `outer control`, `inner control`, `dc source`, `frequency estimator` and a `filter`.

### Dynamic Inverter definition

We will create specific functions to create the components of the inverter as follows:

```julia
#Define converter as an AverageConverter
converter_high_power() = AverageConverter(rated_voltage = 138.0, rated_current = 100.0)

#Define Outer Control as a composition of Virtual Inertia + Reactive Power Droop
function outer_control()
    function virtual_inertia()
        return VirtualInertia(Ta = 2.0, kd = 400.0, kω = 20.0)
    end
    function reactive_droop()
        return ReactivePowerDroop(kq = 0.2, ωf = 1000.0)
    end
    return OuterControl(virtual_inertia(), reactive_droop())
end

#Define an Inner Control as a Voltage+Current Controler with Virtual Impedance:
inner_control() = CurrentControl(
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
dc_source_lv() = FixedDCSource(voltage = 600.0)

#Define a Frequency Estimator as a PLL based on Vikram Kaura and Vladimir Blaskoc 1997 paper:
pll() = KauraPLL(
    ω_lp = 500.0, #Cut-off frequency for LowPass filter of PLL filter.
    kp_pll = 0.084,  #PLL proportional gain
    ki_pll = 4.69,   #PLL integral gain
)

#Define an LCL filter:
filt() = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01)

#Construct the Inverter:
function inv_case78(static_device)
    return DynamicInverter(
        static_device,
        1.0, # ω_ref,
        converter_high_power(), #converter
        outer_control(), #outer control
        inner_control(), #inner control voltage source
        dc_source_lv(), #dc source
        pll(), #pll
        filt(), #filter
    )
end
```

The last function receives a static device, typically a generator, and defines a dynamic inverter based on the components already defined.

### Dynamic Generator definition

Similarly we will construct a dynamic generator as follows:

```julia
#Create the machine
machine_oneDoneQ() = OneDOneQMachine(
    0.0, #R
    1.3125, #Xd
    1.2578, #Xq
    0.1813, #Xd_p
    0.25, #Xq_p
    5.89, #Td0_p
    0.6, #Tq0_p
)

#Shaft
shaft_no_damping() = SingleMass(
    3.01, #H (M = 6.02 -> H = M/2)
    0.0,
) #D

#AVR: Type I: Resembles a DC1 AVR
avr_type1() = AVRTypeI(
    20.0, #Ka - Gain
    0.01, #Ke
    0.063, #Kf
    0.2, #Ta
    0.314, #Te
    0.35, #Tf
    0.001, #Tr
    5.0, #Vrmax
    -5.0, #Vrmin
    0.0039, #Ae - 1st ceiling coefficient
    1.555, #Be - 2nd ceiling coefficient
)

#No TG
tg_none() = TGFixed(1.0) #efficiency

#No PSS
pss_none() = PSSFixed(0.0) #Vs

#Construct the generator
function dyn_gen_second_order(generator)
    return DynamicGenerator(
        generator,
        1.0, # ω_ref,
        machine_oneDoneQ(), #machine
        shaft_no_damping(), #shaft
        avr_type1(), #avr
        tg_none(), #tg
        pss_none(), #pss
    )
end
```

### Add the components to the system

```julia
for g in get_components(Generator, threebus_sys)
    #Find the generator at bus 102
    if get_number(get_bus(g)) == 102
        #Create the dynamic generator
        case_gen = dyn_gen_second_order(g)
        #Attach the dynamic generator to the system
        add_component!(threebus_sys, case_gen)
    #Find the generator at bus 103
    elseif get_number(get_bus(g)) == 103
        #Create the dynamic inverter
        case_inv = inv_case78(g)
        #Attach the dynamic inverter to the system
        add_component!(threebus_sys, case_inv)
    end
end
```

### Save the system in a JSON file

```julia
to_json(threebus_sys, "YOUR_DOCT/threebus_sys.json")
```
