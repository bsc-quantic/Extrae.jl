module FFI

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
Extrae_init() = @ccall Extrae_init()::Cvoid
OMPItrace_init() = @ccall OMPItrace_init()::Cvoid
MPItrace_init() = @ccall MPItrace_init()::Cvoid
OMPtrace_init() = @ccall OMPtrace_init()::Cvoid
SEQtrace_init() = @ccall SEQtrace_init()::Cvoid

Extrae_is_initialized() = @ccall Extrae_is_initialized()::InitType
OMPItrace_is_initialized() = @ccall OMPItrace_is_initialized()::InitType
MPItrace_is_initialized() = @ccall MPItrace_is_initialized()::InitType
OMPtrace_is_initialized() = @ccall OMPtrace_is_initialized()::InitType
SEQtrace_is_initialized() = @ccall SEQtrace_is_initialized()::InitType

Extrae_fini() = @ccall Extrae_fini()::Cvoid
OMPItrace_fini() = @ccall OMPItrace_fini()::Cvoid
MPItrace_fini() = @ccall MPItrace_fini()::Cvoid
OMPtrace_fini() = @ccall OMPtrace_fini()::Cvoid
SEQtrace_fini() = @ccall SEQtrace_fini()::Cvoid

Extrae_flush() = @ccall Extrae_flush()::Cvoid
OMPItrace_flush() = @ccall OMPItrace_flush()::Cvoid
MPItrace_flush() = @ccall MPItrace_flush()::Cvoid
OMPtrace_flush() = @ccall OMPtrace_flush()::Cvoid
SEQtrace_flush() = @ccall SEQtrace_flush()::Cvoid

Extrae_user_function(enter::UInt32) = @ccall Extrae_user_function(enter::UInt32)::UInt64
OMPItrace_user_function(enter::UInt32) = @ccall OMPItrace_user_function(enter::UInt32)::UInt64
MPItrace_user_function(enter::UInt32) = @ccall MPItrace_user_function(enter::UInt32)::UInt64
OMPtrace_user_function(enter::UInt32) = @ccall OMPtrace_user_function(enter::UInt32)::UInt64
SEQtrace_user_function(enter::UInt32) = @ccall SEQtrace_user_function(enter::UInt32)::UInt64

Extrae_event(type, value) = @ccall Extrae_event(type::Type, value::Value)::Cvoid
OMPItrace_event(type, value) = @ccall OMPItrace_event(type::Type, value::Value)::Cvoid
MPItrace_event(type, value) = @ccall MPItrace_event(type::Type, value::Value)::Cvoid
OMPtrace_event(type, value) = @ccall OMPtrace_event(type::Type, value::Value)::Cvoid
SEQtrace_event(type, value) = @ccall SEQtrace_event(type::Type, value::Value)::Cvoid

Extrae_nevent(count, types, values) = @ccall Extrae_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPItrace_nevent(count, types, values) = @ccall OMPItrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
MPItrace_nevent(count, types, values) = @ccall MPItrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPtrace_nevent(count, types, values) = @ccall OMPtrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
SEQtrace_nevent(count, types, values) = @ccall SEQtrace_nevent(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid

Extrae_shutdown() = @ccall Extrae_shutdown()::Cvoid
MPItrace_shutdown() = @ccall MPItrace_shutdown()::Cvoid
OMPItrace_shutdown() = @ccall OMPItrace_shutdown()::Cvoid
OMPtrace_shutdown() = @ccall OMPtrace_shutdown()::Cvoid
SEQtrace_shutdown() = @ccall SEQtrace_shutdown()::Cvoid

Extrae_restart() = @ccall Extrae_restart()::Cvoid
MPItrace_restart() = @ccall MPItrace_restart()::Cvoid
OMPItrace_restart() = @ccall OMPItrace_restart()::Cvoid
OMPtrace_restart() = @ccall OMPtrace_restart()::Cvoid
SEQtrace_restart() = @ccall SEQtrace_restart()::Cvoid

Extrae_counters() = @ccall Extrae_counters()::Cvoid
MPItrace_counters() = @ccall MPItrace_counters()::Cvoid
OMPItrace_counters() = @ccall OMPItrace_counters()::Cvoid
OMPtrace_counters() = @ccall OMPtrace_counters()::Cvoid
SEQtrace_counters() = @ccall SEQtrace_counters()::Cvoid

Extrae_previous_hwc_set() = @ccall Extrae_previous_hwc_set()::Cvoid
MPItrace_previous_hwc_set() = @ccall MPItrace_previous_hwc_set()::Cvoid
OMPItrace_previous_hwc_set() = @ccall OMPItrace_previous_hwc_set()::Cvoid
OMPtrace_previous_hwc_set() = @ccall OMPtrace_previous_hwc_set()::Cvoid
SEQtrace_previous_hwc_set() = @ccall SEQtrace_previous_hwc_set()::Cvoid

Extrae_next_hwc_set() = @ccall Extrae_next_hwc_set()::Cvoid
MPItrace_next_hwc_set() = @ccall MPItrace_next_hwc_set()::Cvoid
OMPItrace_next_hwc_set() = @ccall OMPItrace_next_hwc_set()::Cvoid
OMPtrace_next_hwc_set() = @ccall OMPtrace_next_hwc_set()::Cvoid
SEQtrace_next_hwc_set() = @ccall SEQtrace_next_hwc_set()::Cvoid

Extrae_eventandcounters(type, value) = @ccall Extrae_eventandcounters(type::Type, value::Value)::Cvoid
MPItrace_eventandcounters(type, value) = @ccall MPItrace_eventandcounters(type::Type, value::Value)::Cvoid
OMPItrace_eventandcounters(type, value) = @ccall OMPItrace_eventandcounters(type::Type, value::Value)::Cvoid
OMPtrace_eventandcounters(type, value) = @ccall OMPtrace_eventandcounters(type::Type, value::Value)::Cvoid
SEQtrace_eventandcounters(type, value) = @ccall SEQtrace_eventandcounters(type::Type, value::Value)::Cvoid

Extrae_neventandcounters(count, types, values) = @ccall Extrae_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPItrace_neventandcounters(count, types, values) = @ccall OMPItrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
MPItrace_neventandcounters(count, types, values) = @ccall MPItrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
OMPtrace_neventandcounters(count, types, values) = @ccall OMPtrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid
SEQtrace_neventandcounters(count, types, values) = @ccall SEQtrace_neventandcounters(count::UInt32, types::Ptr{Type}, values::Ptr{Value})::Cvoid

Extrae_define_event_type(type, type_description, nvalues, values, values_description) = @ccall Extrae_define_event_type(type::Ref{Type}, type_description::Cstring, nvalues::Ref{UInt32}, values::Ref{Value}, values_description::Ptr{Ptr{UInt8}})::Cvoid

Extrae_set_tracing_tasks(from, to) = @ccall Extrae_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
OMPtrace_set_tracing_tasks(from, to) = @ccall OMPtrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
MPItrace_set_tracing_tasks(from, to) = @ccall MPItrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid
OMPItrace_set_tracing_tasks(from, to) = @ccall OMPItrace_set_tracing_tasks(from::UInt32, to::UInt32)::Cvoid

@enum Options begin
	Disable = 0
	Caller = 1 << 0
	HWC = 1 << 1
	MPI_HWC = 1 << 2
	MPI = 1 << 3
	OMP = 1 << 4
	OMP_HWC = 1 << 5
	UF_HWC = 1 << 6
	PThread = 1 << 7
	PThread_HWC = 1 << 8
	Sampling = 1 << 9
	All = 1 << 10 - 1
end

Extrae_set_options(options::Options) = @ccall Extrae_set_options(Int32(options))::Cvoid
MPItrace_set_options(options::Options) = @ccall MPItrace_set_options(Int32(options))::Cvoid
OMPtrace_set_options(options::Options) = @ccall OMPtrace_set_options(Int32(options))::Cvoid
OMPItrace_set_options(options::Options) = @ccall OMPItrace_set_options(Int32(options))::Cvoid
SEQtrace_set_options(options::Options) = @ccall SEQtrace_set_options(Int32(options))::Cvoid

Extrae_network_counters() = @ccall Extrae_network_counters()::Cvoid
OMPItrace_network_counters() = @ccall OMPItrace_network_counters()::Cvoid
MPItrace_network_counters() = @ccall MPItrace_network_counters()::Cvoid
OMPtrace_network_counters() = @ccall OMPtrace_network_counters()::Cvoid
SEQtrace_network_counters() = @ccall SEQtrace_network_counters()::Cvoid

Extrae_network_routes(mpi_rank::Int32) = @ccall Extrae_network_routes(mpi_rank)::Cvoid
OMPItrace_network_routes(mpi_rank::Int32) = @ccall OMPItrace_network_routes(mpi_rank)::Cvoid
MPItrace_network_routes(mpi_rank::Int32) = @ccall MPItrace_network_routes(mpi_rank)::Cvoid
OMPtrace_network_routes(mpi_rank::Int32) = @ccall OMPtrace_network_routes(mpi_rank)::Cvoid
SEQtrace_network_routes(mpi_rank::Int32) = @ccall SEQtrace_network_routes(mpi_rank)::Cvoid

Extrae_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall Extrae_init_UserCommunication(ptr)
OMPItrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall OMPItrace_init_UserCommunication(ptr)
MPItrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall MPItrace_init_UserCommunication(ptr)
OMPtrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall OMPtrace_init_UserCommunication(ptr)
SEQtrace_init_UserCommunication(ptr::Ref{UserCommunication}) = @ccall SEQtrace_init_UserCommunication(ptr)

Extrae_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall Extrae_init_CombinedEvents(ptr)::Cvoid
OMPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall OMPItrace_init_CombinedEvents(ptr)::Cvoid
MPItrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall MPItrace_init_CombinedEvents(ptr)::Cvoid
OMPtrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall OMPtrace_init_CombinedEvents(ptr)::Cvoid
SEQtrace_init_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall SEQtrace_init_CombinedEvents(ptr)::Cvoid

Extrae_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall Extrae_emit_CombinedEvents(ptr)
OMPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall OMPItrace_emit_CombinedEvents(ptr)::Cvoid
MPItrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall MPItrace_emit_CombinedEvents(ptr)::Cvoid
OMPtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall OMPtrace_emit_CombinedEvents(ptr)::Cvoid
SEQtrace_emit_CombinedEvents(ptr::Ref{CombinedEvents}) = @ccall SEQtrace_emit_CombinedEvents(ptr)::Cvoid

Extrae_resume_virtual_thread(vthread::UInt32) = @ccall Extrae_resume_virtual_thread(vthread)::CVoid
Extrae_suspend_virtual_thread() = @ccall Extrae_suspend_virtual_thread()::Cvoid
Extrae_register_stacked_type(type::Type) = @ccall Extrae_register_stacked_type(type)::Cvoid

Extrae_get_version(major::Ref{UInt32}, minor::Ref{UInt32}, revision::Ref{UInt32}) = @ccall Extrae_get_version(major, minor, revision)::Cvoid
Extrae_register_codelocation_type(t1::Type, t2::Type, s1::Cstring, s2::Cstring) = @ccall Extrae_register_codelocation_type(t1, t2, s1, s2)::Cvoid
Extrae_register_function_address(ptr::Ref{Cvoid}, funcname::Cstring, modname::Cstring, line::UInt32) = @ccall Extrae_register_function_address(ptr, funcname, modname, line)::Cvoid

# TODO extrae_internals.h

end