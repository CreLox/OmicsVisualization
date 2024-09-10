EnsemblID2EntrezAccession <- function(EnsemblID) {
  
  suppressPackageStartupMessages(library("rentrez"))
  suppressPackageStartupMessages(library("retry"))
  
  retry({
    EntrezSearchResult <-
    entrez_search(db = "gene", term = EnsemblID)
  }, when = "Error", silent = TRUE)
  
  return(paste("LOC", EntrezSearchResult$ids, sep = ""))
}
