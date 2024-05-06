module Extrae

include("FFI.jl")
include("API.jl")
export Event, typecode, valuecode, description
export version, init, isinit, finish, flush, instrumentation, emit, register, previous_hwc_set, next_hwc_set, set_tracing_tasks, setoption, network_counters, network_routes, user_function

function __init__()
    FFI.Extrae_init()

    get!(ENV, "EXTRAE_HOME", Extrae_jll.artifact_dir)
    get!(ENV, "EXTRAE_DISABLE_OMP", true)
    get!(ENV, "EXTRAE_DISABLE_PTHREAD", false)
end

end
