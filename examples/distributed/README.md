# Distributed.jl example

This example squares a random 1000x1000 matrix two times in a worker, and then fetches the values.

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
