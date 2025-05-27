# Extrae

Julia bindings to BSC's [`extrae`](https://tools.bsc.es/extrae) HPC profiler.

It supports automatic instrumentation (through `LD_PRELOAD` mechanism, DynInst is on the way) of MPI, CUDA and pthreads, and PAPI/PMAPI hardware counters and callstack sampling.
Generated traces can be viewed with [Paraver](https://tools.bsc.es/paraver).

It was presented at JuliaCon 2024 Eindhoven:

[![Extrae.jl presentation](https://img.youtube.com/vi/hWOn8DBwYHA/maxresdefault.jpg)](https://youtu.be/hWOn8DBwYHA)

## Installation

If you want to perform a system-wide installation of Extrae, we recommend following this [guide](https://tools.bsc.es/doc/pdf/extrae-installation-guide.pdf). You can find more details in the [section _3. Configuration, build and installation_](https://tools.bsc.es/doc/html/extrae/configure-installation.html) of the documentation.

If you want to use the BinaryBuilder-built artifact, you don't need to do anything more than adding Extrae.jl as a dependency to your project.

## Usage

First, you need to set the Extrae configuration using environment variables or XML configuration. An example configuration file can be found in `scripts/extrae.xml` and in [section _9. An example of Extrae XML configuration file_](https://tools.bsc.es/doc/html/extrae/wholeXML.html) of the documentation.

More information about the configuration options can be found in [section _4. "Extrae XML configuration file"_](https://tools.bsc.es/doc/html/extrae/xml.html) and in [section _10. "Environment variables"_](https://tools.bsc.es/doc/html/extrae/envvars.html) of the documentation.

### Event emision

Extrae's functionality is very basic: every registered event is just a tuple of 2 integers annotating the event type and the event value.
Some events are automatically registered, such as MPI call names when you are tracing or PAPI hardware counters when performing sampling.
But you can also emit your own custom events using `emit`:

```julia
# emit event 80000 with value 4
emit(80_000, 4)
```

Event types are encoded with `Int32` and the values must always be a `Int64`.

If you want to assign a string descriptor to the event, you should call `Extrae.register` before initialization.

```julia
const BANANAS_TYPECODE::Int32 = 80_000
Extrae.register(BANANAS_TYPECODE, "Bananas")
```

Alternatively, you can also add string descriptors to values.

```julia
Extrae.register(Int32(80_001), "Monkey name", Int64[0,1,2], String["no monkey", "louis", "george"])
```

### Initialization

`Extrae` can be initialized just by calling `Extrae.init()`. If you are planning to use `Distributed`, you should call

```julia
@everywhere Extrae.init(Val(:Distributed))
```

to properly initialize the profiler in all workers. If you plan to use MPI, you should use the `LD_PRELOAD` mechanism.

The profiling is finished with `Extrae.finish()`.

### Mark user functions

Many times, the profiler catches much more information than we want. One way to filter it is by marking which moments in the trace where devoted to user code. This can be done by calling `Extrae.user_function(1)` to start and `Extrae.user_function(0)` to end the marking region.

We also provide a `Extrae.@user_function` for code cleanliness.

## Known issues

### User functions do not appear in the profile when using Extrae's callstack sampling

Check out [#23](https://github.com/bsc-quantic/Extrae.jl/issues/23). While Base and Core functions do appear in the profile, user functions do not.
This is due to a miscommunication between Extrae and Julia to pass JITed function symbols, but these is not the case of sysimgs because Extrae can read function names from the file.

A solution is on the works, but meanwhile it can be make to work by [compiling the user functions into a sysimg](https://docs.julialang.org/en/v1/devdocs/sysimg/).

### Can't preload with BinaryBuilder binary

Binaries built through BinaryBuilder are dynamically linked, but the system linker is unable to find the rest of dependencies because the rpaths are configured in another way.
The current solution is to manually preload all the required dependencies manually. We are looking for a way to make this is easier.

Alternatively, you can use system-installed binaries in your cluster (recommended option).
