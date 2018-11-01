function pu_check_gen!(gens::Array{<:ThermalGen}, basemva::Float64)

    for (ix,g) in enumerate(gens)

        if (g.tech.activepower.max/basemva) > 100
            @warn "Data for generator max output is 100 times larger than the base MVA for the system\n. Power Systems infered the Data Provided is in MVA and will transform it using a base of $("basemva")"

            new_data = ((g.tech.activepower/basemva) > 100 ? (g.tech.activepower/basemva): g.tech.activepower,
                        (g.tech.activepowerlimits.max/basemva, (g.tech.activepowerlimits.min/basemva) > 100 ? (g.tech.activepowerlimits.min/basemva) : g.tech.activepowerlimits.min),
                        (g.tech.reactivepower/basemva) > 100 ? (g.tech.reactivepower/basemva): g.tech.reactivepower,
                         ((g.tech.reactivepowerlimits.max) > 100 ? :, (g.tech.reactivepowerlimits.max) > 100 ? :),
                         ((g.tech.reactivepowerlimits.max) > 100 ? :, (g.tech.reactivepowerlimits.max) > 100 ? :)
            )
        end
        g.activepower
        g.activepowerlimits
        g.reactivepower
        g.reactivepowerlimits
        g.ramplimits

    end

    if hist[1]

        gens[ix] = Line(deepcopy(l.name),deepcopy(l.available),
                            deepcopy(l.connectionpoints),deepcopy(l.r),
                            deepcopy(l.x),deepcopy(l.b),deepcopy(l.rate),
                            hist[2])
    end

end

function pu_check_gen!(gens::Array{<:RenewableGen}, basemva::Float64)

    for (ix,g) in enumerate(gens)

        g.installedcapacity
        g.reactivepowerlimits

    end

    if hist[1]

        gens[ix] = Line(deepcopy(l.name),deepcopy(l.available),
                            deepcopy(l.connectionpoints),deepcopy(l.r),
                            deepcopy(l.x),deepcopy(l.b),deepcopy(l.rate),
                            hist[2])
    end

end

function pu_check_gen!(gens::Array{<:HydroGen}, basemva::Float64)

    for (ix,g) in enumerate(gens)

        g.activepower
        g.activepowerlimits
        g.reactivepower
        g.reactivepowerlimits
        g.ramplimits

    end

end