# Taken from MPI.jl: examples/02-broadcast.jl
using Extrae
using MPIBenchmarks

MPI.Init()
Extrae.init()

function iterations(::Type{T}, s::Int) where {T}
    log2size = trailing_zeros(sizeof(T))
    return 4 << ((s < 10 - log2size) ? (20 - log2size) : (30 - 2 * log2size - s))
end

benchmark(IMBPingPong(; iterations))

Extrae.finish()
