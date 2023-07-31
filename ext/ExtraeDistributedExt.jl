using Distributed

"""
    ExtraeLocalManager.jl

Implements a copy of the default `LocalClusterManager` that starts
workers with an overdubbed event loop.
"""

struct ExtraeLocalManager <: ClusterManager
    np::Int
    restrict::Bool  # Restrict binding to 127.0.0.1 only
end

Base.show(io::IO, manager::ExtraeLocalManager) = print(io, "ExtraeLocalManager(#procs=$(manager.np), restrict=$(manager.restrict))")

function Distributed.launch(manager::ExtraeLocalManager, params::Dict, launched::Array, c::Condition)
    dir = params[:dir]
    exename = params[:exename]
    exeflags = params[:exeflags]
    bind_to = manager.restrict ? `127.0.0.1` : `$(LPROC.bind_addr)`
    cookie = cluster_cookie()

    active_project = Base.active_project()
    hookline = """
        using Distributed
        using Extrae
        using Cassette

        Cassette.overdub(Extrae.ExtraeCtx(), start_worker, $(repr(cookie)))
        """

    # Bug: Instead of using julia_cmd(exename), I directly use exename because idk howto access Base.julia_cmd
    for i in 1:manager.np
        cmd = `env EXTRAE_SKIP_AUTO_LIBRARY_INITIALIZE=1 $exename $exeflags --project=$active_project --bind-to $bind_to -e "$hookline"`
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

const DistributedEvent{ValueCode} = Event{400002,ValueCode}
const DistributedUsefulWorkEvent{ValueCode} = Event{400001,ValueCode}
const DistributedMessageHandlingEvent{ValueCode} = Event{400004,ValueCode}

description(::Type{DistributedEvent}) = "Distributed runtime calls"
description(::Type{DistributedUsefulWorkEvent}) = "Distributed workload execution"
description(::Type{DistributedMessageHandlingEvent}) = "Distributed message handling functions"

const DistributedEnd = DistributedEvent{0}()
const DistributedAddProcs = DistributedEvent{1}()
const DistributedRmProcs = DistributedEvent{2}()
const DistributedInitWorker = DistributedEvent{3}()
const DistributedStartWorker = DistributedEvent{4}()
const DistributedRemoteCall = DistributedEvent{5}()
const DistributedRemoteCallFetch = DistributedEvent{6}()
const DistributedRemoteCallWait = DistributedEvent{7}()
const DistributedProcessMessages = DistributedEvent{8}()
const DistributedInterrupt = DistributedEvent{9}()

const DistributedUsefulWork = DistributedUsefulWorkEvent{1}()
const DistributedNotUsefulWork = DistributedUsefulWorkEvent{0}()

const DistributedHandleEnd = DistributedMessageHandlingEvent{0}()
const DistributedHandleCall = DistributedMessageHandlingEvent{1}()
const DistributedHandleCallFetch = DistributedMessageHandlingEvent{2}()
const DistributedHandleCallWait = DistributedMessageHandlingEvent{3}()
const DistributedHandleRemoteDo = DistributedMessageHandlingEvent{4}()
const DistributedHandleResult = DistributedMessageHandlingEvent{5}()
const DistributedHandleIdentifySocket = DistributedMessageHandlingEvent{6}()
const DistributedHandleIdentifySocketAck = DistributedMessageHandlingEvent{7}()
const DistributedHandleJoinPGRP = DistributedMessageHandlingEvent{8}()
const DistributedHandleJoinComplete = DistributedMessageHandlingEvent{9}()

description(::typeof(DistributedEnd)) = "end"
description(::typeof(DistributedAddProcs)) = "addprocs"
description(::typeof(DistributedRmProcs)) = "rmprocs"
description(::typeof(DistributedInitWorker)) = "init_worker"
description(::typeof(DistributedStartWorker)) = "start_worker"
description(::typeof(DistributedRemoteCall)) = "remotecall"
description(::typeof(DistributedRemoteCallFetch)) = "remotecall_fetch"
description(::typeof(DistributedRemoteCallWait)) = "remotecall_wait"
description(::typeof(DistributedProcessMessages)) = "process_messages"
description(::typeof(DistributedInterrupt)) = "interrupt"

description(::typeof(DistributedHandleEnd)) = "End"
description(::typeof(DistributedHandleCall)) = "CallMsg{:call}"
description(::typeof(DistributedHandleCallFetch)) = "CallMsg{:call_fetch}"
description(::typeof(DistributedHandleCallWait)) = "CallWaitMsg"
description(::typeof(DistributedHandleRemoteDo)) = "RemoteDoMsg"
description(::typeof(DistributedHandleResult)) = "ResultMsg"
description(::typeof(DistributedHandleIdentifySocket)) = "IdentifySocketMsg"
description(::typeof(DistributedHandleIdentifySocketAck)) = "IdentifySocketAckMsg"
description(::typeof(DistributedHandleJoinPGRP)) = "JoinPGRPMsg"
description(::typeof(DistributedHandleJoinComplete)) = "JoinCompletesg"

description(::typeof(DistributedUsefulWork)) = "Useful"
description(::typeof(DistributedNotUsefulWork)) = "Not Useful"

# resource identification
dist_taskid()::Cuint = Distributed.myid() - 1
dist_numtasks()::Cuint = Distributed.nworkers() + 1

# cluster manager addprocs 
function addprocs_extrae(np::Integer; restrict=true, kwargs...)
    manager = Extrae.ExtraeLocalManager(np, restrict)
    #check_addprocs_args(manager, kwargs)
    new_workers = addprocs(manager; kwargs...)

    Extrae.init()
    for pid in new_workers
        @fetchfrom pid Extrae.init()
    end
    return new_workers
end
export addprocs_extrae
