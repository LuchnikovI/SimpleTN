@testset "Identity From Array Type Tests" begin
    iden = identity_from_array_type(Array{Int, 8}, 3, :lhs, :rhs)
    @test iden == Node(Int[1 0 0 ; 0 1 0 ; 0 0 1], :lhs, :rhs)
end