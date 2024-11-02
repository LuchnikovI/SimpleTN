function check_uniqueness(ids)
    objs = Set()
    for id in ids
        if id in objs
            throw(RepeatedID(id))
        else
            push!(objs, id)
        end
    end
end

function ids_to_positions(ids_map::Vector, ids::Vector)
    map(x -> begin
        pos = findfirst(y -> y == x, ids_map)
        if isnothing(pos)
            throw(BadAxisID(x))
        else
            pos
        end
    end, ids)
end

struct Node{A<:AbstractArray}
    arr::A
    ids_to_idxs::Vector
    Node(::A, ids...) where {A<:AbstractArray{<:Any, 0}} = throw(ZeroDimensionalArray())
    function Node(arr::A, ids...) where {A<:AbstractArray}
        array_dim = ndims(arr)
        axes_number = length(ids)
        if axes_number != array_dim
            throw(BadAxesNumber(axes_number, array_dim))
        else
            check_uniqueness(ids)
            new{A}(arr, collect(ids))
        end
    end
end

function Base.show(io::IO, node::Node)
    shape = size(node.arr)
    ids = node.ids_to_idxs
    print(io, "Node(shape=", shape, ", axes=", ids, ", array_type=", typeof(node.arr), ")")
end

array_type(::Node{A}) where {A<:AbstractArray} = A
function change_id!(node::Node, old_id, new_id)
    if new_id in node.ids_to_idxs
        throw(IDAlreadyExists(new_id))
    else
        pos = findfirst(map(x -> x == old_id, node.ids_to_idxs))
        if isnothing(pos)
            throw(BadAxisID(old_id))
        else
            node.ids_to_idxs[pos] = new_id
        end
    end
end

function similar_identity(
    arr::AbstractArray,
    size::Int,
    lhs_id,
    rhs_id,
)
    new_arr = similar(arr, size, size)
    T = eltype(arr)
    for i in 1:size
        for j in 1:size
            ArrayInterface.allowed_setindex!(
                new_arr,
                i == j ? one(T) : zero(T),
                i,
                j,
            )
        end
    end
    Node(new_arr, lhs_id, rhs_id)
end

struct PartitionedNode{A<:AbstractArray}
    arr::A
    lhs_axes::Vector
    lhs_indices::Vector{Int}
    rhs_axes::Vector
    rhs_indices::Vector{Int}
    lhs_shape::Vector{Int}
    rhs_shape::Vector{Int}
    function PartitionedNode(node::Node, ids...)
        A = array_type(node)
        shape = size(node.arr)
        rhs_axes = collect(ids)
        lhs_axes = filter(x -> !(x in ids), node.ids_to_idxs)
        rhs_indices = ids_to_positions(node.ids_to_idxs, rhs_axes)
        lhs_indices = ids_to_positions(node.ids_to_idxs, lhs_axes)
        lhs_shape =[shape[i] for i in lhs_indices]
        rhs_shape =[shape[i] for i in rhs_indices]
        new{A}(node.arr, lhs_axes, lhs_indices, rhs_axes, rhs_indices, lhs_shape, rhs_shape)
    end
end

function get_array(node::Node, ids...)
    array_dim = ndims(node.arr)
    axes_number = length(ids)
    if axes_number != array_dim
        throw(BadAxesNumber(axes_number, array_dim))
    else
        check_uniqueness(ids)
        perms = ids_to_positions(node.ids_to_idxs, collect(ids))
        permutedims(node.arr, perms)
    end
end
get_array(node::Node) = node.arr
get_axis_names(node::Node) = deepcopy(node.ids_to_idxs)
function Base.getindex(node::Node, ids...)
    PartitionedNode(node, ids...)
end

Base.:*(lhs::PartitionedNode, rhs::PartitionedNode) = tensordot(lhs, rhs)
