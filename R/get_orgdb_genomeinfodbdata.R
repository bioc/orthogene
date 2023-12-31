#' Import organism database: GenomeInfoDbData
#'
#' Import and format organism ID table from
#' \pkg{GenomeInfoDbData} to
#' be comparable to \code{get_orgdb_gprofiler}.
#'
#' @source
#' \href{https://github.com/Bioconductor/GenomeInfoDbData/blob/master/data/specData.rda}{
#' GenomeInfoDbData GitHub}
#' @return Organisms \code{data.table}
#'
#' @importFrom data.table data.table setnames :=
#' @importFrom utils data
#' @keywords internal
get_orgdb_genomeinfodbdata <- function(verbose = TRUE) {
    # Avoid confusing biocheck
    scientific_name <- display_name <- genus <- NULL
    species <- id <- version <- ..keep_cols <- NULL

    messager("Preparing organisms reference from: GenomeInfoDb", v = verbose)
    requireNamespace("GenomeInfoDbData")
    utils::data("specData")
    #### Remove NAs ####
    no_no_list <- c("environmental", "unclassified", NA)
    specData <- specData[(!genus %in% no_no_list) &
        (!species %in% no_no_list)]
    specData[, display_name := paste(genus, gsub("[(].*", "", species))]
    specData[, scientific_name := format_species(display_name,
        replace_char = "_"
    )]
    specData[, id := format_species(scientific_name,
        abbrev = TRUE,
        split_char = "_", lowercase = TRUE
    )]
    specData[, version := NA]
    data.table::setnames(specData, "tax_id", "taxonomy_id")
    keep_cols <- c(
        "display_name", "id",
        "scientific_name", "taxonomy_id", "version"
    )
    specData <- unique(specData[, ..keep_cols])
    return(specData)
}
