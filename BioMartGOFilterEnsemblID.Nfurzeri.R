BioMartGOFilterEnsemblID.Nfurzeri <- function(GO.CSV, CombineFruitFlyHomology = TRUE, CombineHumanHomology = TRUE, CombineNematodeHomology = TRUE, CombineXenopusHomology = TRUE, CombineZebrafishHomology = TRUE) {
  suppressPackageStartupMessages(library("biomaRt"))
  suppressPackageStartupMessages(library("retry"))
  biomartCacheClear()
  
  retry({
    KillifishTable <-
    getBM(attributes = c("ensembl_gene_id", "external_gene_name"),
          filters = "go_parent_term", values = GO.CSV,
          mart = useEnsembl(biomart = "ensembl", dataset = "nfurzeri_gene_ensembl"))
  }, when = "Error", silent = TRUE)
  row.names(KillifishTable) <- NULL
  KillifishSet <- unique(KillifishTable[, "ensembl_gene_id"])
  
  if (CombineFruitFlyHomology) {
    retry({
      FruitFlyHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "dmelanogaster_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(FruitFlyHomologyTable) <- NULL
    KillifishSet <- unique(c(KillifishSet, FruitFlyHomologyTable[, "nfurzeri_homolog_ensembl_gene"]))
  }
  
  if (CombineHumanHomology) {
    retry({
      HumanHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(HumanHomologyTable) <- NULL
    KillifishSet <- unique(c(KillifishSet, HumanHomologyTable[, "nfurzeri_homolog_ensembl_gene"]))
  }
  
  if (CombineNematodeHomology) {
    retry({
      NematodeHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "celegans_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(NematodeHomologyTable) <- NULL
    KillifishSet <- unique(c(KillifishSet, NematodeHomologyTable[, "nfurzeri_homolog_ensembl_gene"]))
  }
  
  if (CombineXenopusHomology) {
    retry({
      XenopusHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "xtropicalis_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(XenopusHomologyTable) <- NULL
    KillifishSet <- unique(c(KillifishSet, XenopusHomologyTable[, "nfurzeri_homolog_ensembl_gene"]))
  }
  
  if (CombineZebrafishHomology) {
    retry({
      ZebrafishHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = "go_parent_term", values = GO.CSV,
            mart = useEnsembl(biomart = "ensembl", dataset = "drerio_gene_ensembl"))
    }, when = "Error", silent = TRUE)
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
