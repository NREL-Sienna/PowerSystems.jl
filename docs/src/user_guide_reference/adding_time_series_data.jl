using PowerSystems
const PSY = PowerSystems
DATA_DIR = download(PSY.UtilsData.TestData, folder = pwd())
system = System(joinpath(DATA_DIR, "matpower/case5.m"))

new_renewable = RenewableDispatch(
        name = "WindBusA",
        available = true,
        bus = get_component(Bus, system, "3"),
        active_power = 2.0,
        reactive_power = 1.0,
        rating = 1.2,
        prime_mover = PrimeMovers.WT,
        reactive_power_limits = (min = 0.0, max = 0.0),
        base_power = 100.0,
        operation_cost = TwoPartCost(22.0, 0.0),
        power_factor = 1.0
    )

add_component!(system, new_renewable)

# Manually Create a Forecast
csv_data = CSV.read(joinpath(DATA_DIR,"5bus_ts/gen/Renewable/WIND/da_wind5.csv"))
time_series_data_raw = TimeArray(csv_data, timestamp=:TimeStamp)
forecast = SingleTimeSeries(name = "active_power", data = time_series_data_raw)

#Add the forecast to the system and component
add_time_series!(system, new_renewable, forecast)

#Load forecasts from pointers file
#FORECASTS_DIR = joinpath("src", "5bus_ts")
#fname = joinpath(FORECASTS_DIR, "timeseries_pointers_load.json")
#add_time_series!(system, fname)
