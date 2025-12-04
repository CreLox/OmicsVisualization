CompileGOList.FromQuickGOAnnotations <- function(ExportTSVFilePath,
                                                 ExistingGOList = list(),
                                                 UniProtKBACColumnName = "GENE.PRODUCT.ID",
                                                 To = "Ensembl",
                                                 GOColumnName = "GO.TERM") {
  
  QuickGOAnnotationsTable <- read.table(ExportTSVFilePath, header = TRUE, sep = "\t", na.strings = "", quote = "")
  if (nrow(QuickGOAnnotationsTable) == 0) {
    return(ExistingGOList)
  }
  
  MappingTable <- UniProtKBAC2EnsemblID(paste0(QuickGOAnnotationsTable[, UniProtKBACColumnName], collapse = ","), To = To)
  QuickGOAnnotationsTable[, "EnsemblID"] <- rep(NA, nrow(QuickGOAnnotationsTable))
  for (i in 1 : nrow(QuickGOAnnotationsTable)) {
    UniProtKBAC <- QuickGOAnnotationsTable[i, UniProtKBACColumnName]
    EnsemblMapping <- unique(MappingTable[(MappingTable[, "uniprotsptrembl"] == UniProtKBAC), "ensembl_gene_id"])
    QuickGOAnnotationsTable[i, "EnsemblID"] <- paste0(EnsemblMapping, collapse = ";")
  }
  
  for (i in 1 : nrow(QuickGOAnnotationsTable)) {
    for (j in unlist(strsplit(QuickGOAnnotationsTable[i, "EnsemblID"], split = ";"))) {
      if (j %in% names(ExistingGOList)) {
        ExistingGOList[[j]] <- unique(c(ExistingGOList[[j]], QuickGOAnnotationsTable[i, GOColumnName]))
      }
      else {
        ExistingGOList[[j]] <- QuickGOAnnotationsTable[i, GOColumnName]
      }
    }
  }
  
  return(ExistingGOList)
}
