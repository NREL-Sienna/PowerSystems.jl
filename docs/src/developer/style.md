```@meta
EditURL = "<unknown>/docs/src/developer/style.md"
```

```@example style
```@meta
EditURL = "<unknown>/docs/src/developer/style.md"
```

Julia Coding Style Guide for PowerSystems.jl

```@example style
```

Goals

```@example style
* Define a straightforward set of rules that lead to consistent, readable code.
* Developers focus on producing high quality code, not how to format it.
```

Base

```@example style
* Read the official
[Julia style guide](https://docs.julialang.org/en/v1/manual/style-guide/index.html) as reference.
* Read [Julia contribution guidelines](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md#general-formatting-guidelines-for-julia-code-contributions), notably its line length limit.
* Read [Julia guidelines for docstrings](https://docs.julialang.org/en/v1/manual/documentation/index.html).
* Read [BlueStyle](https://github.com/invenia/BlueStyle/) style guide.
* Consider using a plugin that configures your text editor to use [EditorConfig](https://editorconfig.org/) settings.
* Consider using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl).
```

Code Organization

```@example style
* Import standard modules, then 3rd-party modules, then yours. Include a blank
  line between each group.

<!-- ### Modules:  TODO -->
```

Comments

```@example style
* Use comments to describe non-obvious or non-trivial aspects of code.
  Describe why something was done but not how. The "how" should be apparent from
  the code itself.
* Use complete sentences and proper grammar.
* Include a space in between the "#" and the first word of the comment.
* Don't use block comments for Julia code. Prefer using the `# ` prefix. If you are commenting code, consider deleting it instead.

Bad:

```julia
for i in 1:100
    #=
    arr[i] += a[i] * x^2
    arr[i] += b[i] * x
    arr[i] += c[i]
    =#
    nothing
end
```

Good:

```julia
for i in 1:100
```

arr[i] += a[i] * x^2
arr[i] += b[i] * x
arr[i] += c[i]

```@example style
    nothing
end
```

* Use these tags in comments to describe known work:
  * `TODO`:  tasks that need to be done
  * `FIXME`:  code that needs refactoring
  * `BUG`:  known bug that exists. Should include a bug ID and tracking system.
  * `PERF`:  known performance limitation that needs improvement
```

Constructors

```@example style
* Per guidance from Julia documentation, use inner constructors to enforce
  restrictions on parameters or to allow construction of self-referential
  objects.
  Use outer constructors to provide default values or to perform customization.
* Document the reason why the outer constructor is different.
* Note that the compiler will provide a default constructor with all struct
members if no inner constructor is defined.
* When creating a constructor use `function Foo()` instead of `Foo() = ...`.
  * One exception is the case where one file has all single-line functions.
* Prefer explicit `return` in multi line functions instead of the implicit return.
```

Exceptions

```@example style
* Use exceptions for unexpected errors and not for normal error handling.
  * Detection of an unsupported data format from a user should likely throw
  an exception and terminate the application.
  * Do not use try/catch to handle retrieving a potentially-missing key from a
  dictionary.
* Use @assert statements to guard against programming errors. Do not use them
  after detecting bad user input. Note that they may be compiled out in release
  builds.
```

Globals

```@example style
* Global constants should be written in upper case and be declared `const`.
    - `const UPPER_CASE_VARIABLE = π / 2`
* If global variables are needed, prefix them with `g_`.
* Don't use [magic numbers](https://en.wikipedia.org/wiki/Magic_number_%28programming%29).
  Instead, define `const GLOBALS` or `Enums` (Julia @enum).
```

One-line Conditionals

```@example style
Julia code base uses this idiom frequently: `<condition> && <statement>`.

See [Example](https://docs.julialang.org/en/v1.0/manual/control-flow/#Short-Circuit-Evaluation-1):

```julia
function fact(n::Int)
   n >= 0 || error("n must be non-negative")
   n == 0 && return 1
   n * fact(n-1)
end
```

This is acceptable for simple code as in this example. However, in general,
prefer to write out an entire if statement.

Ternary operators provide a way to write clean, concise code.  Use good
judgement.

Good:

```julia
y = x > 0 ? x : -x
```

There are many examples in our codebase that use the form `<cond> ? <statement> : <statement>`.
These may be expressed much more clearly in an if/else statement.
```

Unit Tests

```@example style
All code should be tested.
```

Whitespace

```@example style
* If many function arguments cause the line length to be exceeded, put one
argument per line. In some cases it may make sense to pair some variables on
the same line.

Good:

```julia
function foo(
    var1::String,
    var2::String,
    var3::String,
    var6::T,
) where T <: Number
    println("hello world")
end
```

Bad:

```julia
function foo(var1::String,
             var2::String,
             var3::String,
             var6::T) where T <: Number
    println("hello world")
end
```

* Surround equal signs with spaces when passing keyword args to a
function or defining default values in function declarations.

* Prefer elements in an array on separate lines. Follow opening square bracket with a new line and use closing square bracket on a separate new line.

Good:

```julia
nodes = [
    Node(1),
    Node(2),
    Node(3),
    Node(4),
    Node(5),
];
```

Bad:

```julia
nodes = [Node(1), Node(2), Node(3), Node(4), Node(5)];
```

Prefer a similar rule for Dictionaries, Sets and other data structures.
Use your judgement when data structures can neatly fit on a single line.

* Do not right-align equal signs when assigning groups of variables. It causes
  unnecessary changes whenever someone adds a new variable with a longer name.

Bad:

```julia
x   = 1
foo = 2
```

Good:

```julia
x = 1
foo = 2
```

* Define abstract types on one line. Given the lack of IDE support for Julia,
  this makes it easier to find type definitions.

Bad:

```julia
abstract type
    Foo
end
```

Good:

```julia
abstract type Foo end
```
```

Exports

```@example style
`export` should be used to make it easy for the user to use a symbol from the REPL,
an interactive interface or a program.

You may _need_ to use `export` when extending functionality of other packages
that have also exported the same symbol.

All symbols that have `export` **must** have proper docstrings.
```

References

```@example style
* [The Zen of Python](https://www.python.org/dev/peps/pep-0020).
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

