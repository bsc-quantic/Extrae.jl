module Extrae

include("FFI.jl")
include("API.jl")
export Event, typecode, valuecode, description
export version, init, isinit, finish, flush, instrumentation, emit, register, previous_hwc_set, next_hwc_set, set_tracing_tasks, setoption, network_counters, network_routes, user_function

using Cassette
Cassette.@context ExtraeCtx

using Requires

function __init__()
    @require Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b" include("Instrumentation/Distributed.jl")
end

end
