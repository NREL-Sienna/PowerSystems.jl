# Creating and Handling Data for Dynamic Simulations

## Introduction

This tutorial briefly introduces how to create a system using `PowerSystems.jl` data
structures. The tutorial will guide you to create the JSON data file for the tutorial 1.
Start by calling `PowerSystems.jl`:

````@example dynamic_data
using PowerSystems
const PSY = PowerSystems
````

## Step 1: System description

Next we need to define the different elements required to run a simulation. To run a
simulation in `PowerSimulationsDynamics`, it is required to define a `System` that contains
the following components:

## Static Components:

We called static components to those that are used to run a Power Flow problem.

- Vector of `Bus` elements, that define all the buses in the network.
- Vector of `Branch` elements, that define all the branches elements (that connect two buses)
  in the network.
- Vector of `StaticInjection` elements, that define all the devices connected to buses that
  can inject (or withdraw) power. These static devices, typically generators, in
  `PowerSimulationsDynamics` are used to solve the PowerFlow problem that determines the
  active and reactive power provided for each device.
- Vector of `PowerLoad` elements, that define all the loads connected to buses that can
  withdraw current. These are also used to solve the Power Flow.
- Vector of `Source` elements, that define source components behind a reactance that can
  inject or withdraw current.
- The base of power used to define per unit values, in MVA as a `Float64` value.
- The base frequency used in the system, in Hz as a `Float64` value.

## Dynamic Components:

Dynamic components are those that define differential equations to run a transient simulation.

- Vector of `DynamicInjection` elements. These components must be attached to a
`StaticInjection` that connects the power flow solution to the dynamic formulation of such
device. `DynamicInjection` can be `DynamicGenerator` or `DynamicInverter`, and its specific
formulation (i.e. differential equations) will depend on the specific components that define such device.
- (Optional) Selecting which of the `Lines` (of the `Branch` vector) elements must be modeled of
`DynamicLines` elements, that can be used to model lines with differential equations.

To start we will define the data structures for the network.

## One Machine Infinite Bus case manual data creation

The following describes the system creation for the OMIB case.

## Static System creation

To create the system you need to pass the location of the RAW file see tutorial on loading
power flow cases

````@example dynamic_data
file_dir =
omib_sys = System(joinpath(file_dir, "OMIB.raw"))
````

This system does not have an injection device in bus 1 (the reference bus).
We can add a source with small impedance directly as follows:

````@example dynamic_data
slack_bus = [b for b in get_components(Bus, omib_sys) if b.bustype == BusTypes.REF][1]
inf_source = Source(
    name = "InfBus", #name
    available = true, #availability
    active_power = 0.0,
    reactive_power = 0.0,
    bus = slack_bus, #bus
    R_th = 0.0, #Rth
    X_th = 5e-6, #Xth
)
add_component!(omib_sys, inf_source)
````

We just added a infinite source with $X_{th} = 5\cdot 10^{-6}$ pu

The system can be explored directly using functions like:

````@example dynamic_data
get_components(Source, omib_sys)

get_components(Generator, omib_sys)
````

By exploring those it can be seen that the generators are named as: `generator-bus_number-id`.
Then, the generator attached at bus 2 is named `generator-102-1`.

### Dynamic Injections

We are now interested in attaching to the system the dynamic component that will be modeling
our dynamic generator.

Dynamic generator devices are composed by 5 components, namely, `machine`, `shaft`,
`avr`, `tg` and `pss`. So we will be adding functions to create all of its components and
the generator itself:

*Machine*

````@example dynamic_data
machine_classic() = BaseMachine(
    0.0, #R
    0.2995, #Xd_p
    0.7087, #eq_p
)
````

*Shaft*

````@example dynamic_data
shaft_damping() = SingleMass(
    3.148, #H
    2.0, #D
)
````

*AVR: No AVR*

````@example dynamic_data
avr_none() = AVRFixed(0.0)
````

*TG: No TG*

````@example dynamic_data
tg_none() = TGFixed(1.0) #efficiency
````

*PSS: No PSS*

````@example dynamic_data
pss_none() = PSSFixed(0.0)
````

The next lines receives a static generator name, and creates a `DynamicGenerator` based on
that specific static generator, with the specific components defined previously. This is
a classic machine model without AVR, Turbine Governor and PSS.

````@example dynamic_data
static_gen = get_component(Generator, omib_sys, "generator-102-1")

dyn_gen = DynamicGenerator(
    name = get_name(static_gen),
    ω_ref = 1.0,
    machine = machine_classic(),
    shaft = shaft_damping(),
    avr = avr_none(),
    prime_mover = tg_none(),
    pss = pss_none(),
)
````

The dynamic generator is added to the system by specifying the dynamic and static generator

````@example dynamic_data
add_component!(omib_sys, dyn_gen, static_gen)
````

Then we can serialize our system data to a json file that can be later read as:

````@example dynamic_data
to_json(omib_sys, joinpath(file_dir, "omib_sys.json"), force = true)
````

## Dynamic Lines case: Data creation

We will now create a three bus system with one inverter and one generator.
In order to do so, we will parse the following `ThreebusInverter.raw` network:

````@example dynamic_data
sys_file_dir = joinpath(file_dir, "ThreeBusInverter.raw")
threebus_sys = System(sys_file_dir)
slack_bus = [b for b in get_components(Bus, threebus_sys) if b.bustype == BusTypes.REF][1]
inf_source = Source(
    name = "InfBus", #name
    available = true, #availability
    active_power = 0.0,
    reactive_power = 0.0,
    bus = slack_bus, #bus
    R_th = 0.0, #Rth
    X_th = 5e-6, #Xth
)
add_component!(threebus_sys, inf_source)
````

We will connect a One-d-one-q machine at bus 102, and a Virtual Synchronous Generator
Inverter at bus 103. An inverter is composed by a `converter`, `outer control`,
`inner control`, `dc source`, `frequency estimator` and a `filter`.

## Dynamic Inverter definition

We will create specific functions to create the components of the inverter as follows:

````@example dynamic_data
#Define converter as an AverageConverter
converter_high_power() = AverageConverter(rated_voltage = 138.0, rated_current = 100.0)

#Define Outer Control as a composition of Virtual Inertia + Reactive Power Droop
outer_control() = OuterControl(
    VirtualInertia(Ta = 2.0, kd = 400.0, kω = 20.0),
    ReactivePowerDroop(kq = 0.2, ωf = 1000.0),
)

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
````

We will construct the inverter later by specifying to which static device is assigned.

## Dynamic Generator definition

Similarly we will construct a dynamic generator as follows:
Create the machine

````@example dynamic_data
machine_oneDoneQ() = OneDOneQMachine(
    0.0, #R
    1.3125, #Xd
    1.2578, #Xq
    0.1813, #Xd_p
    0.25, #Xq_p
    5.89, #Td0_p
    0.6, #Tq0_p
)
````

Shaft

````@example dynamic_data
shaft_no_damping() = SingleMass(
    3.01, #H (M = 6.02 -> H = M/2)
    0.0, #D
)
````

AVR: Type I: Resembles a DC1 AVR

````@example dynamic_data
avr_type1() = AVRTypeI(
    20.0, #Ka - Gain
    0.01, #Ke
    0.063, #Kf
    0.2, #Ta
    0.314, #Te
    0.35, #Tf
    0.001, #Tr
    (min = -5.0, max = 5.0),
    0.0039, #Ae - 1st ceiling coefficient
    1.555, #Be - 2nd ceiling coefficient
)

#No TG
tg_none() = TGFixed(1.0) #efficiency

#No PSS
pss_none() = PSSFixed(0.0) #Vs
````

Now we will construct the dynamic generator and inverter.

## Add the components to the system

````@example dynamic_data
for g in get_components(Generator, threebus_sys)
    #Find the generator at bus 102
    if get_number(get_bus(g)) == 102
        #Create the dynamic generator
        case_gen = DynamicGenerator(
            get_name(g),
            1.0, # ω_ref,
            machine_oneDoneQ(), #machine
            shaft_no_damping(), #shaft
            avr_type1(), #avr
            tg_none(), #tg
            pss_none(), #pss
        )
        #Attach the dynamic generator to the system by specifying the dynamic and static part
        add_component!(threebus_sys, case_gen, g)
        #Find the generator at bus 103
    elseif get_number(get_bus(g)) == 103
        #Create the dynamic inverter
        case_inv = DynamicInverter(
            get_name(g),
            1.0, # ω_ref,
            converter_high_power(), #converter
            outer_control(), #outer control
            inner_control(), #inner control voltage source
            dc_source_lv(), #dc source
            pll(), #pll
            filt(), #filter
        )
        #Attach the dynamic inverter to the system
        add_component!(threebus_sys, case_inv, g)
    end
end
````

### Save the system in a JSON file

````@example dynamic_data
to_json(threebus_sys, joinpath(file_dir, "threebus_sys.json"), force = true)
````
