% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_gene_df_type.R
\name{check_gene_df_type}
\alias{check_gene_df_type}
\title{Check gene_df}
\usage{
check_gene_df_type(gene_df, gene_input, verbose = TRUE)
}
\arguments{
\item{gene_df}{Data object containing the genes
(see \code{gene_input} for options on how
the genes can be stored within the object).\cr
Can be one of the following formats:\cr
\itemize{
\item{\code{matrix} : \cr}{A sparse or dense matrix.}
\item{\code{data.frame} : \cr}{A \code{data.frame},
 \code{data.table}. or \code{tibble}.}
\item{code{list} : \cr}{A \code{list} or character \code{vector}.}
}
Genes, transcripts, proteins, SNPs, or genomic ranges
 can be provided in any format
(HGNC, Ensembl, RefSeq, UniProt, etc.) and will be
automatically converted to gene symbols unless
specified otherwise with the \code{...} arguments.\cr
\emph{Note}: If you set \code{method="homologene"}, you
must either supply genes in gene symbol format (e.g. "Sox2")
 OR set \code{standardise_genes=TRUE}.}

\item{gene_input}{Which aspect of \code{gene_df} to
get gene names from:\cr
\itemize{
\item{\code{"rownames"} : \cr}{From row names of data.frame/matrix.}
\item{\code{"colnames"} : \cr}{From column names of data.frame/matrix.}
\item{\code{<column name>} : \cr}{From a column in \code{gene_df},
 e.g. \code{"gene_names"}.}
}}

\item{verbose}{Print messages.}
}
\value{
List of gene_df and gene_input
}
\description{
Handles gene_df regardless of whether it's a
data.frame, matrix, list, or vector
}
\keyword{internal}
