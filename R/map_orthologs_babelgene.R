#' Map orthologs: babelgene
#'
#' Map orthologs from one species to another
#' using \link[babelgene]{orthologs}.
#'
#'
#' @param genes Gene list.
#' @param ... Additional arguments passed
#' to \link[babelgene]{orthologs}.
#' @inheritParams convert_orthologs
#' @inheritParams babelgene::orthologs
#'
#' @source \href{https://cran.r-project.org/web/packages/babelgene/vignettes/babelgene-intro.html}{
#' babelgene tutorial}
#' @return Ortholog map \code{data.frame}
#' @importFrom babelgene orthologs species
#' @importFrom dplyr %>% select
#' @keywords internal
map_orthologs_babelgene <- function(genes,
                                    input_species,
                                    output_species = "human",
                                    verbose = TRUE,
                                    ...) {
    # Avoid confusing checks
    symbol <- human_symbol <- ensembl <- human_ensembl <-
        entrez <- taxon_id <- support <- support_n <- NULL

    source_id <- map_species(
        species = input_species,
        output_format = "scientific_name",
        verbose = verbose
    )
    target_id <- map_species(
        species = output_species,
        output_format = "scientific_name",
        verbose = verbose
    )
    check_species_babelgene(
        source_id = source_id,
        target_id = target_id
    )
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
    gene_map <- babelgene::orthologs(
        genes = genes,
        species = if (is_human(target_id)) source_id else target_id,
        human = is_human(source_id),
        ...
    )

    #### non-human ==> human ####
    if ((!is_human(source_id)) & (is_human(target_id))) {
        gene_map <- gene_map %>% dplyr::select(
            input_gene = symbol,
            ortholog_gene = human_symbol,
            input_geneID = ensembl,
            ortholog_geneID = human_ensembl,
            entrez,
            taxon_id,
            support,
            support_n
        )
    }
    #### Human ==> non-human ####
    if ((is_human(source_id)) & (!is_human(target_id))) {
        gene_map <- gene_map %>% dplyr::select(
            input_gene = human_symbol,
            ortholog_gene = symbol,
            input_geneID = human_ensembl,
            ortholog_geneID = ensembl,
            entrez,
            taxon_id,
            support,
            support_n
        )
    }
    return(gene_map)
}