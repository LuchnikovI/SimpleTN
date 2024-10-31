@testset "Permutations Test" begin
    arr = randn(1, 2, 3, 4, 5, 6)
    node = Node(arr, :a, :b, :c, :d, :e, :f)
    permuted_arr = get_array(node, :c, :a, :d, :b, :f, :e)
    @test permutedims(arr, (3, 1, 4, 2, 6, 5)) ≈ permuted_arr atol=1e-12
end