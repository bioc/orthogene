#' Map orthologs: babelgene
#'
#' Map orthologs from one species to another
#' using \link[babelgene]{orthologs}.
#'
#'
#' @param genes Gene list. 
#' @inheritParams convert_orthologs
#' @inheritParams babelgene::orthologs
#'
#' @source \href{https://cran.r-project.org/web/packages/babelgene/vignettes/babelgene-intro.html}{
#' babelgene tutorial}
#' @return Ortholog map \code{data.frame}
#' @importFrom babelgene orthologs species
#' @importFrom dplyr select
#' @keywords internal
map_orthologs_babelgene <- function(genes,
                                    input_species,
                                    output_species = "human",
                                    min_support = 1,
                                    top = FALSE,
                                    verbose = TRUE,
                                    ...) {
    # Avoid confusing checks
    human_symbol <- ensembl <- human_ensembl <- Gene.Symbol <- 
        taxonomy_id <- entrez <- support <- support_n <- NULL

    source_id <- map_species(
        species = input_species, 
        method = "babelgene",
        output_format = "scientific_name",
        verbose = verbose
    ) |> unname()
    target_id <- map_species(
        species = output_species, 
        method = "babelgene",
        output_format = "scientific_name",
        verbose = verbose
    ) |> unname()
    check_species_babelgene(
        source_id = source_id,
        target_id = target_id
    )
    if(source_id==target_id) return(NULL)
    #### Return input genes ####
    if (all(is_human(source_id), is_human(target_id))) {
        messager("input_species==output_species.",
            "Returning input genes.",
            v = verbose
        )
        gene_map <- data.frame(
            input_gene = genes,
            ortholog_gene = genes
        )
        return(gene_map)
    }
    #### Convert ####
    ## For some reason, this works far better than babelgene::orthologs(),
    ## even when  min_support=1.
    ## However, it can only be used for nonhuman:human mappings.
    if(is_human(source_id) | is_human(target_id)){
        ### Identify the non-human species ####
        mapping_species <- c(source_id,target_id)[
            c(!is_human(source_id), !is_human(target_id))
        ]
        gene_map <- all_genes_babelgene(species = mapping_species, 
                                        min_support = min_support,
                                        verbose = verbose) 
        if(is_human(source_id)){
            gene_map <- gene_map |> dplyr::select(
                input_gene = human_symbol,
                ortholog_gene = Gene.Symbol,
                input_geneID = human_ensembl,
                ortholog_geneID = ensembl,
                entrez,
                taxonomy_id,
                support,
                support_n
            ) 
        } else {
            gene_map <- gene_map |> dplyr::select(
                input_gene = Gene.Symbol,
                ortholog_gene = human_symbol,
                input_geneID = ensembl,
                ortholog_geneID = human_ensembl,
                entrez,
                taxonomy_id,
                support,
                support_n
            ) 
        }
    } else {
        stp <- paste(
            "babelgene cannot convert orthlogs",
            "between pairs of non-human species.",
            "Please set method to to one of the following instead:",
            paste("\n -",c("'homologene'","'gprofiler2"),collapse = ""))
        stop(stp)
    }
    return(gene_map)
}
