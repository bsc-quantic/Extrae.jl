using Distributed
using Extrae

addprocs_extrae(1)

@everywhere using Cassette
@everywhere using Extrae


function random_sleep()
    println("Worker started: ", myid())
    sleep(rand((1,2,3,4,5)))
    println("Worker woke up: ", myid())
end

function test_distributed_work()
    @everywhere Extrae.init()
    Cassette.overdub(Extrae.ExtraeCtx(), remote_do, Cassette.overdub, 2, Extrae.ExtraeCtx(), random_sleep)
    # Cassette.overdub(Extrae.ExtraeCtx(), remote_do, Cassette.overdub, 3, Extrae.ExtraeCtx(), random_sleep)
    # Cassette.overdub(Extrae.ExtraeCtx(), remote_do, Cassette.overdub, 4, Extrae.ExtraeCtx(), random_sleep)
    sleep(10)
    @everywhere Extrae.finish()
end

test_distributed_work()

println("END TEST")