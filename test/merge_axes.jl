@testset "Merge Axes Test" begin
    arr = randn(2, 3, 4, 2, 3, 3)
    node = Node(arr, :a, :b, :c, :d, :e, :f)
    res_node = merge_axes(node, :merged, :a, :f, :c)
    res_arr = get_array(res_node, :b, :d, :e, :merged)
    correct_res_arr = reshape(permutedims(arr, (2, 4, 5, 1, 6, 3)), 3, 2, 3, 24)
    @test res_arr ≈ correct_res_arr atol=1e-12
end