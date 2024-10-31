@testset "Nodes Partitioning Test" begin
    arr = rand(1)
    node = Node(arr, :a)
    partitioned_node = node[]
    @test partitioned_node.lhs_axes == [:a]
    @test partitioned_node.rhs_axes == []
    @test partitioned_node.lhs_indices == [1]
    @test partitioned_node.rhs_indices == []
    @test partitioned_node.lhs_shape == [1]
    @test partitioned_node.rhs_shape == []
    arr = rand(1, 3, 2, 4)
    node = Node(arr, "1", 2, (3, 3), :a)
    partitioned_node = node[:a, "1", 2]
    @test partitioned_node.lhs_axes == [(3, 3)]
    @test partitioned_node.rhs_axes == [:a, "1", 2]
    @test partitioned_node.lhs_indices == [3]
    @test partitioned_node.rhs_indices == [4, 1, 2]
    @test partitioned_node.lhs_shape == [2]
    @test partitioned_node.rhs_shape == [4, 1, 3]
    arr = rand(1, 8, 6, 4, 5, 3, 7, 2)
    node = Node(arr, :a, :b, :c, :d, :e, :f, :h, :i)
    partitioned_node = node[:a, :h, :d, :f]
    @test partitioned_node.lhs_axes == [:b, :c, :e, :i]
    @test partitioned_node.rhs_axes == [:a, :h, :d, :f]
    @test partitioned_node.lhs_indices == [2, 3, 5, 8]
    @test partitioned_node.rhs_indices == [1, 7, 4, 6]
    @test partitioned_node.lhs_shape == [8, 6, 5, 2]
    @test partitioned_node.rhs_shape == [1, 7, 4, 3]
end