FindUniqueGenes.EnsemblID <- function(TargetSpecies = "nfurzeri",
                                      CheckHomologySpecies = c("drerio", "kmarmoratus")) {
  
  suppressPackageStartupMessages(library("biomaRt"))
  suppressPackageStartupMessages(library("retry"))
  biomartCacheClear()
  
  UniqueSet <- NULL
  for (HomologySpecies in CheckHomologySpecies) {
    retry({
      Table <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name"),
            filters = paste("with", HomologySpecies, "homolog", sep = "_"), values = FALSE,
            mart = useEnsembl(biomart = "ensembl", dataset = paste(TargetSpecies, "gene_ensembl", sep = "_")))
    }, when = "Error", silent = TRUE)
    row.names(Table) <- NULL
    if (is.null(UniqueSet)) {
      UniqueSet <- Table[, "ensembl_gene_id"]
    }
    else {
      UniqueSet <- intersect(UniqueSet, Table[, "ensembl_gene_id"])
    }
  }
  
  return(UniqueSet)
}
