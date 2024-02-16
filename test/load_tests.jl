using Revise

# Copied from https://juliatesting.github.io/ReTest.jl/stable/#Working-with-Revise
function recursive_includet(filename)
    already_included = copy(Revise.included_files)
    includet(filename)
    newly_included = setdiff(Revise.included_files, already_included)
    for (mod, file) in newly_included
        Revise.track(mod, file)
    end
end

recursive_includet("PowerSystemsTests.jl")
