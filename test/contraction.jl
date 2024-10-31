@testset "Nodes Contraction Test" begin
    arr1 = randn(2, 3, 4)
    arr2 = randn(3, 2)
    arr3 = randn(2, 2, 4)
    node1 = Node(arr1, 1, 2, :free1)
    node2 = Node(arr2, 2, 3)
    node3 = Node(arr3, 3, 1, :free2)
    contracted = node3[3, 1] * (node1[2] * node2[2])[3, 1]
    @tensor res_arr_to[m, k] := arr1[i, j, k] * arr2[j, l] * arr3[l, i, m]
    res_arr = get_array(contracted, :free2, :free1)
    @test res_arr ≈ res_arr_to atol=1e-12
    arr1 = randn(2, 3, 3)
    arr2 = randn(2, 4, 3)
    arr3 = randn(4, 3, 3, 2)
    arr4 = randn(3, 3, 4)
    node1 = Node(arr1, 1, 2, 3)
    node2 = Node(arr2, 1, 4, :free1)
    node3 = Node(arr3, 4, 2, 5, :free2)
    node4 = Node(arr4, 5, 3, :free3)
    contracted = ((node2[1] * node1[1])[2, 4] * node3[2, 4])[5, 3] * node4[5, 3]
    res_arr = get_array(contracted, :free2, :free3, :free1)
    @tensor res_arr_to[o, p, m] := arr1[i, j, k] * arr2[i, l, m] * arr3[l, j, n, o] * arr4[n, k, p]
    @test res_arr ≈ res_arr_to atol=1e-12
end