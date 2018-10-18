@static if Sys.iswindows()

    has_7z  = nothing
    has_zip = nothing

    function unpack_cmd(file,directory)

        global has_7z
        global has_zip

        if has_7z === nothing
            has_7z  = success(`where 7z`)
            has_zip = success(`where unzip`)
        end

        if has_7z
            try
                return (`7z x $file -y -o$directory`)
            catch
                @error "Can't unpack $file"
            end
        elseif has_zip
            try
                return (`powershell -file $(joinpath(@__FILE__,"winunzip.ps1")) $file $directory`)
            catch
                @error "Can't unpack $file"
            end
        end
    end

end

@static if Sys.isunix()

    function unpack_cmd(file,directory)
            return (`unzip -x $file -d $directory`)
    end

end
