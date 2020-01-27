# PowerSystems Change Log

## v0.8.5

- Add functions to handle DynamicInjection components

## v0.8.4

- Fix 7z error in Julia 1.3 and Windows
- Bug fix in pu conversion in HVDC Table Data
- Improve testing

## v0.8.3

- Update DynamicGenerator and DynamicInverter to comply with PSY
- Change get_components to support parametrized structs
- Improve testing of dynamic structs

## v0.8.2

- Update package dependencies compatibility
- Add range to struct docstrings
- Hydropower data parsing improvements

## v0.8.1

- Bugfix TableData HydroStorage

## v0.8.0

- Updated HydroDispatch and removed HydroStorage

## v0.7.1

- Bugfix services removal

## v0.7.0

- Make codebase consistent with style guide.
- Add Dynamic Data capabilities.
- Change use of services and store them inside of devices.
- Add ext field to devices
- Add ext field to system

## v0.6.2

- Downgrade compatible version of CSV to 0.5.13 to avoid tab complete hang.

## v0.6.2

- Bug Fix in docstrings autogeneration code
- Contigous forecasts function added

## v0.6.1

- Remove bin from auto generation code
- Updated docstrings

## v0.6.0

- Use accessor functions instead of labels to get forecasts
- Bug Fix in code autogeneration

## v0.5.2

- Enforce unique bus numbers
- Set min version of IS to 0.2.4

## v0.5.1

- Bug fix in generate_initial_times
- Bug fixes on SystemTable Data

## v0.5.0

- Store and access forecast data from Disk

## v0.4.3

- Fix Parsing bug in Table data #362
- Enable custom validation descriptors when parsing PSS/E and MATPOWER files
- Enable multiple loads per bus when parsing PSS/E and MATPOWER files
- Support multiple generators per bus and non-sequential bus indexing in powerflow

## v0.4.2

- Fix printing of forecasts #350 fixing #343

## v0.1.1

- Update to Julia-v0.7

## v0.1.0

- Initial implementation
