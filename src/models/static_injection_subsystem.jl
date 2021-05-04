"""
Abstract type for a subsystem that contains multiple instances of StaticInjection

Subtypes must implement:
- get_subcomponents(subsystem::StaticInjectionSubsystem)

The subcomponents in subtypes must be attached to the System as masked components.
"""
abstract type StaticInjectionSubsystem <: StaticInjection end
