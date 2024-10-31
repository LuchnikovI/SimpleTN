struct BadAxisID <: Exception axis_id end

Base.show(io::IO, ex::BadAxisID) =
    print(io, "An axis with ID ", ex.axis_id, " does not exist")

struct RepeatedID <: Exception axis_id end

Base.show(io::IO, ex::RepeatedID) =
    print(io, "An axis with ID ", ex.axis_id, " is repeated at least twice")

struct ContractedIndicesMissMatch <: Exception
    lhs_indices_number::Int
    rhs_indices_number::Int
end

Base.show(io::IO, ex::ContractedIndicesMissMatch) =
    print(io, "Cannot contract ", ex.lhs_indices_number, "indices of the left tensor with ", ex.rhs_indices_number, " indices of the right one")

struct BadAxesNumber <: Exception
    axes_number::Int
    array_dim::Int
end

Base.show(io::IO, ex::BadAxesNumber) =
    print(io, "Dimension of the array is ", ex.array_dim, " while number of axes is ", ex.axes_number)

struct ContractedShapesMissMatch <: Exception
    lhs_shape::Tuple{Vararg{Int}}
    rhs_shape::Tuple{Vararg{Int}}
end

Base.show(io::IO, ex::ContractedShapesMissMatch) =
    print(io, "Shapes of contracted indices must be the same, got ", ex.lhs_shape, " and ", ex.rhs_shape)

struct ZeroDimensionalArray <: Exception end

Base.show(io::IO, ::ZeroDimensionalArray) =
    print(io, "Node must be at least one dimensional")

struct IDAlreadyExists <: Exception id end

Base.show(io::IO, ex::IDAlreadyExists) =
    print(io, "ID ", ex.id, " already exists")