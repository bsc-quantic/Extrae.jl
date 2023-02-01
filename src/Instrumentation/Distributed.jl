using Distributed


include("ExtraeLocalManager.jl")

struct DistributedEvent{ValueCode} <: Event{400002,ValueCode} end

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

# worker management
Cassette.prehook(::ExtraeCtx, ::typeof(addprocs), args...) = emit(DistributedAddProcs)
Cassette.posthook(::ExtraeCtx, _, ::typeof(addprocs), args...) = emit(DistributedEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(rmprocs), args...) = emit(DistributedRmProcs)
Cassette.posthook(::ExtraeCtx, _, ::typeof(rmprocs), args...) = emit(DistributedEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(init_worker), args...) = emit(DistributedInitWorker)
Cassette.posthook(::ExtraeCtx, _, ::typeof(init_worker), args...) = emit(DistributedEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(start_worker), args...) = emit(DistributedStartWorker)
Cassette.posthook(::ExtraeCtx, _, ::typeof(start_worker), args...) = emit(DistributedEnd)

# task creation
Cassette.prehook(::ExtraeCtx, ::typeof(remotecall), f, ::Distributed.Worker, args...) = emit(DistributedRemoteCall)
Cassette.posthook(::ExtraeCtx, _, ::typeof(remotecall), f, ::Distributed.Worker, args...) = emit(DistributedEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(remotecall_fetch), ::typeof(Distributed.fetch_ref), ::Distributed.Worker, args...) = emit(DistributedRemoteCallFetch)
Cassette.posthook(::ExtraeCtx, _, ::typeof(remotecall_fetch), ::typeof(Distributed.fetch_ref), ::Distributed.Worker, args...) = emit(DistributedEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(remotecall_wait), args...) = emit(DistributedRemoteCallWait)
Cassette.posthook(::ExtraeCtx, _, ::typeof(remotecall_wait), args...) = emit(DistributedEnd)

# task management
Cassette.prehook(::ExtraeCtx, ::typeof(process_messages), args...) = emit(DistributedProcessMessages)
Cassette.posthook(::ExtraeCtx, _, ::typeof(process_messages), args...) = emit(DistributedEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(interrupt), args...) = emit(DistributedInterrupt)
Cassette.posthook(::ExtraeCtx, _, ::typeof(interrupt), args...) = emit(DistributedEnd)

# resource identification
function dist_taskid()::Cuint
    id = Distributed.myid() - 1
    return id
end
export dist_taskid

function dist_numtasks()::Cuint
    nworkers = Distributed.nworkers() + 1
    return nworkers
end
export dist_numtasks

# cluster manager addprocs 
function addprocs_extrae(np::Integer; restrict=true, kwargs...)
    manager = Extrae.ExtraeLocalManager(np, restrict)
    #check_addprocs_args(manager, kwargs)
    addprocs(manager; kwargs...)
end
export addprocs_extrae
