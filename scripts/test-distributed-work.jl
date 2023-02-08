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
    Cassette.overdub(Extrae.ExtraeCtx(), remote_do, 2, random_sleep)
    #Cassette.overdub(Extrae.ExtraeCtx(), remote_do, 3, random_sleep)
    # Cassette.overdub(Extrae.ExtraeCtx(), remote_do, 4, random_sleep)
    sleep(10)
    @everywhere Extrae.finish()
end

test_distributed_work()

println("END TEST")