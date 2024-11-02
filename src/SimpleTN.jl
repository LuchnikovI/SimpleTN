module SimpleTN
    export Node, get_array, get_axis_names, change_id!, similar_identity
    using LinearAlgebra
    using ArrayInterface
    include("./exceptions.jl")
    include("./node.jl")
    include("./tensorop.jl")
    include("./broadcast.jl")
end
