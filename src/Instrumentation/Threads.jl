using Base.Threads: threading_run
using Base: do_threadcall

struct ThreadsEvent{ValueCode} <: Event{400003,ValueCode} end

const ThreadsEnd = ThreadsEvent{0}()
const ThreadsThreadCall = ThreadsEvent{1}() # NOTE tracing `do_threadcall` which is called by @threadcall
const ThreadsThreads = ThreadsEvent{2}() # NOTE tracing `threading_run` which is called by `_threadsfor` (used by `@threads`)
# const ThreadsSpawn = ThreadsEvent{3}() # TODO creates a `Task`

description(::typeof(ThreadsEnd)) = "end"
description(::typeof(ThreadsThreadCall)) = "@threadcall"
description(::typeof(ThreadsThreads)) = "@threads"
# description(::typeof(ThreadsSpawn)) = "@spawn"

Cassette.prehook(::ExtraeCtx, ::typeof(do_threadcall), args...) = emit(ThreadsThreadCall)
Cassette.posthook(::ExtraeCtx, _, ::typeof(do_threadcall), args...) = emit(ThreadsEnd)

Cassette.prehook(::ExtraeCtx, ::typeof(threading_run), args...) = emit(ThreadsThreads)
Cassette.posthook(::ExtraeCtx, _, ::typeof(threading_run), args...) = emit(ThreadsEnd)
