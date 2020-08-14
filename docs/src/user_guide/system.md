# System

## System description

### Static Components:

We called static components to those that are used for static

- Vector of `Bus` elements, that define all the buses in the network.
- Vector of `Branch` elements, that define all the branches elements (that connect two buses) in the network.
- Vector of `StaticInjection` elements, that define all the devices connected to buses that can inject (or withdraw) power.
- Vector of `PowerLoad` elements, that define all the loads connected to buses that can withdraw current.
- Vector of `Source` elements, that define source components behind a reactance that can inject or withdraw current.
- The base of power used to define per unit values, in MVA as a `Float64` value.
- The base frequency used in the system, in Hz as a `Float64` value.

### Dynamic Components:

Dynamic components are those that define differential equations to run a transient simulation. Basically those are:

- Vector of `DynamicInjection` elements. These components must be attached to a `StaticInjection` that connects the power flow solution to the dynamic formulation of such device. `DynamicInjection` can be `DynamicGenerator` or `DynamicInverter`, and its specific formulation (i.e. differential equations) will depend on the specific components that define such device.
- (Optional) Selecting which of the `Lines` (of the `Branch` vector) elements must be modeled of `DynamicLines` elements, that can be used to model lines with differential equations.

To start we will define the data structures for the network.
