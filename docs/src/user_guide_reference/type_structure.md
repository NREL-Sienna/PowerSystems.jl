# Type Structure

The abstract hierarchy enables categorization of the devices by their operational
characteristics and modeling requirements. The figure shows the
abstract hierarchy of components. For instance, generation is classified by the distinctive
data requirements for modeling in three categories: Thermal, Renewable, and Hydropower.
As a result of this design, developers can define model logic entirely based on abstract
types and create generic code to support modeling technologies that are not yet
implemented in the package. `PowerSystems.jl` has a category of topological
components (e.g., Bus, Arc), separate from the physical components.

The hierarchy also includes components absent in standard data models, such as services.

The services category includes reserves,transfers and `AGC`. The power of `PowerSystems.jl`
lies in providing the abstraction without an implicit mathematical representation of the component.
