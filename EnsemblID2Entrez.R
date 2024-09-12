EnsemblID2Entrez <- function(EnsemblID,
                             Output = "Accession") {
  
  suppressPackageStartupMessages(library("rentrez"))
  suppressPackageStartupMessages(library("retry"))
  
  retry({
    EntrezSearchResult <-
    entrez_search(db = "gene", term = EnsemblID)
  }, when = "Error", silent = TRUE)
  
  if (is.null(unlist(EntrezSearchResult$ids))) {
    return("")
  }
  else {
    if (Output == "Accession") {
      return(paste("LOC", EntrezSearchResult$ids, sep = ""))
    }
    if (Output == "ID") {
      return(EntrezSearchResult$ids)
    }
    if (Output == "Description") {
      Result <- c()
      for (ID in EntrezSearchResult$ids) {
        Result <- c(Result, entrez_summary(db = "gene", id = ID)$description)
      }
      return(paste(unique(Result), collapse = "; "))
    }
  }
}
