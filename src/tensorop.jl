function tensordot(t1::AbstractArray, t2::AbstractArray, axes_number::Integer)
    shape1 = size(t1)
    indices_num1 = length(shape1)
    prefix1 = shape1[1:(indices_num1 - axes_number)]
    suffix1 = shape1[(indices_num1 - axes_number + 1):indices_num1]
    shape2 = size(t2)
    indices_num2 = length(shape2)
    prefix2 = shape2[1:axes_number]
    suffix2 = shape2[(axes_number + 1):indices_num2]
    if suffix1 != prefix2
        throw(ContractedShapesMissMatch(suffix1, prefix2))
    end
    new_shape = (prefix1..., suffix2...)
    lhs = reshape(t1, prod(prefix1), prod(suffix1))
    rhs = reshape(t2, prod(prefix2), prod(suffix2))
    reshape(lhs * rhs, new_shape)
end

function otimes(t1::AbstractArray, t2::AbstractArray)
    shape1 = size(t1)
    shape2 = size(t2)
    reshape(reshape(t1, (:, 1)) .* reshape(t2, (1, :)), (shape1..., shape2...))
end

function tensordot(t1::AbstractArray, t2::AbstractArray, axes1::Vector{Int}, axes2::Vector{Int})
    if length(axes1) == 0
        otimes(t1, t2)
    else
        new_order1 = [filter(x -> !(x in axes1), 1:length(size(t1))) ; axes1]
        new_order2 = [axes2 ; filter(x -> !(x in axes2), 1:length(size(t2)))]
        tensordot(permutedims(t1, new_order1), permutedims(t2, new_order2), length(axes1))
    end
end

function tensordot(lhs::PartitionedNode, rhs::PartitionedNode)
    lhs_contracted = lhs.rhs_indices
    rhs_contracted = rhs.rhs_indices
    lhs_dim = length(lhs_contracted)
    rhs_dim = length(rhs_contracted)
    if lhs_dim != rhs_dim
        throw(ContractedIndicesMissMatch(lhs_dim, rhs_dim))
    end
    new_arr = tensordot(lhs.arr, rhs.arr, lhs_contracted, rhs_contracted)
    Node(new_arr, (lhs.lhs_axes..., rhs.lhs_axes...)...)
end

function LinearAlgebra.qr(
    partitioned_node::PartitionedNode,
    free_index_id,
)
    arr = permutedims(partitioned_node.arr, (
        partitioned_node.lhs_indices...,
        partitioned_node.rhs_indices...,
    ))
    lhs_dim = prod(partitioned_node.lhs_shape)
    rhs_dim = prod(partitioned_node.rhs_shape)
    arr = reshape(arr, lhs_dim, rhs_dim)
    A = typeof(arr)
    fac = LinearAlgebra.qr(arr)
    q = reshape(A(fac.Q), (partitioned_node.lhs_shape..., :))
    r = reshape(A(fac.R), (:, partitioned_node.rhs_shape...))
    (
        Node(q, partitioned_node.lhs_axes..., free_index_id),
        Node(r, free_index_id, partitioned_node.rhs_axes...),
    )
end

find_rank(::AbstractArray{<:Any, 1}, ::Nothing) = current_rank
find_rank(s::AbstractArray{<:Any, 1}, rank::Integer) = min(length(s), rank)
function find_rank(s::AbstractArray{<:Number, 1}, eps::AbstractFloat)
    s_norm = norm(s)
    rank = length(s) - sum(sqrt.(cumsum(map(x -> (real(x) / s_norm)^2, reverse(s)))) .< eps)
    rank
end

function LinearAlgebra.svd(
    partitioned_node::PartitionedNode,
    free_index_id,
    rank_or_eps::Union{Nothing, AbstractFloat, Integer},
)
    arr = permutedims(partitioned_node.arr, (
        partitioned_node.lhs_indices...,
        partitioned_node.rhs_indices...,
    ))
    lhs_dim = prod(partitioned_node.lhs_shape)
    rhs_dim = prod(partitioned_node.rhs_shape)
    arr = reshape(arr, lhs_dim, rhs_dim)
    fac = LinearAlgebra.svd(arr)
    rank = find_rank(fac.S, rank_or_eps)
    u = reshape(fac.U[:, 1:rank], (partitioned_node.lhs_shape..., :))
    s = fac.S[1:rank]
    vt = reshape(fac.Vt[1:rank, :], (:, partitioned_node.rhs_shape...))
    (
        Node(u, partitioned_node.lhs_axes..., free_index_id),
        Node(s, free_index_id),
        Node(vt, free_index_id, partitioned_node.rhs_axes...),
    )
end
