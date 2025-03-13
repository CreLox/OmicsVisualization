FlaskiRenormalization <- function(Folder = getwd()) {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("stringr"))
  
  setwd(Folder)
  Count <- 0
  for (DataFile in list.files(pattern = "*.xlsx")) {
    NewDataFrame <- as.data.frame(read_xlsx(DataFile))
    Count <- Count + 1
    if (Count == 1) {
      MergedDataFrame <- NewDataFrame
    }
    else {
      MergedDataFrame <- merge(MergedDataFrame, NewDataFrame, by = "ensembl_gene_id")
    }
  }
  rownames(MergedDataFrame) <- MergedDataFrame$"ensembl_gene_id"
  MergedDataFrame <- MergedDataFrame[, (sapply(MergedDataFrame, class) == "numeric") &
                                       !str_detect(colnames(MergedDataFrame), pattern = "baseMean|lfcSE|fpkm|pvalue|padj|log|LOG")]
  
  ForFactorCalculation <- logical(nrow(MergedDataFrame))
  GeometricMean <- rep(NA, nrow(MergedDataFrame))
  for (i in 1 : nrow(MergedDataFrame)) {
    if (all(MergedDataFrame[i,] > 0)) {
      ForFactorCalculation[i] <- TRUE
      GeometricMean[i] <- exp(mean(log(as.numeric(MergedDataFrame[i,]))))
    }
  }
  ForFactorCalculationDataFrame <- MergedDataFrame[ForFactorCalculation,]
  GeometricMean <- GeometricMean[ForFactorCalculation]
  print(sprintf("The total number of genes when calculating factors for renormalization is %d", nrow(ForFactorCalculationDataFrame)))
  
  Factors <- rep(NA, ncol(ForFactorCalculationDataFrame))
  ForFactorCalculationDataFrame <- ForFactorCalculationDataFrame / GeometricMean
  for (i in 1 : ncol(ForFactorCalculationDataFrame)) {
    Factors[i] <- median(ForFactorCalculationDataFrame[, i])
  }
  MergedDataFrame <- t(t(MergedDataFrame) / Factors)
  print(Factors)
  
  return(MergedDataFrame)
}
