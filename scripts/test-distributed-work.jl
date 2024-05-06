using Distributed
using Extrae

ENV["JULIA_DEBUG"] = Extrae
@everywhere ENV["JULIA_DEBUG"] = Extrae

addprocs(1)

function random_sleep()
    println("Worker started: ", myid())
    sleep(rand((1, 2, 3, 4, 5)))
    println("Worker woke up: ", myid())
end

@everywhere function matrix_multiply(A)
    println("multiplying")
    return A^2
end

function test_distributed_work()

    A = rand(1000, 1000)
    a1 = @spawnat :any matrix_multiply(A)
    a2 = @spawnat :any matrix_multiply(A)
    fetch(a1)
    fetch(a2)
    @everywhere Extrae.finish()
end

test_distributed_work()

println("END TEST")