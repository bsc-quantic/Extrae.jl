module ExtraeDistributedExt

using Extrae
using Distributed

taskid()::Cuint = Distributed.myid() - 1
ntasks()::Cuint = Distributed.nworkers() + 1

function init(::Val{:Distributed})
    FFI.Extrae_set_numtasks_function(ntasks)
    FFI.Extrae_set_taskid_function(taskid)

    ENV["EXTRAE_PROGRAM_NAME"] = "JULIATRACE-$(Distributed.myid())"

    Extrae.init()
    Libc.flush_cstdio()

    return nothing
end

end
