#' Standardise species names
#' 
#' Search \code{gprofiler} database for species 
#' that match the input text string.
#' Then translate to a standardised species ID.
#' 
#' @param species Species query 
#' (e.g. "human", "homo sapiens", "hapiens", or 9606).
#' If given a list, will iterate queries for each item. 
#' Set to \code{NULL} to return all species. 
#' @param search_cols Which columns to search for 
#' \code{species} substring in
#' metadata \href{https://biit.cs.ut.ee/gprofiler/api/util/organisms_list}{API}. 
#' @param output_format Which column to return. 
#' @param verbose Print messages. 
#' 
#' @return Species ID of type \code{output_format}
#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr %>% arrange filter_at any_vars
#' @examples 
#' ids <- map_species(species= c("human",9606,"mus musculus","fly","C elegans")) 
map_species <- function(species=NULL,
                        search_cols = c("display_name","id",
                                        "scientific_name",
                                        "taxonomy_id"),
                        output_format=c("id",
                                        "display_name",
                                        "scientific_name",
                                        "taxonomy_id",
                                        "version"),
                        verbose=TRUE){ 
  
  ## Avoid confusing Biocheck
  scientific_name <- . <- NULL
  
  #### Ensure only one output_format ####
  output_format <- output_format[1]
  #### Load organism reference ####
  orgs <- tryCatch({
    orgs <- jsonlite::fromJSON('https://biit.cs.ut.ee/gprofiler/api/util/organisms_list')
    dplyr::arrange(orgs, scientific_name) 
  }, 
  error=function(e){
    messager("Could not access gProfiler API.\nUsing stored `gprofiler_orgs`.",v=verbose)
    gprofiler_orgs
  })
  #### Return all species as an option ####
  if(is.null(species)){
    messager("Returning table with all species.",v=verbose)
    return(orgs)
  } 
  
  if(!output_format %in% colnames(orgs)){
    cols <- paste0("   - '",colnames(orgs),"'",collapse = "\n")
    stop("output_format must be one of:\n",cols)
  }
  
  ### Iterate over multiple queries ####
  species_results <- lapply(species, function(spec){
    messager("Mapping species name:",spec,v=verbose)
    #### Map common species names ####
    spec <- common_species_names_dict(species = spec,
                                      verbose = verbose)
    #### Query multiple columns ####
    mod_spec <- gsub(" |[.]|[-]","",unname(spec))
    orgs_sub <- orgs %>% 
      dplyr::filter_at(.vars = search_cols, 
                       .vars_predicate = dplyr::any_vars(grepl(paste(unname(spec),mod_spec,sep="|"),.,
                                                               ignore.case = TRUE))) 
    if(nrow(orgs_sub)>0){
      if(nrow(orgs_sub)>1){
        messager(nrow(orgs_sub), "organisms identified from search.\nSelecting first:\n", 
                 paste("  -",orgs_sub$scientific_name, collapse = "\n "),v=verbose) 
        orgs_sub <- orgs_sub[1,]
      }else {
        messager(nrow(orgs_sub), "organism identified from search:",orgs_sub$scientific_name,v=verbose) 
        orgs_sub <- orgs_sub[1,]
      }
      return(orgs_sub[[output_format]]) 
    } else {
      messager("WARNING: No organisms identified matched ",paste0("'",spec,"'"),
               "Try a different query.",
               v=verbose)
      return(NULL)
    } 
  }) %>% `names<-`(species)
 return(unlist(species_results))
}