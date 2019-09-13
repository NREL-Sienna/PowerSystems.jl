# "smart" summary and REPL printing

function Base.summary(io::IO, sys::System)
    print(io, "System (base power $(sys.basepower))")
end

function Base.show(io::IO, sys::System)
    println(io, "basepower=$(sys.basepower)")
    show(io, sys.data)
end

function Base.show(io::IO, ::MIME"text/plain", sys::System)
    println(io, "System")
    println(io, "======")
    println(io, "Base Power: $(sys.basepower)\n")
    show(io, MIME"text/plain"(), sys.data)
end

function Base.show(io::IO, ::MIME"text/html", sys::System)
    println(io, "<h1>System</h1>")
    println(io, "<p><b>Base Power</b>: $(sys.basepower)</p>")
    show(io, MIME"text/html"(), sys.data)
end

function Base.summary(io::IO, tech::TechnicalParams)
    print(io, "$(typeof(tech))")
end
