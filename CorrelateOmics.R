CorrelateOmics <- function(ProteomicsDataFilePath = "LFQ_intensities.xlsx",
                           UniProtIDColumnName = "Protein IDs",
                           GeneNameColumnName = "Gene name",
                           ProteomicsColumnsToCalculateMean = 2 : 5,
                           TranscriptomicsDataFilePath = "Reichwald2015Rerun_group_non_diap_vs_diap.results.xlsx",
                           TranscriptomicsColumnsToCalculateMean = 3 : 7,
                           dataset = "nfurzeri_gene_ensembl") {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("retry"))
  suppressPackageStartupMessages(library("biomaRt"))
  biomartCacheClear()
  
  ProteomicsData <- as.data.frame(read_xlsx(ProteomicsDataFilePath))
  TranscriptomicsData <- as.data.frame(read_xlsx(TranscriptomicsDataFilePath))
  DataMatrix <- as.data.frame(matrix(data = NA, nrow = nrow(ProteomicsData), ncol = 5))
  colnames(DataMatrix) <- c("logTranscriptomicsMean", "logTranscriptomicsStdev", "logProteomicsMean", "logProteomicsStdev", "GeneName")
  rownames(DataMatrix) <- 1 : nrow(ProteomicsData)
  
  All.UniProtKB.Entries <- c()
  for (i in 1 : nrow(ProteomicsData)) {
    All.UniProtKB.Entries <- c(All.UniProtKB.Entries, strsplit(ProteomicsData[i, UniProtIDColumnName], split = ";")[[1]])
  }
  retry({
    Table <-
    getBM(attributes = c("ensembl_gene_id", "uniprotsptrembl"),
          filters = "uniprotsptrembl", values = paste(All.UniProtKB.Entries, collapse = ","),
          mart = useEnsembl(biomart = "ensembl", dataset = dataset))
  }, when = "Error", silent = TRUE)
  
  for (i in 1 : nrow(ProteomicsData)) {
    DataMatrix[i, "logProteomicsMean"] <- Alt.ln(mean(2 ^ (as.numeric(ProteomicsData[i, ProteomicsColumnsToCalculateMean]))))
    DataMatrix[i, "logProteomicsStdev"] <- Alt.ln(sd(2 ^ (as.numeric(ProteomicsData[i, ProteomicsColumnsToCalculateMean]))))
    DataMatrix[i, "GeneName"] <- ProteomicsData[i, GeneNameColumnName]
    UniProtKB.Entries <- strsplit(ProteomicsData[i, UniProtIDColumnName], split = ";")[[1]]
    EnsemblMapping <- Table[(Table[, "uniprotsptrembl"] %in% UniProtKB.Entries), "ensembl_gene_id"]
    if (length(unique(EnsemblMapping)) == 1) {
      EnsemblID <- unique(EnsemblMapping)
      rownames(DataMatrix)[i] <- EnsemblID
      if (EnsemblID %in% TranscriptomicsData[, "ensembl_gene_id"]) {
        DataMatrix[i, "logTranscriptomicsMean"] <- Alt.ln(mean(as.numeric(TranscriptomicsData[(TranscriptomicsData[, "ensembl_gene_id"] == EnsemblID), TranscriptomicsColumnsToCalculateMean])))
        DataMatrix[i, "logTranscriptomicsStdev"] <- Alt.ln(sd(as.numeric(TranscriptomicsData[(TranscriptomicsData[, "ensembl_gene_id"] == EnsemblID), TranscriptomicsColumnsToCalculateMean])))
      }
    }
  }
  
  DataMatrix <- DataMatrix[((!is.na(DataMatrix[, "logProteomicsMean"])) & (!is.na(DataMatrix[, "logTranscriptomicsMean"]))),]
  return(DataMatrix)
}

Alt.ln <- function(x) {
  return(log(x + 1))
  # OR:
  # if (x < 1) {
  #   return(x - 1)
  # }
  # else {
  #   return(log(x))
  # }
}
