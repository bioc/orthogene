% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{exp_mouse_enst}
\alias{exp_mouse_enst}
\title{Transcript expression data: mouse}
\format{
sparse matrix
}
\source{
\href{https://pubmed.ncbi.nlm.nih.gov/30096314/}{Publication}
\code{
data("exp_mouse")
mapped_genes <- map_genes(genes = rownames(exp_mouse)[seq(1,100)],
                          target = "ENST",
                          species = "mouse",
                          drop_na = FALSE)
exp_mouse_enst <- exp_mouse[mapped_genes$input,]
rownames(exp_mouse_enst) <- mapped_genes$target
all_nas <- orthogene:::find_all_nas(rownames(exp_mouse_enst))
exp_mouse_enst <- exp_mouse_enst[!all_nas,]
exp_mouse_enst <- phenomix::add_noise(exp_mouse_enst)
usethis::use_data(exp_mouse_enst, overwrite = TRUE)
}
}
\usage{
data("exp_mouse_enst")
}
\description{
Mean pseudobulk single-cell RNA-seq Transcript expression matrix.

Data originally comes from Zeisel et al., 2018 (Cell).
}
\keyword{datasets}
