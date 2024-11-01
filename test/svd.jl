@testset "SVD Test" begin
    arr = randn(2, 4, 2, 4, 3)
    node = Node(arr, :a, :b, :c, :d, :e)
    u, s, vh = svd(node[:b, :d], :free, 1e-9)
    res = (u .* s)[:free] * vh[:free]
    res_arr = get_array(res, :a, :b, :c, :d, :e)
    @test res_arr ≈ arr atol=1e-9
end