
base_dir = dirname(dirname(pathof(PowerSystems)))

sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))

@testset "Check bus index" begin
    @test sort([b.number for b in collect(get_components(Bus, sys))]) == [1, 2, 3, 4, 10]
    @test sort(collect(Set([b.arch.from.number for
                b in collect(get_components(Branch,sys))]))) == [1, 2, 3, 4]
    @test sort(collect(Set([b.arch.to.number for
                b in collect(get_components(Branch,sys))]))) == [2, 3, 4, 10]

    # TODO: add test for loadzones testing MAPPING_BUSNUMBER2INDEX

end
