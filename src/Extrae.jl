module Extrae

using Extrae_jll
using Libdl
using Preferences

export version,
    init,
    isinit,
    finish,
    flush,
    instrumentation,
    emit,
    register,
    previous_hwc_set,
    next_hwc_set,
    set_tracing_tasks,
    setoption,
    network_counters,
    network_routes,
    user_function

function __init__()
    get!(ENV, "EXTRAE_HOME", Extrae_jll.artifact_dir)
    get!(ENV, "EXTRAE_DISABLE_OMP", true)
    get!(ENV, "EXTRAE_DISABLE_PTHREAD", false)
    return nothing
end

const libextrae = @load_preference("libextrae", Extrae_jll.libseqtrace)

function use_system_binary(;
    library_names=[
        "libseqtrace",
        "libpttrace",
        "libmpitrace",
        "libptmpitrace",
        "libcudatrace",
        "libptcudatrace",
        "libcudampitrace",
        "libptcudampitrace",
    ],
    extra_paths=String[],
    export_prefs=false,
    force=true,
)
    libextrae = find_library(library_names, extra_paths)
    if libextrae == ""
        error("""
            Extrae library could not be found with the following name(s):
                $(library_names)
            in the following extra directories (in addition to the default ones):
                $(extra_paths)
            If you want to try different name(s) for the Extrae library, use
                Extrae.use_system_binary(; library_names=[...])""")
    end

    libextrae = join((libextrae, Libdl.dlext), '.')

    set_preferences!(Extrae, "libextrae" => libextrae; export_prefs, force)

    if libextrae != Extrae.libextrae
        @info "Extrae preferences changed" libextrae
        error("You will need to restart Julia for the changes to take effect")
    end
end

function use_jll_binary(binary; export_prefs=false, force=true)
    known_binaries = (
        :libseqtrace,
        :libpttrace,
        :libmpitrace,
        :libptmpitrace,
        :libcudatrace,
        :libptcudatrace,
        :libcudampitrace,
        :libptcudampitrace,
    )
    binary in known_binaries || error("""
               Unknown jll: $binary
               Accepted options are:
                   $(join(string.(known_binaries), ", "))""")

    libextrae = getproperty(Extrae_jll, binary)

    set_preferences!(Extrae, "libextrae" => libextrae; export_prefs, force)

    if libextrae != Extrae.libextrae
        @info "Extrae preferences changed" libextrae
        error("You will need to restart Julia for the changes to take effect")
    end
end

include("FFI.jl")
include("API.jl")
include("Macros.jl")

end
