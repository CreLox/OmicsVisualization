CorrelateOmics <- function(ProteomicsDataFilePath = "LFQ_intensities.xlsx",
                           UniProtIDColumnName = "Protein IDs",
                           GeneNameColumnName = "Gene name",
                           ProteomicsColumnsToCalculateMean = 2 : 5,
                           TranscriptomicsDataFilePath = "Hu2020Rerun_group_non_diap_vs_diap.results.xlsx",
                           TranscriptomicsColumnsToCalculateMean = 3 : 7,
                           RefreshGeneNames = TRUE) {
  
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
  Table <- UniProtKBAC2EnsemblID(paste(All.UniProtKB.Entries, collapse = ","))
  # dataset <- "nfurzeri_gene_ensembl"
  # retry({
  #   Table <-
  #   getBM(attributes = c("ensembl_gene_id", "uniprotsptrembl"),
  #         filters = "uniprotsptrembl", values = paste(All.UniProtKB.Entries, collapse = ","),
  #         mart = useEnsembl(biomart = "ensembl", dataset = dataset))
  # }, when = "Error", silent = TRUE)
  
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
  Counts <- as.data.frame(table(rownames(DataMatrix)))
  ToBeRemovedEnsemblIDs <- as.character(Counts[Counts$Freq > 1, 1])
  DataMatrix <- DataMatrix[!(rownames(DataMatrix) %in% ToBeRemovedEnsemblIDs),]
  
  if (RefreshGeneNames) {
    EnsemblIDs <- rownames(DataMatrix)
    DataMatrix$CurrentEntrezGeneName <- rep(NA, nrow(DataMatrix))
    for (i in 1 : nrow(DataMatrix)) {
      DataMatrix[i, "CurrentEntrezGeneName"] <- EnsemblID2Entrez(EnsemblIDs[i], Output = "Name")
    }
  }
  
  return(DataMatrix)
}

Alt.ln <- function(x) {
  return(log(x + 1))
}
