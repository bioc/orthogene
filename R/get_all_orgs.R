get_all_orgs <- function(method = c(
                                "gprofiler",
                                "homologene",
                                "babelgene"
                                    ),
                         use_local = TRUE, 
                         verbose = TRUE){
    taxon_id <- NULL;
    method <- tolower(method)[1]
    
    #### method: gprofiler ####
    if(method %in% methods_opts(gprofiler_opts = TRUE)){
        messager("Retrieving all organisms available in",
                 paste0(method,"."),v=verbose)
        orgs <- get_orgdb_gprofiler(
            use_local = use_local,
            verbose = verbose
        )
        orgs$source <- "gprofiler"
    #### method: homologene ####
    } else if(method %in% methods_opts(homologene_opts = TRUE)){
        messager("Retrieving all organisms available in",
                 paste0(method,"."),v=verbose)
        orgs <- taxa_id_dict(species = NULL, 
                             include_common_names = FALSE)
        orgs <- orgs[!duplicated(unname(orgs))] 
        orgs <- data.frame(scientific_name=names(orgs),
                           taxonomy_id=unname(orgs), 
                           source = "homologene",
                           check.rows = FALSE, 
                           check.names = FALSE)
    #### method: babelgene ####
    } else if(method %in% methods_opts(babelgene_opts = TRUE)){
        messager("Retrieving all organisms available in",
                 paste0(method,"."),v=verbose)
        requireNamespace("babelgene")
        orgs <- babelgene::species() |> 
            dplyr::rename(taxonomy_id=taxon_id)
        ### Add humans ###
        orgs <- rbind(orgs, data.frame(taxonomy_id=9606,
                                       scientific_name="Homo sapiens",
                                       common_name="human"))
    #### method: genomeinfodb ####
    } else if (tolower(method) == "genomeinfodb") {
        #### Load a really big organism reference ####
        orgs <- rbind(orgs, get_orgdb_genomeinfodbdata(verbose = verbose))
        orgs$source <- "genomeinfodb"
    #### Error ####
    } else {
        messager(paste0("method='",method,"'"),
                 "not recognized by get_all_orgs.",
                 "Defaulting to 'gprofiler'.")
        orgs <- get_orgdb_gprofiler(
            use_local = use_local,
            verbose = verbose
        )
        orgs$source <- "gprofiler"
    }
    ##### Add shortened id #####
    if(!"id" %in% colnames(orgs) && "scientific_name" %in% colnames(orgs)){
        orgs$id <- format_species(species = orgs$scientific_name,
                                       abbrev = TRUE, 
                                       lowercase = TRUE)
    }
    
    if("scientific_name" %in% names(orgs)){
        orgs$scientific_name_formatted <- 
            format_species(species = orgs$scientific_name, 
                                standardise_scientific = TRUE)
    } 
    return(orgs)
}
