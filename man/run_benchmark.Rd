% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_benchmark.R
\name{run_benchmark}
\alias{run_benchmark}
\title{Run benchmark tests}
\usage{
run_benchmark(
  species,
  method_list = c("homologene", "gprofiler", "babelgene"),
  run_convert_orthologs = TRUE,
  remove_failed_times = FALSE,
  save_path = tempfile(fileext = ".csv"),
  mc.cores = 1,
  verbose = TRUE
)
}
\arguments{
\item{species}{Species names.}

\item{run_convert_orthologs}{Benchmark
\link[orthogene]{convert_orthologs} function.}

\item{remove_failed_times}{In instances where
no genes were returned, set time to \code{NA}.}

\item{save_path}{Path to save results to.}

\item{mc.cores}{Number of cores to parallelise species across.}

\item{verbose}{Print messages.}

\item{benchmark_homologene}{Benchmark method "homologene".}

\item{benchmark_gprofiler}{Benchmark method "gprofiler".}

\item{benchmark_babelgene}{Benchmark method "babelgene".}
}
\value{
\code{data.table} with benchmark results
}
\description{
Runs benchmarks tests on \link[orthogene]{all_genes} and
 \link[orthogene]{convert_orthologs} across multiple species,
 using multiple methods ("homologene", and "gprofiler").
}
\keyword{internal}
