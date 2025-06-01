BatchConvert2Entrez <- function(EnsemblID.Xsv,
                                X = ";",
                                Output = "Name") {
  
  AllEnsemblIDs <- unlist(strsplit(EnsemblID.Xsv, split = X))
  
  Out <- c()
  for (i in 1 : length(AllEnsemblIDs)) {
    Out <- c(Out, EnsemblID2Entrez(AllEnsemblIDs[i], Output = Output))
  }
  
  return(Out)
}
