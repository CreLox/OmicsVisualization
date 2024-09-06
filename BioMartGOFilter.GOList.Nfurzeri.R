BioMartGOFilter.GOList.Nfurzeri <- function(GO.CSV,
                                            CombineFruitFlyHomology = TRUE,
                                            CombineHumanHomology = TRUE,
                                            CombineNematodeHomology = TRUE,
                                            CombineXenopusHomology = TRUE,
                                            CombineZebrafishHomology = TRUE) {
  
  suppressPackageStartupMessages(library("biomaRt"))
  suppressPackageStartupMessages(library("retry"))
  biomartCacheClear()
  
  retry({
    KillifishTable <-
    getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
          filters = "go_parent_term", values = GO.CSV,
          mart = useEnsembl(biomart = "ensembl", dataset = "nfurzeri_gene_ensembl"))
  }, when = "Error", silent = TRUE)
  row.names(KillifishTable) <- NULL
  KillifishGOList <- CompileGOList(KillifishTable)
  
  if (CombineFruitFlyHomology) {
    retry({
      FruitFlyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "dmelanogaster_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(FruitFlyTable) <- NULL
    retry({
      FruitFlyHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "dmelanogaster_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(FruitFlyHomologyTable) <- NULL
    FruitFlyGOList <- CompileGOList(FruitFlyTable)
    KillifishGOList <- TranslateGOList.Nfurzeri(FruitFlyHomologyTable, FruitFlyGOList, KillifishGOList)
  }
  
  if (CombineHumanHomology) {
    retry({
      HumanTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(HumanTable) <- NULL
    retry({
      HumanHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(HumanHomologyTable) <- NULL
    HumanGOList <- CompileGOList(HumanTable)
    KillifishGOList <- TranslateGOList.Nfurzeri(HumanHomologyTable, HumanGOList, KillifishGOList)
  }
  
  if (CombineNematodeHomology) {
    retry({
      NematodeTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "celegans_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(NematodeTable) <- NULL
    retry({
      NematodeHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "celegans_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(NematodeHomologyTable) <- NULL
    NematodeGOList <- CompileGOList(NematodeTable)
    KillifishGOList <- TranslateGOList.Nfurzeri(NematodeHomologyTable, NematodeGOList, KillifishGOList)
  }
  
  if (CombineXenopusHomology) {
    retry({
      XenopusTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "xtropicalis_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(XenopusTable) <- NULL
    retry({
      XenopusHomologyTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                           "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                           "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
            filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
            mart = useEnsembl(biomart = "ensembl", dataset = "xtropicalis_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(XenopusHomologyTable) <- NULL
    XenopusGOList <- CompileGOList(XenopusTable)
    KillifishGOList <- TranslateGOList.Nfurzeri(XenopusHomologyTable, XenopusGOList, KillifishGOList)
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
    FilteredZebrafishEnsemblIDs <- paste(ZebrafishHomologyTable[, "ensembl_gene_id"], collapse = ",")
    retry({
      ZebrafishTable <-
      getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
            filters = "ensembl_gene_id", values = FilteredZebrafishEnsemblIDs,
            mart = useEnsembl(biomart = "ensembl", dataset = "drerio_gene_ensembl"))
    }, when = "Error", silent = TRUE)
    row.names(ZebrafishTable) <- NULL
    ZebrafishGOList <- CompileGOList(ZebrafishTable)
    KillifishGOList <- TranslateGOList.Nfurzeri(ZebrafishHomologyTable, ZebrafishGOList, KillifishGOList)
  }
  
  return(KillifishGOList)
}

CompileGOList <- function(BioMartExportGOTable,
                          ExistingGOList = list(),
                          EnsemblIDColumnName = "ensembl_gene_id",
                          GOColumnName = "go_id") {
  
  for (i in 1 : nrow(BioMartExportGOTable)) {
    if (BioMartExportGOTable[i, EnsemblIDColumnName] %in% names(ExistingGOList)) {
      ExistingGOList[[BioMartExportGOTable[i, EnsemblIDColumnName]]] <- unique(c(ExistingGOList[[BioMartExportGOTable[i, EnsemblIDColumnName]]], BioMartExportGOTable[i, GOColumnName]))
    }
    else {
      ExistingGOList[[BioMartExportGOTable[i, EnsemblIDColumnName]]] <- BioMartExportGOTable[i, GOColumnName]
    }
  }
  
  return(ExistingGOList)
}

TranslateGOList.Nfurzeri <- function(HomologyTable,
                                     OriginalGOList, NfurzeriGOList = list(),
                                     OriginalEnsemblIDColumnName = "ensembl_gene_id",
                                     NfurzeriEnsemblIDColumnName = "nfurzeri_homolog_ensembl_gene") {
  
  for (i in 1 : length(OriginalGOList)) {
    OriginalEnsemblID = names(OriginalGOList)[i]
    HomologyNfurzeriEnsemblIDs = HomologyTable[(HomologyTable[, OriginalEnsemblIDColumnName] == OriginalEnsemblID),
                                               NfurzeriEnsemblIDColumnName]
    for (j in HomologyNfurzeriEnsemblIDs) {
      if (j %in% names(NfurzeriGOList)) {
        NfurzeriGOList[[j]] <- unique(c(NfurzeriGOList[[j]], OriginalGOList[[OriginalEnsemblID]]))
      }
      else {
        NfurzeriGOList[[j]] <- OriginalGOList[[OriginalEnsemblID]]
      }
    }
  }
  
  return(NfurzeriGOList)
}
