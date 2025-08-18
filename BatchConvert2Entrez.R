BatchConvert2Entrez <- function(EnsemblID.Xsv,
                                X = "",
                                Output = "Description") {
  
  if ((length(X) == 0) || identical(X, NA) || identical(X, "")) {
    AllEnsemblIDs <- EnsemblID.Xsv
  }
  else {
    AllEnsemblIDs <- unlist(strsplit(EnsemblID.Xsv, split = X))
  }
  
  Out <- c()
  for (i in 1 : length(AllEnsemblIDs)) {
    Out <- c(Out, EnsemblID2Entrez(AllEnsemblIDs[i], Output = Output))
  }
  
  return(Out)
}
