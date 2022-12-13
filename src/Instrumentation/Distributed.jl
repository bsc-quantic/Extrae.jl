using Distributed

# worker management
Cassette.prehook(::ExtraeCtx, ::typeof(addprocs), args...) = println("[TRACE] addprocs - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(addprocs), args...) = println("[TRACE] addprocs - end @ $(myid())")

Cassette.prehook(::ExtraeCtx, ::typeof(rmprocs), args...) = println("[TRACE] rmprocs - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(rmprocs), args...) = println("[TRACE] rmprocs - end @ $(myid())")

Cassette.prehook(::ExtraeCtx, ::typeof(init_worker), args...) = println("[TRACE] init_worker - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(init_worker), args...) = println("[TRACE] init_worker - end @ $(myid())")

Cassette.prehook(::ExtraeCtx, ::typeof(start_worker), args...) = println("[TRACE] start_worker - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(start_worker), args...) = println("[TRACE] start_worker - end @ $(myid())")

# task creation
Cassette.prehook(::ExtraeCtx, ::typeof(remotecall), args...) = println("[TRACE] remotecall - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(remotecall), args...) = println("[TRACE] remotecall - end @ $(myid())")

Cassette.prehook(::ExtraeCtx, ::typeof(remotecall_fetch), args...) = println("[TRACE] remotecall_fetch - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(remotecall_fetch), args...) = println("[TRACE] remotecall_fetch - end @ $(myid())")

Cassette.prehook(::ExtraeCtx, ::typeof(remotecall_wait), args...) = println("[TRACE] remotecall_wait - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(remotecall_wait), args...) = println("[TRACE] remotecall_wait - end @ $(myid())")

# task management
Cassette.prehook(::ExtraeCtx, ::typeof(process_messages), args...) = println("[TRACE] process_messages - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(process_messages), args...) = println("[TRACE] process_messages - end @ $(myid())")

Cassette.prehook(::ExtraeCtx, ::typeof(interrupt), args...) = println("[TRACE] interrupt - begin @ $(myid())")
Cassette.posthook(::ExtraeCtx, _, ::typeof(interrupt), args...) = println("[TRACE] interrupt - end @ $(myid())")
