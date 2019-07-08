#=
This file is auto-generated. Do not edit.
=#


mutable struct HVDCLine <: DCBranch
    name::String
    available::Bool
    arch::Arch
    activepowerlimits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    activepowerlimits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactivepowerlimits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactivepowerlimits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
    internal::PowerSystems.PowerSystemInternal
end

function HVDCLine(name, available, arch, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, )
    HVDCLine(name, available, arch, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, PowerSystemInternal())
end

function HVDCLine(; name, available, arch, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, )
    HVDCLine(name, available, arch, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, )
end

# Constructor for demo purposes; non-functional.

function HVDCLine(::Nothing)
    HVDCLine(;
        name="init",
        available=false,
        arch=Arch(Bus(nothing), Bus(nothing)),
        activepowerlimits_from=(min=0.0, max=0.0),
        activepowerlimits_to=(min=0.0, max=0.0),
        reactivepowerlimits_from=(min=0.0, max=0.0),
        reactivepowerlimits_to=(min=0.0, max=0.0),
        loss=(l0=0.0, l1=0.0),
    )
end

"""Get HVDCLine name."""
get_name(value::HVDCLine) = value.name
"""Get HVDCLine available."""
get_available(value::HVDCLine) = value.available
"""Get HVDCLine arch."""
get_arch(value::HVDCLine) = value.arch
"""Get HVDCLine activepowerlimits_from."""
get_activepowerlimits_from(value::HVDCLine) = value.activepowerlimits_from
"""Get HVDCLine activepowerlimits_to."""
get_activepowerlimits_to(value::HVDCLine) = value.activepowerlimits_to
"""Get HVDCLine reactivepowerlimits_from."""
get_reactivepowerlimits_from(value::HVDCLine) = value.reactivepowerlimits_from
"""Get HVDCLine reactivepowerlimits_to."""
get_reactivepowerlimits_to(value::HVDCLine) = value.reactivepowerlimits_to
"""Get HVDCLine loss."""
get_loss(value::HVDCLine) = value.loss
"""Get HVDCLine internal."""
get_internal(value::HVDCLine) = value.internal
