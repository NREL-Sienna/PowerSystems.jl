
import InfoZIP

Pkg.checkout("PowerModels", "master")

const GITHUB_TAG = "data"

const POWERSYSTEMS_GITHUB_URL = "https://github.com/NREL/PowerSystems.jl"

const ZIP_DATA_URL = joinpath(POWERSYSTEMS_GITHUB_URL, "releases/download/" , GITHUB_TAG, "data-v0.1.0.zip")

const DATA_FOLDER = Pkg.dir("PowerSystems/data")

function download_data()

    if !isdir(DATA_FOLDER)
        mkdir(DATA_FOLDER)
        temp_folder = tempname()
        temp_data_zip = joinpath(temp_folder, "data.zip")
        download(ZIP_DATA_URL, temp_data_zip)
        InfoZIP.unzip(temp_data_zip, DATA_FOLDER)
    end

end

download_data()
