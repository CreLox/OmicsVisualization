AppendEnsemblIDColumn <- function(ProteomicsDataFilePath = "LFQ_intensities.xlsx",
                                   OutputDataFilePath = "Out.xlsx",
                                   UniProtIDColumnName = "Protein IDs",
                                   To = "Ensembl") {
  
  suppressPackageStartupMessages(library("readxl"))
  suppressPackageStartupMessages(library("writexl"))
  
  ProteomicsData <- as.data.frame(read_xlsx(ProteomicsDataFilePath))  
  All.UniProtKB.Entries <- c()
  for (i in 1 : nrow(ProteomicsData)) {
    All.UniProtKB.Entries <- c(All.UniProtKB.Entries, strsplit(ProteomicsData[i, UniProtIDColumnName], split = ";")[[1]])
  }
  Table <- UniProtKBAC2EnsemblID(paste(All.UniProtKB.Entries, collapse = ","), To = To)
  
  ProteomicsData[, "EnsemblID"] <- rep(NA, nrow(ProteomicsData))
  for (i in 1 : nrow(ProteomicsData)) {
    UniProtKB.Entries <- strsplit(ProteomicsData[i, UniProtIDColumnName], split = ";")[[1]]
    EnsemblMapping <- unique(Table[(Table[, "uniprotsptrembl"] %in% UniProtKB.Entries), "ensembl_gene_id"])
    ProteomicsData[i, "EnsemblID"] <- paste(EnsemblMapping, collapse = ";")
  }
  
  write_xlsx(ProteomicsData, OutputDataFilePath)
}
