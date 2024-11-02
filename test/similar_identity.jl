@testset "Similar Identity Tests" begin
    arr = Array{ComplexF64}(undef, 2, 1, 3)
    node = similar_identity(arr, 4, :lhs, :rhs)
    @test node.idxs_to_ids == [:lhs, :rhs]
    @test node.arr ≈ ComplexF64[1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1] atol = 1e-12
end