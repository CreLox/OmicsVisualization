TabulateHighConfidenceOneToOneOrthology.Nfurzeri <- function(TargetSpecies = "drerio") {
  ID <- 15000002 : 15025476
  Prefix <- "ENSNFUG000"
  ID.Prefixed.CSV <- paste0(paste(Prefix, ID, sep = ""), collapse = ",")
  
  retry({
    ConsoleOutput <- capture.output({
                       HomologyTable <- getBM(attributes = c("ensembl_gene_id",
                                                             paste0(TargetSpecies, "_homolog_ensembl_gene"),
                                                             paste0(TargetSpecies, "_homolog_orthology_type"),
                                                             paste0(TargetSpecies, "_homolog_orthology_confidence")),
                                              filters = c(paste0("with_", TargetSpecies, "_homolog"), "ensembl_gene_id"),
                                              values = list(TRUE, ID.Prefixed.CSV),
                                              mart = useEnsembl(biomart = "ensembl", dataset = "nfurzeri_gene_ensembl"))
                     });
    if (length(ConsoleOutput) != 0) {
      stop("Error")
    }
  }, when = ".*", silent = TRUE)
  
  return(HomologyTable[(HomologyTable[, paste0(TargetSpecies, "_homolog_orthology_type")] == "ortholog_one2one") &
                       (HomologyTable[, paste0(TargetSpecies, "_homolog_orthology_confidence")] == "1"),
                       c("ensembl_gene_id", paste0(TargetSpecies, "_homolog_ensembl_gene"))])
}
