# Extrae

Julia bindings to BSC's [`extrae`](https://tools.bsc.es/extrae) HPC profiler.

It supports automatic instrumentation (through `LD_PRELOAD` mechanism, DynInst is on the way) of MPI, CUDA and pthreads, and PAPI/PMAPI hardware counters and callstack sampling.
Generated traces can be viewed with [Paraver](https://tools.bsc.es/paraver).

## Usage

First, you need to set the Extrae configuration using environment variables or XML configuration. An example configuration file can be found in `scripts/extrae.xml`.

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

## Example scripts

In `scripts` directory you can find the `test-distributed-work.jl` script that traces a very basic execution of a Distributed program.  This script squares a random 1000x1000 matrix two times in a worker, and then fetches the values.

To run it, execute:

```bash
scripts/env.sh julia --project=. scripts/test-distributed-work.jl
```

The `env.sh` file sets up some environment variables required by the extrae library at load time.

Then, to obtain the Paraver trace, we use the script `julia2prv` which is a wrapper to the `mpi2prv` tool by extrae. You can create your trace by doing:

```bash
scripts/julia2prv test-distributed.prv JULIATRACE*
```

and you will obtain a Paraver trace named `test-distributed.prv`.
