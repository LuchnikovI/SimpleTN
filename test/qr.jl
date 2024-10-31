@testset "QR Test" begin
    arr = randn(4, 2, 4, 2, 3)
    node = Node(arr, :a, :b, :c, :d, :e)
    q, r = qr(node[:d, :a], :q, :r)
    arr_res = get_array(q[:q] * r[:r], :a, :b, :c, :d, :e)
    @test arr ≈ arr_res atol=1e-12
    q = get_array(q, :e, :b, :c, :q)
    r = get_array(r, :r, :d, :a)
    fac = qr(reshape(permutedims(arr, (5, 2, 3, 4, 1)), 24, 8))
    q_res = reshape(Matrix(fac.Q), 3, 2, 4, :)
    r_res = reshape(Matrix(fac.R), :, 2, 4)
    @test abs.(r_res) ≈ abs.(r) atol=1e-10
    @test abs.(q_res) ≈ abs.(q) atol=1e-10
end