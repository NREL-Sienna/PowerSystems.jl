@static if Sys.iswindows()

    function unpack_cmd(file,directory)
        global has_7z
        global has_zip

        if has_7z === nothing
            has_7z  = success(`where 7z`)
            has_zip = success(`where unzip`)
        end

        try
            rm(directory,recursive=true)
            return (`powershell -file $(joinpath(@__FILE__,"winunzip.ps1")) $file $directory`)
        catch
            @error("Can't unpack $file")
        end
    end

end

@static if Sys.isunix()

    function unpack_cmd(file,directory)
            return (`unzip -x $file -d $directory`)
    end

end