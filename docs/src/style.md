# Julia Coding Style Guide for SIIP

## Goals

* Define a straightforward set of rules that lead to consistent, readable
code.
* Developers focus on producing high quality code, not how to format it.

## Base
* Follow the official
[Julia style guide](https://docs.julialang.org/en/v1/manual/style-guide/index.html)
except for deviations noted here.
* Follow [Julia contribution guidelines](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md#general-formatting-guidelines-for-julia-code-contributions), notably its line length
limit.
* Follow [Julia guidelines for docstrings](https://docs.julialang.org/en/v1/manual/documentation/index.html).
* Follow [JuMP coding standards](http://www.juliaopt.org/JuMP.jl/dev/style),
including its deviations from the Julia style guide.  In particular, note its policies on
  * [whitespace](http://www.juliaopt.org/JuMP.jl/dev/style/#Whitespace-1)
  * [return statements](http://www.juliaopt.org/JuMP.jl/dev/style/#Return-statements-1)
  * [variable names](http://www.juliaopt.org/JuMP.jl/dev/style/#Use-of-underscores-within-names-1).
* Read [The Zen of Python](https://www.python.org/dev/peps/pep-0020).
* Consider using a plugin that configures your text editor to use [EditorConfig](https://editorconfig.org/) settings.

## Code Organization
* Import standard modules, then 3rd-party modules, then yours. Include a blank
line between each group.

### Modules:  TODO

## Comments
* Use comments to describe non-obvious or non-trivial aspects of code.
Describe why something was done but not how.  The "how" should be apparent from
the code itself.
* Use complete sentences and proper grammar.
* Include a space in between the "#" and the first word of the comment.
* Use these tags in comments to describe known work:
  * TODO:  tasks that need to be done
  * FIXME:  code that needs refactoring
  * BUG:  known bug that exists. Should include a bug ID and tracking system.
  * PERF:  known performance limitation that needs improvement

## Constructors
* Per guidance from Julia documentation, use inner constructors to enforce
restrictions on parameters or to allow construction of self-referential
objects.
Use outer constructors to provide default values or to perform customization.
* Document the reason why the outer constructor is different.
* Note that the compiler will provide a default constructor with all struct
members if no inner constructor is defined.
* When creating a constructor use "function Foo()" instead of "Foo() = ..."
One exception is the case where one file has all single-line functions.

## Exceptions
* Use exceptions for unexpected errors and not for normal error handling.
  * Detection of an unsupported data format from a user should likely throw
an exception and terminate the application.
  * Do not use try/catch to handle retrieving a potentially-missing key from a
dictionary.
* Use @assert statements to guard against programming errors. Do not use them
after detecting bad user input. Note that they may be compiled out in release
builds.

## Globals
* Global constants should use UPPER_CASE and be declared const.
* If global variables are needed, prefix them with "g_".
* Don't use magic numbers. Instead, define const globals or Enums (Julia
@enum).

## One-line Conditionals
Julia code base uses this idiom frequently:  ```<cond> && <statement>```
[Example](https://docs.julialang.org/en/v1.0/manual/control-flow/#Short-Circuit-Evaluation-1):
>
    function fact(n::Int)
       n >= 0 || error("n must be non-negative")
       n == 0 && return 1
       n * fact(n-1)
    end

This is acceptable for simple code as in this example. However, in general,
prefer to write out an entire if statement.

Ternary operators provide a way to write clean, concise code.  Use good
judgement.

Good:
>
    y = x > 0 ? x : -x

There are many examples in our codebase that use the form ```<cond> ?
<statement> : <statement>```.  These can be expressed much more clearly in an
if/else statement.

## Unit Tests
All code should be tested.

## Whitespace
* If many function arguments cause the line length to be exceeded, put one
argument per line. In some cases it may make sense to pair some variables on
the same line.
>
    function foo(var1::String,
                 var2::String,
                 var3::String,
                 var4::String,
                 var5::String,
                 var6::String)

* Do not surround equal signs with spaces when passing keyword args to a
function or defining default values in function declarations.
* Do not right-align equal signs when assigning groups of variables. It causes
unnecessary changes whenever someone adds a new variable with a longer name.

Bad:
>
    x   = 1
    foo = 2

Good:
>
    x = 1
    foo = 2

* Define abstract types on one line. Given the lack of IDE support for Julia,
this makes it easier to find type definitions.

Bad:
>
    abstract type
        Foo
    end

Good:
>
    abstract type Foo end
