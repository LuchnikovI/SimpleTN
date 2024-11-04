@testset "Split Axis Test" begin
    arr = randn(2, 3, 12, 2)
    node = Node(arr, :a, :b, :c, :d)
    res_node = split_axis(node, :c, (:c1, 2), (:c2, 3), (:c3, 2))
    res_arr = get_array(res_node, :c1, :c3, :c2, :a, :b, :d)
    correct_res_arr = permutedims(reshape(arr, (2, 3, 2, 3, 2, 2)), (3, 5, 4, 1, 2, 6))
    @test res_arr ≈ correct_res_arr atol=1e-12
end