BioMartGOFilterEnsemblID.Nfurzeri <- function(GO.CSV, CombineHumanHomology = TRUE, CombineZebrafishHomology = TRUE) {
  suppressPackageStartupMessages(library("biomaRt"))
  
  KillifishTable <-
    getBM(attributes = c("ensembl_gene_id", "external_gene_name"),
          filters = "go_parent_term", values = GO.CSV,
          mart = useEnsembl(biomart = "ensembl", dataset = "nfurzeri_gene_ensembl"))
  row.names(KillifishTable) <- NULL
  KillifishSet <- unique(KillifishTable[, "ensembl_gene_id"])
  
  if (CombineHumanHomology) {
  	HumanHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl"))
    row.names(HumanHomologyTable) <- NULL
    KillifishSet <- unique(c(KillifishSet, HumanHomologyTable[, "nfurzeri_homolog_ensembl_gene"]))
  }
  
  if (CombineZebrafishHomology) {
  	ZebrafishHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = "go_parent_term", values = GO.CSV,
            mart = useEnsembl(biomart = "ensembl", dataset = "drerio_gene_ensembl"))
    # with_nfurzeri_homolog is currently not a valid filter for dataset = "drerio_gene_ensembl"
    isRetained = logical(length = nrow(ZebrafishHomologyTable)) # initialize an array of FALSEs
    for (i in 1 : nrow(ZebrafishHomologyTable)) {
      if (ZebrafishHomologyTable[i, "nfurzeri_homolog_ensembl_gene"] != "") {
        isRetained[i] = TRUE
      }
    }
    ZebrafishHomologyTable <- ZebrafishHomologyTable[isRetained,]
    row.names(ZebrafishHomologyTable) <- NULL
    KillifishSet <- unique(c(KillifishSet, ZebrafishHomologyTable[, "nfurzeri_homolog_ensembl_gene"]))
  }
  
  return(KillifishSet)
}
