using PowerSystems
using NamedTuples

alims = @NT(max = 360.0, min = -360.0)
alims = PowerSystems.check_angle_limits(alims)
@assert "$alims" == "(max = 90.0, min = -90.0)"

alims = @NT(max = 75.0, min = -360.0)
alims = PowerSystems.check_angle_limits(alims)
@assert "$alims" == "(max = 75.0, min = -90.0)"

alims = @NT(max = 360.0, min = -75.0)
alims = PowerSystems.check_angle_limits(alims)
@assert "$alims" == "(max = 90.0, min = -75.0)"

alims = @NT(max = 0.0, min = 0.0)
alims = PowerSystems.check_angle_limits(alims)
@assert "$alims" == "(max = 90.0, min = -90.0)"