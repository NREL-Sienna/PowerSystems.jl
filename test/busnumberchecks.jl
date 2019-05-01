
#note: may have to remove the 'data' folder from this directory and run 'build PowerSystems'
base_dir = dirname(dirname(pathof(PowerSystems)))

ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "case5_re.m"))

buses, generators, storage, branches, loads, loadZones, shunts, services =
    PowerSystems.ps_dict2ps_struct(ps_dict);
sys = PowerSystems.System(buses, generators, loads, branches, storage,
                               ps_dict["baseMVA"], nothing, nothing, nothing);

@testset "Check bus index" begin
    @test sort([b.number for b in sys.buses]) == [1, 2, 3, 4, 5]
    @test sort(collect(Set([b.connectionpoints.from.number for b in sys.branches]))) ==
        [1, 2, 3, 4]
    @test sort(collect(Set([b.connectionpoints.to.number for b in sys.branches]))) ==
        [2, 3, 4, 5]

    # TODO: add test for loadzones testing MAPPING_BUSNUMBER2INDEX

end
