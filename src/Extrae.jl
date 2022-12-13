module Extrae

include("FFI.jl")
const Type = FFI.Type
const Value = FFI.Value

include("API.jl")

using Cassette
Cassette.@context ExtraeCtx

using Requires

function __init__()
    @require Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b" include("Instrumentation/Distributed.jl")
end

end
