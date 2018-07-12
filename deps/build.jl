import InfoZIP
og_dir = pwd()
cd(Pkg.dir("PowerModels"))
run(`git pull origin master`)
cd(og_dir)
function download_data(tag::String)

    if !isdir(Pkg.dir("PowerSystems/data"))
        mkpath(Pkg.dir("PowerSystems/data"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/data.zip",Pkg.dir("PowerSystems/data.zip"))
        InfoZIP.unzip(Pkg.dir("PowerSystems/data.zip"),Pkg.dir("PowerSystems/data"))
    end

    if !isdir(Pkg.dir("PowerSystems/data/RTS_GMLC"))
        mkpath(Pkg.dir("PowerSystems/data/RTS_GMLC"))
    end
    if !isdir(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts"))
        mkpath(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts"))
    end
    if !isfile(Pkg.dir("PowerSystems/data/RTS_GMLC/branch.csv"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/branch.csv",Pkg.dir("PowerSystems/data/RTS_GMLC/branch.csv"))
        println(" Downloaded branch.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/RTS_GMLC/bus.csv"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/bus.csv",Pkg.dir("PowerSystems/data/RTS_GMLC/bus.csv"))
        println(" Downloaded bus.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/RTS_GMLC/bus.csv"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/gen.csv",Pkg.dir("PowerSystems/data/RTS_GMLC/gen.csv"))
        println(" Downloaded gen.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/HYDRO/DAY_AHEAD_hydro.csv")) & !isdir(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/HYDRO/REAL_TIME_hydro.csv"))
        mkpath(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/HYDRO"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/DAY_AHEAD_hydro.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/HYDRO/DAY_AHEAD_hydro.csv"))
        println(" Downloaded DAY_AHEAD_hydro.csv")
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/REAL_TIME_hydro.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/HYDRO/REAL_TIME_hydro.csv"))
        println(" Downloaded REAL_TIME_hydro.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/Load/DAY_AHEAD_regional_Load.csv")) & !isdir(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/Load/REAL_TIME_regional_load.csv"))
        mkpath(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/Load"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/DAY_AHEAD_regional_Load.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/Load/DAY_AHEAD_regional_Load.csv"))
        println(" Downloaded DAY_AHEAD_regional_Load.csv")
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/REAL_TIME_regional_load.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/Load/REAL_TIME_regional_load.csv"))
        println(" Downloaded REAL_TIME_regional_load.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/PV/DAY_AHEAD_pv.csv")) & !isdir(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/PV/REAL_TIME_pv.csv"))
        mkpath(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/PV"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/DAY_AHEAD_pv.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/PV/DAY_AHEAD_pv.csv"))
        println(" Downloaded DAY_AHEAD_pv.csv")
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/REAL_TIME_pv.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/PV/REAL_TIME_pv.csv"))
        println(" Downloaded REAL_TIME_pv.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/RTPV/DAY_AHEAD_rtpv.csv")) & !isdir(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/RTPV/REAL_TIME_rtpv.csv"))
        mkpath(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/RTPV"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/DAY_AHEAD_rtpv.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/RTPV/DAY_AHEAD_rtpv.csv"))
        println(" Downloaded DAY_AHEAD_rtpv.csv")
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/REAL_TIME_rtpv.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/RTPV/REAL_TIME_rtpv.csv"))
        println(" Downloaded REAL_TIME_rtpv.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/WIND/DAY_AHEAD_wind.csv")) & !isdir(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/WIND/REAL_TIME_wind.csv"))
        mkpath(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/WIND"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/DAY_AHEAD_wind.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/WIND/DAY_AHEAD_wind.csv"))
        println(" Downloaded DAY_AHEAD_wind.csv")
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/REAL_TIME_wind.csv",Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts/WIND/REAL_TIME_wind.csv"))
        println(" Downloaded REAL_TIME_wind.csv")
    end
    if !isfile(Pkg.dir("PowerSystems/data/matpower/RTS_GMLC.m"))
        mkpath(Pkg.dir("PowerSystems/data/matpower"))
        download("https://github.com/NREL/PowerSystems.jl/releases/download/"*tag* "/RTS_GMLC.m",Pkg.dir("PowerSystems/data/matpower/RTS_GMLC.m"))
        println(" Downloaded RTS_GMLC.m")
    end
    rm(Pkg.dir("PowerSystems/data.zip"),force=true,recursive=true)
end
download_data("v0.1-alpha.2")
