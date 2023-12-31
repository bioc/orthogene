#' Add gene synonyms
#'
#' Add gene synonyms back into \code{gene_map}
#' \code{data.frame}.
#'
#' \code{gene_map} is the output of
#' \link[orthogene]{convert_orthologs}.
#'
#' @return \code{gene_map} \code{data.frame}
#' @importFrom dplyr rename mutate
#' @importFrom stats setNames
#' @keywords internal
add_synonyms <- function(gene_map,
                         syn_map) {

    ## Avoid confusing Biocheck
    input_gene <- NULL;
    
    if(is.null(syn_map)) return(gene_map)
    gene_map <- dplyr::rename(gene_map, input_gene_standard = input_gene)
    syn_dict <- setNames(syn_map$input, syn_map$name)
    gene_map <- dplyr::mutate(gene_map,
        input_gene = syn_dict[gene_map$input_gene_standard],
        .before = 1
    )
    return(gene_map)
}
