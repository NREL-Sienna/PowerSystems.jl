# PowerSchema

[![Build Status](https://travis-ci.org/jdlara-berkeley/PowerSchema.jl.svg?branch=master)](https://travis-ci.org/jdlara-berkeley/PowerSchema.jl)

[![Coverage Status](https://coveralls.io/repos/jdlara-berkeley/PowerSchema.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jdlara-berkeley/PowerSchema.jl?branch=master)

[![codecov.io](http://codecov.io/github/jdlara-berkeley/PowerSchema.jl/coverage.svg?branch=master)](http://codecov.io/github/jdlara-berkeley/PowerSchema.jl?branch=master)


# Base tools

The code in this repository is the base data management code for the global power system analysis tools repository.

All the tests are made using the [Small Test Systems for Power System Economic Studies](http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5589973), contained in the file ```data_5bus.jl```. 

A detailed account of the types usage can be found in the following [Notebook](https://github.com/jdlara-berkeley/MEMF/blob/master/Notebooks/ED%20modular%20modeling%20primer.ipynb)

## Why do we define types for the system components 

The objecitve is to exploit Julia's integration of dynamic types with the function dispatch. As explained in Julia's documentation: 

"Julia’s type system is dynamic, but gains some of the advantages of static type systems by making it possible to indicate that certain values are of specific types. This can be of great assistance in generating efficient code, but even more significantly, it allows method dispatch on the types of function arguments to be deeply integrated with the language."

The way the types are defined for MEMF is by using immutable types. There are two kinds of composite types (in 0.6) ``struct`` (an immutable type, old name was ``immutable``) and ``mutable struct`` (a mutable type, old name was ``type``). ``mutable struct``s are always allocated on the heap. ``struct``s will be allocated on the stack under certain conditions. (One case where they won't be allocated on the stack right now is if they have a field that is a ``mutable struct``). If a ``struct`` only has e.g. bitstype fields, the ``struct`` should always end up on the stack, and for example an array of such a ``struct`` should have a really nice dense memory layout with no boxing or anything like that.  

## To do list

- Include inner constructors in the types 
- Define more clearly the data structure for generators
- Define 3W Transformer branch type  
- Define a single struct that holds all the system data and structure to run analysis. 
- Define a network builder from the branch and node data
