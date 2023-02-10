"""
ExtraeLocalManager.jl
Implements a copy of the default LocalClusterManager that starts
workers with an overdubbed event loop.

"""

struct ExtraeLocalManager <: ClusterManager
    np::Int
    restrict::Bool  # Restrict binding to 127.0.0.1 only
end

Base.show(io::IO, manager::ExtraeLocalManager) = print(io, "ExtraeLocalManager()")

function Distributed.launch(manager::ExtraeLocalManager, params::Dict, launched::Array, c::Condition)
    dir = params[:dir]
    exename = params[:exename]
    exeflags = params[:exeflags]
    bind_to = manager.restrict ? `127.0.0.1` : `$(LPROC.bind_addr)`
    cookie = cluster_cookie()

    #hookline = """using Distributed; f = Base.open("hooked.txt", "w"); write(f, $(repr(string(cookie))))"""
    hookline = """using Distributed; using Extrae; using Cassette; Cassette.overdub(Extrae.ExtraeCtx(), start_worker, $(repr(string(cookie))))"""


    # Bug: Instead of using julia_cmd(exename), I directly use exename because idk howto access Base.julia_cmd
    for i in 1:manager.np
        cmd = `env EXTRAE_SKIP_AUTO_LIBRARY_INITIALIZE=1 $exename $exeflags --project=. --bind-to $bind_to -e "$hookline"`
        io = open(detach(setenv(cmd, dir=dir)), "r+")
        
        # Cluster cookie is not passed through IO. Instead, we set it 
        # as a parameter when starting worker, through the hookline
        #Distributed.write_cookie(io)

        wconfig = WorkerConfig()
        wconfig.process = io
        wconfig.io = io.out
        wconfig.enable_threaded_blas = params[:enable_threaded_blas]
        push!(launched, wconfig)
    end

    notify(c)
end

function Distributed.manage(manager::ExtraeLocalManager, id::Integer, config::WorkerConfig, op::Symbol)
    if op === :interrupt
        kill(config.process, 2)
    end
end

export ExtraeLocalManager