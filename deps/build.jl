
const POWERSYSTEMSTESTDATA_GITHUB_URL = "https://github.com/NREL/PowerSystemsTestData.git"

base_dir = string(dirname(dirname(@__FILE__)))
const DATA_FOLDER = joinpath(base_dir,"data")

const CLONE_CMD = `git clone --depth 1 $POWERSYSTEMSTESTDATA_GITHUB_URL $DATA_FOLDER`

const PULL_CMD = `git -C $DATA_FOLDER pull`

function download_data()

    if !isdir(DATA_FOLDER)
        run(CLONE_CMD)
    else
        run(PULL_CMD)
    end

end

download_data()
