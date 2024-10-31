@testset "Change ID Tests" begin
    arr = randn(4, 3, 3, 2)
    node = Node(arr, :a, "b", 3, (4,))
    change_id!(node, 3, 33)
    @test node.ids_to_idxs == [:a, "b", 33, (4,)]
    @test_throws SimpleTN.IDAlreadyExists change_id!(node, "b", :a)
    @test_throws SimpleTN.BadAxisID change_id!(node, "c", :c)
end