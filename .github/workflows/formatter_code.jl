main_paths = ["./src", "./test"]
for main_path in main_paths
    for (root, dir, files) in walkdir(main_path)
        for f in files
            @show file_path = abspath(root, f)
            occursin("generated", file_path) && continue
            if isfile(file_path)
                !occursin(".jl", file_path) && continue
            end
        format(file_path;
            whitespace_ops_in_indices = true,
            remove_extra_newlines = true,
            verbose = true
            )
        end
    end
end
