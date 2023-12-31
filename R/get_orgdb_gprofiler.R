get_orgdb_gprofiler <- function(use_local,
                                verbose = TRUE) {

    # Avoid confusing Biocheck
    scientific_name <- NULL

    if (use_local) {
        messager("Using stored `gprofiler_orgs`.", v = verbose)
        orgs <- gprofiler_orgs
    } else {
        orgs <- tryCatch(
            {
                URL <- "https://biit.cs.ut.ee/gprofiler/api/util/organisms_list"
                orgs <- jsonlite::fromJSON(URL)
                dplyr::arrange(orgs, scientific_name)
            },
            error = function(e) {
                messager("Could not access gProfiler API.\n",
                    "Using stored `gprofiler_orgs`.",
                    v = verbose
                )
                gprofiler_orgs
            }
        )
    }
    return(orgs)
}
