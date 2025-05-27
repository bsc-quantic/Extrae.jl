using BenchmarkTools
using Extrae: Extrae, @user_function
using Statistics
using DelimitedFiles

const CODE_FLOAT_BYTES::UInt32 = 84210
Extrae.register(CODE_FLOAT_BYTES, "float #bytes")

const CODE_IS_THREADED::UInt32 = 84211
Extrae.register(CODE_IS_THREADED, "is threaded?")

Extrae.init()

# From https://github.com/giordano/julia-on-fugaku
function get_stats(axpy!, N::Int, T::Type)
    b = @benchmark $(axpy!)(a, x, y) setup = (
        a = randn($T); x = randn($T, $N); y = randn($T, $N)
    ) evals = 1
    GC.gc(true)
    return N, minimum(b.times), median(b.times), mean(b.times), maximum(b.times)
end

function benchmark(axpy!, T::Type, file_prefix::String)
    open(joinpath(@__DIR__, "$(file_prefix)_$(T).csv"), "w") do file
        println(
            file,
            "# length, minimum time (nanoseconds), median time (nanoseconds), mean time (nanoseconds), maximum time (nanoseconds)",
        )
        for N in round.(Int, exp10.(0:0.2:9))
            res = get_stats(axpy!, N, T)
            @show res
            println(file, join(res, ','))
        end
    end
end

function axpy!(a, x, y)
    @user_function @simd for i in eachindex(x, y)
        @inbounds y[i] = muladd(a, x[i], y[i])
    end
    return y
end

function taxpy!(a, x, y)
    @user_function Threads.@threads :static for i in eachindex(x, y)
        @inbounds y[i] = muladd(a, x[i], y[i])
    end
    return y
end

for T in (Float16, Float32, Float64)
    Extrae.emit(CODE_IS_THREADED, UInt64(0))
    Extrae.emit(CODE_FLOAT_BYTES, UInt64(sizeof(T)))
    benchmark(axpy!, T, "julia")

    Extrae.emit(CODE_IS_THREADED, UInt64(1))
    Extrae.emit(CODE_FLOAT_BYTES, UInt64(sizeof(T)))
    benchmark(taxpy!, T, "julia")
end

Extrae.finish()
