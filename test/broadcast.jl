@testset "Broadcasting Test" begin
    arr1 = randn(4, 2, 4, 2, 3)
    node1 = Node(arr1, :a, :b, :c, :d, :e)
    arr2 = randn(2, 2)
    node2 = Node(arr2, :b, :d)
    arr3 = randn(2, 2)
    node3 = Node(arr3, :b, :f)
    res_node = node1 .+ node2 .+ node3
    res_arr = get_array(res_node, :a, :b, :c, :d, :e, :f)
    correct_arr = reshape(arr1, 4, 2, 4, 2, 3, 1) .+ reshape(arr2, 1, 2, 1, 2, 1, 1) .+ reshape(arr3, 1, 2, 1, 1, 1, 2)
    @test res_arr ≈ correct_arr atol=1e-12
    res_node_doubled1 = res_node .* 2
    res_node_doubled2 = 2 .* res_node
    @test 2 * correct_arr ≈ get_array(res_node_doubled1, :a, :b, :c, :d, :e, :f) atol=1e-12
    @test correct_arr * 2 ≈ get_array(res_node_doubled1, :a, :b, :c, :d, :e, :f) atol=1e-12
    @test norm(res_node) ≈ norm(correct_arr) atol=1e-12
end