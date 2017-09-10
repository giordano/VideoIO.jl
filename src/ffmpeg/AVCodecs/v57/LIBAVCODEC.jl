include("libavcodec_h.jl")

include("avcodec.jl")
#include("avdct.jl")
#include("d3d11va.jl")
#include("dirac.jl")
#include("dv_profile.jl")
#include("qsv.jl")
#include("vaapi.jl")
#include("vdpau.jl")
#include("version.jl")
#include("videotoolbox.jl")
#include("vorbis_parser.jl")
#include("xvmc.jl")

function Base.unsafe_convert(::Type{Ptr{AVPicture}}, ptr::AVFramePtr)
    return reinterpret(Ptr{AVPicture}, ptr.p)
end
