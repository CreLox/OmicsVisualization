EnsemblID2Entrez <- function(EnsemblID,
                             Output = "Accession") {
  
  suppressPackageStartupMessages(library("rentrez"))
  suppressPackageStartupMessages(library("retry"))
  
  if (is.na(EnsemblID) || is.null(EnsemblID) || (EnsemblID == "") || (length(EnsemblID) == 0)) {
    return("")
  }
  retry({
    ConsoleOutput <- capture.output({
                       EntrezSearchResult <- entrez_search(db = "gene", term = EnsemblID)
                     });
    if (length(ConsoleOutput) != 0) {
      stop("Error")
    }
  }, when = ".*", silent = TRUE)
  
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
          ConsoleOutput <- capture.output({
                             GeneSummary <- entrez_summary(db = "gene", id = ID)
                           });
          if (length(ConsoleOutput) != 0) {
            stop("Error")
          }
        }, when = ".*", silent = TRUE)
        Result <- c(Result, GeneSummary$description)
      }
      return(paste(unique(Result), collapse = "; "))
    }
    if (Output == "Name") {
      Result <- c()
      for (ID in EntrezSearchResult$ids) {
        retry({
          ConsoleOutput <- capture.output({
                             GeneSummary <- entrez_summary(db = "gene", id = ID)
                           });
          if (length(ConsoleOutput) != 0) {
            stop("Error")
          }
        }, when = ".*", silent = TRUE)
        Result <- c(Result, GeneSummary$name)
      }
      return(paste(unique(Result), collapse = "; "))
    }
  }
}
