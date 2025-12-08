CompileGOList.FromQuickGOAnnotations <- function(ExportedTSVFilePath,
                                                 ExistingGOList = list(),
                                                 UniProtKBACColumnName = "GENE.PRODUCT.ID",
                                                 To = "Ensembl",
                                                 GOColumnName = "GO.TERM",
                                                 IgnoreUnreliableGOAnnotationPipelines = FALSE,
                                                 ReferenceColumnName = "REFERENCE",
                                                 IgnoredReferenceCodes = c("GO_REF:0000002", "GO_REF:0000108", "GO_REF:0000118")) {
  
  QuickGOAnnotationsTable <- read.table(ExportedTSVFilePath, header = TRUE, sep = "\t", na.strings = "", quote = "")
  if (nrow(QuickGOAnnotationsTable) == 0) {
    return(ExistingGOList)
  }
  if (IgnoreUnreliableGOAnnotationPipelines) {
    QuickGOAnnotationsTable <- QuickGOAnnotationsTable[!(QuickGOAnnotationsTable[, ReferenceColumnName] %in% IgnoredReferenceCodes),]
  }
  
  MappingTable <- UniProtKBAC2EnsemblID(paste0(unique(QuickGOAnnotationsTable[, UniProtKBACColumnName]), collapse = ","), To = To)
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
