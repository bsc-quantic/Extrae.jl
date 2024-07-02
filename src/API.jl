const Event = Tuple{FFI.Type,FFI.Value}

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

    return VersionNumber(major[], minor[], rev[])
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
init() = FFI.Extrae_init()

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
    return Libc.flush_cstdio()
end

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

function register(tcode, tdesc)
    return FFI.Extrae_define_event_type(tcode, tdesc, 0, FFI.Value[], String[])
end

function register(tcode, tdesc, vcodes, vdescs)
    @assert length(vcodes) == length(vdescs)
    return FFI.Extrae_define_event_type(tcode, tdesc, length(vcodes), vcodes, vdescs)
end

"""
    emit()

Emit the value of the active hardware counters set.
"""
emit() = FFI.Extrae_counters()

"""
    emit(event)

Add a single timestampted event into the tracefile.
"""
function emit(typecode::FFI.Type, valuecode::FFI.Value; counters::Bool=false)
    if counters
        FFI.Extrae_eventandcounters(typecode, valuecode)
    else
        FFI.Extrae_event(typecode, valuecode)
    end
end

function emit(
    typecodes::Vector{FFI.Type}, valuecodes::Vector{FFI.Value}; counters::Bool=false
)
    @assert length(typecodes) == length(valuecodes)
    N = length(typecodes)
    if counters
        FFI.Extrae_neventandcounters(N, typecodes, valuecodes)
    else
        FFI.Extrae_nevent(N, typecodes, valuecodes)
    end
end

function emit(events::Vector{Event}; counters::Bool=false)
    typecodes = map(x -> x[1], events)
    valuecodes = map(x -> x[2], events)
    return emit(typecodes, valuecodes; counters)
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
function set_tracing_tasks(interval::UnitRange{UInt32})
    return FFI.Extrae_set_tracing_tasks(interval.start, interval.stop)
end

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
user_function(enter) = FFI.Extrae_user_function(UInt32(enter))
