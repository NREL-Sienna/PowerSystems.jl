
```
using PowerSystems
using PowerSystemCaseBuilder

c_sys5_pjm_da = build_system(PSITestSystems, "c_sys5_pjm")
transform_single_time_series!(c_sys5_pjm_da, Hour(24), Hour(24))
c_sys5_pjm_rt = build_system(PSITestSystems, "c_sys5_pjm_rt")
transform_single_time_series!(c_sys5_pjm_rt, Hour(24), Hour(1))

for sys in [c_sys5_pjm_da, c_sys5_pjm_rt]
    th = get_component(ThermalStandard, sys, "Park City")
    set_active_power_limits!(th, (min = 0.1, max = 1.7))
    set_status!(th, false)
    set_active_power!(th, 0.0)
    c = get_operation_cost(th)
    c.start_up = 1500
    c.shut_down = 75
    set_time_at_status!(th, 1)

    th = get_component(ThermalStandard, sys, "Alta")
    set_time_limits!(th, (up = 5, down = 1))
    set_active_power_limits!(th, (min = 0.05, max = 0.4))
    set_active_power!(th, 0.05)
    c = get_operation_cost(th)
    c.start_up = 400
    c.shut_down = 200
    set_time_at_status!(th, 2)

    th = get_component(ThermalStandard, sys, "Brighton")
    set_active_power_limits!(th, (min = 2.0, max = 6.0))
    c = get_operation_cost(th)
    set_active_power!(th, 4.88041)
    c.start_up = 5000
    c.shut_down = 3000

    th = get_component(ThermalStandard, sys, "Sundance")
    set_active_power_limits!(th, (min = 1.0, max = 2.0))
    set_time_limits!(th, (up = 5, down = 1))
    set_active_power!(th, 2.0)
    c = get_operation_cost(th)
    c.start_up = 4000
    c.shut_down = 2000
    set_time_at_status!(th, 1)

    th = get_component(ThermalStandard, sys, "Solitude")
    set_active_power_limits!(th, (min = 1.0, max = 5.2))
    set_ramp_limits!(th, (up = 0.0052, down = 0.0052))
    set_active_power!(th, 2.0)
    c = get_operation_cost(th)
    c.start_up = 3000
    c.shut_down = 1500
end

to_json(c_sys5_pjm_da, "c_sys5_pjm_da.json")
to_json(c_sys5_pjm_rt, "c_sys5_pjm_rt.json")
```
