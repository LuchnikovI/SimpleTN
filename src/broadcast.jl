function get_all_ids(nodes::Node...)
    all_ids = Set()
    for node in nodes
        for id in node.ids_to_idxs
            push!(all_ids, id)
        end
    end
    collect(all_ids)
end

function broadcast_node(node::Node, all_ids::Vector)
    extension_ids = filter(x -> !(x in node.ids_to_idxs), all_ids)
    extension_size = length(extension_ids)
    extension_shape = (1 for _ in 1:extension_size)
    old_shape = size(node.arr)
    new_ids_to_idxs = [node.ids_to_idxs ; extension_ids]
    new_arr = reshape(node.arr, (old_shape..., extension_shape...))
    perms = ids_to_positions(new_ids_to_idxs, all_ids)
    new_arr = permutedims(new_arr, perms)
    new_arr
end

function Base.Broadcast.broadcasted(f, nodes::Node...)
    all_ids = get_all_ids(nodes...)
    new_arr = Base.Broadcast.broadcast(f, map(x -> broadcast_node(x, all_ids), collect(nodes))...)
    Node(new_arr, all_ids...)
end