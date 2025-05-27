#!/usr/bin/env julia

# Use this script like
#     ./mpi2prv.jl <MPIT files> <PRV OUTPUT FILE>
#
# Example:
#     ./mpi2prv.jl set-0/*.mpit output.prv
#
# NOTE: you must run this in an environment where `Extrae_jll` is installed.  If you want to
# run this in a specific environment, either set the environment variable `JULIA_PROJECT`
# (https://docs.julialang.org/en/v1/manual/environment-variables/#JULIA_PROJECT):
#     JULIA_PROJECT=<PROJECT> ./mpi2prv.jl <MPIT files> <PRV OUTPUT FILE>
# or run the script with
#     julia --project=<PROJECT> mpi2prv.jl <MPIT files> <PRV OUTPUT FILE>

using Extrae_jll: mpi2prv

run(`$(mpi2prv()) $(ARGS)`)
