BioMartGOFilter.Nfurzeri <- function(GO.CSV,
                                     IncludeChildren = TRUE,
                                     CombineFruitFlyHomology = FALSE,
                                     CombineHumanHomology = TRUE,
                                     CombineMedakaHomology = TRUE,
                                     CombineMouseHomology = TRUE,
                                     CombineNematodeHomology = FALSE,
                                     CombineXenopusHomology = TRUE,
                                     CombineZebrafishHomology = TRUE) {
  
  suppressPackageStartupMessages(library("biomaRt"))
  suppressPackageStartupMessages(library("retry"))
  suppressPackageStartupMessages(library("ontologyIndex"))
  biomartCacheClear()
  
  if (IncludeChildren) {
    Ontology <- get.Ontology()
    GO.Vector <- unlist(strsplit(GO.CSV, split = ","))
    GO.Vector.Complemented <- c()
    for (i in 1 : length(GO.Vector)) {
      GO.Vector.Complemented <- c(GO.Vector.Complemented,
                                  get_descendants(Ontology, GO.Vector[i], exclude_roots = FALSE))
    }
    GO.CSV <- paste0(unique(GO.Vector.Complemented), collapse = ",")
  }
    
  SpeciesDatasetNameList <- c()
  if (CombineFruitFlyHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "dmelanogaster_gene_ensembl")
  }
  if (CombineHumanHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "hsapiens_gene_ensembl")
  }
  if (CombineMedakaHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "olatipes_gene_ensembl")
  }
  if (CombineMouseHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "mmusculus_gene_ensembl")
  }
  if (CombineNematodeHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "celegans_gene_ensembl")
  }
  if (CombineXenopusHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "xtropicalis_gene_ensembl")
  }
  if (CombineZebrafishHomology) {
    SpeciesDatasetNameList <- c(SpeciesDatasetNameList, "drerio_gene_ensembl")
  }
  
  retry({
          ConsoleOutput <- capture.output({
                             KillifishTable <-
                             getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
                                   filters = "go_parent_term", values = GO.CSV,
                                   mart = useEnsembl(biomart = "ensembl", dataset = "nfurzeri_gene_ensembl"))
                           });
          if (length(ConsoleOutput) != 0) {
            stop("Error")
          }
        }, when = ".*", silent = TRUE)
  row.names(KillifishTable) <- NULL
  KillifishGOList <- CompileGOList(KillifishTable)
  
  for (SpeciesDatasetName in SpeciesDatasetNameList) {
    retry({
            ConsoleOutput <- capture.output({
                               ThisSpeciesTable <-
                               getBM(attributes = c("ensembl_gene_id", "external_gene_name", "go_id"),
                                     filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
                                     mart = useEnsembl(biomart = "ensembl", dataset = SpeciesDatasetName))
                             });
            if (length(ConsoleOutput) != 0) {
              stop("Error")
            }
          }, when = ".*", silent = TRUE)
    row.names(ThisSpeciesTable) <- NULL
    ThisSpeciesGOList <- CompileGOList(ThisSpeciesTable)
    
    retry({
            ConsoleOutput <- capture.output({
                               ThisSpeciesHomologyTable <-
                               getBM(attributes = c("ensembl_gene_id", "external_gene_name",
                                                    "nfurzeri_homolog_ensembl_gene", "nfurzeri_homolog_associated_gene_name",
                                                    "nfurzeri_homolog_orthology_type", "nfurzeri_homolog_orthology_confidence"),
                                     filters = c("with_nfurzeri_homolog", "go_parent_term"), values = list(TRUE, GO.CSV),
                                     mart = useEnsembl(biomart = "ensembl", dataset = SpeciesDatasetName))
                             });
            if (length(ConsoleOutput) != 0) {
              stop("Error")
            }
          }, when = ".*", silent = TRUE)
    row.names(ThisSpeciesHomologyTable) <- NULL
    
    KillifishGOList <- TranslateGOList.Nfurzeri(ThisSpeciesHomologyTable, ThisSpeciesGOList, KillifishGOList)
  }
  
  return(KillifishGOList)
}

CompileGOList <- function(BioMartExportGOTable,
                          ExistingGOList = list(),
                          EnsemblIDColumnName = "ensembl_gene_id",
                          GOColumnName = "go_id") {
  
  if (nrow(BioMartExportGOTable) == 0) {
    return(ExistingGOList)
  }
  
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
                                     OrthologyTypeColumnName = "nfurzeri_homolog_orthology_type",
                                     SafeOrthologyTypes = c("ortholog_one2one", "ortholog_one2many"),
                                     NfurzeriEnsemblIDColumnName = "nfurzeri_homolog_ensembl_gene") {
  
  for (i in 1 : length(OriginalGOList)) {
    OriginalEnsemblID <- names(OriginalGOList)[i]
    HomologyNfurzeriEnsemblIDs <- HomologyTable[(HomologyTable[, OriginalEnsemblIDColumnName] == OriginalEnsemblID) &
                                                (HomologyTable[, OrthologyTypeColumnName] %in% SafeOrthologyTypes),
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
