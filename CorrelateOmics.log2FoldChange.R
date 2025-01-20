CorrelateOmics.log2FoldChange <- function(ProteomicsDataFilePath = "LFQ_quantification.xlsx",
                                          UniProtIDColumnName = "Protein IDs",
                                          To = "Ensembl",
                                          GeneNameColumnName = "Gene name",
                                          Proteomicslog2FoldChangeColumn = 9,
                                          TranscriptomicsDataFilePath = "Hu2020Rerun_group_non_diap_vs_diap.results.xlsx",
                                          EnsemblIDColumnName = "ensembl_gene_id",
                                          Transcriptomicslog2FoldChangeColumn = 12,
                                          RefreshGeneNames = TRUE) {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("retry"))
  suppressPackageStartupMessages(library("biomaRt"))
  biomartCacheClear()
  
  ProteomicsData <- as.data.frame(read_xlsx(ProteomicsDataFilePath))
  TranscriptomicsData <- as.data.frame(read_xlsx(TranscriptomicsDataFilePath))
  DataMatrix <- as.data.frame(matrix(data = NA, nrow = nrow(ProteomicsData), ncol = 3))
  colnames(DataMatrix) <- c("Transcriptomicslog2FoldChange", "Proteomicslog2FoldChange", "GeneName")
  
  All.UniProtKB.Entries <- c()
  for (i in 1 : nrow(ProteomicsData)) {
    All.UniProtKB.Entries <- c(All.UniProtKB.Entries, strsplit(ProteomicsData[i, UniProtIDColumnName], split = ";")[[1]])
  }
  Table <- UniProtKBAC2EnsemblID(paste(All.UniProtKB.Entries, collapse = ","), To = To)
  
  for (i in 1 : nrow(ProteomicsData)) {
    DataMatrix[i, "Proteomicslog2FoldChange"] <- as.numeric(ProteomicsData[i, Proteomicslog2FoldChangeColumn])
    DataMatrix[i, "GeneName"] <- ProteomicsData[i, GeneNameColumnName]
    UniProtKB.Entries <- strsplit(ProteomicsData[i, UniProtIDColumnName], split = ";")[[1]]
    EnsemblMapping <- Table[(Table[, "uniprotsptrembl"] %in% UniProtKB.Entries), "ensembl_gene_id"]
    if ((length(unique(EnsemblMapping)) == 1) && !is.na(unique(EnsemblMapping)) && (unique(EnsemblMapping) != "")) {
      EnsemblID <- unique(EnsemblMapping)
      rownames(DataMatrix)[i] <- EnsemblID
      if (EnsemblID %in% TranscriptomicsData[, EnsemblIDColumnName]) {
        DataMatrix[i, "Transcriptomicslog2FoldChange"] <- as.numeric(TranscriptomicsData[(TranscriptomicsData[, EnsemblIDColumnName] == EnsemblID), Transcriptomicslog2FoldChangeColumn])
      }
    }
  }
  DataMatrix <- DataMatrix[((!is.na(DataMatrix[, "Proteomicslog2FoldChange"])) & (!is.na(DataMatrix[, "Transcriptomicslog2FoldChange"]))),]
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
