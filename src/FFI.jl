module FFI

const lib = "libseqtrace"

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
Extrae_init() = @ccall lib.Extrae_init()::Cvoid
OMPItrace_init() = @ccall lib.OMPItrace_init()::Cvoid
MPItrace_init() = @ccall lib.MPItrace_init()::Cvoid
OMPtrace_init() = @ccall lib.OMPtrace_init()::Cvoid
SEQtrace_init() = @ccall lib.SEQtrace_init()::Cvoid

Extrae_is_initialized() = @ccall lib.Extrae_is_initialized()::InitType
OMPItrace_is_initialized() = @ccall lib.OMPItrace_is_initialized()::InitType
MPItrace_is_initialized() = @ccall lib.MPItrace_is_initialized()::InitType
OMPtrace_is_initialized() = @ccall lib.OMPtrace_is_initialized()::InitType
SEQtrace_is_initialized() = @ccall lib.SEQtrace_is_initialized()::InitType

Extrae_fini() = @ccall lib.Extrae_fini()::Cvoid
OMPItrace_fini() = @ccall lib.OMPItrace_fini()::Cvoid
MPItrace_fini() = @ccall lib.MPItrace_fini()::Cvoid
OMPtrace_fini() = @ccall lib.OMPtrace_fini()::Cvoid
SEQtrace_fini() = @ccall lib.SEQtrace_fini()::Cvoid

Extrae_flush() = @ccall lib.Extrae_flush()::Cvoid
OMPItrace_flush() = @ccall lib.OMPItrace_flush()::Cvoid
MPItrace_flush() = @ccall lib.MPItrace_flush()::Cvoid
OMPtrace_flush() = @ccall lib.OMPtrace_flush()::Cvoid
SEQtrace_flush() = @ccall lib.SEQtrace_flush()::Cvoid

Extrae_user_function(enter::UInt32) = @ccall lib.Extrae_user_function(enter::UInt32)::UInt64
OMPItrace_user_function(enter::UInt32) = @ccall lib.OMPItrace_user_function(enter::UInt32)::UInt64
MPItrace_user_function(enter::UInt32) = @ccall lib.MPItrace_user_function(enter::UInt32)::UInt64
OMPtrace_user_function(enter::UInt32) = @ccall lib.OMPtrace_user_function(enter::UInt32)::UInt64
SEQtrace_user_function(enter::UInt32) = @ccall lib.SEQtrace_user_function(enter::UInt32)::UInt64

Extrae_event(type, value) = @ccall lib.Extrae_event(type::Type, value::Value)::Cvoid
OMPItrace_event(type, value) = @ccall lib.OMPItrace_event(type::Type, value::Value)::Cvoid
MPItrace_event(type, value) = @ccall lib.MPItrace_event(type::Type, value::Value)::Cvoid
OMPtrace_event(type, value) = @ccall lib.OMPtrace_event(type::Type, value::Value)::Cvoid
SEQtrace_event(type, value) = @ccall lib.SEQtrace_event(type::Type, value::Value)::Cvoid

Extrae_nevent(count, types, values) = @ccall lib.Extrae_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPItrace_nevent(count, types, values) = @ccall lib.OMPItrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
MPItrace_nevent(count, types, values) = @ccall lib.MPItrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPtrace_nevent(count, types, values) = @ccall lib.OMPtrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
SEQtrace_nevent(count, types, values) = @ccall lib.SEQtrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid

Extrae_shutdown() = @ccall lib.Extrae_shutdown()::Cvoid
MPItrace_shutdown() = @ccall lib.MPItrace_shutdown()::Cvoid
OMPItrace_shutdown() = @ccall lib.OMPItrace_shutdown()::Cvoid
OMPtrace_shutdown() = @ccall lib.OMPtrace_shutdown()::Cvoid
SEQtrace_shutdown() = @ccall lib.SEQtrace_shutdown()::Cvoid

Extrae_restart() = @ccall lib.Extrae_restart()::Cvoid
MPItrace_restart() = @ccall lib.MPItrace_restart()::Cvoid
OMPItrace_restart() = @ccall lib.OMPItrace_restart()::Cvoid
OMPtrace_restart() = @ccall lib.OMPtrace_restart()::Cvoid
SEQtrace_restart() = @ccall lib.SEQtrace_restart()::Cvoid

Extrae_counters() = @ccall lib.Extrae_counters()::Cvoid
MPItrace_counters() = @ccall lib.MPItrace_counters()::Cvoid
OMPItrace_counters() = @ccall lib.OMPItrace_counters()::Cvoid
OMPtrace_counters() = @ccall lib.OMPtrace_counters()::Cvoid
SEQtrace_counters() = @ccall lib.SEQtrace_counters()::Cvoid

Extrae_previous_hwc_set() = @ccall lib.Extrae_previous_hwc_set()::Cvoid
MPItrace_previous_hwc_set() = @ccall lib.MPItrace_previous_hwc_set()::Cvoid
OMPItrace_previous_hwc_set() = @ccall lib.OMPItrace_previous_hwc_set()::Cvoid
OMPtrace_previous_hwc_set() = @ccall lib.OMPtrace_previous_hwc_set()::Cvoid
SEQtrace_previous_hwc_set() = @ccall lib.SEQtrace_previous_hwc_set()::Cvoid

Extrae_next_hwc_set() = @ccall lib.Extrae_next_hwc_set()::Cvoid
MPItrace_next_hwc_set() = @ccall lib.MPItrace_next_hwc_set()::Cvoid
OMPItrace_next_hwc_set() = @ccall lib.OMPItrace_next_hwc_set()::Cvoid
OMPtrace_next_hwc_set() = @ccall lib.OMPtrace_next_hwc_set()::Cvoid
SEQtrace_next_hwc_set() = @ccall lib.SEQtrace_next_hwc_set()::Cvoid

Extrae_eventandcounters(type, value) = @ccall lib.Extrae_eventandcounters(type::Type, value::Value)::Cvoid
MPItrace_eventandcounters(type, value) = @ccall lib.MPItrace_eventandcounters(type::Type, value::Value)::Cvoid
OMPItrace_eventandcounters(type, value) = @ccall lib.OMPItrace_eventandcounters(type::Type, value::Value)::Cvoid
OMPtrace_eventandcounters(type, value) = @ccall lib.OMPtrace_eventandcounters(type::Type, value::Value)::Cvoid
SEQtrace_eventandcounters(type, value) = @ccall lib.SEQtrace_eventandcounters(type::Type, value::Value)::Cvoid

Extrae_neventandcounters(count, types, values) = @ccall lib.Extrae_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPItrace_neventandcounters(count, types, values) = @ccall lib.OMPItrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
MPItrace_neventandcounters(count, types, values) = @ccall lib.MPItrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPtrace_neventandcounters(count, types, values) = @ccall lib.OMPtrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
SEQtrace_neventandcounters(count, types, values) = @ccall lib.SEQtrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid

Extrae_define_event_type(type, type_description, nvalues, values, values_description) = @ccall lib.Extrae_define_event_type(type::Ref{Type}, type_description::Cstring, nvalues::Ref{UInt32}, values::Ref{Value}, values_description::Ptr{Ptr{UInt8}})::Cvoid

Extrae_set_tracing_tasks(from, to) = @ccall lib.Extrae_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
OMPtrace_set_tracing_tasks(from, to) = @ccall lib.OMPtrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
MPItrace_set_tracing_tasks(from, to) = @ccall lib.MPItrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
OMPItrace_set_tracing_tasks(from, to) = @ccall lib.OMPItrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid

@enum Options begin
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

Extrae_set_options(options::Options) = @ccall lib.Extrae_set_options(options::Int32)::Cvoid
MPItrace_set_options(options::Options) = @ccall lib.MPItrace_set_options(options::Int32)::Cvoid
OMPtrace_set_options(options::Options) = @ccall lib.OMPtrace_set_options(options::Int32)::Cvoid
OMPItrace_set_options(options::Options) = @ccall lib.OMPItrace_set_options(options::Int32)::Cvoid
SEQtrace_set_options(options::Options) = @ccall lib.SEQtrace_set_options(options::Int32)::Cvoid

Extrae_network_counters() = @ccall lib.Extrae_network_counters()::Cvoid
OMPItrace_network_counters() = @ccall lib.OMPItrace_network_counters()::Cvoid
MPItrace_network_counters() = @ccall lib.MPItrace_network_counters()::Cvoid
OMPtrace_network_counters() = @ccall lib.OMPtrace_network_counters()::Cvoid
SEQtrace_network_counters() = @ccall lib.SEQtrace_network_counters()::Cvoid

Extrae_network_routes(mpi_rank::Int32) = @ccall lib.Extrae_network_routes(mpi_rank::Int32)::Cvoid
OMPItrace_network_routes(mpi_rank::Int32) = @ccall lib.OMPItrace_network_routes(mpi_rank::Int32)::Cvoid
MPItrace_network_routes(mpi_rank::Int32) = @ccall lib.MPItrace_network_routes(mpi_rank::Int32)::Cvoid
OMPtrace_network_routes(mpi_rank::Int32) = @ccall lib.OMPtrace_network_routes(mpi_rank::Int32)::Cvoid
SEQtrace_network_routes(mpi_rank::Int32) = @ccall lib.SEQtrace_network_routes(mpi_rank::Int32)::Cvoid

Extrae_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall lib.Extrae_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
OMPItrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall lib.OMPItrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
MPItrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall lib.MPItrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
OMPtrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall lib.OMPtrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid
SEQtrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall lib.SEQtrace_init_UserCommunication(ptr::Ref{UserCommunication})::Cvoid

Extrae_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.Extrae_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
OMPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.OMPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
MPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.MPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
OMPtrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.OMPtrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
SEQtrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.SEQtrace_init_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid

Extrae_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.Extrae_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
OMPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.OMPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
MPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.MPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
OMPtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.OMPtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid
SEQtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall lib.SEQtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents})::Cvoid

Extrae_resume_virtual_thread(vthread::UInt32) = @ccall lib.Extrae_resume_virtual_thread(vthread::UInt32)::Cvoid
Extrae_suspend_virtual_thread() = @ccall lib.Extrae_suspend_virtual_thread()::Cvoid
Extrae_register_stacked_type(type::Type) = @ccall lib.Extrae_register_stacked_type(type::Type)::Cvoid

Extrae_get_version(major::Ref{UInt32}, minor::Ref{UInt32}, revision::Ref{UInt32}) = @ccall lib.Extrae_get_version(major::Ref{UInt32}, minor::Ref{UInt32}, revision::Ref{UInt32})::Cvoid
Extrae_register_codelocation_type(t1::Type, t2::Type, s1::Cstring, s2::Cstring) = @ccall lib.Extrae_register_codelocation_type(t1::Type, t2::Type, s1::Cstring, s2::Cstring)::Cvoid
Extrae_register_function_address(ptr::Ref{Cvoid}, funcname::Cstring, modname::Cstring, line::UInt32) = @ccall lib.Extrae_register_function_address(ptr::Ref{Cvoid}, funcname::Cstring, modname::Cstring, line::UInt32)::Cvoid

# TODO extrae_internals.h

end