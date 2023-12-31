#' Check gene_df
#'
#' Handles gene_df regardless of whether it's a
#' data.frame, matrix, list, or vector
#'
#' @inheritParams convert_orthologs
#'
#' @return List of gene_df and gene_input
#' @importFrom methods is
#' @keywords internal
check_gene_df_type <- function(gene_df,
                               gene_input,
                               verbose = TRUE) {
    messager("Preparing gene_df.", v = verbose)
    if (is_delayed_array(gene_df)) {
        messager("DelayedArray format detected.", v = verbose)
    } else if (is_sparse_matrix(gene_df)) {
        messager("sparseMatrix format detected.", v = verbose)
    } else if (is(gene_df, "matrix") |
               is(gene_df, "Matrix")) {
        messager("Dense matrix format detected.",
            v = verbose
        )
    } else if (is(gene_df, "data.frame") |
        is(gene_df, "data.table") |
        is(gene_df, "tibble")) {
        messager(is(gene_df)[1], "format detected.", v = verbose)
        if (!is(gene_df, "data.frame")) {
            # data.tables, tibbles, etc have too many idiosyncrasies
            # standardise them here.
            messager("Converting to data.frame", v = verbose)
        }
        gene_df <- data.frame(gene_df,
            check.names = FALSE,
            stringsAsFactors = FALSE
        )
    } else if (is(gene_df, "character") |
               is(gene_df, "vector") |
               is(gene_df, "list")) {
        messager(is(gene_df)[1], "format detected.", v = verbose)
        messager("Converting to data.frame", v = verbose)
        gene_df <- data.frame(
            ## Extra index col prevents df from accidentally
            ## turning into vector again later.
            index = seq(1,length(gene_df)), 
            input_gene = unlist(unname(gene_df)),
            row.names = unlist(unname(gene_df)),
            check.names = FALSE,
            stringsAsFactors = FALSE
        )
        gene_input <- "input_gene"
    } else {
        stop_msg <- paste0(
            "gene_df class not recognised: ", is(gene_df)[1], "\n",
            "Must be one of:\n",
            paste0("  - sparseMatrix / dg[CRT]Matrix \n",
                "  - data.frame / data.table / tibble \n",
                "  - character / vector / list \n",
                sep = "\n"
            )
        )
        stop(stop_msg)
    }
    #### Return ####
    return(list(
        gene_df = gene_df,
        gene_input = gene_input
    ))
}
