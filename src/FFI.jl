module FFI

using Extrae_jll
using Preferences

using ..Extrae: libextrae

# extrae_types.h
@enum InitType begin
    NotInitialized = 0
    Extrae
    MPI
    SharedMem
end

@enum UserCommunicationTypes begin
    Send = 0
    Recv
end

@enum UserFunction begin
    FunctionNone = -1
    FunctionLeave = 0
    FunctionEnter
end

const CommTag = UInt32
const CommPartner = UInt32
const CommId = Int64
const Type = UInt32
const Value = UInt64

struct UserCommunication
    type::UserCommunicationTypes
    tag::CommTag
    size::UInt32
    id::CommId
end

struct CombinedEvents
    hwCounters::Int32
    callers::Int32
    userFunction::Int32
    nEvents::UInt32
    types::Ptr{Type}
    values::Ptr{Value}
    nCommunications::UInt32
    communications::Ptr{UserCommunication}
end

# extrae.h
Extrae_init() = @ccall libextrae.Extrae_init()::Cvoid
OMPItrace_init() = @ccall libextrae.OMPItrace_init()::Cvoid
MPItrace_init() = @ccall libextrae.MPItrace_init()::Cvoid
OMPtrace_init() = @ccall libextrae.OMPtrace_init()::Cvoid
SEQtrace_init() = @ccall libextrae.SEQtrace_init()::Cvoid

Extrae_is_initialized() = @ccall libextrae.Extrae_is_initialized()::InitType
OMPItrace_is_initialized() = @ccall libextrae.OMPItrace_is_initialized()::InitType
MPItrace_is_initialized() = @ccall libextrae.MPItrace_is_initialized()::InitType
OMPtrace_is_initialized() = @ccall libextrae.OMPtrace_is_initialized()::InitType
SEQtrace_is_initialized() = @ccall libextrae.SEQtrace_is_initialized()::InitType

Extrae_fini() = @ccall libextrae.Extrae_fini()::Cvoid
OMPItrace_fini() = @ccall libextrae.OMPItrace_fini()::Cvoid
MPItrace_fini() = @ccall libextrae.MPItrace_fini()::Cvoid
OMPtrace_fini() = @ccall libextrae.OMPtrace_fini()::Cvoid
SEQtrace_fini() = @ccall libextrae.SEQtrace_fini()::Cvoid

Extrae_flush() = @ccall libextrae.Extrae_flush()::Cvoid
OMPItrace_flush() = @ccall libextrae.OMPItrace_flush()::Cvoid
MPItrace_flush() = @ccall libextrae.MPItrace_flush()::Cvoid
OMPtrace_flush() = @ccall libextrae.OMPtrace_flush()::Cvoid
SEQtrace_flush() = @ccall libextrae.SEQtrace_flush()::Cvoid

function Extrae_user_function(enter::UInt32)
    @ccall libextrae.Extrae_user_function(enter::UInt32)::UInt64
end
function OMPItrace_user_function(enter::UInt32)
    @ccall libextrae.OMPItrace_user_function(enter::UInt32)::UInt64
end
function MPItrace_user_function(enter::UInt32)
    @ccall libextrae.MPItrace_user_function(enter::UInt32)::UInt64
end
function OMPtrace_user_function(enter::UInt32)
    @ccall libextrae.OMPtrace_user_function(enter::UInt32)::UInt64
end
function SEQtrace_user_function(enter::UInt32)
    @ccall libextrae.SEQtrace_user_function(enter::UInt32)::UInt64
end

Extrae_event(type, value) = @ccall libextrae.Extrae_event(type::Type, value::Value)::Cvoid
function OMPItrace_event(type, value)
    @ccall libextrae.OMPItrace_event(type::Type, value::Value)::Cvoid
end
function MPItrace_event(type, value)
    @ccall libextrae.MPItrace_event(type::Type, value::Value)::Cvoid
end
function OMPtrace_event(type, value)
    @ccall libextrae.OMPtrace_event(type::Type, value::Value)::Cvoid
end
function SEQtrace_event(type, value)
    @ccall libextrae.SEQtrace_event(type::Type, value::Value)::Cvoid
end

function Extrae_nevent(count, types, values)
    @ccall libextrae.Extrae_nevent(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function OMPItrace_nevent(count, types, values)
    @ccall libextrae.OMPItrace_nevent(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function MPItrace_nevent(count, types, values)
    @ccall libextrae.MPItrace_nevent(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function OMPtrace_nevent(count, types, values)
    @ccall libextrae.OMPtrace_nevent(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function SEQtrace_nevent(count, types, values)
    @ccall libextrae.SEQtrace_nevent(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end

Extrae_shutdown() = @ccall libextrae.Extrae_shutdown()::Cvoid
MPItrace_shutdown() = @ccall libextrae.MPItrace_shutdown()::Cvoid
OMPItrace_shutdown() = @ccall libextrae.OMPItrace_shutdown()::Cvoid
OMPtrace_shutdown() = @ccall libextrae.OMPtrace_shutdown()::Cvoid
SEQtrace_shutdown() = @ccall libextrae.SEQtrace_shutdown()::Cvoid

Extrae_restart() = @ccall libextrae.Extrae_restart()::Cvoid
MPItrace_restart() = @ccall libextrae.MPItrace_restart()::Cvoid
OMPItrace_restart() = @ccall libextrae.OMPItrace_restart()::Cvoid
OMPtrace_restart() = @ccall libextrae.OMPtrace_restart()::Cvoid
SEQtrace_restart() = @ccall libextrae.SEQtrace_restart()::Cvoid

Extrae_counters() = @ccall libextrae.Extrae_counters()::Cvoid
MPItrace_counters() = @ccall libextrae.MPItrace_counters()::Cvoid
OMPItrace_counters() = @ccall libextrae.OMPItrace_counters()::Cvoid
OMPtrace_counters() = @ccall libextrae.OMPtrace_counters()::Cvoid
SEQtrace_counters() = @ccall libextrae.SEQtrace_counters()::Cvoid

Extrae_previous_hwc_set() = @ccall libextrae.Extrae_previous_hwc_set()::Cvoid
MPItrace_previous_hwc_set() = @ccall libextrae.MPItrace_previous_hwc_set()::Cvoid
OMPItrace_previous_hwc_set() = @ccall libextrae.OMPItrace_previous_hwc_set()::Cvoid
OMPtrace_previous_hwc_set() = @ccall libextrae.OMPtrace_previous_hwc_set()::Cvoid
SEQtrace_previous_hwc_set() = @ccall libextrae.SEQtrace_previous_hwc_set()::Cvoid

Extrae_next_hwc_set() = @ccall libextrae.Extrae_next_hwc_set()::Cvoid
MPItrace_next_hwc_set() = @ccall libextrae.MPItrace_next_hwc_set()::Cvoid
OMPItrace_next_hwc_set() = @ccall libextrae.OMPItrace_next_hwc_set()::Cvoid
OMPtrace_next_hwc_set() = @ccall libextrae.OMPtrace_next_hwc_set()::Cvoid
SEQtrace_next_hwc_set() = @ccall libextrae.SEQtrace_next_hwc_set()::Cvoid

function Extrae_eventandcounters(type, value)
    @ccall libextrae.Extrae_eventandcounters(type::Type, value::Value)::Cvoid
end
function MPItrace_eventandcounters(type, value)
    @ccall libextrae.MPItrace_eventandcounters(type::Type, value::Value)::Cvoid
end
function OMPItrace_eventandcounters(type, value)
    @ccall libextrae.OMPItrace_eventandcounters(type::Type, value::Value)::Cvoid
end
function OMPtrace_eventandcounters(type, value)
    @ccall libextrae.OMPtrace_eventandcounters(type::Type, value::Value)::Cvoid
end
function SEQtrace_eventandcounters(type, value)
    @ccall libextrae.SEQtrace_eventandcounters(type::Type, value::Value)::Cvoid
end

function Extrae_neventandcounters(count, types, values)
    @ccall libextrae.Extrae_neventandcounters(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function OMPItrace_neventandcounters(count, types, values)
    @ccall libextrae.OMPItrace_neventandcounters(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function MPItrace_neventandcounters(count, types, values)
    @ccall libextrae.MPItrace_neventandcounters(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function OMPtrace_neventandcounters(count, types, values)
    @ccall libextrae.OMPtrace_neventandcounters(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end
function SEQtrace_neventandcounters(count, types, values)
    @ccall libextrae.SEQtrace_neventandcounters(
        count::UInt32, types::Ptr{Type}, values::Ptr{Value}
    )::Cvoid
end

function Extrae_define_event_type(
    type, type_description, nvalues, values, values_description
)
    @ccall libextrae.Extrae_define_event_type(
        type::Ref{Type},
        type_description::Cstring,
        nvalues::Ref{UInt32},
        values::Ref{Vector{Value}},
        values_description::Ptr{Ptr{UInt8}},
    )::Cvoid
end

function Extrae_set_tracing_tasks(from, to)
    @ccall libextrae.Extrae_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
end
function OMPtrace_set_tracing_tasks(from, to)
    @ccall libextrae.OMPtrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
end
function MPItrace_set_tracing_tasks(from, to)
    @ccall libextrae.MPItrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
end
function OMPItrace_set_tracing_tasks(from, to)
    @ccall libextrae.OMPItrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
end

@enum Options::Int32 begin
    Disable = 0
    Caller = 1 << 0
    HWC = 1 << 1
    MPI_HWC = 1 << 2
    _MPI = 1 << 3
    OMP = 1 << 4
    OMP_HWC = 1 << 5
    UF_HWC = 1 << 6
    PThread = 1 << 7
    PThread_HWC = 1 << 8
    Sampling = 1 << 9
    All = 1 << 10 - 1
end

function Extrae_set_options(options::Options)
    @ccall libextrae.Extrae_set_options(options::Int32)::Cvoid
end
function MPItrace_set_options(options::Options)
    @ccall libextrae.MPItrace_set_options(options::Int32)::Cvoid
end
function OMPtrace_set_options(options::Options)
    @ccall libextrae.OMPtrace_set_options(options::Int32)::Cvoid
end
function OMPItrace_set_options(options::Options)
    @ccall libextrae.OMPItrace_set_options(options::Int32)::Cvoid
end
function SEQtrace_set_options(options::Options)
    @ccall libextrae.SEQtrace_set_options(options::Int32)::Cvoid
end

Extrae_network_counters() = @ccall libextrae.Extrae_network_counters()::Cvoid
OMPItrace_network_counters() = @ccall libextrae.OMPItrace_network_counters()::Cvoid
MPItrace_network_counters() = @ccall libextrae.MPItrace_network_counters()::Cvoid
OMPtrace_network_counters() = @ccall libextrae.OMPtrace_network_counters()::Cvoid
SEQtrace_network_counters() = @ccall libextrae.SEQtrace_network_counters()::Cvoid

function Extrae_network_routes(mpi_rank::Int32)
    @ccall libextrae.Extrae_network_routes(mpi_rank::Int32)::Cvoid
end
function OMPItrace_network_routes(mpi_rank::Int32)
    @ccall libextrae.OMPItrace_network_routes(mpi_rank::Int32)::Cvoid
end
function MPItrace_network_routes(mpi_rank::Int32)
    @ccall libextrae.MPItrace_network_routes(mpi_rank::Int32)::Cvoid
end
function OMPtrace_network_routes(mpi_rank::Int32)
    @ccall libextrae.OMPtrace_network_routes(mpi_rank::Int32)::Cvoid
end
function SEQtrace_network_routes(mpi_rank::Int32)
    @ccall libextrae.SEQtrace_network_routes(mpi_rank::Int32)::Cvoid
end

function Extrae_init_UserCommunication(ptr::Ref{UserCommunication})
    @ccall libextrae.Extrae_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
end
function OMPItrace_init_UserCommunication(ptr::Ref{UserCommunication})
    @ccall libextrae.OMPItrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
end
function MPItrace_init_UserCommunication(ptr::Ref{UserCommunication})
    @ccall libextrae.MPItrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
end
function OMPtrace_init_UserCommunication(ptr::Ref{UserCommunication})
    @ccall libextrae.OMPtrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
end
function SEQtrace_init_UserCommunication(ptr::Ref{UserCommunication})
    @ccall libextrae.SEQtrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
end

function Extrae_init_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.Extrae_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function OMPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.OMPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function MPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.MPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function OMPtrace_init_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.OMPtrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function SEQtrace_init_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.SEQtrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end

function Extrae_emit_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.Extrae_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function OMPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.OMPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function MPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.MPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function OMPtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.OMPtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end
function SEQtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})
    @ccall libextrae.SEQtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
end

function Extrae_resume_virtual_thread(vthread::UInt32)
    @ccall libextrae.Extrae_resume_virtual_thread(vthread::UInt32)::Cvoid
end
Extrae_suspend_virtual_thread() = @ccall libextrae.Extrae_suspend_virtual_thread()::Cvoid
function Extrae_register_stacked_type(type::Type)
    @ccall libextrae.Extrae_register_stacked_type(type::Type)::Cvoid
end

function Extrae_get_version(major::Ref{UInt32}, minor::Ref{UInt32}, revision::Ref{UInt32})
    @ccall libextrae.Extrae_get_version(
        major::Ref{UInt32}, minor::Ref{UInt32}, revision::Ref{UInt32}
    )::Cvoid
end
function Extrae_register_codelocation_type(t1::Type, t2::Type, s1::Cstring, s2::Cstring)
    @ccall libextrae.Extrae_register_codelocation_type(
        t1::Type, t2::Type, s1::Cstring, s2::Cstring
    )::Cvoid
end
function Extrae_register_function_address(
    ptr::Ref{Cvoid}, funcname::Cstring, modname::Cstring, line::UInt32
)
    @ccall libextrae.Extrae_register_function_address(
        ptr::Ref{Cvoid}, funcname::Cstring, modname::Cstring, line::UInt32
    )::Cvoid
end

# extrae_internals.h
function Extrae_set_threadid_function(f::Function)
    @ccall libextrae.Extrae_set_threadid_function(
        @cfunction($f, Cuint, ())::Ptr{Cvoid}
    )::Cvoid
end
function Extrae_set_numthreads_function(f::Function)
    @ccall libextrae.Extrae_set_numthreads_function(
        @cfunction($f, Cuint, ())::Ptr{Cvoid}
    )::Cvoid
end

function Extrae_set_taskid_function(f::Function)
    @ccall libextrae.Extrae_set_taskid_function(
        @cfunction($f, Cuint, ())::Ptr{Cvoid}
    )::Cvoid
end
function Extrae_set_numtasks_function(f::Function)
    @ccall libextrae.Extrae_set_numtasks_function(
        @cfunction($f, Cuint, ())::Ptr{Cvoid}
    )::Cvoid
end
function Extrae_set_barrier_tasks_function(f::Function)
    @ccall libextrae.Extrae_set_barrier_tasks_function(
        @cfunction($f, Cuint, ())::Ptr{Cvoid}
    )::Cvoid
end

function Extrae_set_thread_name(thread::Unsigned, name::String)
    @ccall libextrae.Extrae_set_thread_name(thread::Cuint, name::Cstring)::Cvoid
end
function Extrae_function_from_address(type::Type, address)
    @ccall libextrae.Extrae_function_from_address(type::Cuint, address::Ref{Cvoid})::Cvoid
end

end
