abstract type
    Forecast
end

"""
    Deterministic
        A deterministic forecast for a particular data field in a PowerSystemDevice.

"""
struct Deterministic <: Forecast
    device::PowerSystemDevice       # device
    field::Symbol                   # field of device
    resolution::Dates.Period        # resolution
    initialtime::Dates.DateTime     # forecast availability time
    data::TimeSeries.TimeArray      # TimeStamp - scalingfactor

    function Deterministic(device::PowerSystemDevice,
                            field::Symbol,
                            resolution::Dates.Period,
                            initialtime::Dates.DateTime,
                            data::TimeSeries.TimeArray; kwargs...)
        runchecks = in(:runchecks, keys(kwargs)) ? kwargs[:runchecks] : true
        if runchecks # TODO: Should this go here, or in the PowerSystem constructors?
            if !isafield(device,field)
                @error "Device $device has no field: $field"
            end
        end
        new(device, field, resolution, initialtime, data)
    end
end


function Deterministic(device::PowerSystemDevice, field::Symbol, resolution::Dates.Period, initialtime::Dates.DateTime, time_steps::Int; kwargs...)
    data = TimeSeries.TimeArray(initialtime:Dates.Hour(1):initialtime+resolution*(time_steps-1), ones(time_steps))
    Deterministic(device, field, resolution, initialtime, data; kwargs...)
end

function Deterministic(device::PowerSystemDevice, field::Symbol, data::TimeSeries.TimeArray; kwargs...)
    resolution = getresolution(data)
    initialtime = TimeSeries.timestamp(data)[1]
    time_steps = length(data)
    Deterministic(device, field, resolution, initialtime, data; kwargs...)
end

struct Scenarios <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end
