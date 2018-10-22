@testset "Check bus index" begin

base_dir = dirname(dirname(pathof(PowerSystems))) #note: may have to remove the 'data' folder from this directory and run 'build PowerSystems'

ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(base_dir, "data/matpower/case5_re.m")));

Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts  = PowerSystems.ps_dict2ps_struct(ps_dict);
sys = PowerSystems.PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]);

@test sort([b.number for b in sys.buses]) == [1, 2, 3, 4, 5]
@test sort(collect(Set([b.connectionpoints.from.number for b in sys.branches]))) == [1, 2, 4, 5]
@test sort(collect(Set([b.connectionpoints.to.number for b in sys.branches]))) == [1, 3, 4, 5]

end


