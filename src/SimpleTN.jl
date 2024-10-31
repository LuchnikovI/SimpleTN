module SimpleTN
    export Node, get_array, get_axis_names, change_id!, qr
    using LinearAlgebra
    include("./exceptions.jl")
    include("./node.jl")
    include("./tensorop.jl")
end
