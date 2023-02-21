# Extrae

[![Registry](https://badgen.net/badge/registry/bsc-quantic/purple)](https://github.com/bsc-quantic/Registry)

Julia bindings to `extrae` Basic API.

## Parallel programming models currently instrumented

- Threads
- Distributed

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

## Visualization of Julia events
You can find Paraver configurations to load the Julia events in the `cfgs` directory.  To use them, with Paraver open and the trace loaded, go to _File>Load Configuration..._ and choose one of the configurations depending on which events you want to visualize.
