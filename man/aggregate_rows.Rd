% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregate_rows.R
\name{aggregate_rows}
\alias{aggregate_rows}
\title{Aggregate rows of matrix}
\source{
\code{
data("exp_mouse_enst")
X <- exp_mouse_enst
gene_map <- map_genes(genes = rownames(X),species = "mouse")
X_agg <- orthogene:::aggregate_rows(X = X, 
                                    groupings = gene_map$name)
sum(duplicated(rownames(exp_mouse))) # 0 
sum(duplicated(rownames(X))) # 1215 
sum(duplicated(rownames(X_agg))) # 0 
}
}
\usage{
aggregate_rows(
  X,
  groupings,
  agg_fun = "sum",
  agg_method = c("monocle3", "stats"),
  as_sparse = TRUE,
  as_DelayedArray = TRUE,
  dropNA = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{X}{Input matrix.}

\item{groupings}{Gene groups of the same length as \code{nrow(X)}.}

\item{agg_fun}{Aggregation function.}

\item{agg_method}{Aggregation method.}

\item{as_sparse}{Convert aggregated matrix to sparse matrix.}

\item{as_DelayedArray}{Convert aggregated matrix to
\link[DelayedArray]{DelayedArray}.}

\item{dropNA}{Drop genes assigned to \code{NA} in \code{groupings}.}

\item{verbose}{Print messages.}
}
\value{
Aggregated matrix
}
\description{
Aggregate rows of a matrix for many:1 mappings,  using a grouping vector.
}
\keyword{internal}
