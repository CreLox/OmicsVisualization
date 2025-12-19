FinalList <- list()
for (i in (15000002 : 15025476)) {
  EnsemblID <- paste0("ENSNFUG000", i)
  EntrezMapping <- EnsemblID2Entrez(EnsemblID, "Accession")
  if (length(EntrezMapping) > 1) {
    AmbiguousMapping <- list(EntrezMapping)
    names(AmbiguousMapping) <- EnsemblID
    FinalList <- c(FinalList, AmbiguousMapping)
  }
}

for (i in 1 : length(FinalList)) {
  cat(names(FinalList)[i])
  cat("\n")
}

for (i in names(FinalList)) {
  FinalList[[i]] <- sort(FinalList[[i]])
  if (length(FinalList[[i]]) == 2) {
    cat(paste0("[", i,"]","(https://www.ensembl.org/Nothobranchius_furzeri/Gene/Summary?g=",i,") | [",remove.LOC(FinalList[[i]][1])," | [",remove.LOC(FinalList[[i]][2]), collapse = ""))
    cat("\n")
  }
  else {
     cat(paste0("[", i,"]","(https://www.ensembl.org/Nothobranchius_furzeri/Gene/Summary?g=",i,") | [",remove.LOC(FinalList[[i]][1])," | [",remove.LOC(FinalList[[i]][2])," | [",remove.LOC(FinalList[[i]][3]), collapse = ""))
     cat("\n")
  }
}

remove.LOC <-function(string) {
  suppressPackageStartupMessages(library("rentrez"))
  suppressPackageStartupMessages(library("retry"))
  ID <- paste0(unlist(strsplit(string, split = "LOC")), collapse = "")
  retry({
          ConsoleOutput <- capture.output({
                             GeneSummary <- entrez_summary(db = "gene", id = ID)
                           });
          if (length(ConsoleOutput) != 0) {
            stop("Error")
          }
        }, when = ".*", silent = TRUE)
  if (GeneSummary$name == string) {
    return(paste0(ID ,"](https://www.ncbi.nlm.nih.gov/gene/", ID, ")<br>(", GeneSummary$description, ")", collapse = ""))
  }
  else {
    return(paste0(ID ,"](https://www.ncbi.nlm.nih.gov/gene/", ID, ")<br>(*", GeneSummary$name, "*: ", GeneSummary$description, ")", collapse = ""))
  }
}
