@testset "Node Construction Tests" begin
    arr = Array{Float32, 0}(undef)
    @test_throws SimpleTN.ZeroDimensionalArray Node(arr)
    arr = rand(1, 2, 3)
    node = Node(arr, "1", 2, (3, 3))
    @test shape(node) == Dict((3, 3) => 3, "1" => 1, 2 => 2)
    @test_throws SimpleTN.BadAxesNumber Node(arr, "1", 2, 3, (4,))
    @test_throws SimpleTN.RepeatedID Node(arr, "1", "1", 3)
end