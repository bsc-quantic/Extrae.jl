using Distributed

include("ExtraeLocalManager.jl")

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

##### WORKAROUND TO NOT ESCAPE ON TASKS. See: https://github.com/JuliaLabs/Cassette.jl/issues/120
Cassette.overdub(ctx::ExtraeCtx, ::typeof(Base.Core._Task), @nospecialize(f), stack::Int, future) = Base.Core._Task(()->Cassette.overdub(ctx, f), stack, future)


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

# workload execution
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.run_work_thunk), f::Function, args...) = emit(DistributedUsefulWork)
Cassette.posthook(::ExtraeCtx, _, ::typeof(Distributed.run_work_thunk), f::Function, args...) = emit(DistributedNotUsefulWork)

# message handle
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.CallMsg{:call}, args...) = emit(DistributedHandleCall)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.CallMsg{:call_fetch}, args...) = emit(DistributedHandleCallFetch)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.CallWaitMsg, args...) = emit(DistributedHandleCallWait)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.RemoteDoMsg, args...) = emit(DistributedHandleRemoteDo)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.ResultMsg, args...) = emit(DistributedHandleResult)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.IdentifySocketMsg, args...) = emit(DistributedHandleIdentifySocket)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.IdentifySocketAckMsg, args...) = emit(DistributedHandleIdentifySocketAck)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.JoinPGRPMsg, args...) = emit(DistributedHandleJoinPGRP)
Cassette.prehook(::ExtraeCtx, ::typeof(Distributed.handle_msg), ::Distributed.JoinCompleteMsg, args...) = emit(DistributedHandleJoinComplete)

Cassette.posthook(::ExtraeCtx, _, ::typeof(Distributed.handle_msg), args...) = emit(DistributedHandleEnd)


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
