using PowerSystems
cost = VariableCost([(1.0, 1.0), (2.0, 1.1), (3.0, 1.2)])
slopes = get_slopes(cost)
res = [1.0, 10.0, 10.0]
for (ix, v) in enumerate(slopes)
    @test isapprox(v, res[ix])
end

bps = get_breakpoint_upperbounds(cost)
res = [1.0, 0.1, 0.1]
for (ix, v) in enumerate(bps)
    @test isapprox(v, res[ix])
end
