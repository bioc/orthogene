#' Gene expression data: mouse 
#' 
#' @description 
#' Mean pseudobulk single-cell RNA-seq gene expression matrix.
#' 
#' Data originally comes from Zeisel et al., 2018 (Cell).
#' 
#' @source \href{https://pubmed.ncbi.nlm.nih.gov/30096314/}{Publication}
#' \code{
#' ctd <- ewceData::ctd()
#' exp_mouse <- as(ctd[[1]]$mean_exp, "sparseMatrix")
#' usethis::use_data(exp_mouse, overwrite = TRUE)
#' }
#' @format sparse matrix
#' @usage data("exp_mouse")
"exp_mouse"
 

#' Reference organisms
#' 
#' @description 
#' Organism for which gene references are available via  
#' \href{https://biit.cs.ut.ee/gprofiler/gost}{gProfiler}  
#' \href{https://biit.cs.ut.ee/gprofiler/api/util/organisms_list}{API}. 
#' 
#' Used as a backup if API is not available. 
#' 
#' @source \href{https://biit.cs.ut.ee/gprofiler/gost}{gProfiler site}
#' @format \code{data.frame}
#' \code{
#'  gprofiler_orgs <- jsonlite::fromJSON('https://biit.cs.ut.ee/gprofiler/api/util/organisms_list')
#'  gprofiler_orgs <-  dplyr::arrange(gprofiler_orgs, scientific_name)
#'  usethis::use_data(gprofiler_orgs, overwrite = TRUE, internal=TRUE)
#' }
"gprofiler_orgs" 

