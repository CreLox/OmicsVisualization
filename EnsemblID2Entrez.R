EnsemblID2Entrez <- function(EnsemblID,
                             Output = "Description") {
  
  suppressPackageStartupMessages(library("rentrez"))
  suppressPackageStartupMessages(library("retry"))
  
  if (identical(EnsemblID, NA) || identical(EnsemblID, "") || (length(EnsemblID) == 0)) {
    return("")
  }
  if (length(EnsemblID) > 1) {
    return(BatchConvert2Entrez(EnsemblID, Output = Output))
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
