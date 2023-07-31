module Extrae

include("FFI.jl")
include("API.jl")
export Event, typecode, valuecode, description
export version, init, isinit, finish, flush, instrumentation, emit, register, previous_hwc_set, next_hwc_set, set_tracing_tasks, setoption, network_counters, network_routes, user_function

include("Instrumentation/Threads.jl")

end
