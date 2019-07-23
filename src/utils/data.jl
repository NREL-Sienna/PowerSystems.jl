# this file is included in the build.jl script

module UtilsData

__precompile__(true)

export TestData

abstract type AbstractOS end
abstract type Unix <: AbstractOS end
abstract type BSD <: Unix end

abstract type Windows <: AbstractOS end
abstract type MacOS <: BSD end
abstract type Linux <: BSD end

if Sys.iswindows()
    const os = Windows
elseif Sys.isapple()
    const os = MacOS
else
    const os = Linux
end

abstract type TestData end

"""
Download Power System Data from `branch="master"` name into a "data" folder in given argument path.
Skip the actual download if the folder already exists and force=false.
Defaults to the root of the PowerSystems package.

Returns the downloaded folder name.
"""
function Base.download(::Type{TestData}
                       ;
                       folder::AbstractString=joinpath(@__DIR__, "../..") |> abspath,
                       branch::String="master",
                       force::Bool=false,
                      )

    if Sys.iswindows()
        POWERSYSTEMSTESTDATA_URL = "https://github.com/NREL/PowerSystemsTestData/arcive/$branch.zip"
    else
        POWERSYSTEMSTESTDATA_URL = "https://github.com/NREL/PowerSystemsTestData/arcive/$branch.tar.gz"
    end
    directory = folder |> normpath |> abspath
    data = joinpath(directory, "data")
    if !isdir(data) || force
        tempfilename = Base.download(POWERSYSTEMSTESTDATA_URL)
        mkpath(directory)
        unzip(os, tempfilename, directory)
        mv(joinpath(directory, "PowerSystemsTestData-$branch"), data, force=true)
    end

    return data
end

function unzip(::Type{<:BSD}, filename, directory)
    @assert success(`tar -xvf $filename -C $directory`) "Unable to extract $filename to $directory"
end

function unzip(::Type{Windows}, filename, directory)
    home = (Base.VERSION < v"0.7-") ? JULIA_HOME : Sys.BINDIR
    @assert success(`$home/7z x $filename -y -o$directory`) "Unable to extract $filename to $directory"
end

end # module UtilsData

