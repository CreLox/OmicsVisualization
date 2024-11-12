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
        retry({
          GeneSummary <- entrez_summary(db = "gene", id = ID)
        }, when = "Error", silent = TRUE)
        Result <- c(Result, GeneSummary$description)
      }
      return(paste(unique(Result), collapse = "; "))
    }
    if (Output == "Name") {
      Result <- c()
      for (ID in EntrezSearchResult$ids) {
        retry({
          GeneSummary <- entrez_summary(db = "gene", id = ID)
        }, when = "Error", silent = TRUE)
        Result <- c(Result, GeneSummary$name)
      }
      return(paste(unique(Result), collapse = "; "))
    }
  }
}
