sparsity <- function(X) {
    sum(X == 0) / (dim(X)[1] * dim(X)[2])
}
