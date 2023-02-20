"""
    version()

Return the version of the underlying TRACE package.

Although an application may be compiled to a specific TRACE library, by using the appropiate shared library commands, the application may use a different TRACE library.
"""
function version()
    major = Ref(UInt32(0))
    minor = Ref(UInt32(0))
    rev = Ref(UInt32(0))

    FFI.Extrae_get_version(major, minor, rev)

    VersionNumber(major[], minor[], rev[])
end

"""
    init()

Initialize the tracing library.

This routine is called automatically in different circumstances, which include:
- Call to MPI_Init when the appropriate instrumentation library is linked or preload with the application.
- Usage of the DynInst launcher.
- If either the `libseqtrace.so`, `libomptrace.so` or `libpttrace.so` are linked dynamically or preloaded with the application.

No major problems should occur if the library is initialized twice, only a warning appears in the terminal output noticing the intent of double initialization.
"""
function init()

  ## TODO: This setup should depend on isntrumentation options.
  ## For example, if isntrumenting Distributed, here we setup the
  ## Distributed functions to identify resources
  FFI.Extrae_set_numtasks_function(dist_numtasks)
  FFI.Extrae_set_taskid_function(dist_taskid)
  #register(DistributedEvent, "Distributed runtime call")
  #register(DistributedUsefulWorkEvent, "Workers workload execution")

  ## Setup traceid for not intereference
  ENV["EXTRAE_PROGRAM_NAME"] = "JULIATRACE$(Distributed.myid())"

  FFI.Extrae_init()
  Libc.flush_cstdio()

  @debug "Extrae initialized in worker $(myid())"

end
export init


"""
    isinit()

Return `true` if the instrumentation has been initialized and if so, which mechanism was the first to initialize it.
"""
isinit() = FFI.Extrae_is_initialized()

"""
    finish()

Finalize the tracing library and dumps the intermediate tracing buffers onto disk.
"""
function finish()
  FFI.Extrae_fini()
  Libc.flush_cstdio()
end
export finish

"""
    flush()

Force the calling thread to write the events stored in the tracing buffers to disk.
"""
flush() = FFI.Extrae_flush()

"""
    instrumentation(state)

Turn on/off the instrumentation.
"""
instrumentation(state::Bool) = state ? restart() : shutdown()

"""
    emit()

Emit the value of the active hardware counters set.
"""
emit() = FFI.Extrae_counters()

abstract type Event{TypeCode,ValueCode} end
typecode(::Event{T}) where {T} = T
valuecode(::Event{T,V}) where {T,V} = V
description(::Type{Event{T,V}}) where {T,V} = String(V)
description(::E) where {E<:Event} = description(E)

"""
    emit(event)

Add a single timestampted event into the tracefile.
"""
function emit(::Event{T,V}; counters::Bool=false) where {T,V}
    @debug "Event emit: $(T): $(V)"
    if counters
        FFI.Extrae_eventandcounters(FFI.Type(T), FFI.Value(V))
    else
        FFI.Extrae_event(FFI.Type(T), FFI.Value(V))
    end
end

emit(events::Vector{Event}; counters::Bool=false) = foreach(e -> event(e; counters=counters), events)

"""
    register(event, description)
    register(events, description)

Document to the Paraver Configuration File human readable information regarding type type and its values values.
"""
register(::Type{<:Event{T}}, desc::String) where {T} = FFI.Extrae_define_event_type(T, Base.cconvert(Cstring(desc)), 0, Nothing, Nothing)
function register(events::Vector{<:Event{T,V} where {V}}, desc::String) where {T}
    nvalues = length(events)
    values = valuecode.(events)
    descs = description.(events)
    FFI.Extrae_define_event_type(T, Base.cconvert(desc), nvalues, Ref(values), Ref(descs))
end

"""
    previous_hwc_set()

Switch to the previous hardware counter set defined in the XML file.
"""
previous_hwc_set() = FFI.Extrae_previous_hwc_set()

"""
    next_hwc_set()

Switch to the following hardware counter set defined in the XML file.
"""
next_hwc_set() = FFI.Extrae_next_hwc_set()

"""
    set_tracing_tasks()

Select the range of tasks (not threads!) to store information from in the tracefile.
"""
set_tracing_tasks(interval::UnitRange{UInt32}) = FFI.Extrae_set_tracing_tasks(interval.start::UInt32, interval.stop::UInt32)

"""
    setoption(options)

Configure tracing options at runtime. The options parameter has to be a bitwise or combination of the following options, depending on the user's needs:
- EXTRAE_CALLER_OPTION Dumps caller information at each entry or exit point of the MPI routines. Caller levels need to be configured at XML.
- `EXTRAE_HWC_OPTION` Activates hardware counter gathering.
- `EXTRAE_MPI_OPTION` Activates tracing of MPI calls.
- `EXTRAE_MPI_HWC_OPTION` Activates hardware counter gathering in MPI routines.
- `EXTRAE_OMP_OPTION` Activates tracing of OpenMP runtime or outlined routines.
- `EXTRAE_OMP_HWC_OPTION` Activates hardware counter gathering in OpenMP runtime or outlined routines.
- `EXTRAE_UF_HWC_OPTION` Activates hardware counter gathering in the user functions.
"""
setoption(options::FFI.Options) = FFI.Extrae_set_options(options)

"""
    network_counters()

Emit the value of the network counters if the system has this capability (Only available for systems with Myrinet GM/MX networks).
"""
network_counters() = FFI.Extrae_network_counters()

"""
    network_routes(task)

Emit the network routes for an specific `task`.
"""
network_routes(task) = FFI.Extrae_network_routes(task)

"""
    user_function(enter)

Emit an event into the tracefile which references the source code (data includes: source line number, file name and function name).

If enter is 0 it marks an end (i.e., leaving the function), otherwise it marks the beginning of the routine. The user must be careful to place the call of this routine in places where the code is always executed, being careful not to place them inside if and return statements. The function returns the address of the reference.
```julia
function routine1()
    user_function(1);
    [routine1 code]
    user_function(0);
end

function routine2()
    user_function(1);
    [routine2 code]
    user_function(0);
end
```

In order to gather performance counters during the execution of these calls, the user-functions tag and its counters have to be both enabled int section.

# Warning

Note that you need to compile your application binary with debugging information (typically the `-g` compiler flag) in order to translate the captured addresses into valuable information such as function name, file name and line number.
"""
user_function(enter) = FFI.Extrae_user_function(enter)