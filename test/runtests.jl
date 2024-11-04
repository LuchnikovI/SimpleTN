using Test
using SimpleTN
using TensorOperations
using LinearAlgebra

include("./construction.jl")
include("./partitioning.jl")
include("./contraction.jl")
include("./permutations.jl")
include("./change_id.jl")
include("./qr.jl")
include("./svd.jl")
include("./broadcast.jl")
include("./similar_identity.jl")
include("./identity_from_array_type.jl")
include("./merge_axes.jl")
include("./split_axis.jl")