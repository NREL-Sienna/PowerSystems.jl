# Understanding [ACBusTypes](@ref)

When creating nodal datasets, the definitions for AC Buses can have a significant impact on the
topology logic for the network.

## Voltage Control Types

  - PQ:
    
      + **Known:** Real Power Injection ($P$) and Reactive Power Injection($Q$). These are typically the loads at that bus or fixed power factor generators.
      + **Unknown:** Voltage Magnitude ($|V|$) and Voltage Angle ($\delta$).
      + Represents a bus where the voltage magnitude and angle are free to vary based on the system conditions.

  - PV:
    
      + **Known:** Real Power Injection ($P$) and Voltage Magnitude ($|V|$).
      + **Unknown:** Reactive Power Injection ($Q$) and Voltage Angle ($\delta$).
      + Typically represents a bus with an injector connected, where the injector controls the reactive power output and regulates the bus voltage magnitude to a setpoint.

## Reference and Slack Buses

There is a nuanced distinction between a slack bus and a reference bus. In most small test sytems and
academic discussions, the system has a single slack bus which is also the reference bus. However, for large interconnected cases or cases with a very radial structure, having a single bus that takes on all the real power mistmatches in the system can lead to erroneus results.

  - Slack:
    
      + Known: Voltage Magnitude ($|V|$) and Voltage Angle ($\delta$) **when the slack and the reference are the same bus, otherwise is unknown**.
      + Unknown: Real Power ($P$) and Reactive Power ($Q$). These values are calculated as residuals after the power flow solution converges to account for system losses and imbalances and allocated using participation factors in the model formulation.
      + This kind of buses absorb or supplies the difference between the total generation and total load plus losses in the system. There can be several slack buses in a system.

  - Ref:
    
      + Known: Voltage Magnitude ($|V|$) and Voltage Angle ($\delta$). Typically, the angle to 0 degrees for simplicity and the voltage is set to a fixed value per unit.
      + Unknown: Real Power ($P$) and Reactive Power ($Q$). These values are calculated as residuals after the power flow solution converges to account for system losses and imbalances when there is there is a single slack bus that matches the reference bus.
      + Serves as the "reference" for all other bus voltage angles in the AC interconnected system.

For the study of large interconnected areas that include different asynchronous AC networks connected through HVDC the system can contain multiple reference buses. Since not all modeling efforts require a properly set reference bus, e.g., Zonal Modeling, **PowerSystems.jl does not perform a verification that the system buses are adequately set. This feature is implemented in PowerNetworkMatrices.jl**

## Isolated Buses and the `available` field

In certain modeling applications, particularly power flow modeling tools, the designation of
"isolated" is used to signal that the bus is disconnected from the network as well as any other
component attached to it. However, in PowerSystems.jl this is achieved by employing the `available` field and setting it to false as follows: `set_available!(bus, false)`.

In PowerSystems.jl the `ISOLATED` type means exactly that: The bus is not connected to the network. In
resource analysis where systems contain isolated subsystems and they can be ignored for the purposes of the power flow but are relevant when performing optimization, the `ISOLATED` designation provides the capability to describe those situations in precise terms. `ISOLATED` buses can also be made unavailable to make the components attached to them also unavailable.
